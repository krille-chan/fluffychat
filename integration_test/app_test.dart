import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fluffychat/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Test', () {
    testWidgets('Test if the app starts', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      find.byWidgetPredicate((widget) => Widget is HomeserverPicker);
      await tester.pumpAndSettle();
    });
  });
}
