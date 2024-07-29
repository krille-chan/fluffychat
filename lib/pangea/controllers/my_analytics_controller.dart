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
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// handles the processing of analytics for
/// 1) messages sent by the user and
/// 2) constructs used by the user, both in sending messages and doing practice activities
class MyAnalyticsController extends BaseController {
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
    _refreshAnalyticsIfOutdated();

    // Listen to a stream that provides the eventIDs
    // of new messages sent by the logged in user
    stateStream
        .where((data) => data is Map && data.containsKey("eventID"))
        .listen((data) {
      updateAnalyticsTimer(data['eventID']);
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

  Client get _client => _pangeaController.matrixState.client;

  /// Given an newly sent message, reset the timer
  /// and add the event ID to the cache of un-added event IDs
  void updateAnalyticsTimer(String newEventId) {
    addMessageSinceUpdate(newEventId);

    // cancel the last timer that was set on message event and
    // reset it to fire after _minutesBeforeUpdate minutes
    _updateTimer?.cancel();
    _updateTimer = Timer(Duration(minutes: _minutesBeforeUpdate), () {
      debugPrint("timer fired, updating analytics");
      updateAnalytics();
    });
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
    final Room analyticsRoom = await _client.getMyAnalyticsRoom(userL2!);

    // get the last time analytics were updated for this room
    final DateTime? l2AnalyticsLastUpdated =
        await analyticsRoom.analyticsLastUpdated(
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
      await analyticsRoom.sendConstructsEvent(
        recentConstructUses,
      );
    }
  }
}
