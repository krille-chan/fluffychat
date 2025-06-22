import 'package:matrix/matrix.dart';

import '../../config/app_config.dart';

extension VisibleInGuiExtension on List<Event> {
  List<Event> filterByVisibleInGui({String? exceptionEventId}) => where(
        (event) => event.isVisibleInGui || event.eventId == exceptionEventId,
      ).toList();
}

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
      (!AppConfig.hideUnknownEvents || isEventTypeKnown);

  bool get isState => !{
        EventTypes.Message,
        EventTypes.Sticker,
        EventTypes.Encrypted,
      }.contains(type);

  bool get isCollapsedState => !{
        EventTypes.Message,
        EventTypes.Sticker,
        EventTypes.Encrypted,
        EventTypes.RoomCreate,
        EventTypes.RoomTombstone,
      }.contains(type);
}
