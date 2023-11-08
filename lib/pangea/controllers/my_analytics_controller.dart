import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/student_analytics_summary_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../extensions/client_extension.dart';
import '../extensions/pangea_room_extension.dart';
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
      Room room, RecentMessageRecord messageRecord) async {
    try {
      debugPrint("in handle message with type ${messageRecord.useType}");
      if (_userId == null) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
            m: "null userId in updateAnalytics", s: StackTrace.current);
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
        debugPrint("adding to total ${event?.content.messages.length}");
        if (event != null) {
          event.handleNewMessage(messageRecord);
        }
      }
    } catch (err) {
      debugger(when: kDebugMode);
    }
  }

  Future<List<StudentAnalyticsEvent?>> analyticsEvents(
      List<Room> spaces) async {
    final List<Future<StudentAnalyticsEvent?>> events = [];
    for (final space in spaces) {
      events.add(space.getStudentAnalytics(_userId!));
    }
    return Future.wait(events);
  }

  Future<List<StudentAnalyticsEvent?>> allMyAnalyticsEvents() =>
      analyticsEvents(
        _pangeaController.matrixState.client.classesAndExchangesImStudyingIn,
      );

  Future<void> saveConstructsMixed(
      List<OneConstructUse> allUses, String langCode) async {
    try {
      final Map<String, List<OneConstructUse>> aggregatedVocabUse = {};
      for (final use in allUses) {
        aggregatedVocabUse[use.lemma!] ??= [];
        aggregatedVocabUse[use.lemma]!.add(use);
      }
      final Room analyticsRoom = await _pangeaController.matrixState.client
          .getMyAnalyticsRoom(langCode);
      analyticsRoom.makeSureTeachersAreInvitedToAnalyticsRoom();
      final List<Future<void>> saveFutures = [];
      for (final uses in aggregatedVocabUse.entries) {
        debugPrint("saving of type ${uses.value.first.constructType}");
        saveFutures.add(
          analyticsRoom.saveConstructUsesSameLemma(
              uses.key, uses.value.first.constructType!, uses.value),
        );
      }

      await Future.wait(saveFutures);
    } catch (err, s) {
      debugger(when: kDebugMode);
      if (!kDebugMode) rethrow;
      ErrorHandler.logError(e: err, s: s);
    }
  }
}
