import 'dart:async';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:matrix/matrix.dart';

/// Represents an item in the completion cache.
class _RequestCacheItem {
  PracticeActivityRequest req;

  Future<PracticeActivityEvent?> practiceActivityEvent;

  _RequestCacheItem({
    required this.req,
    required this.practiceActivityEvent,
  });
}

/// Controller for handling activity completions.
class PracticeGenerationController {
  static final Map<int, _RequestCacheItem> _cache = {};
  Timer? _cacheClearTimer;

  PracticeGenerationController() {
    _initializeCacheClearing();
  }

  void _initializeCacheClearing() {
    const duration = Duration(minutes: 2);
    _cacheClearTimer = Timer.periodic(duration, (Timer t) => _clearCache());
  }

  void _clearCache() {
    _cache.clear();
  }

  void dispose() {
    _cacheClearTimer?.cancel();
  }

  Future<PracticeActivityEvent?> _sendAndPackageEvent(
    PracticeActivityModel model,
    PangeaMessageEvent pangeaMessageEvent,
  ) async {
    final Event? activityEvent = await pangeaMessageEvent.room.sendPangeaEvent(
      content: model.toJson(),
      parentEventId: pangeaMessageEvent.eventId,
      type: PangeaEventTypes.pangeaActivityRes,
    );

    if (activityEvent == null) {
      return null;
    }

    return PracticeActivityEvent(
      event: activityEvent,
      timeline: pangeaMessageEvent.timeline,
    );
  }

  Future<PracticeActivityEvent?> getPracticeActivity(
    PracticeActivityRequest req,
    PangeaMessageEvent event,
  ) async {
    final int cacheKey = req.hashCode;

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!.practiceActivityEvent;
    } else {
      //TODO - send request to server/bot, either via API or via event of type pangeaActivityReq
      // for now, just make and send the event from the client
      final Future<PracticeActivityEvent?> eventFuture =
          _sendAndPackageEvent(dummyModel(event), event);

      _cache[cacheKey] =
          _RequestCacheItem(req: req, practiceActivityEvent: eventFuture);

      return _cache[cacheKey]!.practiceActivityEvent;
    }
  }

  PracticeActivityModel dummyModel(PangeaMessageEvent event) =>
      PracticeActivityModel(
        tgtConstructs: [
          ConstructIdentifier(lemma: "be", type: ConstructType.vocab),
        ],
        activityType: ActivityTypeEnum.multipleChoice,
        langCode: event.messageDisplayLangCode,
        msgId: event.eventId,
        multipleChoice: MultipleChoice(
          question: "What is a synonym for 'happy'?",
          choices: ["sad", "angry", "joyful", "tired"],
          answer: "joyful",
        ),
      );
}
