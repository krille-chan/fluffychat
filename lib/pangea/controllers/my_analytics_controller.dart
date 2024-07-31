import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_record_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/choreo_record.dart';
import 'package:fluffychat/pangea/models/representation_content_model.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

/// handles the processing of analytics for
/// 1) messages sent by the user and
/// 2) constructs used by the user, both in sending messages and doing practice activities
class MyAnalyticsController extends BaseController {
  late PangeaController _pangeaController;
  final StreamController analyticsUpdateStream = StreamController.broadcast();
  Timer? _updateTimer;

  Client get _client => _pangeaController.matrixState.client;

  String? get userL2 => _pangeaController.languageController.activeL2Code();

  /// the max number of messages that will be cached before
  /// an automatic update is triggered
  final int _maxMessagesCached = 1;

  /// the number of minutes before an automatic update is triggered
  final int _minutesBeforeUpdate = 5;

  /// the time since the last update that will trigger an automatic update
  final Duration _timeSinceUpdate = const Duration(days: 1);

  MyAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;

    // Wait for the next sync in the stream to ensure that the pangea controller
    // is fully initialized. It will throw an error if it is not.
    _pangeaController.matrixState.client.onSync.stream.first
        .then((_) => _refreshAnalyticsIfOutdated());

    // Listen to a stream that provides the eventIDs
    // of new messages sent by the logged in user
    stateStream.where((data) => data is Map).listen((data) {
      onMessageSent(data as Map<String, dynamic>);
    });
  }

  /// If analytics haven't been updated in the last day, update them
  Future<DateTime?> _refreshAnalyticsIfOutdated() async {
    /// wait for the initial sync to finish, so the
    /// timeline data from analytics rooms is accurate
    if (_client.prevBatch == null) {
      await _client.onSync.stream.first;
    }

    DateTime? lastUpdated =
        await _pangeaController.analytics.myAnalyticsLastUpdated();
    final DateTime yesterday = DateTime.now().subtract(_timeSinceUpdate);

    if (lastUpdated?.isBefore(yesterday) ?? true) {
      debugPrint("analytics out-of-date, updating");
      await updateAnalytics();
      lastUpdated = await _pangeaController.analytics.myAnalyticsLastUpdated();
    }
    return lastUpdated;
  }

  /// Given the data from a newly sent message, format and cache
  /// the message's construct data locally and reset the update timer
  void onMessageSent(Map<String, dynamic> data) {
    // cancel the last timer that was set on message event and
    // reset it to fire after _minutesBeforeUpdate minutes
    _updateTimer?.cancel();
    _updateTimer = Timer(Duration(minutes: _minutesBeforeUpdate), () {
      debugPrint("timer fired, updating analytics");
      updateAnalytics();
    });

    // extract the relevant data about this message
    final String? eventID = data['eventID'];
    final String? roomID = data['roomID'];
    final PangeaRepresentation? originalSent = data['originalSent'];
    final PangeaMessageTokens? tokensSent = data['tokensSent'];
    final ChoreoRecord? choreo = data['choreo'];

    if (roomID == null || eventID == null) return;

    // convert that data into construct uses and add it to the cache
    final metadata = ConstructUseMetaData(
      roomId: roomID,
      eventId: eventID,
      timeStamp: DateTime.now(),
    );

    final grammarConstructs = choreo?.grammarConstructUses(metadata: metadata);
    final itConstructs = choreo?.itStepsToConstructUses(metadata: metadata);
    final vocabUses = tokensSent != null
        ? originalSent?.vocabUses(
            choreo: choreo,
            tokens: tokensSent.tokens,
            metadata: metadata,
          )
        : null;
    final List<OneConstructUse> constructs = [
      ...(grammarConstructs ?? []),
      ...(itConstructs ?? []),
      ...(vocabUses ?? []),
    ];
    addMessageSinceUpdate(
      eventID,
      constructs,
    );
  }

  /// Add a list of construct uses for a new message to the local
  /// cache of recently sent messages
  void addMessageSinceUpdate(
    String eventID,
    List<OneConstructUse> constructs,
  ) {
    try {
      final currentCache = _pangeaController.analytics.messagesSinceUpdate;
      if (!currentCache.containsKey(eventID)) {
        currentCache[eventID] = constructs;
        setMessagesSinceUpdate(currentCache);
      }

      // if the cached has reached if max-length, update analytics
      if (_pangeaController.analytics.messagesSinceUpdate.length >
          _maxMessagesCached) {
        debugPrint("reached max messages, updating");
        updateAnalytics();
      }
    } catch (e, s) {
      ErrorHandler.logError(
        e: PangeaWarningError("Failed to add message since update: $e"),
        s: s,
        m: 'Failed to add message since update for eventId: $eventID',
      );
    }
  }

  /// Clears the local cache of recently sent constructs. Called before updating analytics
  void clearMessagesSinceUpdate() {
    setMessagesSinceUpdate({});
  }

  /// Save the local cache of recently sent constructs to the local storage
  void setMessagesSinceUpdate(Map<String, List<OneConstructUse>> cache) {
    final formattedCache = {};
    for (final entry in cache.entries) {
      final constructJsons = entry.value.map((e) => e.toJson()).toList();
      formattedCache[entry.key] = constructJsons;
    }
    _pangeaController.pStoreService.save(
      PLocalKey.messagesSinceUpdate,
      formattedCache,
    );
    analyticsUpdateStream.add(null);
  }

  Completer<void>? _updateCompleter;
  Future<void> updateAnalytics() async {
    if (!(_updateCompleter?.isCompleted ?? true)) {
      await _updateCompleter!.future;
      return;
    }
    _updateCompleter = Completer<void>();
    try {
      await _updateAnalytics();
      clearMessagesSinceUpdate();
      analyticsUpdateStream.add(null);
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        m: "Failed to update analytics",
        s: s,
      );
    } finally {
      _updateCompleter?.complete();
      _updateCompleter = null;
    }
  }

  /// top level analytics sending function. Gather recent messages and activity records,
  /// convert them into the correct formats, and send them to the analytics room
  Future<void> _updateAnalytics() async {
    // if missing important info, don't send analytics. Could happen if user just signed up.
    if (userL2 == null || _client.userID == null) return;

    // analytics room for the user and current target language
    final Room? analyticsRoom = await _client.getMyAnalyticsRoom(userL2!);

    // get the last time analytics were updated for this room
    final DateTime? l2AnalyticsLastUpdated =
        await analyticsRoom?.analyticsLastUpdated(
      _client.userID!,
    );

    // all chats in which user is a student
    final List<Room> chats = _client.rooms
        .where((room) => !room.isSpace && !room.isAnalyticsRoom)
        .toList();

    // get the recent message events and activity records for each chat
    final List<Future<List<Event>>> recentMsgFutures = [];
    final List<Future<List<Event>>> recentActivityFutures = [];
    for (final Room chat in chats) {
      recentMsgFutures.add(
        chat.getEventsBySender(
          type: EventTypes.Message,
          sender: _client.userID!,
          since: l2AnalyticsLastUpdated,
        ),
      );
      recentActivityFutures.add(
        chat.getEventsBySender(
          type: PangeaEventTypes.activityRecord,
          sender: _client.userID!,
          since: l2AnalyticsLastUpdated,
        ),
      );
    }
    final List<List<Event>> recentMsgs =
        (await Future.wait(recentMsgFutures)).toList();
    final List<PracticeActivityRecordEvent> recentActivityRecords =
        (await Future.wait(recentActivityFutures))
            .expand((e) => e)
            .map((event) => PracticeActivityRecordEvent(event: event))
            .toList();

    // get the timelines for each chat
    final List<Future<Timeline>> timelineFutures = [];
    for (final chat in chats) {
      timelineFutures.add(chat.getTimeline());
    }
    final List<Timeline> timelines = await Future.wait(timelineFutures);
    final Map<String, Timeline> timelineMap =
        Map.fromIterables(chats.map((e) => e.id), timelines);

    //convert into PangeaMessageEvents
    final List<List<PangeaMessageEvent>> recentPangeaMessageEvents = [];
    for (final (index, eventList) in recentMsgs.indexed) {
      recentPangeaMessageEvents.add(
        eventList
            .map(
              (event) => PangeaMessageEvent(
                event: event,
                timeline: timelines[index],
                ownMessage: true,
              ),
            )
            .toList(),
      );
    }

    final List<PangeaMessageEvent> allRecentMessages =
        recentPangeaMessageEvents.expand((e) => e).toList();

    // get constructs for messages
    final List<OneConstructUse> recentConstructUses = [];
    for (final PangeaMessageEvent message in allRecentMessages) {
      recentConstructUses.addAll(message.allConstructUses);
    }

    // get constructs for practice activities
    final List<Future<List<OneConstructUse>>> constructFutures = [];
    for (final PracticeActivityRecordEvent activity in recentActivityRecords) {
      final Timeline? timeline = timelineMap[activity.event.roomId!];
      if (timeline == null) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "PracticeActivityRecordEvent has null timeline",
          data: activity.event.toJson(),
        );
        continue;
      }
      constructFutures.add(activity.uses(timeline));
    }
    final List<List<OneConstructUse>> constructLists =
        await Future.wait(constructFutures);

    recentConstructUses.addAll(constructLists.expand((e) => e));

    //TODO - confirm that this is the correct construct content
    // debugger(
    //   when: kDebugMode,
    // );
    // ;    debugger(
    //       when: kDebugMode &&
    //           (allRecentMessages.isNotEmpty || recentActivityRecords.isNotEmpty),
    //     );

    if (recentConstructUses.isNotEmpty || l2AnalyticsLastUpdated == null) {
      await analyticsRoom?.sendConstructsEvent(
        recentConstructUses,
      );
    }
  }
}
