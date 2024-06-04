import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/match_rule_ids.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/models/constructs_event.dart';
import 'package:fluffychat/pangea/models/summary_analytics_event.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../constants/class_default_values.dart';
import '../extensions/client_extension/client_extension.dart';
import '../extensions/pangea_room_extension/pangea_room_extension.dart';
import '../models/chart_analytics_model.dart';
import 'base_controller.dart';
import 'pangea_controller.dart';

class AnalyticsController extends BaseController {
  late PangeaController _pangeaController;

  final List<AnalyticsCacheModel> _cachedAnalyticsModels = [];
  final List<ConstructCacheEntry> _cachedConstructs = [];

  AnalyticsController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

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
  }

  Future<List<SummaryAnalyticsEvent>> allMySummaryAnalytics() async {
    final analyticsRooms =
        _pangeaController.matrixState.client.allMyAnalyticsRooms;

    final List<SummaryAnalyticsEvent> allEvents = [];
    for (final Room analyticsRoom in analyticsRooms) {
      final List<SummaryAnalyticsEvent>? roomEvents =
          (await analyticsRoom.getAnalyticsEvents(
        type: PangeaEventTypes.summaryAnalytics,
        since: currentAnalyticsTimeSpan.cutOffDate,
      ))
              ?.cast<SummaryAnalyticsEvent>();
      allEvents.addAll(roomEvents ?? []);
    }
    return allEvents;
  }

  Future<List<SummaryAnalyticsEvent>> allSpaceMemberAnalytics(
    Room space,
  ) async {
    final langCode = _pangeaController.languageController.activeL2Code(
      roomID: space.id,
    );
    final List<SummaryAnalyticsEvent> analyticsEvents = [];
    await space.postLoad();
    await space.requestParticipants();
    for (final student in space.students) {
      final Room? analyticsRoom = _pangeaController.matrixState.client
          .analyticsRoomLocal(langCode, student.id);
      if (analyticsRoom != null) {
        final List<SummaryAnalyticsEvent>? roomEvents =
            (await analyticsRoom.getAnalyticsEvents(
          type: PangeaEventTypes.summaryAnalytics,
          since: currentAnalyticsTimeSpan.cutOffDate,
        ))
                ?.cast<SummaryAnalyticsEvent>();
        analyticsEvents.addAll(roomEvents ?? []);
      }
    }

    final List<String> spaceChildrenIds = space.spaceChildren
        .map((e) => e.roomId)
        .where((e) => e != null)
        .cast<String>()
        .toList();

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
    required DateTime? analyticsLastUpdated,
    AnalyticsSelected? selected,
    bool forceUpdate = false,
    bool updateExpired = false,
  }) {
    timeSpan ??= currentAnalyticsTimeSpan;
    final int index = _cachedAnalyticsModels.indexWhere(
      (e) =>
          (e.timeSpan == timeSpan) &&
          (e.defaultSelected.id == defaultSelected.id) &&
          (e.defaultSelected.type == defaultSelected.type) &&
          (e.selected?.id == selected?.id) &&
          (e.selected?.type == selected?.type),
    );

    if (index != -1) {
      final DateTime? cachedLastUpdate =
          _cachedAnalyticsModels[index].summaryLastUpdated;
      if ((updateExpired && _cachedAnalyticsModels[index].isExpired) ||
          forceUpdate ||
          cachedLastUpdate != analyticsLastUpdated) {
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
    required DateTime? summaryLastUpdated,
    AnalyticsSelected? selected,
    TimeSpan? timeSpan,
  }) {
    _cachedAnalyticsModels.add(
      AnalyticsCacheModel(
        timeSpan: timeSpan ?? currentAnalyticsTimeSpan,
        chartAnalyticsModel: chartAnalyticsModel,
        defaultSelected: defaultSelected,
        selected: selected,
        summaryLastUpdated: summaryLastUpdated,
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

  List<SummaryAnalyticsEvent> filterRoomAnalytics(
    List<SummaryAnalyticsEvent> unfiltered,
    String? roomID,
  ) {
    List<SummaryAnalyticsEvent> filtered = [...unfiltered];
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

  List<SummaryAnalyticsEvent> filterPrivateChatAnalytics(
    List<SummaryAnalyticsEvent> unfiltered,
    Room? space,
  ) {
    final List<String> directChatIds =
        space?.childrenAndGrandChildrenDirectChatIds ?? [];
    List<SummaryAnalyticsEvent> filtered =
        List<SummaryAnalyticsEvent>.from(unfiltered);
    filtered = filtered.where((e) {
      return (e.content).messages.any(
            (u) => directChatIds.contains(u.chatId),
          );
    }).toList();
    filtered.forEachIndexed(
      (i, _) => (filtered[i].content).messages.removeWhere(
            (u) => !directChatIds.contains(u.chatId),
          ),
    );
    return filtered;
  }

  List<SummaryAnalyticsEvent> filterSpaceAnalytics(
    List<SummaryAnalyticsEvent> unfiltered,
    String spaceId,
  ) {
    final selectedSpace =
        _pangeaController.matrixState.client.getRoomById(spaceId);
    final List<String> chatIds = selectedSpace?.spaceChildren
            .map((e) => e.roomId)
            .where((e) => e != null)
            .cast<String>()
            .toList() ??
        [];

    List<SummaryAnalyticsEvent> filtered =
        List<SummaryAnalyticsEvent>.from(unfiltered);
    filtered = filtered
        .where(
          (e) => (e.content).messages.any((u) => chatIds.contains(u.chatId)),
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
        return filterPrivateChatAnalytics(unfilteredAnalytics, space);
      case AnalyticsEntryType.space:
        return filterSpaceAnalytics(unfilteredAnalytics, selected!.id);
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
      final DateTime? analyticsLastUpdated = await _pangeaController.myAnalytics
          .analyticsLastUpdated(PangeaEventTypes.summaryAnalytics);
      final local = getAnalyticsLocal(
        defaultSelected: defaultSelected,
        selected: selected,
        forceUpdate: forceUpdate,
        analyticsLastUpdated: analyticsLastUpdated,
      );
      if (local != null && !forceUpdate) {
        return local;
      }

      await _pangeaController.matrixState.client.roomsLoading;
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
      }

      final List<SummaryAnalyticsEvent> summaryEvents =
          defaultSelected.type == AnalyticsEntryType.space
              ? await allSpaceMemberAnalytics(space!)
              : await allMySummaryAnalytics();

      final List<SummaryAnalyticsEvent> filteredAnalytics =
          await filterAnalytics(
        unfilteredAnalytics: summaryEvents,
        defaultSelected: defaultSelected,
        space: space,
        selected: selected,
      );

      final ChartAnalyticsModel newModel = ChartAnalyticsModel(
        timeSpan: currentAnalyticsTimeSpan,
        msgs: filteredAnalytics
            .map((event) => event.content.messages)
            .expand((msgs) => msgs)
            .toList(),
      );

      if (local == null) {
        cacheAnalytics(
          chartAnalyticsModel: newModel,
          defaultSelected: defaultSelected,
          selected: selected,
          timeSpan: currentAnalyticsTimeSpan,
          summaryLastUpdated: analyticsLastUpdated,
        );
      }

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

  List<ConstructAnalyticsEvent>? _constructs;
  bool settingConstructs = false;

  List<ConstructAnalyticsEvent>? get constructs => _constructs;

  Future<List<ConstructAnalyticsEvent>> allMyConstructs({
    ConstructType? type,
  }) async {
    final List<Room> analyticsRooms =
        _pangeaController.matrixState.client.allMyAnalyticsRooms;

    List<ConstructAnalyticsEvent> allConstructs = [];
    for (final Room analyticsRoom in analyticsRooms) {
      final List<ConstructAnalyticsEvent>? roomEvents =
          (await analyticsRoom.getAnalyticsEvents(
        type: PangeaEventTypes.construct,
      ))
              ?.cast<ConstructAnalyticsEvent>();
      allConstructs.addAll(roomEvents ?? []);
    }

    allConstructs = type == null
        ? allConstructs
        : allConstructs.where((e) => e.content.type == type).toList();

    final List<String> adminSpaceRooms =
        await _pangeaController.matrixState.client.teacherRoomIds;
    for (final construct in allConstructs) {
      final lemmaUses = construct.content.uses;
      for (final lemmaUse in lemmaUses) {
        lemmaUse.uses.removeWhere((u) => adminSpaceRooms.contains(u.chatId));
      }
    }

    return allConstructs
        .where((construct) => construct.content.uses.isNotEmpty)
        .toList();
  }

  Future<List<ConstructAnalyticsEvent>> allSpaceMemberConstructs(
    Room space, {
    ConstructType? type,
  }) async {
    await space.postLoad();
    await space.requestParticipants();
    final String? langCode = _pangeaController.languageController.activeL2Code(
      roomID: space.id,
    );

    if (langCode == null) {
      ErrorHandler.logError(
        m: "langCode missing in allSpaceMemberConstructs",
        data: {
          "space": space,
        },
      );
      return [];
    }

    final List<ConstructAnalyticsEvent> constructEvents = [];
    for (final student in space.students) {
      final Room? analyticsRoom = _pangeaController.matrixState.client
          .analyticsRoomLocal(langCode, student.id);
      if (analyticsRoom != null) {
        final List<ConstructAnalyticsEvent>? roomEvents =
            (await analyticsRoom.getAnalyticsEvents(
          type: PangeaEventTypes.construct,
        ))
                ?.cast<ConstructAnalyticsEvent>();
        constructEvents.addAll(roomEvents ?? []);
      }
    }

    final List<String> spaceChildrenIds = space.spaceChildren
        .map((e) => e.roomId)
        .where((e) => e != null)
        .cast<String>()
        .toList();

    final List<ConstructAnalyticsEvent> allConstructs = [];
    for (final constructEvent in constructEvents) {
      final lemmaUses = constructEvent.content.uses;
      for (final lemmaUse in lemmaUses) {
        lemmaUse.uses.removeWhere((u) => !spaceChildrenIds.contains(u.chatId));
      }

      if (constructEvent.content.uses.isNotEmpty) {
        allConstructs.add(constructEvent);
      }
    }

    return type == null
        ? allConstructs
        : allConstructs.where((e) => e.content.type == type).toList();
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
      final lemmaUses = construct.content.uses;
      for (final lemmaUse in lemmaUses) {
        lemmaUse.uses.removeWhere((u) => u.chatId != roomID);
      }
    }
    return filtered;
  }

  List<ConstructAnalyticsEvent> filterPrivateChatConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    Room parentSpace,
  ) {
    final List<String> directChatIds =
        parentSpace.childrenAndGrandChildrenDirectChatIds;
    final List<ConstructAnalyticsEvent> filtered =
        List<ConstructAnalyticsEvent>.from(unfilteredConstructs);
    for (final construct in filtered) {
      final lemmaUses = construct.content.uses;
      for (final lemmaUse in lemmaUses) {
        lemmaUse.uses.removeWhere((u) => !directChatIds.contains(u.chatId));
      }
    }
    return filtered;
  }

  List<ConstructAnalyticsEvent> filterSpaceConstructs(
    List<ConstructAnalyticsEvent> unfilteredConstructs,
    Room space,
  ) {
    final List<String> chatIds = space.spaceChildren
        .map((e) => e.roomId)
        .where((e) => e != null)
        .cast<String>()
        .toList();

    final List<ConstructAnalyticsEvent> filtered =
        List<ConstructAnalyticsEvent>.from(unfilteredConstructs);

    for (final construct in filtered) {
      final lemmaUses = construct.content.uses;
      for (final lemmaUse in lemmaUses) {
        lemmaUse.uses.removeWhere((u) => !chatIds.contains(u.chatId));
      }
    }

    return filtered;
  }

  List<ConstructAnalyticsEvent>? getConstructsLocal({
    required TimeSpan timeSpan,
    required ConstructType constructType,
    required AnalyticsSelected defaultSelected,
    required DateTime? constructsLastUpdated,
    AnalyticsSelected? selected,
  }) {
    final index = _cachedConstructs.indexWhere(
      (e) =>
          e.timeSpan == timeSpan &&
          e.type == constructType &&
          e.defaultSelected.id == defaultSelected.id &&
          e.defaultSelected.type == defaultSelected.type &&
          e.selected?.id == selected?.id &&
          e.selected?.type == selected?.type,
    );

    if (index > -1) {
      if (_cachedConstructs[index].constructsLastUpdated !=
          constructsLastUpdated) {
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
    required DateTime? constructsLastUpdated,
    AnalyticsSelected? selected,
  }) {
    _cachedConstructs.add(
      ConstructCacheEntry(
        timeSpan: currentAnalyticsTimeSpan,
        type: constructType,
        events: events,
        defaultSelected: defaultSelected,
        selected: selected,
        constructsLastUpdated: constructsLastUpdated,
      ),
    );
  }

  Future<List<ConstructAnalyticsEvent>> getMyConstructs({
    required AnalyticsSelected defaultSelected,
    required ConstructType constructType,
    AnalyticsSelected? selected,
  }) async {
    final List<ConstructAnalyticsEvent> unfilteredConstructs =
        await allMyConstructs(
      type: constructType,
    );

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
      type: constructType,
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
      final lemmaUses = construct.content.uses;
      for (final lemmaUse in lemmaUses) {
        lemmaUse.uses.removeWhere(
          (u) => u.timeStamp.isBefore(currentAnalyticsTimeSpan.cutOffDate),
        );
      }
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
            : filterPrivateChatConstructs(unfilteredConstructs, space!);
      case AnalyticsEntryType.space:
        return filterSpaceConstructs(unfilteredConstructs, space!);
      default:
        throw Exception("invalid filter type - ${selected?.type}");
    }
  }

  Future<List<ConstructAnalyticsEvent>?> setConstructs({
    required ConstructType constructType,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
    bool removeIT = false,
    bool forceUpdate = false,
  }) async {
    final DateTime? constructsLastUpdated = await _pangeaController.myAnalytics
        .analyticsLastUpdated(PangeaEventTypes.construct);
    final List<ConstructAnalyticsEvent>? local = getConstructsLocal(
      timeSpan: currentAnalyticsTimeSpan,
      constructType: constructType,
      defaultSelected: defaultSelected,
      selected: selected,
      constructsLastUpdated: constructsLastUpdated,
    );
    if (local != null && !forceUpdate) {
      _constructs = local;
      return _constructs;
    }

    if (settingConstructs) return _constructs;
    settingConstructs = true;
    await _pangeaController.matrixState.client.roomsLoading;
    Room? space;
    if (defaultSelected.type == AnalyticsEntryType.space) {
      space = _pangeaController.matrixState.client.getRoomById(
        defaultSelected.id,
      );
    }

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

    _constructs = filteredConstructs;

    if (local == null) {
      cacheConstructs(
        constructType: constructType,
        events: _constructs!,
        defaultSelected: defaultSelected,
        selected: selected,
        constructsLastUpdated: constructsLastUpdated,
      );
    }

    settingConstructs = false;
    return _constructs;
  }
}

class ConstructCacheEntry {
  final TimeSpan timeSpan;
  final ConstructType type;
  final List<ConstructAnalyticsEvent> events;
  final AnalyticsSelected defaultSelected;
  AnalyticsSelected? selected;
  final DateTime? constructsLastUpdated;

  ConstructCacheEntry({
    required this.timeSpan,
    required this.type,
    required this.events,
    required this.defaultSelected,
    required this.constructsLastUpdated,
    this.selected,
  });
}

class AnalyticsCacheModel {
  TimeSpan timeSpan;
  ChartAnalyticsModel chartAnalyticsModel;
  final AnalyticsSelected defaultSelected;
  AnalyticsSelected? selected;
  late DateTime _createdAt;
  final DateTime? summaryLastUpdated;

  AnalyticsCacheModel({
    required this.timeSpan,
    required this.chartAnalyticsModel,
    required this.defaultSelected,
    required this.summaryLastUpdated,
    this.selected,
  }) {
    _createdAt = DateTime.now();
  }

  bool get isExpired =>
      DateTime.now().difference(_createdAt).inMinutes >
      ClassDefaultValues.minutesDelayToMakeNewChartAnalytics;
}
