import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/environment_constants.dart';
import '../utils/fluffy_chat_tester.dart';
import 'auth_flows.dart';

Future<void> multiAccount(WidgetTester widgetTester) => widgetTester
    .startFluffyChatTest()
    .then((tester) => tester._multiAccountAndNotifications());

extension on FluffyChatTester {
  Future<void> _multiAccountAndNotifications() async {
    await ensureLoggedIn();

    // Login user 2
    await tapOn(Key('accounts_and_settings_buttons'));
    await tapOn('Add account');
    await login(username: user2Name, password: user2Pw);
    await tapOn(CloseButton);
    await tapOn('Skip');

    // Logout user 2
    await tapOn(Key('accounts_and_settings_buttons'));
    await tapOn(user2Name);
    await tapOn(Key('accounts_and_settings_buttons'));
    await tapOn('Settings');
    await scrollUntilVisible('Logout');
    await tapOn('Logout');
    await tapOn(Key('ok_cancel_alert_dialog_ok_button'));
    await waitFor('One of your clients has been logged out');
  }
}
