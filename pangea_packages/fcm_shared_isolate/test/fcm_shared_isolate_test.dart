import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fcm_shared_isolate/fcm_shared_isolate.dart';

void main() {
  const channel = MethodChannel('fcm_shared_isolate');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('create', () {
    FcmSharedIsolate();
  });
}
