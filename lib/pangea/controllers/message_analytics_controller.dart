import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/match_rule_ids.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/language_list_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/models/analytics/analytics_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_event.dart';
import 'package:fluffychat/pangea/models/analytics/summary_analytics_event.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../constants/class_default_values.dart';
import '../extensions/client_extension/client_extension.dart';
import '../extensions/pangea_room_extension/pangea_room_extension.dart';
import '../models/analytics/chart_analytics_model.dart';
import 'base_controller.dart';
import 'pangea_controller.dart';

// controls the fetching of analytics data
class AnalyticsController extends BaseController {
  late PangeaController _pangeaController;

  final List<AnalyticsCacheModel> _cachedAnalyticsModels = [];
  final List<ConstructCacheEntry> _cachedConstructs = [];

  AnalyticsController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  ///////// TIME SPANS //////////
  String get _analyticsTimeSpanKey => "ANALYTICS_TIME_SPAN_KEY";

  TimeSpan get currentAnalyticsTimeSpan {
    try {
      final String? str = _pangeaController.pStoreService.read(
        _analyticsTimeSpanKey,
        local: true,
      );
      return str != null
          ? TimeSpan.values.firstWhere((e) {
              final spanString = e.toString();
              return spanString == str;
            })
          : ClassDefaultValues.defaultTimeSpan;
    } catch (err) {
      debugger(when: kDebugMode);
      return ClassDefaultValues.defaultTimeSpan;
    }
  }

  Future<void> setCurrentAnalyticsTimeSpan(TimeSpan timeSpan) async {
    await _pangeaController.pStoreService.save(
      _analyticsTimeSpanKey,
      timeSpan.toString(),
      local: true,
    );
    setState();
  }

  ///////// SPACE ANALYTICS LANGUAGES //////////
  String get _analyticsSpaceLangKey => "ANALYTICS_SPACE_LANG_KEY";

  LanguageModel get currentAnalyticsSpaceLang {
    try {
      final String? str = _pangeaController.pStoreService.read(
        _analyticsSpaceLangKey,
        local: true,
      );
      return str != null
          ? PangeaLanguage.byLangCode(str)
          : _pangeaController.languageController.userL2 ??
              _pangeaController.pLanguageStore.targetOptions.first;
    } catch (err) {
      debugger(when: kDebugMode);
      return _pangeaController.pLanguageStore.targetOptions.first;
    }
  }

  Future<void> setCurrentAnalyticsSpaceLang(LanguageModel lang) async {
    await _pangeaController.pStoreService.save(
      _analyticsSpaceLangKey,
      lang.langCode,
      local: true,
    );
    setState();
  }

  Future<DateTime?> myAnalyticsLastUpdated(String type) async {
    // given an analytics event type, get the last updated times
    // for each of the user's analytics rooms and return the most recent
    // Most Recent instead of the oldest because, for instance:
    //     My last Spanish event was sent 3 days ago.
    //     My last English event was sent 1 day ago.
    //     When I go to check if the cached data is out of date, the cached item was set 2 days ago.
    //     I know there’s new data available because the English update data (the most recent) is after the cache’s creation time.
    //     So, I should update the cache.
    final List<Room> analyticsRooms = _pangeaController
        .matrixState.client.allMyAnalyticsRooms
        .where((room) => room.isAnalyticsRoom)
        .toList();

    final List<DateTime> lastUpdates = [];
    for (final Room analyticsRoom in analyticsRooms) {
      final DateTime? lastUpdated = await analyticsRoom.analyticsLastUpdated(
        type,
        _pangeaController.matrixState.client.userID!,
      );
      if (lastUpdated != null) {
        lastUpdates.add(lastUpdated);
      }
    }

    if (lastUpdates.isEmpty) return null;
    return lastUpdates.reduce(
      (check, mostRecent) => check.isAfter(mostRecent) ? check : mostRecent,
    );
  }

  Future<DateTime?> spaceAnalyticsLastUpdated(
    String type,
    Room space,
  ) async {
    // check if any students have recently updated their analytics
    // if any have, then the cache needs to be updated
    // TODO - figure out how to do this on a per-student basis
    await space.requestParticipants();

    final List<Future<DateTime?>> lastUpdatedFutures = [];
    for (final student in space.students) {
      final Room? analyticsRoom = _pangeaController.matrixState.client
          .analyticsRoomLocal(currentAnalyticsSpaceLang.langCode, student.id);
      if (analyticsRoom == null) continue;
      lastUpdatedFutures.add(
        analyticsRoom.analyticsLastUpdated(
          type,
          student.id,
        ),
      );
    }

    final List<DateTime?> lastUpdatedWithNulls =
        await Future.wait(lastUpdatedFutures);
    final List<DateTime> lastUpdates =
        lastUpdatedWithNulls.where((e) => e != null).cast<DateTime>().toList();
    if (lastUpdates.isNotEmpty) {
      return lastUpdates.reduce(
        (check, mostRecent) => check.isAfter(mostRecent) ? check : mostRecent,
      );
    }
    return null;
  }

  // Map of space ids to the last fetched hierarchy. Used when filtering
  // private chat analytics to determine which children are already visible
  // in the chat list
  final Map<String, List<String>> _lastFetchedHierarchies = {};

  void setLatestHierarchy(String spaceId, GetSpaceHierarchyResponse resp) {
    final List<String> roomIds = resp.rooms.map((room) => room.roomId).toList();
    _lastFetchedHierarchies[spaceId] = roomIds;
  }

  Future<List<String>> getLatestSpaceHierarchy(String spaceId) async {
    if (!_lastFetchedHierarchies.containsKey(spaceId)) {
      final resp =
          await _pangeaController.matrixState.client.getSpaceHierarchy(spaceId);
      setLatestHierarchy(spaceId, resp);
    }
    return _lastFetchedHierarchies[spaceId] ?? [];
  }

  //////////////////////////// MESSAGE SUMMARY ANALYTICS ////////////////////////////

  Future<List<SummaryAnalyticsEvent>> mySummaryAnalytics() async {
    // gets all the summary analytics events for the user
    // since the current timespace's cut off date
    final analyticsRooms =
        _pangeaController.matrixState.client.allMyAnalyticsRooms;

    final List<SummaryAnalyticsEvent> allEvents = [];

    // TODO switch to using list of futures
    for (final Room analyticsRoom in analyticsRooms) {
      final List<AnalyticsEvent>? roomEvents =
          await analyticsRoom.getAnalyticsEvents(
        type: PangeaEventTypes.summaryAnalytics,
        since: currentAnalyticsTimeSpan.cutOffDate,
        userId: _pangeaController.matrixState.client.userID!,
      );

      allEvents.addAll(
        roomEvents?.cast<SummaryAnalyticsEvent>() ?? [],
      );
    }
    return allEvents;
  }

  Future<List<SummaryAnalyticsEvent>> spaceMemberAnalytics(
    Room space,
  ) async {
    // gets all the summary analytics events for the students
    // in a space since the current timespace's cut off date

    // ensure that all the space's events are loaded (mainly the for langCode)
    // and that the participants are loaded
    await space.postLoad();
    await space.requestParticipants();

    // TODO switch to using list of futures
    final List<SummaryAnalyticsEvent> analyticsEvents = [];
    for (final student in space.students) {
      final Room? analyticsRoom = _pangeaController.matrixState.client
          .analyticsRoomLocal(currentAnalyticsSpaceLang.langCode, student.id);

      if (analyticsRoom != null) {
        final List<AnalyticsEvent>? roomEvents =
            await analyticsRoom.getAnalyticsEvents(
          type: PangeaEventTypes.summaryAnalytics,
          since: currentAnalyticsTimeSpan.cutOffDate,
          userId: student.id,
        );
        analyticsEvents.addAll(
          roomEvents?.cast<SummaryAnalyticsEvent>() ?? [],
        );
      }
    }

    final List<String> spaceChildrenIds = space.allSpaceChildRoomIds;

    // filter out the analyics events that don't belong to the space's children
    final List<SummaryAnalyticsEvent> allAnalyticsEvents = [];
    for (final analyticsEvent in analyticsEvents) {
      analyticsEvent.content.messages.removeWhere(
        (msg) => !spaceChildrenIds.contains(msg.chatId),
      );
      allAnalyticsEvents.add(analyticsEvent);
    }

    return allAnalyticsEvents;
  }

  ChartAnalyticsModel? getAnalyticsLocal({
    TimeSpan? timeSpan,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
    bool forceUpdate = false,
    bool updateExpired = false,
    DateTime? lastUpdated,
  }) {
    timeSpan ??= currentAnalyticsTimeSpan;
    final int index = _cachedAnalyticsModels.indexWhere(
      (e) =>
          (e.timeSpan == timeSpan) &&
          (e.defaultSelected.id == defaultSelected.id) &&
          (e.defaultSelected.type == defaultSelected.type) &&
          (e.selected?.id == selected?.id) &&
          (e.selected?.type == selected?.type) &&
          (e.langCode == currentAnalyticsSpaceLang.langCode),
    );

    if (index != -1) {
      if ((updateExpired && _cachedAnalyticsModels[index].isExpired) ||
          forceUpdate ||
          _cachedAnalyticsModels[index].needsUpdate(lastUpdated)) {
        _cachedAnalyticsModels.removeAt(index);
      } else {
        return _cachedAnalyticsModels[index].chartAnalyticsModel;
      }
    }

    return null;
  }

  void cacheAnalytics({
    required ChartAnalyticsModel chartAnalyticsModel,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
    TimeSpan? timeSpan,
  }) {
    _cachedAnalyticsModels.add(
      AnalyticsCacheModel(
        timeSpan: timeSpan ?? currentAnalyticsTimeSpan,
        chartAnalyticsModel: chartAnalyticsModel,
        defaultSelected: defaultSelected,
        selected: selected,
        langCode: currentAnalyticsSpaceLang.langCode,
      ),
    );
  }

  List<SummaryAnalyticsEvent> filterStudentAnalytics(
    List<SummaryAnalyticsEvent> unfiltered,
    String? studentId,
  ) {
    final List<SummaryAnalyticsEvent> filtered =
        List<SummaryAnalyticsEvent>.from(unfiltered);
    filtered.removeWhere((e) => e.event.senderId != studentId);
    return filtered;
  }

  Future<List<SummaryAnalyticsEvent>> filterRoomAnalytics(
    List<SummaryAnalyticsEvent> unfiltered,
    String? roomID,
  ) async {
    List<SummaryAnalyticsEvent> filtered = [...unfiltered];
    Room? room;
    if (roomID != null) {
      room = _pangeaController.matrixState.client.getRoomById(roomID);
      if (room?.isSpace == true) {
        return await filterSpaceAnalytics(unfiltered, roomID);
      }
    }

    filtered = filtered
        .where(
          (e) => (e.content).messages.any((u) => u.chatId == roomID),
        )
        .toList();
    filtered.forEachIndexed(
      (i, _) => (filtered[i].content).messages.removeWhere(
            (u) => u.chatId != roomID,
          ),
    );
    return filtered;
  }

  Future<List<SummaryAnalyticsEvent>> filterPrivateChatAnalytics(
    List<SummaryAnalyticsEvent> unfiltered,
    Room space,
  ) async {
    final List<String> privateChatIds = space.allSpaceChildRoomIds;
    final List<String> lastFetched = await getLatestSpaceHierarchy(space.id);
    for (final id in lastFetched) {
      privateChatIds.removeWhere((e) => e == id);
    }

    List<SummaryAnalyticsEvent> filtered =
        List<SummaryAnalyticsEvent>.from(unfiltered);
    filtered = filtered.where((e) {
      return (e.content).messages.any(
            (u) => privateChatIds.contains(u.chatId),
          );
    }).toList();
    filtered.forEachIndexed(
      (i, _) => (filtered[i].content).messages.removeWhere(
            (u) => !privateChatIds.contains(u.chatId),
          ),
    );
    return filtered;
  }

  Future<List<SummaryAnalyticsEvent>> filterSpaceAnalytics(
    List<SummaryAnalyticsEvent> unfiltered,
    String spaceId,
  ) async {
    final List<String> chatIds = await getLatestSpaceHierarchy(spaceId);
    List<SummaryAnalyticsEvent> filtered =
        List<SummaryAnalyticsEvent>.from(unfiltered);

    filtered = filtered
        .where(
          (e) => e.content.messages.any((u) => chatIds.contains(u.chatId)),
        )
        .toList();

    filtered.forEachIndexed(
      (i, _) => (filtered[i].content).messages.removeWhere(
            (u) => !chatIds.contains(u.chatId),
          ),
    );
    return filtered;
  }

  Future<List<SummaryAnalyticsEvent>> filterAnalytics({
    required List<SummaryAnalyticsEvent> unfilteredAnalytics,
    required AnalyticsSelected defaultSelected,
    Room? space,
    AnalyticsSelected? selected,
  }) async {
    for (int i = 0; i < unfilteredAnalytics.length; i++) {
      unfilteredAnalytics[i].content.messages.removeWhere(
            (record) => record.time.isBefore(
              currentAnalyticsTimeSpan.cutOffDate,
            ),
          );
    }

    switch (selected?.type) {
      case null:
        return unfilteredAnalytics;
      case AnalyticsEntryType.student:
        if (defaultSelected.type != AnalyticsEntryType.space) {
          throw Exception(
            "student filtering not available for default filter ${defaultSelected.type}",
          );
        }
        return filterStudentAnalytics(unfilteredAnalytics, selected?.id);
      case AnalyticsEntryType.room:
        return filterRoomAnalytics(unfilteredAnalytics, selected?.id);
      case AnalyticsEntryType.privateChats:
        if (defaultSelected.type == AnalyticsEntryType.student) {
          throw "private chat filtering not available for my analytics";
        }
        if (space == null) {
          throw "space is null in filterAnalytics with selected type privateChats";
        }
        return await filterPrivateChatAnalytics(
          unfilteredAnalytics,
          space,
        );
      case AnalyticsEntryType.space:
        return await filterSpaceAnalytics(unfilteredAnalytics, selected!.id);
      default:
        throw Exception("invalid filter type - ${selected?.type}");
    }
  }

  Future<ChartAnalyticsModel> getAnalytics({
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
    bool forceUpdate = false,
  }) async {
    try {
      await _pangeaController.matrixState.client.roomsLoading;

      // if the user is looking at space analytics, then fetch the space
      Room? space;
      if (defaultSelected.type == AnalyticsEntryType.space) {
        space = _pangeaController.matrixState.client.getRoomById(
          defaultSelected.id,
        );
        if (space == null) {
          ErrorHandler.logError(
            m: "space not found in getAnalytics",
            data: {
              "defaultSelected": defaultSelected,
              "selected": selected,
            },
          );
          return ChartAnalyticsModel(
            msgs: [],
            timeSpan: currentAnalyticsTimeSpan,
          );
        }
        await space.postLoad();
      }

      DateTime? lastUpdated;
      if (defaultSelected.type != AnalyticsEntryType.space) {
        // if default selected view is my analytics, check for the last
        // time the logged in user updated their analytics events
        // this gets passed to getAnalyticsLocal to determine if the cached
        // entry is out-of-date
        lastUpdated = await myAnalyticsLastUpdated(
          PangeaEventTypes.summaryAnalytics,
        );
      } else {
        // else, get the last time a student in the space updated their analytics
        lastUpdated = await spaceAnalyticsLastUpdated(
          PangeaEventTypes.summaryAnalytics,
          space!,
        );
      }

      final ChartAnalyticsModel? local = getAnalyticsLocal(
        defaultSelected: defaultSelected,
        selected: selected,
        forceUpdate: forceUpdate,
        lastUpdated: lastUpdated,
      );
      if (local != null && !forceUpdate) {
        debugPrint("returning local analytics");
        return local;
      }
      debugPrint("fetching new analytics");

      // get all the relevant summary analytics events for the current timespan
      final List<SummaryAnalyticsEvent> summaryEvents =
          defaultSelected.type == AnalyticsEntryType.space
              ? await spaceMemberAnalytics(space!)
              : await mySummaryAnalytics();

      // filter out the analytics events based on filters the user has chosen
      final List<SummaryAnalyticsEvent> filteredAnalytics =
          await filterAnalytics(
        unfilteredAnalytics: summaryEvents,
        defaultSelected: defaultSelected,
        space: space,
        selected: selected,
      );

      // then create and return the model to be displayed
      final ChartAnalyticsModel newModel = ChartAnalyticsModel(
        timeSpan: currentAnalyticsTimeSpan,
        msgs: filteredAnalytics
            .map((event) => event.content.messages)
            .expand((msgs) => msgs)
            .toList(),
      );

      cacheAnalytics(
        chartAnalyticsModel: newModel,
        defaultSelected: defaultSelected,
        selected: selected,
        timeSpan: currentAnalyticsTimeSpan,
      );

      return newModel;
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
      return ChartAnalyticsModel(
        msgs: [],
        timeSpan: currentAnalyticsTimeSpan,
      );
    }
  }

  //////////////////////////// CONSTRUCTS ////////////////////////////

  Future<List<ConstructAnalyticsEvent>> allMyConstructs() async {
    final List<Room> analyticsRooms =
        _pangeaController.matrixState.client.allMyAnalyticsRooms;

    final List<ConstructAnalyticsEvent> allConstructs = [];
    for (final Room analyticsRoom in analyticsRooms) {
      final List<ConstructAnalyticsEvent>? roomEvents =
          (await analyticsRoom.getAnalyticsEvents(
        type: PangeaEventTypes.construct,
        since: currentAnalyticsTimeSpan.cutOffDate,
        userId: _pangeaController.matrixState.client.userID!,
      ))
              ?.cast<ConstructAnalyticsEvent>();
      allConstructs.addAll(roomEvents ?? []);
    }

    final List<String> adminSpaceRooms =
        await _pangeaController.matrixState.client.teacherRoomIds;
    for (final construct in allConstructs) {
      construct.content.uses.removeWhere(
        (use) => adminSpaceRooms.contains(use.chatId),
      );
    }

    return allConstructs
        .where((construct) => construct.content.uses.isNotEmpty)
        .toList();
  }

  Future<List<ConstructAnalyticsEvent>> allSpaceMemberConstructs(
    Room space,
  ) async {
    await space.postLoad();
    await space.requestParticipants();
    final List<ConstructAnalyticsEvent> constructEvents = [];
    for (final student in space.students) {
      final Room? analyticsRoom = _pangeaController.matrixState.client
          .analyticsRoomLocal(currentAnalyticsSpaceLang.langCode, student.id);
      if (analyticsRoom != null) {
        final List<ConstructAnalyticsEvent>? roomEvents =
            (await analyticsRoom.getAnalyticsEvents(
          type: PangeaEventTypes.construct,
          since: currentAnalyticsTimeSpan.cutOffDate,
          userId: student.id,
        ))
                ?.cast<ConstructAnalyticsEvent>();
        constructEvents.addAll(roomEvents ?? []);
      }
    }

    final List<String> spaceChildrenIds = space.allSpaceChildRoomIds;
    final List<ConstructAnalyticsEvent> allConstructs = [];
    for (final constructEvent in constructEvents) {
      constructEvent.content.uses.removeWhere(
        (use) => !spaceChildrenIds.contains(use.chatId),
      );

      if (constructEvent.content.uses.isNotEmpty) {
        allConstructs.add(constructEvent);
      }
    }

    return allConstructs;
  }

  List<ConstructAnalyticsEvent> filterStudentConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    String? studentId,
  ) {
    final List<ConstructAnalyticsEvent> filtered =
        List<ConstructAnalyticsEvent>.from(unfilteredConstructs);
    filtered.removeWhere((element) => element.event.senderId != studentId);
    return filtered;
  }

  List<ConstructAnalyticsEvent> filterRoomConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    String? roomID,
  ) {
    final List<ConstructAnalyticsEvent> filtered = [...unfilteredConstructs];
    for (final construct in filtered) {
      construct.content.uses.removeWhere((u) => u.chatId != roomID);
    }
    return filtered;
  }

  Future<List<ConstructAnalyticsEvent>> filterPrivateChatConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    Room space,
  ) async {
    final List<String> privateChatIds = space.allSpaceChildRoomIds;
    final List<String> lastFetched = await getLatestSpaceHierarchy(space.id);
    for (final id in lastFetched) {
      privateChatIds.removeWhere((e) => e == id);
    }
    final List<ConstructAnalyticsEvent> filtered =
        List<ConstructAnalyticsEvent>.from(unfilteredConstructs);
    for (final construct in filtered) {
      construct.content.uses.removeWhere(
        (use) => !privateChatIds.contains(use.chatId),
      );
    }
    return filtered;
  }

  Future<List<ConstructAnalyticsEvent>> filterSpaceConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    Room space,
  ) async {
    final List<String> chatIds = await getLatestSpaceHierarchy(space.id);
    final List<ConstructAnalyticsEvent> filtered =
        List<ConstructAnalyticsEvent>.from(unfilteredConstructs);

    for (final construct in filtered) {
      construct.content.uses.removeWhere(
        (use) => !chatIds.contains(use.chatId),
      );
    }

    return filtered;
  }

  List<ConstructAnalyticsEvent>? getConstructsLocal({
    required TimeSpan timeSpan,
    required ConstructType constructType,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
    DateTime? lastUpdated,
  }) {
    final index = _cachedConstructs.indexWhere(
      (e) =>
          e.timeSpan == timeSpan &&
          e.type == constructType &&
          e.defaultSelected.id == defaultSelected.id &&
          e.defaultSelected.type == defaultSelected.type &&
          e.selected?.id == selected?.id &&
          e.selected?.type == selected?.type &&
          e.langCode == currentAnalyticsSpaceLang.langCode,
    );

    if (index > -1) {
      if (_cachedConstructs[index].needsUpdate(lastUpdated)) {
        _cachedConstructs.removeAt(index);
        return null;
      }
      return _cachedConstructs[index].events;
    }

    return null;
  }

  void cacheConstructs({
    required ConstructType constructType,
    required List<ConstructAnalyticsEvent> events,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
  }) {
    final entry = ConstructCacheEntry(
      timeSpan: currentAnalyticsTimeSpan,
      type: constructType,
      events: List.from(events),
      defaultSelected: defaultSelected,
      selected: selected,
      langCode: currentAnalyticsSpaceLang.langCode,
    );
    _cachedConstructs.add(entry);
  }

  Future<List<ConstructAnalyticsEvent>> getMyConstructs({
    required AnalyticsSelected defaultSelected,
    required ConstructType constructType,
    AnalyticsSelected? selected,
  }) async {
    final List<ConstructAnalyticsEvent> unfilteredConstructs =
        await allMyConstructs();

    final Room? space = selected?.type == AnalyticsEntryType.space
        ? _pangeaController.matrixState.client.getRoomById(selected!.id)
        : null;

    return filterConstructs(
      unfilteredConstructs: unfilteredConstructs,
      space: space,
      defaultSelected: defaultSelected,
      selected: selected,
    );
  }

  Future<List<ConstructAnalyticsEvent>> getSpaceConstructs({
    required ConstructType constructType,
    required Room space,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
  }) async {
    final List<ConstructAnalyticsEvent> unfilteredConstructs =
        await allSpaceMemberConstructs(
      space,
    );

    return filterConstructs(
      unfilteredConstructs: unfilteredConstructs,
      space: space,
      defaultSelected: defaultSelected,
      selected: selected,
    );
  }

  Future<List<ConstructAnalyticsEvent>> filterConstructs({
    required List<ConstructAnalyticsEvent> unfilteredConstructs,
    required AnalyticsSelected defaultSelected,
    Room? space,
    AnalyticsSelected? selected,
  }) async {
    if ([AnalyticsEntryType.privateChats, AnalyticsEntryType.space]
        .contains(selected?.type)) {
      assert(space != null);
    }

    for (int i = 0; i < unfilteredConstructs.length; i++) {
      final construct = unfilteredConstructs[i];
      construct.content.uses.removeWhere(
        (use) => use.timeStamp.isBefore(currentAnalyticsTimeSpan.cutOffDate),
      );
    }

    unfilteredConstructs.removeWhere((e) => e.content.uses.isEmpty);

    switch (selected?.type) {
      case null:
        return unfilteredConstructs;
      case AnalyticsEntryType.student:
        if (defaultSelected.type != AnalyticsEntryType.space) {
          throw Exception(
            "student filtering not available for default filter ${defaultSelected.type}",
          );
        }
        return filterStudentConstructs(unfilteredConstructs, selected!.id);
      case AnalyticsEntryType.room:
        return filterRoomConstructs(unfilteredConstructs, selected?.id);
      case AnalyticsEntryType.privateChats:
        return defaultSelected.type == AnalyticsEntryType.student
            ? throw "private chat filtering not available for my analytics"
            : await filterPrivateChatConstructs(unfilteredConstructs, space!);
      case AnalyticsEntryType.space:
        return await filterSpaceConstructs(unfilteredConstructs, space!);
      default:
        throw Exception("invalid filter type - ${selected?.type}");
    }
  }

  Future<List<ConstructAnalyticsEvent>?> getConstructs({
    required ConstructType constructType,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
    bool removeIT = true,
    bool forceUpdate = false,
  }) async {
    debugPrint("getting constructs");
    await _pangeaController.matrixState.client.roomsLoading;

    Room? space;
    if (defaultSelected.type == AnalyticsEntryType.space) {
      space = _pangeaController.matrixState.client.getRoomById(
        defaultSelected.id,
      );
      if (space == null) {
        ErrorHandler.logError(
          m: "space not found in setConstructs",
          data: {
            "defaultSelected": defaultSelected,
            "selected": selected,
          },
        );
        return [];
      }
      await space.postLoad();
    }

    DateTime? lastUpdated;
    if (defaultSelected.type != AnalyticsEntryType.space) {
      // if default selected view is my analytics, check for the last
      // time the logged in user updated their analytics events
      // this gets passed to getAnalyticsLocal to determine if the cached
      // entry is out-of-date
      lastUpdated = await myAnalyticsLastUpdated(
        PangeaEventTypes.construct,
      );
    } else {
      // else, get the last time a student in the space updated their analytics
      lastUpdated = await spaceAnalyticsLastUpdated(
        PangeaEventTypes.construct,
        space!,
      );
    }

    final List<ConstructAnalyticsEvent>? local = getConstructsLocal(
      timeSpan: currentAnalyticsTimeSpan,
      constructType: constructType,
      defaultSelected: defaultSelected,
      selected: selected,
      lastUpdated: lastUpdated,
    );
    if (local != null && !forceUpdate) {
      debugPrint("returning local constructs");
      return local;
    }
    debugPrint("fetching new constructs");

    final filteredConstructs = space == null
        ? await getMyConstructs(
            constructType: constructType,
            defaultSelected: defaultSelected,
            selected: selected,
          )
        : await getSpaceConstructs(
            constructType: constructType,
            space: space,
            defaultSelected: defaultSelected,
            selected: selected,
          );

    if (removeIT) {
      for (final construct in filteredConstructs) {
        construct.content.uses.removeWhere(
          (element) =>
              element.lemma == "Try interactive translation" ||
              element.lemma == "itStart" ||
              element.lemma == MatchRuleIds.interactiveTranslation,
        );
      }
    }

    if (local == null) {
      cacheConstructs(
        constructType: constructType,
        events: filteredConstructs,
        defaultSelected: defaultSelected,
        selected: selected,
      );
    }

    return filteredConstructs;
  }
}

abstract class CacheEntry {
  final String langCode;
  final TimeSpan timeSpan;
  final AnalyticsSelected defaultSelected;
  AnalyticsSelected? selected;
  late final DateTime _createdAt;

  CacheEntry({
    required this.timeSpan,
    required this.defaultSelected,
    required this.langCode,
    this.selected,
  }) {
    _createdAt = DateTime.now();
  }

  bool get isExpired =>
      DateTime.now().difference(_createdAt).inMinutes >
      ClassDefaultValues.minutesDelayToMakeNewChartAnalytics;

  bool needsUpdate(DateTime? lastEventUpdated) {
    // cache entry is invalid if it's older than the last event update
    // if lastEventUpdated is null, that would indicate that no events
    // of this type have been sent to the room. In this case, there
    // shouldn't be any cached data.
    if (lastEventUpdated == null) {
      Sentry.addBreadcrumb(
        Breadcrumb(message: "lastEventUpdated is null in needsUpdate"),
      );
      return false;
    }
    return _createdAt.isBefore(lastEventUpdated);
  }
}

class ConstructCacheEntry extends CacheEntry {
  final ConstructType type;
  final List<ConstructAnalyticsEvent> events;

  ConstructCacheEntry({
    required this.type,
    required this.events,
    required super.timeSpan,
    required super.langCode,
    required super.defaultSelected,
    super.selected,
  });
}

class AnalyticsCacheModel extends CacheEntry {
  final ChartAnalyticsModel chartAnalyticsModel;

  AnalyticsCacheModel({
    required this.chartAnalyticsModel,
    required super.timeSpan,
    required super.langCode,
    required super.defaultSelected,
    super.selected,
  });

  @override
  bool get isExpired =>
      DateTime.now().difference(_createdAt).inMinutes >
      ClassDefaultValues.minutesDelayToMakeNewChartAnalytics;
}
