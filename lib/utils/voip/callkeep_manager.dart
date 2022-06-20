import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:callkeep/callkeep.dart';
import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

import 'package:fluffychat/utils/voip_plugin.dart';

class CallKeeper {
  CallKeeper(this.callKeepManager, this.uuid, this.number, this.call) {
    call?.onCallStateChanged.stream.listen(_handleCallState);
  }

  CallKeepManager callKeepManager;
  String number;
  String uuid;
  bool held = false;
  bool muted = false;
  bool connected = false;
  CallSession? call;

  void _handleCallState(CallState state) {
    Logs().v('CallKeepManager::handleCallState: ${state.toString()}');
    switch (state) {
      case CallState.kConnecting:
        break;
      case CallState.kConnected:
        if (!connected) {
          callKeepManager.answer(uuid);
        } else {
          callKeepManager.setMutedCall(uuid, false);
          callKeepManager.setOnHold(uuid, false);
        }
        break;
      case CallState.kEnded:
        callKeepManager.hangup(uuid);
        break;
      /* TODO:
      case CallState.kMuted:
        callKeepManager.setMutedCall(uuid, true);
        break;
      case CallState.kHeld:
        callKeepManager.setOnHold(uuid, true);
        break;
      */
      case CallState.kFledgling:
        // TODO: Handle this case.
        break;
      case CallState.kInviteSent:
        // TODO: Handle this case.
        break;
      case CallState.kWaitLocalMedia:
        // TODO: Handle this case.
        break;
      case CallState.kCreateOffer:
        // TODO: Handle this case.
        break;
      case CallState.kCreateAnswer:
        // TODO: Handle this case.
        break;
      case CallState.kRinging:
        // TODO: Handle this case.
        break;
    }
  }
}

class CallKeepManager {
  factory CallKeepManager() {
    return _instance;
  }

  CallKeepManager._internal() {
    _callKeep = FlutterCallkeep();
  }

  static final CallKeepManager _instance = CallKeepManager._internal();

  late FlutterCallkeep _callKeep;
  VoipPlugin? _voipPlugin;
  Map<String, CallKeeper> calls = <String, CallKeeper>{};

  String newUUID() => const Uuid().v4();

  String get appName => 'Famedly';

  Map<String, dynamic> get alertOptions => <String, dynamic>{
        'alertTitle': 'Permissions required',
        'alertDescription': '$appName needs to access your phone accounts!',
        'cancelButton': 'Cancel',
        'okButton': 'ok',
        // Required to get audio in background when using Android 11
        'foregroundService': {
          'channelId': 'com.famedly.talk',
          'channelName': 'Foreground service for my app',
          'notificationTitle': '$appName is running on background',
          'notificationIcon': 'mipmap/ic_notification_launcher',
        },
      };

  void setVoipPlugin(VoipPlugin plugin) {
    if (kIsWeb) {
      throw 'Not support callkeep for flutter web';
    }
    _voipPlugin = plugin;
    _voipPlugin!.onIncomingCall = (CallSession call) async {
      await _callKeep.setup(
          null,
          <String, dynamic>{
            'ios': <String, dynamic>{
              'appName': appName,
            },
            'android': alertOptions,
          },
          backgroundMode: true);

      await displayIncomingCall(call);

      call.onCallStateChanged.stream.listen((state) {
        if (state == CallState.kEnded) {
          _callKeep.endAllCalls();
        }
      });
      call.onCallEventChanged.stream.listen((event) {
        if (event == CallEvent.kLocalHoldUnhold) {
          Logs().i(
              'Call hold event: local ${call.localHold}, remote ${call.remoteOnHold}');
        }
      });
    };
  }

  void removeCall(String callUUID) {
    calls.remove(callUUID);
  }

  void addCall(String callUUID, CallKeeper callKeeper) {
    calls[callUUID] = callKeeper;
  }

  String findCallUUID(String number) {
    var uuid = '';
    calls.forEach((String key, CallKeeper item) {
      if (item.number == number) {
        uuid = key;
        return;
      }
    });
    return uuid;
  }

  void setCallHeld(String callUUID, bool held) {
    calls[callUUID]!.held = held;
  }

  void setCallMuted(String callUUID, bool muted) {
    calls[callUUID]!.muted = muted;
  }

  void didDisplayIncomingCall(CallKeepDidDisplayIncomingCall event) {
    final callUUID = event.callUUID;
    final number = event.handle;
    Logs().v('[displayIncomingCall] $callUUID number: $number');
    addCall(callUUID!, CallKeeper(this, callUUID, number!, null));
  }

  void onPushKitToken(CallKeepPushKitToken event) {
    Logs().v('[onPushKitToken] token => ${event.token}');
  }

  Future<void> initialize() async {
    _callKeep.on(CallKeepPerformAnswerCallAction(), answerCall);
    _callKeep.on(CallKeepDidPerformDTMFAction(), didPerformDTMFAction);
    _callKeep.on(
        CallKeepDidReceiveStartCallAction(), didReceiveStartCallAction);
    _callKeep.on(CallKeepDidToggleHoldAction(), didToggleHoldCallAction);
    _callKeep.on(
        CallKeepDidPerformSetMutedCallAction(), didPerformSetMutedCallAction);
    _callKeep.on(CallKeepPerformEndCallAction(), endCall);
    _callKeep.on(CallKeepPushKitToken(), onPushKitToken);
    _callKeep.on(CallKeepDidDisplayIncomingCall(), didDisplayIncomingCall);
  }

  Future<void> hangup(String callUUID) async {
    await _callKeep.endCall(callUUID);
    removeCall(callUUID);
  }

  Future<void> reject(String callUUID) async {
    await _callKeep.rejectCall(callUUID);
  }

  Future<void> answer(String callUUID) async {
    final keeper = calls[callUUID];
    if (!keeper!.connected) {
      await _callKeep.answerIncomingCall(callUUID);
      keeper.connected = true;
    }
  }

  Future<void> setOnHold(String callUUID, bool held) async {
    await _callKeep.setOnHold(callUUID, held);
    setCallHeld(callUUID, held);
  }

  Future<void> setMutedCall(String callUUID, bool muted) async {
    await _callKeep.setMutedCall(callUUID, muted);
    setCallMuted(callUUID, muted);
  }

  Future<void> updateDisplay(String callUUID) async {
    final number = calls[callUUID]!.number;
    // Workaround because Android doesn't display well displayName, se we have to switch ...
    if (isIOS) {
      await _callKeep.updateDisplay(callUUID,
          displayName: 'New Name', handle: number);
    } else {
      await _callKeep.updateDisplay(callUUID,
          displayName: number, handle: 'New Name');
    }
  }

  Future<CallKeeper> displayIncomingCall(CallSession call) async {
    final callUUID = newUUID();
    final callKeeper = CallKeeper(this, callUUID, call.displayName!, call);
    addCall(callUUID, callKeeper);
    await _callKeep.displayIncomingCall(callUUID, call.displayName!,
        handleType: 'number', hasVideo: call.type == CallType.kVideo);
    return callKeeper;
  }

  Future<void> checkoutPhoneAccountSetting(BuildContext context) async {
    await _callKeep.setup(context, <String, dynamic>{
      'ios': <String, dynamic>{
        'appName': appName,
      },
      'android': alertOptions,
    });
    final hasPhoneAccount = await _callKeep.hasPhoneAccount();
    if (!hasPhoneAccount) {
      await _callKeep.hasDefaultPhoneAccount(context, alertOptions);
    }
  }

  /// CallActions.
  Future<void> answerCall(CallKeepPerformAnswerCallAction event) async {
    final callUUID = event.callUUID;
    final keeper = calls[event.callUUID]!;
    if (!keeper.connected) {
      // Answer Call
      keeper.call!.answer();
      keeper.connected = true;
    }
    Timer(const Duration(seconds: 1), () {
      _callKeep.setCurrentCallActive(callUUID!);
    });
  }

  Future<void> endCall(CallKeepPerformEndCallAction event) async {
    final keeper = calls[event.callUUID];
    keeper?.call?.hangup();
    removeCall(event.callUUID!);
  }

  Future<void> didPerformDTMFAction(CallKeepDidPerformDTMFAction event) async {
    final keeper = calls[event.callUUID]!;
    keeper.call?.sendDTMF(event.digits!);
  }

  Future<void> didReceiveStartCallAction(
      CallKeepDidReceiveStartCallAction event) async {
    if (event.handle == null) {
      // @TODO: sometime we receive `didReceiveStartCallAction` with handle` undefined`
      return;
    }
    final callUUID = event.callUUID ?? newUUID();
    if (event.callUUID == null) {
      final call =
          await _voipPlugin!.voip.inviteToCall(event.handle!, CallType.kVideo);
      addCall(callUUID, CallKeeper(this, callUUID, call.displayName!, call));
    }
    await _callKeep.startCall(callUUID, event.handle!, event.handle!);
    Timer(const Duration(seconds: 1), () {
      _callKeep.setCurrentCallActive(callUUID);
    });
  }

  Future<void> didPerformSetMutedCallAction(
      CallKeepDidPerformSetMutedCallAction event) async {
    final keeper = calls[event.callUUID]!;
    if (event.muted ?? false) {
      keeper.call?.setMicrophoneMuted(true);
    } else {
      keeper.call?.setMicrophoneMuted(false);
    }
    setCallMuted(event.callUUID!, event.muted!);
  }

  Future<void> didToggleHoldCallAction(
      CallKeepDidToggleHoldAction event) async {
    final keeper = calls[event.callUUID]!;
    if (event.hold ?? false) {
      keeper.call?.setRemoteOnHold(true);
    } else {
      keeper.call?.setRemoteOnHold(false);
    }
    setCallHeld(event.callUUID!, event.hold!);
  }
}
