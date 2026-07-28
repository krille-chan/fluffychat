// Schellout fork: Web Push registration via self-hosted Sygnal.
//
// The JS side (web/web_push.js) registers web/push_service_worker.js and
// returns the browser PushSubscription. This file turns that subscription
// into a Matrix HTTP pusher pointing at Sygnal, following the Sygnal
// webpush pushkin contract: pushkey = p256dh key, pusher data carries
// endpoint + auth.
import 'dart:convert';
import 'dart:js_interop';

import 'package:matrix/matrix.dart';

import '../config/setting_keys.dart';

@JS('schelloutWebPush.subscribe')
external JSPromise<JSString> _jsSubscribe(JSString vapidPublicKey);

@JS('schelloutWebPush.permissionState')
external JSString _jsPermissionState();

const String _appId = 'com.schellout.chat.web';

bool get webPushAvailable =>
    AppSettings.webPushVapidKey.value.isNotEmpty &&
    AppSettings.webPushGatewayUrl.value.isNotEmpty;

String get webPushPermissionState {
  try {
    return _jsPermissionState().toDart;
  } catch (_) {
    return 'denied';
  }
}

/// Subscribes this browser to Web Push and registers a Matrix pusher.
///
/// [interactive] should be true when called from a user gesture (required
/// for the permission prompt on iOS/Safari). When false, this only proceeds
/// if permission was already granted, so app startup never triggers a
/// prompt (which browsers would reject or silently deny anyway).
Future<void> setupWebPush(Client client, {bool interactive = false}) async {
  if (!webPushAvailable) return;
  if (!interactive && webPushPermissionState != 'granted') return;
  try {
    final vapidKey = AppSettings.webPushVapidKey.value;
    final gatewayUrl = AppSettings.webPushGatewayUrl.value;

    final subJsonString = (await _jsSubscribe(vapidKey.toJS).toDart).toDart;
    final sub = json.decode(subJsonString) as Map<String, dynamic>;
    final endpoint = sub['endpoint'] as String;
    final keys = sub['keys'] as Map<String, dynamic>;
    final p256dh = keys['p256dh'] as String;
    final auth = keys['auth'] as String;

    final pushers = await client.getPushers() ?? [];
    final alreadyRegistered = pushers.any(
      (pusher) =>
          pusher.appId == _appId &&
          pusher.pushkey == p256dh &&
          pusher.data.additionalProperties['endpoint'] == endpoint &&
          pusher.data.url.toString() == gatewayUrl,
    );
    if (alreadyRegistered) {
      Logs().v('[WebPush] Pusher already registered for this browser');
      return;
    }

    // Remove a stale pusher from this browser if the subscription rotated.
    final previousPushkey = AppSettings.webPushRegisteredPushkey.value;
    if (previousPushkey.isNotEmpty && previousPushkey != p256dh) {
      final stale = pushers.where(
        (pusher) => pusher.appId == _appId && pusher.pushkey == previousPushkey,
      );
      for (final pusher in stale) {
        try {
          await client.deletePusher(
            PusherId(appId: pusher.appId, pushkey: pusher.pushkey),
          );
          Logs().i('[WebPush] Removed stale pusher');
        } catch (e) {
          Logs().w('[WebPush] Failed to remove stale pusher', e);
        }
      }
    }

    await client.postPusher(
      Pusher(
        pushkey: p256dh,
        appId: _appId,
        appDisplayName: 'Schellout Chat Web',
        deviceDisplayName: client.deviceName ?? 'Web',
        lang: 'en',
        data: PusherData(
          url: Uri.parse(gatewayUrl),
          format: AppSettings.pushNotificationsPusherFormat.value,
          additionalProperties: {'endpoint': endpoint, 'auth': auth},
        ),
        kind: 'http',
      ),
      append: true,
    );
    await AppSettings.webPushRegisteredPushkey.setItem(p256dh);
    Logs().i('[WebPush] Pusher registered');
  } catch (e, s) {
    Logs().w('[WebPush] Unable to set up Web Push', e, s);
    if (interactive) rethrow;
  }
}
