import 'dart:async';
import 'dart:developer';

<<<<<<< Updated upstream
import 'package:fluffychat/pangea/constants/language_constants.dart';
=======
>>>>>>> Stashed changes
import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/analytics/summary_analytics_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

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
    final List<String> currentCache = messagesSinceUpdate;
    if (!currentCache.contains(eventId)) {
      currentCache.add(eventId);
      _pangeaController.pStoreService.save(
        PLocalKey.messagesSinceUpdate,
        currentCache,
        local: true,
      );
    }

    // if the cached has reached if max-length, update analytics
    if (messagesSinceUpdate.length > _maxMessagesCached) {
      debugPrint("reached max messages, updating");
      updateAnalytics();
    }
  }

  // called before updating analytics
  void clearMessagesSinceUpdate() {
    _pangeaController.pStoreService.save(
      PLocalKey.messagesSinceUpdate,
      [],
      local: true,
    );
  }

  // a local cache of eventIds for messages sent since the last update
  // it's possible for this cache to be invalid or deleted
  // It's a proxy measure for messages sent since last update
  List<String> get messagesSinceUpdate {
    final dynamic locallySaved = _pangeaController.pStoreService.read(
      PLocalKey.messagesSinceUpdate,
      local: true,
    );
    if (locallySaved == null) {
      _pangeaController.pStoreService.save(
        PLocalKey.messagesSinceUpdate,
        [],
        local: true,
      );
      return [];
    }

    try {
      return locallySaved as List<String>;
    } catch (err) {
      _pangeaController.pStoreService.save(
        PLocalKey.messagesSinceUpdate,
        [],
        local: true,
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

  // top level analytics sending function. Send analytics
  // for each type of analytics event
  // to each of the applicable analytics rooms
  Future<void> _updateAnalytics() async {
    // if missing important info, don't send analytics
    if (userL2 == null || _client.userID == null) {
      debugger(when: kDebugMode);
      return;
    }

    // get the last updated time for each analytics room
    // and the least recent update, which will be used to determine
    // how far to go back in the chat history to get messages
    final Map<String, DateTime?> lastUpdatedMap = await _pangeaController
        .matrixState.client
        .allAnalyticsRoomsLastUpdated();
    final List<DateTime> lastUpdates = lastUpdatedMap.values
        .where((lastUpdate) => lastUpdate != null)
        .cast<DateTime>()
        .toList();

    /// Get the last time that analytics to for current target language
    /// were updated. This my present a problem is the user has analytics
    /// rooms for multiple languages, and a non-target language was updated
    /// less recently than the target language. In this case, some data may
    /// be missing, but a case like that seems relatively rare, and could
    /// result in unnecessaily going too far back in the chat history
    DateTime? l2AnalyticsLastUpdated = lastUpdatedMap[userL2];
    if (l2AnalyticsLastUpdated == null) {
      /// if the target language has never been updated, use the least
      /// recent update time
      lastUpdates.sort((a, b) => a.compareTo(b));
      l2AnalyticsLastUpdated =
          lastUpdates.isNotEmpty ? lastUpdates.first : null;
    }

    final List<Room> chats = await _client.chatsImAStudentIn;

    final List<PangeaMessageEvent> recentMsgs =
        await _getMessagesWithUnsavedAnalytics(
      l2AnalyticsLastUpdated,
      chats,
    );

    final List<ActivityRecordResponse> recentActivities =
        await getRecentActivities(userL2!, l2AnalyticsLastUpdated, chats);

    // FOR DISCUSSION:
    // we want to make sure we save something for every message send
    // however, we're currently saving analytics for messages not in the userL2
    // based on bad language detection results. maybe it would be better to
    // save the analytics for these messages in the userL2 analytics room, but
    // with useType of unknown

    final Room analyticsRoom = await _client.getMyAnalyticsRoom(userL2!);

    // if there is no analytics room for this langCode, then user hadn't sent
    // message in this language at the time of the last analytics update
    // so fallback to the least recent update time
    final DateTime? lastUpdated =
        lastUpdatedMap[analyticsRoom.id] ?? l2AnalyticsLastUpdated;

    // final String msgLangCode = (msg.originalSent?.langCode != null &&
    //         msg.originalSent?.langCode != LanguageKeys.unknownLanguage)
    //     ? msg.originalSent!.langCode
    //     : userL2;

    // finally, send the analytics events to the analytics room
    await _sendAnalyticsEvents(
      analyticsRoom,
      recentMsgs,
      lastUpdated,
      recentActivities,
    );
  }

  Future<List<ActivityRecordResponse>> getRecentActivities(
    String userL2,
    DateTime? lastUpdated,
    List<Room> chats,
  ) async {
    final List<Future<List<Event>>> recentActivityFutures = [];
    for (final Room chat in chats) {
      recentActivityFutures.add(
        chat.getEventsBySender(
          type: PangeaEventTypes.activityRecord,
          sender: _client.userID!,
          since: lastUpdated,
        ),
      );
    }
    final List<List<Event>> recentActivityLists =
        await Future.wait(recentActivityFutures);

    return recentActivityLists
        .expand((e) => e)
        .map((e) => ActivityRecordResponse.fromJson(e.content))
        .toList();
  }

  /// Returns the new messages that have not yet been saved to analytics.
  /// The keys in the map correspond to different categories or groups of messages,
  /// while the values are lists of [PangeaMessageEvent] objects belonging to each category.
  Future<List<PangeaMessageEvent>> _getMessagesWithUnsavedAnalytics(
    DateTime? since,
    List<Room> chats,
  ) async {
    // get the recent messages for each chat
    final List<Future<List<PangeaMessageEvent>>> futures = [];
    for (final Room chat in chats) {
      futures.add(
        chat.myMessageEventsInChat(
          since: since,
        ),
      );
    }
    final List<List<PangeaMessageEvent>> recentMsgLists =
        await Future.wait(futures);

    // flatten the list of lists of messages
    return recentMsgLists.expand((e) => e).toList();
  }

  Future<void> _sendAnalyticsEvents(
    Room analyticsRoom,
    List<PangeaMessageEvent> recentMsgs,
    DateTime? lastUpdated,
    List<ActivityRecordResponse> recentActivities,
  ) async {
    final List<OneConstructUse> constructContent = [];

    if (recentMsgs.isNotEmpty) {
      // remove messages that were sent before the last update

      // format the analytics data
      final List<RecentMessageRecord> summaryContent =
          SummaryAnalyticsModel.formatSummaryContent(recentMsgs);
      // if there's new content to be sent, or if lastUpdated hasn't been
      // set yet for this room, send the analytics events
      if (summaryContent.isNotEmpty || lastUpdated == null) {
        await analyticsRoom.sendSummaryAnalyticsEvent(
          summaryContent,
        );
      }

      constructContent
          .addAll(ConstructAnalyticsModel.formatConstructsContent(recentMsgs));
    }

    if (recentActivities.isNotEmpty) {
      // TODO - Concert recentActivities into list of constructUse objects.
      // First, We need to get related practiceActivityEvent from timeline in order to get its related constructs. Alternatively we
      // could search for completed practice activities and see which have been completed by the user.
      // It's not clear which is the best approach at the moment and we should consider both.
    }

    await analyticsRoom.sendConstructsEvent(
      constructContent,
    );
  }
}
