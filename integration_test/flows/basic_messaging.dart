// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/fluffy_chat_tester.dart';
import 'auth_flows.dart';
import 'chat_flows.dart';

Future<void> basicMessaging(WidgetTester widgetTester) => widgetTester
    .startFluffyChatTest()
    .then((tester) => tester._basicMessaging());

extension on FluffyChatTester {
  Future<void> _basicMessaging() async {
    await ensureLoggedIn();
    await ensureGroupChatCreated();

    await tapOn(ChatFlows.groupChatName);
    const testMessage = 'Hello from integration test!';
    await enterText(Key('chat_input_field'), testMessage);
    await tapOn(Key('send_button'));
    await waitFor(testMessage);
    await goBack();
  }
}
