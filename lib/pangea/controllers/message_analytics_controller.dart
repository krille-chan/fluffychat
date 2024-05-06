import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/match_rule_ids.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/models/student_analytics_summary_model.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../constants/class_default_values.dart';
import '../extensions/client_extension.dart';
import '../extensions/pangea_room_extension.dart';
import '../matrix_event_wrappers/construct_analytics_event.dart';
import '../models/chart_analytics_model.dart';
import '../models/student_analytics_event.dart';
import 'base_controller.dart';
import 'pangea_controller.dart';

class AnalyticsController extends BaseController {
  late PangeaController _pangeaController;

  final List<CacheModel> _cachedModels = [];
  final List<ConstructCacheEntry> _cachedConstructs = [];

  AnalyticsController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  String get _analyticsTimeSpanKey => "ANALYTICS_TIME_SPAN_KEY";

  TimeSpan get currentAnalyticsTimeSpan {
    try {
      final String? str =
          _pangeaController.pStoreService.read(_analyticsTimeSpanKey);
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
    await _pangeaController.pStoreService
        .save(_analyticsTimeSpanKey, timeSpan.toString());
  }

  Future<List<ChartAnalyticsModel?>> allClassAnalytics() async {
    final List<Future<ChartAnalyticsModel?>> classAnalyticFutures = [];
    for (final classRoom in (await _pangeaController
        .matrixState.client.classesAndExchangesImTeaching)) {
      classAnalyticFutures.add(
        getAnalytics(classRoom: classRoom),
      );
    }

    return Future.wait(classAnalyticFutures);
  }

  ChartAnalyticsModel? getAnalyticsLocal({
    TimeSpan? timeSpan,
    String? classId,
    String? studentId,
    String? chatId,
    bool forceUpdate = false,
    bool updateExpired = false,
  }) {
    timeSpan ??= currentAnalyticsTimeSpan;
    final int index = _cachedModels.indexWhere(
      (e) =>
          (e.timeSpan == timeSpan) &&
          (e.classId == classId) &&
          (e.studentId == studentId) &&
          (e.chatId == chatId),
    );

    if (index != -1) {
      if ((updateExpired && _cachedModels[index].isExpired) || forceUpdate) {
        _cachedModels.removeAt(index);
      } else {
        return _cachedModels[index].chartAnalyticsModel;
      }
    }

    return null;
  }

  Future<ChartAnalyticsModel> getAnalytics({
    TimeSpan? timeSpan,
    Room? classRoom,
    String? studentId,
    String? chatId,
    bool forceUpdate = false,
  }) async {
    timeSpan ??= currentAnalyticsTimeSpan;
    try {
      final cachedModel = getAnalyticsLocal(
        classId: classRoom?.id,
        studentId: studentId,
        chatId: chatId,
        updateExpired: true,
        forceUpdate: forceUpdate,
      );
      if (cachedModel != null) return cachedModel;
      // debugger(when: classRoom?.displayname.contains('clizass') ?? false);
      late List<StudentAnalyticsEvent?> studentAnalyticsSummaryEvents;
      if (classRoom == null) {
        if (studentId == null) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(
            m: "studentId should have been defined",
            s: StackTrace.current,
          );
        } else {
          studentAnalyticsSummaryEvents =
              await _pangeaController.myAnalytics.allMyAnalyticsEvents();
        }
      } else {
        if (studentId != null) {
          studentAnalyticsSummaryEvents = [
            await classRoom.getStudentAnalytics(studentId),
          ];
        } else {
          studentAnalyticsSummaryEvents = await classRoom.getClassAnalytics();
        }
        if (studentId != null && chatId != null) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(
            m: "studentId and chatId should have both been defined",
            s: StackTrace.current,
          );
          studentAnalyticsSummaryEvents = [];
        }
      }

      final List<RecentMessageRecord> msgs = [];
      for (final event in studentAnalyticsSummaryEvents) {
        if (event != null) {
          msgs.addAll(event.content.messages);
        } else {
          debugPrint("studentAnalyticsSummaryEvent is null");
        }
      }

      final newModel = ChartAnalyticsModel(
        timeSpan: timeSpan,
        msgs: msgs,
        chatId: chatId,
      );

      _cachedModels.add(
        CacheModel(
          timeSpan: timeSpan,
          classId: classRoom?.id,
          studentId: studentId,
          chatId: chatId,
          chartAnalyticsModel: newModel,
        ),
      );

      return newModel;
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
      return ChartAnalyticsModel(msgs: [], timeSpan: timeSpan, chatId: chatId);
    }
  }

  Future<ChartAnalyticsModel> getAnalyticsForPrivateChats({
    TimeSpan? timeSpan,
    required Room? classRoom,
    bool forceUpdate = false,
  }) async {
    timeSpan ??= currentAnalyticsTimeSpan;

    try {
      if (classRoom == null) {
        return ChartAnalyticsModel(msgs: [], timeSpan: timeSpan);
      }

      final cachedModel = getAnalyticsLocal(
        classId: classRoom.id,
        studentId: null,
        chatId: AnalyticsEntryType.privateChats.toString(),
        updateExpired: true,
        forceUpdate: forceUpdate,
      );
      if (cachedModel != null) return cachedModel;
      final List<StudentAnalyticsEvent?> studentAnalyticsSummaryEvents =
          await classRoom.getClassAnalytics();
      final List<String> directChatIds =
          classRoom.childrenAndGrandChildrenDirectChatIds;

      final List<RecentMessageRecord> msgs = [];
      for (final event in studentAnalyticsSummaryEvents) {
        if (event != null) {
          msgs.addAll(
            event.content.messages
                .where((m) => directChatIds.contains(m.chatId)),
          );
        } else {
          debugPrint("studentAnalyticsSummaryEvent is null");
        }
      }
      final newModel = ChartAnalyticsModel(
        timeSpan: timeSpan,
        msgs: msgs,
        chatId: null,
      );

      _cachedModels.add(
        CacheModel(
          timeSpan: timeSpan,
          classId: classRoom.id,
          studentId: null,
          chatId: AnalyticsEntryType.privateChats.toString(),
          chartAnalyticsModel: newModel,
        ),
      );

      return newModel;
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
      return ChartAnalyticsModel(msgs: [], timeSpan: timeSpan);
    }
  }

  List<ConstructEvent>? _constructs;
  bool settingConstructs = false;

  List<ConstructEvent>? get constructs => _constructs;

  String? getLangCode({
    Room? space,
    String? roomID,
  }) {
    final String? targetRoomID = space?.id ?? roomID;
    final String? roomLangCode =
        _pangeaController.languageController.activeL2Code(roomID: targetRoomID);
    final String? userLangCode =
        _pangeaController.languageController.userL2?.langCode;

    return roomLangCode ?? userLangCode;
  }

  Future<Room> myAnalyticsRoom(String langCode) =>
      _pangeaController.matrixState.client.getMyAnalyticsRoom(langCode);

  Room? studentAnalyticsRoom(String studentId, String langCode) =>
      _pangeaController.matrixState.client.analyticsRoomLocal(
        langCode,
        studentId,
      );

  Future<List<ConstructEvent>> allMyConstructs(
    String langCode, {
    ConstructType? type,
  }) async {
    final Room analyticsRoom = await myAnalyticsRoom(langCode);
    final List<String> adminSpaceRooms =
        await _pangeaController.matrixState.client.teacherRoomIds;

    final allConstructs = type == null
        ? await analyticsRoom.allConstructEvents
        : (await analyticsRoom.allConstructEvents)
            .where((e) => e.content.type == type)
            .toList();

    for (int i = 0; i < allConstructs.length; i++) {
      final construct = allConstructs[i];
      final uses = construct.content.uses;
      uses.removeWhere((u) => adminSpaceRooms.contains(u.chatId));
    }

    return allConstructs
        .where((construct) => construct.content.uses.isNotEmpty)
        .toList();
  }

  Future<List<ConstructEvent>> allSpaceMemberConstructs(
    Room space,
    String langCode, {
    ConstructType? type,
  }) async {
    final List<Future<List<ConstructEvent>>> constructEventFutures = [];
    await space.postLoad();
    await space.requestParticipants();
    for (final student in space.students) {
      final Room? room = _pangeaController.matrixState.client
          .analyticsRoomLocal(langCode, student.id);
      if (room != null) constructEventFutures.add(room.allConstructEvents);
    }

    final List<List<ConstructEvent>> constructLists =
        await Future.wait(constructEventFutures);

    final List<String> spaceChildrenIds = space.spaceChildren
        .map((e) => e.roomId)
        .where((e) => e != null)
        .cast<String>()
        .toList();

    final List<ConstructEvent> allConstructs = [];
    for (final constructList in constructLists) {
      for (int i = 0; i < constructList.length; i++) {
        final construct = constructList[i];
        final uses = construct.content.uses;
        uses.removeWhere((u) => !spaceChildrenIds.contains(u.chatId));
      }
      allConstructs.addAll(
        constructList.where((e) => e.content.uses.isNotEmpty),
      );
    }

    return type == null
        ? allConstructs
        : allConstructs.where((e) => e.content.type == type).toList();
  }

  List<ConstructEvent> filterStudentConstructs(
    List<ConstructEvent> unfilteredConstructs,
    String? studentId,
  ) {
    final List<ConstructEvent> filtered =
        List<ConstructEvent>.from(unfilteredConstructs);
    filtered.removeWhere((e) => e.event.senderId != studentId);
    return filtered;
  }

  List<ConstructEvent> filterRoomConstructs(
    List<ConstructEvent> unfilteredConstructs,
    String? roomID,
  ) {
    List<ConstructEvent> filtered = [...unfilteredConstructs];
    filtered = unfilteredConstructs
        .where((e) => e.content.uses.any((u) => u.chatId == roomID))
        .toList();
    filtered.forEachIndexed(
      (i, _) => filtered[i].content.uses.removeWhere((u) => u.chatId != roomID),
    );
    return filtered;
  }

  List<ConstructEvent> filterPrivateChatConstructs(
    List<ConstructEvent> unfilteredConstructs,
    Room parentSpace,
  ) {
    final List<String> directChatIds =
        parentSpace.childrenAndGrandChildrenDirectChatIds;
    List<ConstructEvent> filtered =
        List<ConstructEvent>.from(unfilteredConstructs);
    filtered = filtered.where((e) {
      return e.content.uses.any((u) => directChatIds.contains(u.chatId));
    }).toList();
    filtered.forEachIndexed(
      (i, _) => filtered[i].content.uses.removeWhere(
            (u) => !directChatIds.contains(u.chatId),
          ),
    );
    return filtered;
  }

  List<ConstructEvent> filterSpaceConstructs(
    List<ConstructEvent> unfilteredConstructs,
    Room space,
  ) {
    final List<String> chatIds = space.spaceChildren
        .map((e) => e.roomId)
        .where((e) => e != null)
        .cast<String>()
        .toList();

    List<ConstructEvent> filtered =
        List<ConstructEvent>.from(unfilteredConstructs);
    filtered = filtered
        .where((e) => e.content.uses.any((u) => chatIds.contains(u.chatId)))
        .toList();

    filtered.forEachIndexed(
      (i, _) => filtered[i].content.uses.removeWhere(
            (u) => !chatIds.contains(u.chatId),
          ),
    );
    return filtered;
  }

  List<ConstructEvent>? getConstructsLocal({
    required TimeSpan timeSpan,
    required ConstructType constructType,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
  }) {
    final cachedEntry = _cachedConstructs
        .firstWhereOrNull(
          (e) =>
              e.timeSpan == timeSpan &&
              e.type == constructType &&
              e.defaultSelected.id == defaultSelected.id &&
              e.defaultSelected.type == defaultSelected.type &&
              e.selected?.id == selected?.id &&
              e.selected?.type == selected?.type,
        )
        ?.events;
    return cachedEntry;
  }

  void cacheConstructs({
    required ConstructType constructType,
    required List<ConstructEvent> events,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
  }) {
    _cachedConstructs.add(
      ConstructCacheEntry(
        timeSpan: currentAnalyticsTimeSpan,
        type: constructType,
        events: events,
        defaultSelected: defaultSelected,
        selected: selected,
      ),
    );
  }

  Future<List<ConstructEvent>> getMyConstructs({
    required AnalyticsSelected defaultSelected,
    required ConstructType constructType,
    required String langCode,
    AnalyticsSelected? selected,
  }) async {
    final List<ConstructEvent> unfilteredConstructs = await allMyConstructs(
      langCode,
      type: constructType,
    );

    final Room? space = selected?.type == AnalyticsEntryType.space
        ? _pangeaController.matrixState.client.getRoomById(selected!.id)
        : null;

    return filterConstructs(
      unfilteredConstructs: unfilteredConstructs,
      langCode: langCode,
      space: space,
      defaultSelected: defaultSelected,
      selected: selected,
    );
  }

  Future<List<ConstructEvent>> getSpaceConstructs({
    required ConstructType constructType,
    required Room space,
    required AnalyticsSelected defaultSelected,
    required String langCode,
    AnalyticsSelected? selected,
  }) async {
    final List<ConstructEvent> unfilteredConstructs =
        await allSpaceMemberConstructs(
      space,
      langCode,
      type: constructType,
    );

    return filterConstructs(
      unfilteredConstructs: unfilteredConstructs,
      langCode: langCode,
      space: space,
      defaultSelected: defaultSelected,
      selected: selected,
    );
  }

  Future<List<ConstructEvent>> filterConstructs({
    required List<ConstructEvent> unfilteredConstructs,
    required String langCode,
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
      final uses = construct.content.uses;
      uses.removeWhere(
        (u) => u.timeStamp.isBefore(currentAnalyticsTimeSpan.cutOffDate),
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
        final Room? analyticsRoom =
            studentAnalyticsRoom(selected!.id, langCode);
        if (analyticsRoom == null) {
          throw Exception("analyticsRoom missing in filterConstructs");
        }
        return filterStudentConstructs(unfilteredConstructs, selected.id);
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

  Future<List<ConstructEvent>?> setConstructs({
    required ConstructType constructType,
    required AnalyticsSelected defaultSelected,
    AnalyticsSelected? selected,
    bool removeIT = false,
    bool forceUpdate = false,
  }) async {
    final List<ConstructEvent>? local = getConstructsLocal(
      timeSpan: currentAnalyticsTimeSpan,
      constructType: constructType,
      defaultSelected: defaultSelected,
      selected: selected,
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

    final String? roomID = space?.id ?? selected?.id;
    final String? langCode = getLangCode(
      space: space,
      roomID: roomID,
    );

    if (langCode == null) {
      ErrorHandler.logError(
        m: "langCode missing in getConstructs",
        data: {
          "constructType": constructType,
          "AnalyticsEntryType": defaultSelected.type,
          "AnalyticsEntryId": defaultSelected.id,
          "space": space,
        },
      );
      throw "langCode missing in getConstructs";
    }

    final filteredConstructs = space == null
        ? await getMyConstructs(
            constructType: constructType,
            langCode: langCode,
            defaultSelected: defaultSelected,
            selected: selected,
          )
        : await getSpaceConstructs(
            constructType: constructType,
            space: space,
            langCode: langCode,
            defaultSelected: defaultSelected,
            selected: selected,
          );

    _constructs = removeIT
        ? filteredConstructs
            .where(
              (element) =>
                  element.content.lemma != "Try interactive translation" &&
                  element.content.lemma != "itStart" &&
                  element.content.lemma != MatchRuleIds.interactiveTranslation,
            )
            .toList()
        : filteredConstructs;

    if (local == null) {
      cacheConstructs(
        constructType: constructType,
        events: _constructs!,
        defaultSelected: defaultSelected,
        selected: selected,
      );
    }

    settingConstructs = false;
    return _constructs;
  }
}

class ConstructCacheEntry {
  final TimeSpan timeSpan;
  final ConstructType type;
  final List<ConstructEvent> events;
  final AnalyticsSelected defaultSelected;
  AnalyticsSelected? selected;

  ConstructCacheEntry({
    required this.timeSpan,
    required this.type,
    required this.events,
    required this.defaultSelected,
    this.selected,
  });
}

class CacheModel {
  TimeSpan timeSpan;
  ChartAnalyticsModel chartAnalyticsModel;
  String? classId;
  String? chatId;
  String? studentId;
  late DateTime _createdAt;

  CacheModel({
    required this.timeSpan,
    required this.classId,
    required this.chartAnalyticsModel,
    required this.chatId,
    required this.studentId,
  }) {
    _createdAt = DateTime.now();
  }

  bool get isExpired =>
      DateTime.now().difference(_createdAt).inMinutes >
      ClassDefaultValues.minutesDelayToMakeNewChartAnalytics;
}

// class ListTotals {
//   String listName;
//   ConstructUses vocabUse;

//   ListTotals({required this.listName, required this.vocabUse});
// }
