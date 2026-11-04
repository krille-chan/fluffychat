// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/pages/chat/events/swipe_to_reply.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<int> swipe(
    WidgetTester tester,
    double dx, {
    bool rightToLeft = false,
  }) async {
    var replies = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeToReply(
            rightToLeft: rightToLeft,
            onReply: () => replies++,
            child: const SizedBox(width: 200, height: 50, child: Text('msg')),
          ),
        ),
      ),
    );
    await tester.drag(find.text('msg'), Offset(dx, 0));
    await tester.pumpAndSettle();
    return replies;
  }

  testWidgets('Swiping past the threshold replies', (tester) async {
    expect(await swipe(tester, 100), 1);
    expect(await swipe(tester, -100, rightToLeft: true), 1);
  });

  testWidgets('Short or wrong direction swipes do not reply', (tester) async {
    expect(await swipe(tester, 30), 0);
    expect(await swipe(tester, -100), 0);
    expect(await swipe(tester, 100, rightToLeft: true), 0);
  });
}
