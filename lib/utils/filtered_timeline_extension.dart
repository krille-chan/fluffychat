import 'package:famedlysdk/famedlysdk.dart';

import '../app_config.dart';

extension FilteredTimelineExtension on Timeline {
  List<Event> getFilteredEvents({bool collapseRoomCreate = true}) {
    final filteredEvents = events
        .where((e) =>
            // always filter out edit and reaction relationships
            !{RelationshipTypes.Edit, RelationshipTypes.Reaction}
                .contains(e.relationshipType) &&
            // always filter out m.key.* events
            !e.type.startsWith('m.key.verification.') &&
            // event types to hide: redaction and reaction events
            // if a reaction has been redacted we also want it to be hidden in the timeline
            !{EventTypes.Reaction, EventTypes.Redaction}.contains(e.type) &&
            // if we enabled to hide all redacted events, don't show those
            (!AppConfig.hideRedactedEvents || !e.redacted) &&
            // if we enabled to hide all unknown events, don't show those
            (!AppConfig.hideUnknownEvents || e.isEventTypeKnown) &&
            // remove state events that we don't want to render
            (!{EventTypes.Message, EventTypes.Sticker, EventTypes.Encrypted}
                    .contains(e.type) ||
                !AppConfig.hideAllStateEvents))
        .toList();

    // Hide state events from the room creater right after the room created event
    if (collapseRoomCreate &&
        filteredEvents[filteredEvents.length - 1].type ==
            EventTypes.RoomCreate) {
      while (filteredEvents.length >= 3 &&
          filteredEvents[filteredEvents.length - 2].senderId ==
              filteredEvents[filteredEvents.length - 1].senderId &&
          ![EventTypes.Message, EventTypes.Sticker, EventTypes.Encrypted]
              .contains(filteredEvents[filteredEvents.length - 2].type)) {
        filteredEvents.removeAt(filteredEvents.length - 2);
      }
    }
    return filteredEvents;
  }
}
