// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/services.dart';

/// Dart wrapper around the native Android ConversationNotifications
/// MethodChannel.  All methods are no-ops on non-Android platforms.
class AndroidConversationNotifications {
  static const _channel = MethodChannel('chat.fluffy.fluffychat/conversations');

  /// Publishes (or updates) a long-lived dynamic shortcut for a Matrix room
  /// with SHORTCUT_CATEGORY_CONVERSATION so that Android classifies linked
  /// MessagingStyle notifications as Conversations.
  static Future<void> publishShortcut({
    required String id,
    required String name,
    required String roomUrl,
    Uint8List? avatar,
    bool isImportant = false,
  }) async {
    if (!PlatformInfos.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('publishShortcut', {
        'id': id,
        'name': name,
        'roomUrl': roomUrl,
        'avatar': ?avatar,
        'isImportant': isImportant,
      });
    } on PlatformException catch (e) {
      // Non-fatal: notification still shows without conversation shortcut.
      throw Exception('publishShortcut failed: ${e.message}');
    }
  }

  static Future<void> removeShortcuts(List<String> ids) async {
    if (!PlatformInfos.isAndroid || ids.isEmpty) return;
    await _channel.invokeMethod<void>('removeShortcuts', {'ids': ids});
  }

  /// Creates a per-room notification channel linked to its shortcut via
  /// setConversationId() so Android Settings shows per-conversation controls.
  /// If the channel already exists this is a no-op.
  static Future<void> createConversationChannel({
    required String id,
    required String name,
    String? groupId,
    required String parentChannelId,
    required String shortcutId,
  }) async {
    if (!PlatformInfos.isAndroid) return;
    await _channel.invokeMethod<void>('createConversationChannel', {
      'id': id,
      'name': name,
      'groupId': ?groupId,
      'parentChannelId': parentChannelId,
      'shortcutId': shortcutId,
    });
  }

  static Future<void> removeConversationChannels(List<String> ids) async {
    if (!PlatformInfos.isAndroid || ids.isEmpty) return;
    await _channel.invokeMethod<void>('removeConversationChannels', {
      'ids': ids,
    });
  }
}
