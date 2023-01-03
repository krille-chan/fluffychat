import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/pages/chat/chat_view.dart';
import 'package:fluffychat/pages/chat_list/chat_list_body.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fluffychat/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

import 'extensions/default_flows.dart';
import 'extensions/wait_for.dart';
import 'users.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Integration Test',
    () {
      setUpAll(
        () async {
          // this random dialog popping up is super hard to cover in tests
          SharedPreferences.setMockInitialValues({
            SettingKeys.showNoGoogle: false,
          });
          try {
            Hive.deleteFromDisk();
            Hive.initFlutter();
          } catch (_) {}
        },
      );

      testWidgets(
        'Start app, login and logout',
        (WidgetTester tester) async {
          app.main();
          await tester.ensureAppStartedHomescreen();
          await tester.ensureLoggedOut();
        },
      );

      testWidgets(
        'Login again',
        (WidgetTester tester) async {
          app.main();
          await tester.ensureAppStartedHomescreen();
        },
      );

      testWidgets(
        'Start chat and send message',
        (WidgetTester tester) async {
          app.main();
          await tester.ensureAppStartedHomescreen();
          await tester.waitFor(find.byType(TextField));
          await tester.enterText(find.byType(TextField), Users.user2.name);
          await tester.pumpAndSettle();

          await tester.scrollUntilVisible(
            find.text('Chats'),
            500,
            scrollable: find.descendant(
              of: find.byType(ChatListViewBody),
              matching: find.byType(Scrollable),
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text('Chats'));
          await tester.pumpAndSettle();
          await tester.waitFor(find.byType(SearchTitle));
          await tester.pumpAndSettle();

          await tester.scrollUntilVisible(
            find.text(Users.user2.name).first,
            500,
            scrollable: find.descendant(
              of: find.byType(ChatListViewBody),
              matching: find.byType(Scrollable),
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text(Users.user2.name).first);

          try {
            await tester.waitFor(
              find.byType(ChatView),
              timeout: const Duration(seconds: 5),
            );
          } catch (_) {
            // in case the homeserver sends the username as search result
            if (find.byIcon(Icons.send_outlined).evaluate().isNotEmpty) {
              await tester.tap(find.byIcon(Icons.send_outlined));
              await tester.pumpAndSettle();
            }
          }

          await tester.waitFor(find.byType(ChatView));
          await tester.enterText(find.byType(TextField).last, 'Test');
          await tester.pumpAndSettle();
          try {
            await tester.waitFor(find.byIcon(Icons.send_outlined));
            await tester.tap(find.byIcon(Icons.send_outlined));
          } catch (_) {
            await tester.testTextInput.receiveAction(TextInputAction.done);
          }
          await tester.pumpAndSettle();
          await tester.waitFor(find.text('Test'));
          await tester.pumpAndSettle();
        },
      );
    },
  );
}
