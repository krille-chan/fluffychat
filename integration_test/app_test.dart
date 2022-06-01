import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fluffychat/main.dart' as app;

import 'users.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Test', () {
    test('Check server availability', () async {
      final response = await get(Uri.parse('$homeserver/_matrix/static/'));
      expect(response.statusCode, 200);
    }, timeout: const Timeout(Duration(seconds: 10)));
    testWidgets('Test if the app starts', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 10));

      await tester.pumpAndSettle();

      expect(find.text('Connect'), findsOneWidget);
      expect(find.text('Homeserver'), findsOneWidget);

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

      await tester.enterText(inputs.first, Users.alice.name);
      await tester.enterText(inputs.last, Users.alice.password);
      await tester.testTextInput.receiveAction(TextInputAction.done);
    });
  });
}
