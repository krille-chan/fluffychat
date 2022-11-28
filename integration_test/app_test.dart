import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fluffychat/main.dart' as app;

import 'users.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Test', () {
    testWidgets('Test if the app starts', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 10));

      await tester.pumpAndSettle();

      expect(find.text('Connect'), findsOneWidget);

      final input = find.byType(TextField);

      expect(input, findsOneWidget);

      await tester.enterText(input, homeserver);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // in case registration is allowed
      try {
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();
      } catch (e) {
        log('Registration is not allowed. Proceeding with login...');
      }
      await tester.pumpAndSettle();

      final inputs = find.byType(TextField);

      await tester.enterText(inputs.first, Users.user1.name);
      await tester.enterText(inputs.last, Users.user1.password);
      await tester.testTextInput.receiveAction(TextInputAction.done);
    });
  });
}
