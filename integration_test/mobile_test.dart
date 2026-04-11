import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'flows/auth_flows.dart';
import 'flows/basic_messaging.dart';
import 'flows/chat_flows.dart';
import 'flows/keyboard_shortcuts.dart';
import 'flows/login_and_chat_backup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FluffyChat Integration Tests', () {
    testWidgets('Login and logout flow', loginAndChatBackup);
    testWidgets('Basic Messaging', basicMessaging);
    testWidgets('Keyboard shortcuts', keyboardShortcuts);
    testWidgets('Archive chats', archiveChats);
    testWidgets('Final logout', finalLogout);
  });
}
