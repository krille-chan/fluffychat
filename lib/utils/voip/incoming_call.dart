import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart' hide CallEvent, Event;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:fluffychat/utils/app_state.dart';
import 'package:fluffychat/utils/localization_for_locale_extension.dart';
import 'package:fluffychat/utils/voip/voip_plugin.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import '../../pages/voip/widgets/call_banner.dart';

Map<String?, CallKeeper> calls = <String?, CallKeeper>{};

/// Add uuid extension field for CallSession
extension CallSessionUuidExt on CallSession {
  static Map<String, String> uuids_ = {};
  String get callUUID {
    if (uuids_.containsKey(callId)) {
      return uuids_[callId]!;
    }
    final uuid = const Uuid().v4().toString();
    uuids_[callId] = uuid;
    return uuid;
  }

  void removeUUID() {
    uuids_.remove(callId);
  }
}

class CallKeeper {
  CallKeeper(this.incomingCallManager, this.call) {
    call.onCallStateChanged.stream.listen(_handleCallState);
  }

  IncomingCallManager incomingCallManager;
  bool? held = false;
  bool? muted = false;
  bool connected = false;
  CallSession call;

  // update native caller to show what remote user has done.
  Future _handleCallState(CallState state) async {
    Logs().d('CallKeepManager::handleCallState: ${state.toString()}');
    if (state case CallState.kConnected) {
      await incomingCallManager.endIncomingCall(call.callUUID);
    } else if (state case CallState.kEnded) {
      await incomingCallManager.endIncomingCall(call.callUUID);
    }
  }
}

class IncomingCallManager {
  late VoipPlugin voipPlugin;
  factory IncomingCallManager(VoipPlugin voipPlugin) {
    _instance.voipPlugin = voipPlugin;
    return _instance;
  }

  static final IncomingCallManager _instance = IncomingCallManager._internal();
  IncomingCallManager._internal();

  void removeCall(String? callUUID) {
    final callkeep = calls.remove(callUUID);
    callkeep?.call.removeUUID();
  }

  void addCall(String? callUUID, CallKeeper callKeeper) {
    if (calls.containsKey(callUUID)) return;
    calls[callUUID] = callKeeper;
  }

  Future<void> initialize() async {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      Logs().w(event!.event.name.toString());
      if (event.event case Event.actionCallAccept) {
        await answerCall(event.body['id']);
      } else if (event.event case Event.actionCallDecline) {
        await reject(event.body['id']);
      }
    });
    Logs().d('callkeepv3 init done');
  }

  /// CallActions.
  Future<void> answerCall(String callUUID) async {
    final keeper = calls[callUUID]!;

    // never null because incoming call thingy is always triggered after handleNewCall
    final callProxy = voipPlugin.currentCallProxy;

    final provider = Provider.of<AppState>(
      FluffyChatApp.appGlobalKey.currentContext!,
      listen: false,
    );

    final remoteUser =
        await keeper.call.room.requestUser(keeper.call.inviteeUserId!);
    provider.proxy = callProxy;

    provider.remoteUserInCall = remoteUser;

    provider.setGlobalBanner(
      CallBanner(proxy: callProxy!),
    );
    FluffyChatApp.router.go('/rooms/${callProxy.room.id}/call');
    if (!keeper.connected) {
      Logs().d('[VOIP] answering call');
      // Answer Call, don't await because call page is not up yet no loading
      // inndicator to show
      unawaited(keeper.call.answer());
      keeper.connected = true;
    }
  }

  /// recieved decline from other end, passed on by callkeepmanager
  Future<void> hangup(String callUUID) async {
    await endIncomingCall(callUUID);
    removeCall(callUUID);
  }

  /// user clicked the decline button on incoming call UI
  Future<void> reject(String callUUID) async {
    await endIncomingCall(callUUID);
    final keeper = calls[callUUID];
    // unawaited because we don't have a screen to show any progress indicator
    unawaited(keeper!.call.reject());
    removeCall(callUUID);
  }

  Future<void> showIncomingCall(CallSession call) async {
    final callKeeper = CallKeeper(this, call);
    final l10n = await WidgetsBinding.instance.platformDispatcher.loadL10n();
    addCall(call.callUUID, callKeeper);
    final remoteUser = await call.room.requestUser(call.inviteeUserId!);
    final avatarMxc = await call.client.getAvatarUrl(remoteUser?.id ?? '');
    final avatarUrl = avatarMxc?.getThumbnail(
      call.client,
      width: 500,
      height: 500,
      method: ThumbnailMethod.scale,
    );

    final params = getParams(
      call,
      avatarUrl.toString(),
      l10n,
    );

    Logs().e('[VOIP] showing incoming call with params: ${params.toJson()}');

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  /// only hides incoming call notification
  Future endIncomingCall(String callUUID) async {
    try {
      await FlutterCallkitIncoming.endCall(callUUID);
    } catch (e) {
      Logs().e('[VOIP] removing callkit incoming failed on endIncomingCall');
    }
  }

  Future showMissedCallNotification(CallSession call) async {
    final l10n = await WidgetsBinding.instance.platformDispatcher.loadL10n();
    final remoteUser = await call.room.requestUser(call.inviteeUserId!);
    final avatarMxc = await call.client.getAvatarUrl(remoteUser?.id ?? '');
    final avatarUrl = avatarMxc?.getThumbnail(
      call.client,
      width: 500,
      height: 500,
      method: ThumbnailMethod.scale,
    );
    await FlutterCallkitIncoming.showMissCallNotification(
      getParams(
        call,
        avatarUrl.toString(),
        l10n,
      ),
    );
  }

  CallKitParams getParams(CallSession call, String avatarUrl, L10n l10n) {
    return CallKitParams(
      id: call.callUUID,
      appName: call.client.clientName,
      nameCaller: call.room.getLocalizedDisplayname(),
      handle: call.type == CallType.kVideo ? l10n.videoCall : l10n.audioCall,
      avatar: avatarUrl,
      textAccept: l10n.accept,
      textDecline: l10n.reject,
      type: call.type == CallType.kVideo ? 1 : 0,
      missedCallNotification: NotificationParams(
        isShowCallback: false,
        subtitle: 'Missed call from ${call.room.getLocalizedDisplayname()}',
      ),
      android: const AndroidParams(
        isShowLogo: true,
        isShowCallID: true,
      ),
      // TODO: add ios once you can run decryption stuff in background
    );
  }
}
