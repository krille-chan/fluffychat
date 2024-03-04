import 'dart:developer';

import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/models/headwords.dart';
import 'package:fluffychat/pangea/models/student_analytics_summary_model.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics_page.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../constants/class_default_values.dart';
import '../extensions/client_extension.dart';
import '../extensions/pangea_room_extension.dart';
import '../models/chart_analytics_model.dart';
import '../models/construct_analytics_event.dart';
import '../models/student_analytics_event.dart';
import 'base_controller.dart';
import 'pangea_controller.dart';

class AnalyticsController extends BaseController {
  late PangeaController _pangeaController;

  final List<CacheModel> _cachedModels = [];

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

  Future<List<ChartAnalyticsModel?>> allClassAnalytics() {
    final List<Future<ChartAnalyticsModel?>> classAnalyticFutures = [];
    for (final classRoom
        in _pangeaController.matrixState.client.classesAndExchangesImTeaching) {
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

  Future<VocabHeadwords> vocabHeadwordsWithTotals(
    String langCode,
    List<ConstructEvent> vocab, [
    String? chatId,
  ]) async {
    final VocabHeadwords vocabHeadwords =
        await VocabHeadwords.getHeadwords(langCode);
    for (final vocabList in vocabHeadwords.lists) {
      for (final vocabEvent in vocab) {
        vocabList.addVocabUse(
          vocabEvent.content.lemma,
          vocabEvent.content.uses,
        );
      }
    }
    return vocabHeadwords;
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

  Future<Room> myAnalyticsRoom(String langCode) =>
      _pangeaController.matrixState.client.getMyAnalyticsRoom(langCode);

  Future<List<ConstructEvent>> myConstructs(String langCode) async {
    final Room analyticsRoom = await myAnalyticsRoom(langCode);

    return analyticsRoom.allConstructEvents;
  }

  Future<List<ConstructEvent>> studentConstructs(
    String studentId,
    String langCode,
  ) {
    final Room? analyticsRoom = _pangeaController.matrixState.client
        .analyticsRoomLocal(langCode, studentId);
    if (analyticsRoom == null) {
      ErrorHandler.logError(
        m: "analyticsRoom missing in studentConstructs",
        s: StackTrace.current,
        data: {
          "studentId": studentId,
          "langCode": langCode,
        },
      );
    }
    return analyticsRoom?.allConstructEvents ?? Future.value([]);
  }

  Future<List<ConstructEvent>> spaceMemberVocab(String spaceId) async {
    await _pangeaController.matrixState.client.roomsLoading;
    final Room? space =
        _pangeaController.matrixState.client.getRoomById(spaceId);
    if (space == null) {
      throw Exception("space missing in spaceVocab");
    }
    final String? langCode = space.firstLanguageSettings?.targetLanguage;

    final List<Future<List<ConstructEvent>>> vocabEventFutures = [];
    await space.requestParticipants();
    for (final student in space.students) {
      final Room? room = _pangeaController.matrixState.client
          .analyticsRoomLocal(langCode, student.id);
      if (room != null) vocabEventFutures.add(room.allConstructEvents);
    }

    final List<List<ConstructEvent>> allVocabLists =
        await Future.wait(vocabEventFutures);

    final List<ConstructEvent> allVocab = [];
    for (final vocabList in allVocabLists) {
      allVocab.addAll(vocabList);
    }
    return allVocab;
  }

  /// in student analytics page, the [defaultSelected] is the student
  /// in class analytics page, the [defaultSelected] is the class
  /// [defaultSelected] should never be a chat
  /// the specific [selected] will be those items in the lists - chat, student or class
  Future<VocabHeadwords> vocabHeadsByAnalyticsSelected({
    required AnalyticsSelected? selected,
    required AnalyticsSelected defaultSelected,
  }) async {
    Future<List<ConstructEvent>> eventsFuture;
    String langCode;

    if (defaultSelected.type == AnalyticsEntryType.space) {
      // as long as a student isn't selected, we want the vocab events for the whole class
      final Room? classRoom =
          _pangeaController.matrixState.client.getRoomById(defaultSelected.id);
      if (classRoom?.classSettings == null) {
        throw Exception("classRoom missing in spaceMemberVocab");
      }
      langCode = classRoom!.classSettings!.targetLanguage;
      eventsFuture = selected?.type == AnalyticsEntryType.student
          ? studentConstructs(selected!.id, langCode)
          : spaceMemberVocab(defaultSelected.id);
    } else if (defaultSelected.type == AnalyticsEntryType.student) {
      // in this case, we're on an individual's own analytics page
      if (selected?.type == AnalyticsEntryType.space ||
          selected?.type == AnalyticsEntryType.student) {
        langCode = _pangeaController.languageController
            .activeL2Code(roomID: selected!.id)!;
        eventsFuture = myConstructs(langCode);
      } else {
        if (_pangeaController.languageController.userL2 == null) {
          throw Exception("userL2 missing in vocabHeadsByAnalyticsSelected");
        }
        langCode = _pangeaController.languageController.userL2!.langCode;
        eventsFuture = myConstructs(langCode);
      }
    } else {
      throw Exception("invalid defaultSelected.type - ${defaultSelected.type}");
    }

    return vocabHeadwordsWithTotals(langCode, await eventsFuture);
  }

  /// in student analytics page, the [defaultSelected] is the student
  /// in class analytics page, the [defaultSelected] is the class
  /// [defaultSelected] should never be a chat
  /// the specific [selected] will be those items in the lists - chat, student or class
  Future<List<ConstructEvent>> constuctEventsByAnalyticsSelected({
    required AnalyticsSelected? selected,
    required AnalyticsSelected defaultSelected,
    required ConstructType constructType,
  }) async {
    late Future<List<ConstructEvent>> eventFutures;
    String? langCode;
    if (defaultSelected.type == AnalyticsEntryType.space) {
      // as long as a student isn't selected, we want the vocab events for the whole class
      final Room? space =
          _pangeaController.matrixState.client.getRoomById(defaultSelected.id);
      if (space == null) {
        throw "No space available";
      }
      langCode = space.firstLanguageSettings?.targetLanguage;
      if (langCode == null) {
        throw "No target language available";
      }

      eventFutures = selected?.type == AnalyticsEntryType.student
          ? studentConstructs(selected!.id, langCode)
          : spaceMemberVocab(defaultSelected.id);
    } else if (defaultSelected.type == AnalyticsEntryType.student) {
      // in this case, we're on an individual's own analytics page

      if (selected?.type == AnalyticsEntryType.space ||
          selected?.type == AnalyticsEntryType.student) {
        langCode = _pangeaController.languageController
            .activeL2Code(roomID: selected!.id)!;
        eventFutures = myConstructs(langCode);
      } else {
        if (_pangeaController.languageController.userL2 == null) {
          throw "userL2 missing in constuctEventsByAnalyticsSelected";
        }
        langCode = _pangeaController.languageController.userL2!.langCode;
        eventFutures = myConstructs(langCode);
      }
    } else {
      throw "invalid defaultSelected.type - ${defaultSelected.type}";
    }

    final List<ConstructEvent> events = (await eventFutures)
        .where(
          (element) => element.content.type == constructType,
        )
        .toList();

    final List<String> chatIdsToFilterBy = [];
    if (selected?.type == AnalyticsEntryType.room) {
      chatIdsToFilterBy.add(selected!.id);
    } else if (selected?.type == AnalyticsEntryType.privateChats) {
      chatIdsToFilterBy.addAll(
        _pangeaController.matrixState.client
                .getRoomById(defaultSelected.id)
                ?.childrenAndGrandChildrenDirectChatIds ??
            [],
      );
    } else if (defaultSelected.type == AnalyticsEntryType.space) {
      chatIdsToFilterBy.addAll(
        _pangeaController.matrixState.client
                .getRoomById(defaultSelected.id)
                ?.childrenAndGrandChildren
                .where((e) => e.roomId != null)
                .map((e) => e.roomId!) ??
            [],
      );
    }
    if (chatIdsToFilterBy.isNotEmpty) {
      for (final event in events) {
        event.content.uses
            .removeWhere((u) => !chatIdsToFilterBy.contains(u.chatId));
      }
      events.removeWhere((e) => e.content.uses.isEmpty);
    }

    return events;
  }
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
