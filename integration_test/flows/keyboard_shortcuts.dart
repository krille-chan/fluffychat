import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/fluffy_chat_tester.dart';
import 'auth_flows.dart';
import 'chat_flows.dart';

Future<void> keyboardShortcuts(WidgetTester widgetTester) => widgetTester
    .startFluffyChatTest()
    .then((tester) => tester._keyboardShortcuts());

extension on FluffyChatTester {
  Future<void> _keyboardShortcuts() async {
    await ensureLoggedIn();
    await ensureGroupChatCreated();
    await tapOn(ChatFlows.groupChatName);

    // Focus the input field and enter text
    final inputField = find.byKey(const Key('chat_input_field'));
    await tester.tap(inputField);
    await tester.pumpAndSettle();
    await tester.enterText(inputField, 'hello');
    await tester.pumpAndSettle();

    // Select all text with Ctrl+A
    await sendKeyCombo(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA);

    // Bold with Ctrl+B
    await sendKeyCombo(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB);

    // Verify the text field now contains **hello**
    final textField = tester.widget<EditableText>(
      find.descendant(of: inputField, matching: find.byType(EditableText)),
    );
    expect(textField.controller.text, '**hello**');

    // Clear and test italic: type new text, select, Ctrl+I
    await tester.enterText(inputField, 'world');
    await tester.pumpAndSettle();
    await sendKeyCombo(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA);
    await sendKeyCombo(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI);
    expect(textField.controller.text, '*world*');

    // Clear and test with no selection (cursor only): Ctrl+B inserts ****
    await tester.enterText(inputField, '');
    await tester.pumpAndSettle();
    await sendKeyCombo(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB);
    expect(textField.controller.text, '****');
  }
}
