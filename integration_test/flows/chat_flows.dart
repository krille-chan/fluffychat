import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/widgets/chat_settings_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/fluffy_chat_tester.dart';
import 'auth_flows.dart';

Future<void> archiveChats(WidgetTester widgetTester) =>
    widgetTester.startFluffyChatTest().then((tester) => tester._archiveChats());

extension ChatFlows on FluffyChatTester {
  static const String groupChatName = 'Test Group 01';

  Future<void> ensureGroupChatCreated() async {
    if (await isVisible(groupChatName)) return;
    await tapOn(FloatingActionButton);
    await tapOn('Create group');
    await enterText(TextField, groupChatName);
    await tapOn('Create a group and invite users');
    await waitFor('Invite contact');
    await goBack();
    await goBack();
  }

  Future<void> _archiveChats() async {
    await ensureLoggedIn();
    await ensureGroupChatCreated();
    await tapOn(groupChatName);
    await tapOn(ChatSettingsPopupMenu);
    await tapOn('Leave');
    await waitFor('Are you sure?');
    await tapOn('Leave');
    await waitFor(ChatList);
  }
}
