import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/local.key.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics/analytics_event.dart';
import 'package:fluffychat/pangea/models/analytics/analytics_model.dart';
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

  MyAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  // adds the listener that handles when to run automatic updates
  // to analytics - either after a certain number of messages sent/
  // received or after a certain amount of time without an update
  Future<void> addEventsListener() async {
    final Client client = _pangeaController.matrixState.client;

    // if analytics haven't been updated in the last day, update them
    DateTime? lastUpdated = await _pangeaController.analytics
        .myAnalyticsLastUpdated(PangeaEventTypes.summaryAnalytics);
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
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

  // given an update from sync stream, check if the update contains
  // messages for which analytics will be saved. If so, reset the timer
  // and add the event ID to the cache of un-added event IDs
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

  Future<void> _updateAnalytics() async {
    // top level analytics sending function. Send analytics
    // for each type of analytics event
    // to each of the applicable analytics rooms
    clearMessagesSinceUpdate();

    // fetch a list of all the chats that the user is studying
    // and a list of all the spaces in which the user is studying
    await setStudentChats();
    await setStudentSpaces();

    // get all the analytics rooms that the user has
    // and create any missing analytics rooms (if the user is studying
    // in a class but doesn't have an analytics room for that class's L2)
    final List<Room> analyticsRooms =
        _pangeaController.matrixState.client.allMyAnalyticsRooms;
    analyticsRooms.addAll(await createMissingAnalyticsRooms());

    // finally, send an analytics event for each analytics room and
    // each type of analytics event
    for (final Room analyticsRoom in analyticsRooms) {
      for (final String type in AnalyticsEvent.analyticsEventTypes) {
        await sendAnalyticsEvent(analyticsRoom, type);
      }
    }
  }

  Future<void> sendAnalyticsEvent(
    Room analyticsRoom,
    String type,
  ) async {
    // given an analytics room for a language and a type of analytics event
    // gathers all the relevant data and sends it to the analytics room

    // get the language code for the analytics room
    final String? langCode = analyticsRoom.madeForLang;
    if (langCode == null) {
      ErrorHandler.logError(
        e: "no lang code found for analytics room: ${analyticsRoom.id}",
        s: StackTrace.current,
      );
      return;
    }

    // get the last time an analytics event of this type was sent to this room
    final DateTime? lastUpdated = await analyticsRoom.analyticsLastUpdated(
      type,
      _pangeaController.matrixState.client.userID!,
    );

    // each type of analytics event has a format for storing per-message data
    // for SummaryAnalytics events, this is RecentMessageRecord
    // for Construct events, this is OneConstructUse
    // analyticsContent is a list of these formatted data
    final List<dynamic> analyticsContent = [];

    for (final Room chat in _studentChats) {
      // for each chat the student studies in, check if the langCode
      // matches the langCode of the analytics room
      // TODO gabby - replace this
      final String? chatLangCode =
          _pangeaController.languageController.activeL2Code();
      if (chatLangCode != langCode) continue;

      // get messages the logged in user has sent in all chats
      // since the last analytics event was sent
      List<PangeaMessageEvent>? recentMsgs;
      try {
        recentMsgs = await chat.myMessageEventsInChat(
          since: lastUpdated,
        );
      } catch (err) {
        debugPrint("failed to fetch messages for chat ${chat.id}");
        continue;
      }

      if (lastUpdated != null) {
        recentMsgs.removeWhere(
          (msg) => msg.event.originServerTs.isBefore(lastUpdated),
        );
      }

      // then format that data into analytics data and add the formatted
      // data to the list of analyticsContent
      analyticsContent.addAll(
        AnalyticsModel.formatAnalyticsContent(recentMsgs, type),
      );
    }

    // send the analytics data to the analytics room
    // if there is no data to send, don't send an event,
    // unless no events have been sent yet. In that case, send an event
    // with no data to indicate that the the system checked for data
    // and found none, so the system doesn't repeatedly check for data
    if (analyticsContent.isEmpty && lastUpdated != null) return;
    await AnalyticsEvent.sendEvent(
      analyticsRoom,
      type,
      analyticsContent,
    );
  }

  // on the off chance that the user is in a class but doesn't have an analytics
  // room for the target language of that class, create the analytics room(s)
  Future<List<Room>> createMissingAnalyticsRooms() async {
    List<String> targetLangs = [];
    final String? userL2 = _pangeaController.languageController.activeL2Code();
    if (userL2 != null) targetLangs.add(userL2);
    // TODO gabby - replace this
    final List<String?> spaceL2s = studentSpaces
        .map(
          (space) => _pangeaController.languageController.activeL2Code(),
        )
        .toList();
    targetLangs.addAll(spaceL2s.where((l2) => l2 != null).cast<String>());
    targetLangs = targetLangs.toSet().toList();
    for (final String langCode in targetLangs) {
      await _pangeaController.matrixState.client.getMyAnalyticsRoom(langCode);
    }
    return _pangeaController.matrixState.client.allMyAnalyticsRooms;
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
