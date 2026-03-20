import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/widgets/chat_settings_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/fluffy_chat_tester.dart';
import 'auth_flows.dart';

Future<void> basicMessaging(WidgetTester widgetTester) => widgetTester
    .startFluffyChatTest()
    .then((tester) => tester._basicMessaging());

extension on FluffyChatTester {
  Future<void> _basicMessaging() async {
    final shouldLogout = await ensureLoggedIn();

    // Create a new group chat
    await tapOn(FloatingActionButton);
    await tapOn('Create group');
    await enterText(TextField, 'Test Group 01');
    await tapOn('Create a group and invite users');
    await waitFor('Invite contact');
    await goBack();

    // Send a message
    const testMessage = 'Hello from integration test!';
    await enterText(Key('chat_input_field'), testMessage);
    await tapOn(Key('send_button'));

    // Ensure message is visible
    await waitFor(testMessage);

    // Archive the chat
    await tapOn(ChatSettingsPopupMenu);
    await tapOn('Leave');
    await waitFor('Are you sure?');
    await tapOn('Leave');
    await waitFor(ChatList);

    if (shouldLogout) await logout();
  }
}
