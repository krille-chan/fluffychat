import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/pages/chat/chat_view.dart';
import 'package:fluffychat/pages/chat_list/chat_list_body.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/pages/invitation_selection/invitation_selection_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
            find.text('Chats').first,
            500,
            scrollable: find
                .descendant(
                  of: find.byType(ChatListViewBody),
                  matching: find.byType(Scrollable),
                )
                .first,
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text('Chats'));
          await tester.pumpAndSettle();
          await tester.waitFor(find.byType(SearchTitle));
          await tester.pumpAndSettle();

          await tester.scrollUntilVisible(
            find.text(Users.user2.name).first,
            500,
            scrollable: find
                .descendant(
                  of: find.byType(ChatListViewBody),
                  matching: find.byType(Scrollable),
                )
                .first,
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

      testWidgets('Spaces', (tester) async {
        app.main();
        await tester.ensureAppStartedHomescreen();

        await tester.waitFor(find.byTooltip('Show menu'));
        await tester.tap(find.byTooltip('Show menu'));
        await tester.pumpAndSettle();

        await tester.waitFor(find.byIcon(Icons.workspaces_outlined));
        await tester.tap(find.byIcon(Icons.workspaces_outlined));
        await tester.pumpAndSettle();

        await tester.waitFor(find.byType(TextField));
        await tester.enterText(find.byType(TextField).last, 'Test Space');
        await tester.pumpAndSettle();

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester.waitFor(find.text('Invite contact'));

        await tester.tap(find.text('Invite contact'));
        await tester.pumpAndSettle();

        await tester.waitFor(
          find.descendant(
            of: find.byType(InvitationSelectionView),
            matching: find.byType(TextField),
          ),
        );
        await tester.enterText(
          find.descendant(
            of: find.byType(InvitationSelectionView),
            matching: find.byType(TextField),
          ),
          Users.user2.name,
        );

        await Future.delayed(const Duration(milliseconds: 250));
        await tester.testTextInput.receiveAction(TextInputAction.done);

        await Future.delayed(const Duration(milliseconds: 1000));
        await tester.pumpAndSettle();

        await tester.tap(
          find
              .descendant(
                of: find.descendant(
                  of: find.byType(InvitationSelectionView),
                  matching: find.byType(ListTile),
                ),
                matching: find.text(Users.user2.name),
              )
              .last,
        );
        await tester.pumpAndSettle();

        await tester.waitFor(find.maybeUppercaseText('Yes'));
        await tester.tap(find.maybeUppercaseText('Yes'));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();

        await tester.waitFor(find.text('Load 2 more participants'));
        await tester.tap(find.text('Load 2 more participants'));
        await tester.pumpAndSettle();

        expect(find.text(Users.user2.name), findsOneWidget);
      });
    },
  );
}
