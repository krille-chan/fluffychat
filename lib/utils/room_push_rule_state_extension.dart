// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';

extension RoomPushRuleStateExtension on Room {
  static const String encryptedRoomWakeupRulePrefix = 'encrypted_wakeup.';

  String get _encryptedRoomWakeupRuleId => '$encryptedRoomWakeupRulePrefix$id';

  PushRuleState get effectivePushRuleState => pushRuleState;

  Future<void> setEffectivePushRuleState(PushRuleState newState) async {
    if (!encrypted) {
      await _deleteEncryptedRoomWakeupRule();
      await setPushRuleState(newState);
      return;
    }

    switch (newState) {
      case PushRuleState.notify:
        if (pushRuleState != PushRuleState.notify) {
          await setPushRuleState(PushRuleState.notify);
        }
        await _deleteEncryptedRoomWakeupRule();
        break;
      case PushRuleState.mentionsOnly:
        if (pushRuleState != PushRuleState.mentionsOnly) {
          await setPushRuleState(PushRuleState.mentionsOnly);
        }
        await _setEncryptedRoomWakeupRule();
        break;
      case PushRuleState.dontNotify:
        await _deleteEncryptedRoomWakeupRule();
        await setPushRuleState(PushRuleState.dontNotify);
        break;
    }
  }

  Future<void> _setEncryptedRoomWakeupRule() async {
    await client.setPushRule(
      PushRuleKind.override,
      _encryptedRoomWakeupRuleId,
      ['notify'],
      conditions: [
        PushCondition(
          kind: PushRuleConditions.eventMatch.name,
          key: 'type',
          pattern: EventTypes.Encrypted,
        ),
        PushCondition(
          kind: PushRuleConditions.eventMatch.name,
          key: 'room_id',
          pattern: id,
        ),
      ],
    );
  }

  Future<void> _deleteEncryptedRoomWakeupRule() async {
    if (!client.hasEncryptedRoomWakeupRule(id)) return;
    await client.deletePushRule(
      PushRuleKind.override,
      _encryptedRoomWakeupRuleId,
    );
  }
}

extension EncryptedRoomWakeupRuleExtension on Client {
  bool hasEncryptedRoomWakeupRule(String roomId) {
    final ruleId =
        '${RoomPushRuleStateExtension.encryptedRoomWakeupRulePrefix}$roomId';
    return globalPushRules?.override?.any((rule) => rule.ruleId == ruleId) ??
        false;
  }

  bool isEncryptedRoomWakeupRule(PushRule rule) {
    if (!rule.ruleId.startsWith(
      RoomPushRuleStateExtension.encryptedRoomWakeupRulePrefix,
    )) {
      return false;
    }

    final conditions = rule.conditions;
    if (conditions == null) return false;

    final matchesEncryptedEvents = conditions.any(
      (condition) =>
          condition.kind == PushRuleConditions.eventMatch.name &&
          condition.key == 'type' &&
          condition.pattern == EventTypes.Encrypted,
    );
    final matchesARoom = conditions.any(
      (condition) =>
          condition.kind == PushRuleConditions.eventMatch.name &&
          condition.key == 'room_id',
    );
    return matchesEncryptedEvents && matchesARoom;
  }
}

extension SyncUpdatePushRuleStateExtension on SyncUpdate {
  bool get hasPushRuleStateUpdate =>
      accountData?.any((accountData) => accountData.type == 'm.push_rules') ??
      false;
}
