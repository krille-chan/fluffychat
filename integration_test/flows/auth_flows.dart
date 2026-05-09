import 'package:fluffychat/pages/sign_in/view_model/model/public_homeserver_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/environment_constants.dart';
import '../utils/fluffy_chat_tester.dart';

Future<void> finalLogout(WidgetTester widgetTester) =>
    widgetTester.startFluffyChatTest().then((tester) => tester.logout());

extension AuthFlows on FluffyChatTester {
  Future<void> login({
    String username = user1Name,
    String password = user1Pw,
  }) async {
    await waitFor('Sign in');
    await tapOn('Sign in');
    await enterText(TextField, 'http://$homeserver', index: 0);
    await tapOn(RadioListTile<PublicHomeserverData>, index: 0);
    await tapOn('Continue');
    await waitFor('Log in to http://$homeserver');
    await enterText(TextField, username, index: 0);
    await enterText(TextField, password, index: 1);
    await tapOn('Login');
  }

  Future<void> logout() async {
    await ensureLoggedIn();
    await tapOn(Key('accounts_and_settings_buttons'));
    await tapOn('Settings');
    await scrollUntilVisible('Logout');
    await tapOn('Logout');
    await tapOn(Key('ok_cancel_alert_dialog_ok_button'));
    await waitFor('Sign in');
  }

  Future<void> skipNoNotificationsDialog() async {
    if (await isVisible('Push notifications not available')) {
      await tapOn('Do not show again');
    }
  }

  Future<bool> ensureLoggedIn() async {
    if (await isVisible('Sign in') == false) return false;

    await login();
    await tapOn(CloseButton);
    await tapOn('Skip');
    await skipNoNotificationsDialog();
    return true;
  }
}
