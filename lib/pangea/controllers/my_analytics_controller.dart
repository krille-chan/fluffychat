import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_record_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/analytics/summary_analytics_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../extensions/client_extension/client_extension.dart';
import '../extensions/pangea_room_extension/pangea_room_extension.dart';

/// handles the processing of analytics for
/// 1) messages sent by the user and
/// 2) constructs used by the user, both in sending messages and doing practice activities
class MyAnalyticsController {
  late PangeaController _pangeaController;
  Timer? _updateTimer;

  /// the max number of messages that will be cached before
  /// an automatic update is triggered
  final int _maxMessagesCached = 10;

  /// the number of minutes before an automatic update is triggered
  final int _minutesBeforeUpdate = 5;

  /// the time since the last update that will trigger an automatic update
  final Duration _timeSinceUpdate = const Duration(days: 1);

  MyAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  /// adds the listener that handles when to run automatic updates
  /// to analytics - either after a certain number of messages sent
  /// received or after a certain amount of time [_timeSinceUpdate] without an update
  Future<void> initialize() async {
    final lastUpdated = await _refreshAnalyticsIfOutdated();

    // listen for new messages and updateAnalytics timer
    // we are doing this in an attempt to update analytics when activitiy is low
    // both in messages sent by this client and other clients that you're connected with
    // doesn't account for messages sent by other clients that you're not connected with
    _client.onSync.stream
        .where((SyncUpdate update) => update.rooms?.join != null)
        .listen((update) {
      updateAnalyticsTimer(update, lastUpdated);
    });
  }

  /// If analytics haven't been updated in the last day, update them
  Future<DateTime?> _refreshAnalyticsIfOutdated() async {
    DateTime? lastUpdated = await _pangeaController.analytics
        .myAnalyticsLastUpdated(PangeaEventTypes.summaryAnalytics);
    final DateTime yesterday = DateTime.now().subtract(_timeSinceUpdate);

    if (lastUpdated?.isBefore(yesterday) ?? true) {
      debugPrint("analytics out-of-date, updating");
      await updateAnalytics();
      lastUpdated = await _pangeaController.analytics
          .myAnalyticsLastUpdated(PangeaEventTypes.summaryAnalytics);
    }
    return lastUpdated;
  }

  Client get _client => _pangeaController.matrixState.client;

  /// Given an update from sync stream, check if the update contains
  /// messages for which analytics will be saved. If so, reset the timer
  /// and add the event ID to the cache of un-added event IDs
  void updateAnalyticsTimer(SyncUpdate update, DateTime? lastUpdated) {
    for (final entry in update.rooms!.join!.entries) {
      final Room room = _client.getRoomById(entry.key)!;

      // get the new events in this sync that are messages
      final List<Event>? events = entry.value.timeline?.events
          ?.map((event) => Event.fromMatrixEvent(event, room))
          .where((event) => hasUserAnalyticsToCache(event, lastUpdated))
          .toList();

      // add their event IDs to the cache of un-added event IDs
      if (events == null || events.isEmpty) continue;
      for (final event in events) {
        addMessageSinceUpdate(event.eventId);
      }

      // cancel the last timer that was set on message event and
      // reset it to fire after _minutesBeforeUpdate minutes
      _updateTimer?.cancel();
      _updateTimer = Timer(Duration(minutes: _minutesBeforeUpdate), () {
        debugPrint("timer fired, updating analytics");
        updateAnalytics();
      });
    }
  }

  // checks if event from sync update is a message that should have analytics
  bool hasUserAnalyticsToCache(Event event, DateTime? lastUpdated) {
    return event.senderId == _client.userID &&
        (lastUpdated == null || event.originServerTs.isAfter(lastUpdated)) &&
        event.type == EventTypes.Message &&
        event.messageType == MessageTypes.Text &&
        !(event.eventId.contains("web") &&
            !(event.eventId.contains("android")) &&
            !(event.eventId.contains("iOS")));
  }

  // adds an event ID to the cache of un-added event IDs
  // if the event IDs isn't already added
  void addMessageSinceUpdate(String eventId) {
    try {
      final List<String> currentCache = messagesSinceUpdate;
      if (!currentCache.contains(eventId)) {
        currentCache.add(eventId);
        _pangeaController.pStoreService.save(
          PLocalKey.messagesSinceUpdate,
          currentCache,
        );
      }

      // if the cached has reached if max-length, update analytics
      if (messagesSinceUpdate.length > _maxMessagesCached) {
        debugPrint("reached max messages, updating");
        updateAnalytics();
      }
    } catch (exception, stackTrace) {
      ErrorHandler.logError(
        e: PangeaWarningError("Failed to add message since update: $exception"),
        s: stackTrace,
        m: 'Failed to add message since update for eventId: $eventId',
      );
      Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setExtra(
            'extra_info',
            'Failed during addMessageSinceUpdate with eventId: $eventId',
          );
          scope.setTag('where', 'addMessageSinceUpdate');
        },
      );
    }
  }

  // called before updating analytics
  void clearMessagesSinceUpdate() {
    _pangeaController.pStoreService.save(
      PLocalKey.messagesSinceUpdate,
      [],
    );
  }

  // a local cache of eventIds for messages sent since the last update
  // it's possible for this cache to be invalid or deleted
  // It's a proxy measure for messages sent since last update
  List<String> get messagesSinceUpdate {
    try {
      Logs().d('Reading messages since update from local storage');
      final dynamic locallySaved = _pangeaController.pStoreService.read(
        PLocalKey.messagesSinceUpdate,
      );
      if (locallySaved == null) {
        Logs().d('No locally saved messages found, initializing empty list.');
        _pangeaController.pStoreService.save(
          PLocalKey.messagesSinceUpdate,
          [],
        );
        return [];
      }
      return locallySaved.cast<String>();
    } catch (exception, stackTrace) {
      ErrorHandler.logError(
        e: PangeaWarningError(
          "Failed to get messages since update: $exception",
        ),
        s: stackTrace,
        m: 'Failed to retrieve messages since update',
      );
      Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setExtra(
            'extra_info',
            'Error during messagesSinceUpdate getter',
          );
          scope.setTag('where', 'messagesSinceUpdate');
        },
      );
      _pangeaController.pStoreService.save(
        PLocalKey.messagesSinceUpdate,
        [],
      );
      return [];
    }
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

  String? get userL2 => _pangeaController.languageController.activeL2Code();

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
      PangeaEventTypes.summaryAnalytics,
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
      timelineFutures.add(
        chat.timeline == null
            ? chat.getTimeline()
            : Future.value(chat.timeline),
      );
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

    final List<RecentMessageRecord> summaryContent =
        SummaryAnalyticsModel.formatSummaryContent(allRecentMessages);
    // if there's new content to be sent, or if lastUpdated hasn't been
    // set yet for this room, send the analytics events
    if (summaryContent.isNotEmpty || l2AnalyticsLastUpdated == null) {
      await analyticsRoom?.sendSummaryAnalyticsEvent(
        summaryContent,
      );
    }

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

    if (recentConstructUses.isNotEmpty) {
      await analyticsRoom?.sendConstructsEvent(
        recentConstructUses,
      );
    }
  }
}
