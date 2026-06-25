// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/widgets/adaptive_dialogs/dialog_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/environment_constants.dart';
import '../utils/fluffy_chat_tester.dart';
import 'auth_flows.dart';

Future<void> loginAndChatBackup(WidgetTester widgetTester) => widgetTester
    .startFluffyChatTest()
    .then((tester) => tester._loginAndChatBackup());

extension on FluffyChatTester {
  Future<void> _loginAndChatBackup() async {
    // Set up with only recovery key:
    await login();
    await tapOn('Skip', pumpAndSettle: false);
    await tapOn('Store in Android KeyStore');
    await tapOn('Continue');
    await skipNoNotificationsDialog();
    await logout();

    // Restore with recovery key from keystore:
    await login();
    await tapOn('Unlock');
    await skipNoNotificationsDialog();
    await logout();

    // Reset with passphrase:
    await login();
    await waitFor('Restore Crypto Identity');
    await tapOn('Reset account');
    await tapOn('Reset account', index: 1);
    await enterText(TextField, passphrase1, index: 0);
    await enterText(TextField, passphrase1, index: 1);
    await tapOn('Continue', pumpAndSettle: false);
    await waitFor('Please enter your password');
    await enterText(DialogTextField, user1Pw, pumpAndSettle: false);
    await tapOn('Ok');
    await tapOn('Continue');
    AuthFlows.userPassphrases[user1Name] = passphrase1;
    await logout();

    // Restore with passphrase:
    await ensureLoggedIn();

    // Reset passphrase
    await tapOn(Key('accounts_and_settings_buttons'));
    await tapOn('Settings');
    await tapOn('Chat backup');
    await tapOn('Reset recovery key');
    await enterText(TextField, passphrase1, index: 0);
    await enterText(TextField, passphrase1, index: 1);
    await tapOn('Continue', pumpAndSettle: false);
    await waitFor('You are ready to start!');
    await tapOn('Continue');
    AuthFlows.userPassphrases[user1Name] = passphrase1;
  }
}
