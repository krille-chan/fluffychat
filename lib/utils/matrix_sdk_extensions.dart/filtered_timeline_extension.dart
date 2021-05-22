import 'package:famedlysdk/famedlysdk.dart';

import '../../config/app_config.dart';

extension FilteredTimelineExtension on Timeline {
  List<Event> getFilteredEvents({Set<String> unfolded = const {}}) {
    final filteredEvents = events
        .where((e) =>
            // always filter out edit and reaction relationships
            !{RelationshipTypes.edit, RelationshipTypes.reaction}
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
            (e.isState || !AppConfig.hideAllStateEvents))
        .toList();

    // Fold state events
    var counter = 0;
    for (var i = filteredEvents.length - 1; i >= 0; i--) {
      if (!filteredEvents[i].isState) continue;
      if (i > 0 &&
          filteredEvents[i - 1].isState &&
          !unfolded.contains(filteredEvents[i - 1].eventId)) {
        counter++;
        filteredEvents[i].unsigned['im.fluffychat.collapsed_state_event'] =
            true;
      } else {
        filteredEvents[i].unsigned['im.fluffychat.collapsed_state_event'] =
            false;
        filteredEvents[i]
            .unsigned['im.fluffychat.collapsed_state_event_count'] = counter;
        counter = 0;
      }
    }
    return filteredEvents;
  }
}

extension IsStateExtension on Event {
  bool get isState => !{
        EventTypes.Message,
        EventTypes.Sticker,
        EventTypes.Encrypted
      }.contains(type);
}
