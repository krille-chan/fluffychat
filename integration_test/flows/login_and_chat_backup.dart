import 'package:flutter_test/flutter_test.dart';

import '../utils/fluffy_chat_tester.dart';
import 'auth_flows.dart';

Future<void> loginAndChatBackup(WidgetTester widgetTester) => widgetTester
    .startFluffyChatTest()
    .then((tester) => tester._loginAndChatBackup());

extension on FluffyChatTester {
  Future<void> _loginAndChatBackup() async {
    await login();

    // Skip bootstrap
    await tapOn('Copy to clipboard');
    await tapOn('Next');
    await tapOn('Close');

    await skipNoNotificationsDialog();

    await logout();
  }
}
