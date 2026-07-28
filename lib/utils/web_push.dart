// Schellout fork: Web Push registration via self-hosted Sygnal.
// No-op on non-web platforms (see web_push_stub.dart).
export 'web_push_stub.dart' if (dart.library.js_interop) 'web_push_web.dart';
