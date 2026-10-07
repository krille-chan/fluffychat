// SPDX-FileCopyrightText: 2026 Brandon Dick
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/pages/chat_list/unread_bubble.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hides a stale server count when the room has no new messages', () {
    expect(
      effectiveUnreadNotificationCount(
        notificationCount: 1,
        hasNewMessages: false,
      ),
      0,
    );
  });

  test('keeps a real server count when the room has new messages', () {
    expect(
      effectiveUnreadNotificationCount(
        notificationCount: 1,
        hasNewMessages: true,
      ),
      1,
    );
  });
}
