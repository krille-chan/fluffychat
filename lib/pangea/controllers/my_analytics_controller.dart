import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics_event.dart';
import 'package:fluffychat/pangea/models/constructs_event.dart';
import 'package:fluffychat/pangea/models/constructs_model.dart';
import 'package:fluffychat/pangea/models/student_analytics_summary_model.dart';
import 'package:fluffychat/pangea/models/summary_analytics_event.dart';
import 'package:fluffychat/pangea/models/summary_analytics_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../extensions/client_extension/client_extension.dart';
import '../extensions/pangea_room_extension/pangea_room_extension.dart';
import '../models/constructs_analytics_model.dart';

class MyAnalyticsController extends BaseController {
  late PangeaController _pangeaController;

  MyAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  final List<String> analyticsEventTypes = [
    PangeaEventTypes.summaryAnalytics,
    PangeaEventTypes.construct,
  ];

  Future<void> sendAllAnalyticsEvents(
    Room analyticsRoom,
  ) async {
    final String? langCode = analyticsRoom.madeForLang;
    if (langCode == null) {
      ErrorHandler.logError(
        e: "no lang code found for analytics room: ${analyticsRoom.id}",
        s: StackTrace.current,
      );
      return;
    }

    final Map<String, AnalyticsEvent?> prevEvents = {};
    for (final type in analyticsEventTypes) {
      final prevEvent = await analyticsRoom.getLastAnalyticsEvent(type);
      prevEvents[type] = prevEvent;
    }

    final List<DateTime?> lastUpdates = prevEvents.values
        .map((e) => e?.content.lastUpdated)
        .cast<DateTime?>()
        .toList();

    DateTime? earliestLastUpdated;
    if (!lastUpdates.any((updated) => updated == null)) {
      earliestLastUpdated = lastUpdates.reduce(
        (min, e) => e!.isBefore(min!) ? e : min,
      );
    }

    final List<RecentMessageRecord> analyticsContent = [];
    final List<OneConstructUse> constructsContent = [];

    for (final Room chat in _studentChats) {
      final String? chatLangCode =
          _pangeaController.languageController.activeL2Code(roomID: chat.id);
      if (chatLangCode != langCode) continue;

      final List<PangeaMessageEvent> recentMsgs =
          await chat.myMessageEventsInChat(
        since: earliestLastUpdated,
      );

      analyticsContent.addAll(
        formatAnalyticsContent(
          recentMsgs,
          prevEvents[PangeaEventTypes.summaryAnalytics]
              as SummaryAnalyticsEvent?,
        ),
      );

      constructsContent.addAll(
        formatConstructsContent(
          recentMsgs,
          prevEvents[PangeaEventTypes.construct] as ConstructAnalyticsEvent?,
        ),
      );
    }

    if (analyticsContent.isNotEmpty) {
      final SummaryAnalyticsModel analyticsModel = SummaryAnalyticsModel(
        messages: analyticsContent,
        lastUpdated: DateTime.now(),
        prevEventId:
            prevEvents[PangeaEventTypes.summaryAnalytics]?.event.eventId,
        prevLastUpdated:
            prevEvents[PangeaEventTypes.summaryAnalytics]?.content.lastUpdated,
      );
      await analyticsRoom.sendEvent(
        analyticsModel.toJson(),
        type: PangeaEventTypes.summaryAnalytics,
      );
    }

    if (constructsContent.isNotEmpty) {
      final Map<String, List<OneConstructUse>> lemmasUses = {};
      for (final use in constructsContent) {
        if (use.lemma == null) {
          debugPrint("use has no lemma!");
          continue;
        }
        lemmasUses[use.lemma!] ??= [];
        lemmasUses[use.lemma]!.add(use);
      }

      final ConstructAnalyticsModel constructsModel = ConstructAnalyticsModel(
        type: ConstructType.grammar,
        uses: lemmasUses.entries
            .map(
              (entry) => LemmaConstructsModel(
                lemma: entry.key,
                uses: entry.value,
              ),
            )
            .toList(),
        lastUpdated: DateTime.now(),
        prevEventId: prevEvents[PangeaEventTypes.construct]?.event.eventId,
        prevLastUpdated:
            prevEvents[PangeaEventTypes.construct]?.content.lastUpdated,
      );

      await analyticsRoom.sendEvent(
        constructsModel.toJson(),
        type: PangeaEventTypes.construct,
      );
    }
  }

  List<RecentMessageRecord> formatAnalyticsContent(
    List<PangeaMessageEvent> recentMsgs,
    SummaryAnalyticsEvent? prevEvent,
  ) {
    List<PangeaMessageEvent> filtered = List.from(recentMsgs);
    if (prevEvent?.content.lastUpdated != null) {
      filtered = recentMsgs
          .where(
            (msg) => msg.event.originServerTs.isAfter(
              prevEvent!.content.lastUpdated!,
            ),
          )
          .toList();
    }

    final List<String> addedMsgIds =
        prevEvent?.content.messages.map((msg) => msg.eventId).toList() ?? [];

    filtered.removeWhere((msg) => addedMsgIds.contains(msg.eventId));

    final List<RecentMessageRecord> records = filtered
        .map(
          (msg) => RecentMessageRecord(
            eventId: msg.eventId,
            chatId: msg.room.id,
            useType: msg.useType,
            time: msg.originServerTs,
          ),
        )
        .toList();

    return records;
  }

  List<OneConstructUse> formatConstructsContent(
    List<PangeaMessageEvent> recentMsgs,
    ConstructAnalyticsEvent? prevEvent,
  ) {
    List<PangeaMessageEvent> filtered = List.from(recentMsgs);
    if (prevEvent?.content.lastUpdated != null) {
      filtered = recentMsgs
          .where(
            (msg) => msg.event.originServerTs.isAfter(
              prevEvent!.content.lastUpdated!,
            ),
          )
          .toList();
    }

    final List<String> addedMsgIds = prevEvent?.content.uses
            .map((lemmause) => lemmause.uses.map((use) => use.msgId))
            .expand((element) => element)
            .where((element) => element != null)
            .cast<String>()
            .toList() ??
        [];

    filtered.removeWhere((msg) => addedMsgIds.contains(msg.eventId));

    final List<OneConstructUse> uses = filtered
        .map(
          (msg) => msg.originalSent?.choreo?.toGrammarConstructUse(
            msg.eventId,
            msg.room.id,
            msg.originServerTs,
          ),
        )
        .where((element) => element != null)
        .cast<List<OneConstructUse>>()
        .expand((element) => element)
        .toList();

    return uses;
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
    if (_studentSpaces.isNotEmpty) return;
    _studentSpaces = await _pangeaController
        .matrixState.client.classesAndExchangesImStudyingIn;
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

  // on the off chance that the user is in a class but doesn't have an analytics
  // room for the target language of that class, create the analytics room(s)
  Future<List<Room>> createMissingAnalyticsRoom() async {
    List<String> targetLangs = [];
    final String? userL2 = _pangeaController.languageController.activeL2Code();
    if (userL2 != null) targetLangs.add(userL2);
    final List<String?> spaceL2s = studentSpaces
        .map(
          (space) => _pangeaController.languageController.activeL2Code(
            roomID: space.id,
          ),
        )
        .toList();
    targetLangs.addAll(spaceL2s.where((l2) => l2 != null).cast<String>());
    targetLangs = targetLangs.toSet().toList();
    for (final String langCode in targetLangs) {
      await _pangeaController.matrixState.client.getMyAnalyticsRoom(langCode);
    }
    return _pangeaController.matrixState.client.allMyAnalyticsRooms;
  }

  Future<void> updateAnalytics() async {
    await setStudentChats();
    final List<Room> analyticsRooms =
        _pangeaController.matrixState.client.allMyAnalyticsRooms;
    analyticsRooms.addAll(await createMissingAnalyticsRoom());

    for (final Room analyticsRoom in analyticsRooms) {
      await sendAllAnalyticsEvents(analyticsRoom);
    }
  }

  // used to aggregate ConstructEvents, from multiple senders (students) with the same lemma
  List<AggregateConstructUses> aggregateConstructData(
    List<ConstructAnalyticsEvent> constructs,
  ) {
    final Map<String, List<LemmaConstructsModel>> lemmasToConstructs = {};
    for (final construct in constructs) {
      for (final lemmaUses in construct.content.uses) {
        lemmasToConstructs[lemmaUses.lemma] ??= [];
        lemmasToConstructs[lemmaUses.lemma]!.add(lemmaUses);
      }
    }

    final List<AggregateConstructUses> aggregatedConstructs = [];
    for (final lemmaToConstructs in lemmasToConstructs.entries) {
      final List<LemmaConstructsModel> lemmaConstructs =
          lemmaToConstructs.value;
      final AggregateConstructUses aggregatedData = AggregateConstructUses(
        lemmaUses: lemmaConstructs,
      );
      aggregatedConstructs.add(aggregatedData);
    }
    return aggregatedConstructs;
  }
}

class AggregateConstructUses {
  final List<LemmaConstructsModel> _lemmaUses;

  AggregateConstructUses({required List<LemmaConstructsModel> lemmaUses})
      : _lemmaUses = lemmaUses;

  String get lemma {
    assert(
      _lemmaUses.isNotEmpty &&
          _lemmaUses.every(
            (construct) => construct.lemma == _lemmaUses.first.lemma,
          ),
    );
    return _lemmaUses.first.lemma;
  }

  List<OneConstructUse> get uses => _lemmaUses
      .map((lemmaUse) => lemmaUse.uses)
      .expand((element) => element)
      .toList();
}
