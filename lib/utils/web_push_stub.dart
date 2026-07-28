// Schellout fork: Web Push is only available on web builds.
import 'package:matrix/matrix.dart';

/// Whether Web Push is available and configured on this platform.
bool get webPushAvailable => false;

/// 'granted' | 'denied' | 'default' — always 'denied' off-web.
String get webPushPermissionState => 'denied';

/// Registers a Web Push subscription as a Matrix pusher. No-op off-web.
Future<void> setupWebPush(Client client, {bool interactive = false}) async {}
