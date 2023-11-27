// Package imports:
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import '../extensions/pangea_room_extension.dart';
import '../models/class_model.dart';

class RoomRulesEditController {
  final Room? room;

  late PangeaRoomRules rules;

  RoomRulesEditController([this.room]) {
    rules = room?.pangeaRoomRules ?? PangeaRoomRules();
  }

  StateEvent get toStateEvent => StateEvent(
        content: rules.toJson(),
        type: PangeaEventTypes.rules,
      );
}
