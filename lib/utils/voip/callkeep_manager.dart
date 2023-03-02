import 'dart:async';

import 'package:flutter/material.dart';

import 'package:callkeep/callkeep.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:fluffychat/utils/voip_plugin.dart';

class CallKeeper {
  CallKeeper(this.callKeepManager, this.call) {
    call.onCallStateChanged.stream.listen(_handleCallState);
  }

  CallKeepManager callKeepManager;
  bool? held = false;
  bool? muted = false;
  bool connected = false;
  CallSession call;

  // update native caller to show what remote user has done.
  void _handleCallState(CallState state) {
    Logs().i('CallKeepManager::handleCallState: ${state.toString()}');
    switch (state) {
      case CallState.kConnecting:
        Logs().v('callkeep connecting');
        break;
      case CallState.kConnected:
        Logs().v('callkeep connected');
        if (!connected) {
          callKeepManager.answer(call.callId);
        } else {
          callKeepManager.setMutedCall(call.callId, false);
          callKeepManager.setOnHold(call.callId, false);
        }
        break;
      case CallState.kEnded:
        callKeepManager.hangup(call.callId);
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

Map<String?, CallKeeper> calls = <String?, CallKeeper>{};

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

  String get appName => 'FluffyChat';

  Future<bool> get hasPhoneAccountEnabled async =>
      await _callKeep.hasPhoneAccount();

  Map<String, dynamic> get alertOptions => <String, dynamic>{
        'alertTitle': 'Permissions required',
        'alertDescription':
            'Allow $appName to register as a calling account? This will allow calls to be handled by the native android dialer.',
        'cancelButton': 'Cancel',
        'okButton': 'ok',
        // Required to get audio in background when using Android 11
        'foregroundService': {
          'channelId': 'com.fluffy.fluffychat',
          'channelName': 'Foreground service for my app',
          'notificationTitle': '$appName is running on background',
          'notificationIcon': 'mipmap/ic_notification_launcher',
        },
        'additionalPermissions': [''],
      };
  bool setupDone = false;

  Future<void> showCallkitIncoming(CallSession call) async {
    if (!setupDone) {
      await _callKeep.setup(
        null,
        <String, dynamic>{
          'ios': <String, dynamic>{
            'appName': appName,
          },
          'android': alertOptions,
        },
        backgroundMode: true,
      );
    }
    setupDone = true;
    await displayIncomingCall(call);
    call.onCallStateChanged.stream.listen((state) {
      if (state == CallState.kEnded) {
        _callKeep.endAllCalls();
      }
    });
    call.onCallEventChanged.stream.listen(
      (event) {
        if (event == CallEvent.kLocalHoldUnhold) {
          Logs().i(
            'Call hold event: local ${call.localHold}, remote ${call.remoteOnHold}',
          );
        }
      },
    );
  }

  void removeCall(String? callUUID) {
    calls.remove(callUUID);
  }

  void addCall(String? callUUID, CallKeeper callKeeper) {
    if (calls.containsKey(callUUID)) return;
    calls[callUUID] = callKeeper;
  }

  void setCallHeld(String? callUUID, bool? held) {
    calls[callUUID]!.held = held;
  }

  void setCallMuted(String? callUUID, bool? muted) {
    calls[callUUID]!.muted = muted;
  }

  void didDisplayIncomingCall(CallKeepDidDisplayIncomingCall event) {
    final callUUID = event.callUUID;
    final number = event.handle;
    Logs().v('[displayIncomingCall] $callUUID number: $number');
    // addCall(callUUID, CallKeeper(this null));
  }

  void onPushKitToken(CallKeepPushKitToken event) {
    Logs().v('[onPushKitToken] token => ${event.token}');
  }

  Future<void> initialize() async {
    _callKeep.on(CallKeepPerformAnswerCallAction(), answerCall);
    _callKeep.on(CallKeepDidPerformDTMFAction(), didPerformDTMFAction);
    _callKeep.on(
      CallKeepDidReceiveStartCallAction(),
      didReceiveStartCallAction,
    );
    _callKeep.on(CallKeepDidToggleHoldAction(), didToggleHoldCallAction);
    _callKeep.on(
      CallKeepDidPerformSetMutedCallAction(),
      didPerformSetMutedCallAction,
    );
    _callKeep.on(CallKeepPerformEndCallAction(), endCall);
    _callKeep.on(CallKeepPushKitToken(), onPushKitToken);
    _callKeep.on(CallKeepDidDisplayIncomingCall(), didDisplayIncomingCall);
    Logs().i('[VOIP] Initialized');
  }

  Future<void> hangup(String callUUID) async {
    await _callKeep.endCall(callUUID);
    removeCall(callUUID);
  }

  Future<void> reject(String callUUID) async {
    await _callKeep.rejectCall(callUUID);
  }

  Future<void> answer(String? callUUID) async {
    final keeper = calls[callUUID]!;
    if (!keeper.connected) {
      await _callKeep.answerIncomingCall(callUUID!);
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
    // Workaround because Android doesn't display well displayName, se we have to switch ...
    if (isIOS) {
      await _callKeep.updateDisplay(
        callUUID,
        displayName: 'New Name',
        handle: callUUID,
      );
    } else {
      await _callKeep.updateDisplay(
        callUUID,
        displayName: callUUID,
        handle: 'New Name',
      );
    }
  }

  Future<CallKeeper> displayIncomingCall(CallSession call) async {
    final callKeeper = CallKeeper(this, call);
    addCall(call.callId, callKeeper);
    await _callKeep.displayIncomingCall(
      call.callId,
      '${call.room.getLocalizedDisplayname()} (FluffyChat)',
      localizedCallerName:
          '${call.room.getLocalizedDisplayname()} (FluffyChat)',
      handleType: 'number',
      hasVideo: call.type == CallType.kVideo,
    );
    return callKeeper;
  }

  Future<void> checkoutPhoneAccountSetting(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text(L10n.of(context)!.callingPermissions),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () => openCallingAccountsPage(context),
              title: Text(L10n.of(context)!.callingAccount),
              subtitle: Text(L10n.of(context)!.callingAccountDetails),
              trailing: const Icon(Icons.phone),
            ),
            const Divider(),
            ListTile(
              onTap: () => FlutterForegroundTask.openSystemAlertWindowSettings(
                forceOpen: true,
              ),
              title: Text(L10n.of(context)!.appearOnTop),
              subtitle: Text(L10n.of(context)!.appearOnTopDetails),
              trailing: const Icon(Icons.file_upload_rounded),
            ),
            const Divider(),
            ListTile(
              onTap: () => openAppSettings(),
              title: Text(L10n.of(context)!.otherCallingPermissions),
              trailing: const Icon(Icons.mic),
            ),
          ],
        ),
      ),
    );
  }

  void openCallingAccountsPage(BuildContext context) async {
    await _callKeep.setup(context, <String, dynamic>{
      'ios': <String, dynamic>{
        'appName': appName,
      },
      'android': alertOptions,
    });
    final hasPhoneAccount = await _callKeep.hasPhoneAccount();
    Logs().e(hasPhoneAccount.toString());
    if (!hasPhoneAccount) {
      await _callKeep.hasDefaultPhoneAccount(context, alertOptions);
    } else {
      await _callKeep.openPhoneAccounts();
    }
  }

  /// CallActions.
  Future<void> answerCall(CallKeepPerformAnswerCallAction event) async {
    final callUUID = event.callUUID;
    final keeper = calls[event.callUUID]!;
    if (!keeper.connected) {
      Logs().e('answered');
      // Answer Call
      keeper.call.answer();
      keeper.connected = true;
    }
    Timer(const Duration(seconds: 1), () {
      _callKeep.setCurrentCallActive(callUUID!);
    });
  }

  Future<void> endCall(CallKeepPerformEndCallAction event) async {
    final keeper = calls[event.callUUID];
    keeper?.call.hangup();
    removeCall(event.callUUID);
  }

  Future<void> didPerformDTMFAction(CallKeepDidPerformDTMFAction event) async {
    final keeper = calls[event.callUUID]!;
    keeper.call.sendDTMF(event.digits!);
  }

  Future<void> didReceiveStartCallAction(
    CallKeepDidReceiveStartCallAction event,
  ) async {
    if (event.handle == null) {
      // @TODO: sometime we receive `didReceiveStartCallAction` with handle` undefined`
      return;
    }
    final callUUID = event.callUUID!;
    if (event.callUUID == null) {
      final call =
          await _voipPlugin!.voip.inviteToCall(event.handle!, CallType.kVideo);
      addCall(callUUID, CallKeeper(this, call));
    }
    await _callKeep.startCall(callUUID, event.handle!, event.handle!);
    Timer(const Duration(seconds: 1), () {
      _callKeep.setCurrentCallActive(callUUID);
    });
  }

  Future<void> didPerformSetMutedCallAction(
    CallKeepDidPerformSetMutedCallAction event,
  ) async {
    final keeper = calls[event.callUUID];
    if (event.muted!) {
      keeper!.call.setMicrophoneMuted(true);
    } else {
      keeper!.call.setMicrophoneMuted(false);
    }
    setCallMuted(event.callUUID, event.muted);
  }

  Future<void> didToggleHoldCallAction(
    CallKeepDidToggleHoldAction event,
  ) async {
    final keeper = calls[event.callUUID];
    if (event.hold!) {
      keeper!.call.setRemoteOnHold(true);
    } else {
      keeper!.call.setRemoteOnHold(false);
    }
    setCallHeld(event.callUUID, event.hold);
  }
}
