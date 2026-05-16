// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';

extension EventCheckboxRoomExtension on Room {
  static const String relationshipType = 'im.fluffychat.checkboxes';
  Future<String?> checkCheckbox(
    String eventId,
    int checkboxId, {
    String? txid,
  }) => sendEvent(
    {
      'm.relates_to': {
        'rel_type': relationshipType,
        'event_id': eventId,
        'checkbox_id': checkboxId,
      },
    },
    type: EventTypes.Reaction,
    txid: txid,
  );
}

extension EventCheckboxExtension on Event {
  int? get checkedCheckboxId => content
      .tryGetMap<String, Object?>('m.relates_to')
      ?.tryGet<int>('checkbox_id');
}
