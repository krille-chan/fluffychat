import 'package:matrix/matrix.dart';

import '../../config/app_config.dart';

extension IsStateExtension on Event {
  bool get isVisibleInGui =>
      // always filter out edit and reaction relationships
      !{RelationshipTypes.edit, RelationshipTypes.reaction}
          .contains(relationshipType) &&
      // always filter out m.key.* events
      !type.startsWith('m.key.verification.') &&
      // event types to hide: redaction and reaction events
      // if a reaction has been redacted we also want it to be hidden in the timeline
      !{EventTypes.Reaction, EventTypes.Redaction}.contains(type) &&
      // if we enabled to hide all redacted events, don't show those
      (!AppConfig.hideRedactedEvents || !redacted) &&
      // if we enabled to hide all unknown events, don't show those
      (!AppConfig.hideUnknownEvents || isEventTypeKnown) &&
      // remove state events that we don't want to render
      (isState || !AppConfig.hideAllStateEvents) &&
      // hide unimportant state events
      (!AppConfig.hideUnimportantStateEvents ||
          !isState ||
          importantStateEvents.contains(type)) &&
      // hide simple join/leave member events in public rooms
      (!AppConfig.hideUnimportantStateEvents ||
          type != EventTypes.RoomMember ||
          room.joinRules != JoinRules.public ||
          content.tryGet<String>('membership') == 'ban' ||
          stateKey != senderId);

  static const Set<String> importantStateEvents = {
    EventTypes.Encryption,
    EventTypes.RoomCreate,
    EventTypes.RoomMember,
    EventTypes.RoomTombstone,
    EventTypes.CallInvite,
  };

  bool get isState => !{
        EventTypes.Message,
        EventTypes.Sticker,
        EventTypes.Encrypted
      }.contains(type);
}
