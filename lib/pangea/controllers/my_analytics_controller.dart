import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/analytics/summary_analytics_event.dart';
import 'package:fluffychat/pangea/models/analytics/summary_analytics_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../extensions/client_extension/client_extension.dart';
import '../extensions/pangea_room_extension/pangea_room_extension.dart';

// controls the sending of analytics events
class MyAnalyticsController extends BaseController {
  late PangeaController _pangeaController;
  Timer? _updateTimer;
  final int _maxMessagesCached = 10;
  final int _minutesBeforeUpdate = 5;

  /// the time since the last update that will trigger an automatic update
  final Duration _timeSinceUpdate = const Duration(days: 1);

  MyAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  /// adds the listener that handles when to run automatic updates
  /// to analytics - either after a certain number of messages sent/
  /// received or after a certain amount of time [_timeSinceUpdate] without an update
  Future<void> addEventsListener() async {
    final Client client = _pangeaController.matrixState.client;

    // if analytics haven't been updated in the last day, update them
    DateTime? lastUpdated = await _pangeaController.analytics
        .myAnalyticsLastUpdated(PangeaEventTypes.summaryAnalytics);
    final DateTime yesterday = DateTime.now().subtract(_timeSinceUpdate);
    if (lastUpdated?.isBefore(yesterday) ?? true) {
      debugPrint("analytics out-of-date, updating");
      await updateAnalytics();
      lastUpdated = await _pangeaController.analytics
          .myAnalyticsLastUpdated(PangeaEventTypes.summaryAnalytics);
    }

    client.onSync.stream
        .where((SyncUpdate update) => update.rooms?.join != null)
        .listen((update) {
      updateAnalyticsTimer(update, lastUpdated);
    });
  }

  /// given an update from sync stream, check if the update contains
  /// messages for which analytics will be saved. If so, reset the timer
  /// and add the event ID to the cache of un-added event IDs
  void updateAnalyticsTimer(SyncUpdate update, DateTime? lastUpdated) {
    for (final entry in update.rooms!.join!.entries) {
      final Room room =
          _pangeaController.matrixState.client.getRoomById(entry.key)!;

      // get the new events in this sync that are messages
      final List<Event>? events = entry.value.timeline?.events
          ?.map((event) => Event.fromMatrixEvent(event, room))
          .where((event) => eventHasAnalytics(event, lastUpdated))
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
  bool eventHasAnalytics(Event event, DateTime? lastUpdated) {
    return (lastUpdated == null || event.originServerTs.isAfter(lastUpdated)) &&
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

  // top level analytics sending function. Send analytics
  // for each type of analytics event
  // to each of the applicable analytics rooms
  Future<void> _updateAnalytics() async {
    // if the user's l2 is not sent, don't send analytics
    final String? userL2 = _pangeaController.languageController.activeL2Code();
    if (userL2 == null) {
      return;
    }

    // fetch a list of all the chats that the user is studying
    // and a list of all the spaces in which the user is studying
    await setStudentChats();
    await setStudentSpaces();

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

    // for each chat the user is studying in, get all the messages
    // since the least recent update analytics update, and sort them
    // by their langCodes
    final Map<String, List<PangeaMessageEvent>> langCodeToMsgs =
        await getLangCodesToMsgs(
      userL2,
      l2AnalyticsLastUpdated,
    );

    final List<String> langCodes = langCodeToMsgs.keys.toList();
    for (final String langCode in langCodes) {
      // for each of the langs that the user has sent message in, get
      // the corresponding analytics room (or create it)
      final Room analyticsRoom = await _pangeaController.matrixState.client
          .getMyAnalyticsRoom(langCode);

      // if there is no analytics room for this langCode, then user hadn't sent
      // message in this language at the time of the last analytics update
      // so fallback to the least recent update time
      final DateTime? lastUpdated =
          lastUpdatedMap[analyticsRoom.id] ?? l2AnalyticsLastUpdated;

      // get the corresponding list of recent messages for this langCode
      final List<PangeaMessageEvent> recentMsgs =
          langCodeToMsgs[langCode] ?? [];

      // finally, send the analytics events to the analytics room
      await sendAnalyticsEvents(
        analyticsRoom,
        recentMsgs,
        lastUpdated,
      );
    }
  }

  Future<Map<String, List<PangeaMessageEvent>>> getLangCodesToMsgs(
    String userL2,
    DateTime? since,
  ) async {
    // get a map of langCodes to messages for each chat the user is studying in
    final Map<String, List<PangeaMessageEvent>> langCodeToMsgs = {};
    for (final Room chat in _studentChats) {
      List<PangeaMessageEvent>? recentMsgs;
      try {
        recentMsgs = await chat.myMessageEventsInChat(
          since: since,
        );
      } catch (err) {
        debugPrint("failed to fetch messages for chat ${chat.id}");
        continue;
      }

      // sort those messages by their langCode
      // langCode is hopefully based on the original sent rep, but if that
      // is null or unk, it will be based on the user's current l2
      for (final msg in recentMsgs) {
        final String msgLangCode = (msg.originalSent?.langCode != null &&
                msg.originalSent?.langCode != LanguageKeys.unknownLanguage)
            ? msg.originalSent!.langCode
            : userL2;
        langCodeToMsgs[msgLangCode] ??= [];
        langCodeToMsgs[msgLangCode]!.add(msg);
      }
    }
    return langCodeToMsgs;
  }

  Future<void> sendAnalyticsEvents(
    Room analyticsRoom,
    List<PangeaMessageEvent> recentMsgs,
    DateTime? lastUpdated,
  ) async {
    // remove messages that were sent before the last update
    if (recentMsgs.isEmpty) return;
    if (lastUpdated != null) {
      recentMsgs.removeWhere(
        (msg) => msg.event.originServerTs.isBefore(lastUpdated),
      );
    }

    // format the analytics data
    final List<RecentMessageRecord> summaryContent =
        SummaryAnalyticsModel.formatSummaryContent(recentMsgs);
    final List<OneConstructUse> constructContent =
        ConstructAnalyticsModel.formatConstructsContent(recentMsgs);

    // if there's new content to be sent, or if lastUpdated hasn't been
    // set yet for this room, send the analytics events
    if (summaryContent.isNotEmpty || lastUpdated == null) {
      await SummaryAnalyticsEvent.sendSummaryAnalyticsEvent(
        analyticsRoom,
        summaryContent,
      );
    }

    if (constructContent.isNotEmpty) {
      await ConstructAnalyticsEvent.sendConstructsEvent(
        analyticsRoom,
        constructContent,
      );
    }
  }

  List<Room> _studentChats = [];

  Future<void> setStudentChats() async {
    final List<String> teacherRoomIds =
        await _pangeaController.matrixState.client.teacherRoomIds;
    _studentChats = _pangeaController.matrixState.client.rooms
        .where(
          (r) =>
              !r.isSpace &&
              !r.isAnalyticsRoom &&
              !teacherRoomIds.contains(r.id),
        )
        .toList();
    setState(data: _studentChats);
  }

  List<Room> get studentChats {
    try {
      if (_studentChats.isNotEmpty) return _studentChats;
      setStudentChats();
      return _studentChats;
    } catch (err) {
      debugger(when: kDebugMode);
      return [];
    }
  }

  List<Room> _studentSpaces = [];

  Future<void> setStudentSpaces() async {
    _studentSpaces =
        await _pangeaController.matrixState.client.spacesImStudyingIn;
  }

  List<Room> get studentSpaces {
    try {
      if (_studentSpaces.isNotEmpty) return _studentSpaces;
      setStudentSpaces();
      return _studentSpaces;
    } catch (err) {
      debugger(when: kDebugMode);
      return [];
    }
  }
}
