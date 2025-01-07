import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const channel = MethodChannel('fcm_shared_isolate');
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // ignore: deprecated_member_use
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    // ignore: deprecated_member_use
    channel.setMockMethodCallHandler(null);
  });

  test('create', () async {});
}
