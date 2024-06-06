import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/construct_analytics_event.dart';
import 'package:fluffychat/pangea/models/student_analytics_summary_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../extensions/client_extension/client_extension.dart';
import '../extensions/pangea_room_extension/pangea_room_extension.dart';
import '../models/constructs_analytics_model.dart';
import '../models/student_analytics_event.dart';

class MyAnalyticsController {
  late PangeaController _pangeaController;

  MyAnalyticsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  String? get _userId => _pangeaController.matrixState.client.userID;

  //PTODO - locally cache and update periodically
  Future<void> handleMessage(
    Room room,
    RecentMessageRecord messageRecord, {
    bool isEdit = false,
  }) async {
    try {
      debugPrint("in handle message with type ${messageRecord.useType}");
      if (_userId == null) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "null userId in updateAnalytics",
          s: StackTrace.current,
        );
        return;
      }

      await _pangeaController.classController.addDirectChatsToClasses(room);
      //expanding this to all parents of the room
      // final List<Room> spaces = room.immediateClassParents;
      final List<Room> spaces = room.pangeaSpaceParents;
      // janky but probably stays until we have a class analytics bot added by
      // default to all chats

      final List<StudentAnalyticsEvent?> events = await analyticsEvents(spaces);

      for (final event in events) {
        if (event != null) {
          event.handleNewMessage(messageRecord, isEdit: isEdit);
        }
      }
    } catch (err) {
      debugger(when: kDebugMode);
    }
  }

  Future<List<StudentAnalyticsEvent?>> analyticsEvents(
    List<Room> spaces,
  ) async {
    final List<Future<StudentAnalyticsEvent?>> events = [];
    if (_userId != null) {
      for (final space in spaces) {
        events.add(space.getStudentAnalytics(_userId!));
      }
    }
    return Future.wait(events);
  }

  Future<List<StudentAnalyticsEvent?>> allMyAnalyticsEvents() async =>
      analyticsEvents(
        await _pangeaController
            .matrixState.client.classesAndExchangesImStudyingIn,
      );

  Future<void> saveConstructsMixed(
    List<OneConstructUse> allUses,
    String langCode, {
    bool isEdit = false,
  }) async {
    try {
      final Map<String, List<OneConstructUse>> aggregatedVocabUse = {};
      for (final use in allUses) {
        if (use.lemma == null) continue;
        aggregatedVocabUse[use.lemma!] ??= [];
        aggregatedVocabUse[use.lemma]!.add(use);
      }
      final Room analyticsRoom = await _pangeaController.matrixState.client
          .getMyAnalyticsRoom(langCode);

      final List<Future<void>> saveFutures = [];
      for (final uses in aggregatedVocabUse.entries) {
        debugPrint("saving of type ${uses.value.first.constructType}");
        saveFutures.add(
          analyticsRoom.saveConstructUsesSameLemma(
            uses.key,
            uses.value.first.constructType ?? ConstructType.grammar,
            uses.value,
            isEdit: isEdit,
          ),
        );
      }

      await Future.wait(saveFutures);
    } catch (err, s) {
      debugger(when: kDebugMode);
      if (!kDebugMode) rethrow;
      ErrorHandler.logError(e: err, s: s);
    }
  }

  // used to aggregate ConstructEvents, from multiple senders (students) with the same lemma
  List<AggregateConstructUses> aggregateConstructData(
    List<ConstructEvent> constructs,
  ) {
    final Map<String, List<ConstructEvent>> lemmasToConstructs = {};
    for (final construct in constructs) {
      lemmasToConstructs[construct.content.lemma] ??= [];
      lemmasToConstructs[construct.content.lemma]!.add(construct);
    }

    final List<AggregateConstructUses> aggregatedConstructs = [];
    for (final lemmaToConstructs in lemmasToConstructs.entries) {
      final List<ConstructEvent> lemmaConstructs = lemmaToConstructs.value;
      final AggregateConstructUses aggregatedData = AggregateConstructUses(
        constructs: lemmaConstructs,
      );
      aggregatedConstructs.add(aggregatedData);
    }
    return aggregatedConstructs;
  }
}

class AggregateConstructUses {
  final List<ConstructEvent> _constructs;

  AggregateConstructUses({required List<ConstructEvent> constructs})
      : _constructs = constructs;

  String get lemma {
    assert(
      _constructs.isNotEmpty &&
          _constructs.every(
            (construct) =>
                construct.content.lemma == _constructs.first.content.lemma,
          ),
    );
    return _constructs.first.content.lemma;
  }

  List<OneConstructUse> get uses => _constructs
      .map((construct) => construct.content.uses)
      .expand((element) => element)
      .toList();
}
