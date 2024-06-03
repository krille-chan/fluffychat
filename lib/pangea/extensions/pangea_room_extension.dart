import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics_event.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/models/constructs_event.dart';
import 'package:fluffychat/pangea/models/summary_analytics_event.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import markdown.dart
import 'package:html_unescape/html_unescape.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/src/utils/markdown.dart';
import 'package:matrix/src/utils/space_child.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../config/app_config.dart';
import '../constants/pangea_event_types.dart';
import '../enum/use_type.dart';
import '../models/choreo_record.dart';
import '../models/representation_content_model.dart';
import 'client_extension.dart';

extension PangeaRoom on Room {
  /// the pangeaClass event is listed an importantStateEvent so, if event exists,
  /// it's already local. If it's an old class and doesn't, then the class_controller
  /// should automatically migrate during this same session, when the space is first loaded
  ClassSettingsModel? get classSettings {
    try {
      if (!isSpace) {
        return null;
      }
      final Map<String, dynamic>? content = languageSettingsStateEvent?.content;
      if (content != null) {
        final ClassSettingsModel classSettings =
            ClassSettingsModel.fromJson(content);
        return classSettings;
      }
      return null;
    } catch (err, s) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "Error in classSettings",
          data: {"room": toJson()},
        ),
      );
      ErrorHandler.logError(e: err, s: s);
      return null;
    }
  }

  PangeaRoomRules? get pangeaRoomRules {
    try {
      final Map<String, dynamic>? content = pangeaRoomRulesStateEvent?.content;
      if (content != null) {
        final PangeaRoomRules roomRules = PangeaRoomRules.fromJson(content);
        return roomRules;
      }
      return null;
    } catch (err, s) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "Error in pangeaRoomRules",
          data: {"room": toJson()},
        ),
      );
      ErrorHandler.logError(e: err, s: s);
      return null;
    }
  }

  String? get creatorId => getState(EventTypes.RoomCreate)?.senderId;

  DateTime? get creationTime => getState(EventTypes.RoomCreate)?.originServerTs;

  ClassSettingsModel? get firstLanguageSettings =>
      classSettings ??
      firstParentWithState(PangeaEventTypes.classSettings)?.classSettings;

  PangeaRoomRules? get firstRules =>
      pangeaRoomRules ??
      firstParentWithState(PangeaEventTypes.rules)?.pangeaRoomRules;

  //resolve somehow if multiple rooms have the state?
  //check logic
  Room? firstParentWithState(String stateType) {
    if (![PangeaEventTypes.classSettings, PangeaEventTypes.rules]
        .contains(stateType)) {
      return null;
    }

    for (final parent in pangeaSpaceParents) {
      if (parent.getState(stateType) != null) {
        return parent;
      }
    }
    for (final parent in pangeaSpaceParents) {
      final parentFirstRoom = parent.firstParentWithState(stateType);
      if (parentFirstRoom != null) return parentFirstRoom;
    }
    return null;
  }

  IconData? get roomTypeIcon {
    if (membership == Membership.invite) return Icons.add;
    if (isPangeaClass) return Icons.school;
    if (isExchange) return Icons.connecting_airports;
    if (isAnalyticsRoom) return Icons.analytics;
    if (isDirectChat) return Icons.forum;
    return Icons.group;
  }

  Text nameAndRoomTypeIcon([TextStyle? textStyle]) => Text.rich(
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(roomTypeIcon),
            ),
            TextSpan(
              text: '  $name',
            ),
          ],
        ),
      );

  /// find any parents and return the rooms
  List<Room> get immediateClassParents => pangeaSpaceParents
      .where(
        (element) => element.isPangeaClass,
      )
      .toList();

  List<Room> get pangeaSpaceParents => client.rooms
      .where(
        (r) => r.isSpace,
      )
      .where(
        (space) => space.spaceChildren.any(
          (room) => room.roomId == id,
        ),
      )
      .toList();

  bool isChild(String roomId) =>
      isSpace && spaceChildren.any((room) => room.roomId == roomId);

  bool isFirstOrSecondChild(String roomId) {
    return isSpace &&
        (spaceChildren.any((room) => room.roomId == roomId) ||
            spaceChildren
                .where((sc) => sc.roomId != null)
                .map((sc) => client.getRoomById(sc.roomId!))
                .any(
                  (room) =>
                      room != null &&
                      room.isSpace &&
                      room.spaceChildren.any((room) => room.roomId == roomId),
                ));
  }

  //note this only will return rooms that the user has joined or been invited to
  List<Room> get joinedChildren {
    if (!isSpace) return [];
    return spaceChildren
        .where((child) => child.roomId != null)
        .map(
          (child) => client.getRoomById(child.roomId!),
        )
        .where((child) => child != null)
        .cast<Room>()
        .where(
          (child) => child.membership == Membership.join,
        )
        .toList();
  }

  List<String> get joinedChildrenRoomIds =>
      joinedChildren.map((child) => child.id).toList();

  List<SpaceChild> get childrenAndGrandChildren {
    if (!isSpace) return [];
    final List<SpaceChild> kids = [];
    for (final child in spaceChildren) {
      kids.add(child);
      if (child.roomId != null) {
        final Room? childRoom = client.getRoomById(child.roomId!);
        if (childRoom != null && childRoom.isSpace) {
          kids.addAll(childRoom.spaceChildren);
        }
      }
    }
    return kids.where((element) => element.roomId != null).toList();
  }

  //this assumes that a user has been invited to all group chats in a space
  //it is a janky workaround for determining whether a spacechild is a direct chat
  //since the spaceChild object doesn't contain this info. this info is only accessible
  //when the user has joined or been invited to the room. direct chats included in
  //a space show up in spaceChildren but the user has not been invited to them.
  List<String> get childrenAndGrandChildrenDirectChatIds {
    final List<String> nonDirectChatRoomIds = childrenAndGrandChildren
        .where((child) => child.roomId != null)
        .map((e) => client.getRoomById(e.roomId!))
        .where((r) => r != null && !r.isDirectChat)
        .map((e) => e!.id)
        .toList();

    return childrenAndGrandChildren
        .where(
          (child) =>
              child.roomId != null &&
              !nonDirectChatRoomIds.contains(child.roomId),
        )
        .map((e) => e.roomId)
        .cast<String>()
        .toList();

    // return childrenAndGrandChildren
    //     .where((element) => element.roomId != null)
    //     .where(
    //       (child) {
    //         final room = client.getRoomById(child.roomId!);
    //         return room == null || room.isDirectChat;
    //       },
    //     )
    //     .map((e) => e.roomId)
    //     .cast<String>()
    //     .toList();
  }

  //if the user is an admin of the room or any immediate parent of the room
  //Question: check parents of parents?
  //check logic
  bool get isSpaceAdmin {
    if (isSpace) return isRoomAdmin;

    for (final parent in pangeaSpaceParents) {
      if (parent.isRoomAdmin) {
        return true;
      }
    }
    for (final parent in pangeaSpaceParents) {
      for (final parent2 in parent.pangeaSpaceParents) {
        if (parent2.isRoomAdmin) {
          return true;
        }
      }
    }
    return false;
  }

  bool isUserRoomAdmin(String userId) => getParticipants().any(
        (e) =>
            e.id == userId &&
            e.powerLevel == ClassDefaultValues.powerLevelOfAdmin,
      );

  bool isUserSpaceAdmin(String userId) {
    if (isSpace) return isUserRoomAdmin(userId);

    for (final parent in pangeaSpaceParents) {
      if (parent.isUserRoomAdmin(userId)) {
        return true;
      }
    }
    return false;
  }

  Event? get languageSettingsStateEvent =>
      getState(PangeaEventTypes.classSettings);

  Event? get pangeaRoomRulesStateEvent => getState(PangeaEventTypes.rules);

  bool get isPangeaClass => isSpace && languageSettingsStateEvent != null;

  bool get isAnalyticsRoom =>
      getState(EventTypes.RoomCreate)?.content.tryGet<String>('type') ==
      PangeaRoomTypes.analytics;

  bool get isExchange =>
      isSpace &&
      languageSettingsStateEvent == null &&
      pangeaRoomRulesStateEvent != null;

  bool get isDirectChatWithoutMe =>
      isDirectChat && !getParticipants().any((e) => e.id == client.userID);

  bool isMadeByUser(String userId) =>
      getState(EventTypes.RoomCreate)?.senderId == userId;

  String? get madeForLang {
    final creationContent = getState(EventTypes.RoomCreate)?.content;
    return creationContent?.tryGet<String>(ModelKey.langCode) ??
        creationContent?.tryGet<String>(ModelKey.oldLangCode);
  }

  bool isMadeForLang(String langCode) {
    final creationContent = getState(EventTypes.RoomCreate)?.content;
    return creationContent?.tryGet<String>(ModelKey.langCode) == langCode ||
        creationContent?.tryGet<String>(ModelKey.oldLangCode) == langCode;
  }

  bool isAnalyticsRoomOfUser(String userId) =>
      isAnalyticsRoom && isMadeByUser(userId);

  String get domainString =>
      AppConfig.defaultHomeserver.replaceAll("matrix.", "");

  String get classCode {
    if (!isSpace) {
      for (final Room potentialClassRoom in pangeaSpaceParents) {
        if (potentialClassRoom.isPangeaClass) {
          return potentialClassRoom.classCode;
        }
      }
      return "Not in a class!";
    }

    return canonicalAlias.replaceAll(":$domainString", "").replaceAll("#", "");
  }

  // StudentAnalyticsEvent? _getStudentAnalyticsLocal() {
  //   if (!isAnalyticsRoom) {
  //     debugger(when: kDebugMode);
  //     ErrorHandler.logError(
  //       m: "calling getStudentAnalyticsLocal on non-analytics room",
  //       s: StackTrace.current,
  //     );
  //     return null;
  //   }

  //   final Event? matrixEvent = getState(PangeaEventTypes.summaryAnalytics);

  //   return matrixEvent != null
  //       ? StudentAnalyticsEvent(event: matrixEvent)
  //       : null;
  // }

  // Future<Map<String, DateTime>> lemmasLastUpdated() async {
  //   try {
  //     if (!isAnalyticsRoom) {
  //       debugger(when: kDebugMode);
  //       throw Exception(
  //         "calling lemmasLastUpdated on non-analytics room",
  //       );
  //     }

  //     await postLoad();
  //     final entries = states[PangeaEventTypes.vocab]?.entries.toList();
  //     if (entries != null && entries.isNotEmpty) {
  //       final Map<String, DateTime> resultMap = {};
  //       for (final entry in entries) {
  //         // migration - don't count uses without unique IDs
  //         if (ConstructEvent(event: entry.value)
  //             .content
  //             .uses
  //             .any((use) => use.id != null)) {
  //           resultMap[entry.key] = entry.value.originServerTs;
  //         }
  //       }
  //       return resultMap;
  //     }
  //     return {};
  //   } catch (err) {
  //     debugger(when: kDebugMode);
  //     rethrow;
  //   }
  // }

  // Future<StudentAnalyticsEvent?> getStudentAnalyticsEvent({
  //   bool forcedUpdate = false,
  // }) async {
  //   try {
  //     if (!isAnalyticsRoom) {
  //       debugger(when: kDebugMode);
  //       throw Exception(
  //         "calling getStudentAnalyticsLocal on non-analytics room",
  //       );
  //     }

  //     await postLoad();
  //     StudentAnalyticsEvent? localEvent = _getStudentAnalyticsLocal();

  //     if (isRoomOwner && localEvent == null) {
  //       final Event? matrixEvent = await _createStudentAnalyticsEvent();
  //       if (matrixEvent != null) {
  //         localEvent = StudentAnalyticsEvent(event: matrixEvent);
  //       }
  //     }

  //     return localEvent;
  //   } catch (err) {
  //     debugger(when: kDebugMode);
  //     rethrow;
  //   }
  // }

  void checkClass() {
    if (!isSpace) {
      debugger(when: kDebugMode);
      Sentry.addBreadcrumb(
        Breadcrumb(message: "calling room.students with non-class room"),
      );
    }
  }

  List<User> get students {
    checkClass();
    return isSpace
        ? getParticipants()
            .where(
              (e) =>
                  e.powerLevel < ClassDefaultValues.powerLevelOfAdmin &&
                  e.id != BotName.byEnvironment,
            )
            .toList()
        : getParticipants();
  }

  Future<List<User>> get teachers async {
    checkClass();
    final List<User> participants = await requestParticipants();
    return isSpace
        ? participants
            .where(
              (e) =>
                  e.powerLevel == ClassDefaultValues.powerLevelOfAdmin &&
                  e.id != BotName.byEnvironment,
            )
            .toList()
        : participants;
  }

  ///   if [isSpace]
  ///     for all child chats, call _getChatAnalyticsGlobal and merge results
  ///   else
  ///     get analytics from pangea chat server
  ///     do any needed conversion work
  ///   save RoomAnalytics object to PangeaEventTypes.analyticsSummary event
  // Future<Event?> _createStudentAnalyticsEvent() async {
  //   try {
  //     if (!isAnalyticsRoom) {
  //       debugger(when: kDebugMode);
  //       throw Exception(
  //         "calling _createStudentAnalyticsEvent on non-analytics room",
  //       );
  //     }

  //     await postLoad();
  //     if (!pangeaCanSendEvent(PangeaEventTypes.studentAnalyticsSummary)) {
  //       ErrorHandler.logError(
  //         m: "null powerLevels in createStudentAnalytics",
  //         s: StackTrace.current,
  //       );
  //       return null;
  //     }
  //     if (client.userID == null) {
  //       debugger(when: kDebugMode);
  //       throw Exception("null userId in createStudentAnalytics");
  //     }

  //     final String eventId = await client.setRoomStateWithKey(
  //       id,
  //       PangeaEventTypes.studentAnalyticsSummary,
  //       '',
  //       StudentAnalyticsSummary(
  //         lastUpdated: null,
  //         messages: [],
  //       ).toJson(),
  //     );
  //     final Event? event = await getEventById(eventId);

  //     if (event == null) {
  //       debugger(when: kDebugMode);
  //       throw Exception(
  //         "null event after creation with eventId $eventId in createStudentAnalytics",
  //       );
  //     }
  //     return event;
  //   } catch (err, stack) {
  //     ErrorHandler.logError(e: err, s: stack, data: powerLevels);
  //     return null;
  //   }
  // }

  Future<List<PangeaMessageEvent>> myMessageEventsInChat({
    DateTime? since,
  }) async {
    try {
      int numberOfSearches = 0;
      if (isSpace) {
        throw Exception(
          "In messageListForChat with room that is not a chat",
        );
      }
      final Timeline timeline = await getTimeline();
      while (timeline.canRequestHistory && numberOfSearches < 50) {
        try {
          await timeline.requestHistory();
        } catch (err) {
          break;
        }
        numberOfSearches += 1;
        if (timeline.events.any(
          (event) => event.originServerTs.isAfter(since ?? DateTime.now()),
        )) {
          break;
        }
      }

      final List<PangeaMessageEvent> msgs = [];
      for (Event event in timeline.events) {
        final bool hasAnalytics = (event.senderId == client.userID) &&
            (event.type == EventTypes.Message) &&
            (event.content['msgtype'] == MessageTypes.Text &&
                !(event.relationshipType == RelationshipTypes.edit));
        if (hasAnalytics &&
            (since == null || event.originServerTs.isAfter(since))) {
          if (event.hasAggregatedEvents(timeline, RelationshipTypes.edit)) {
            event = event
                    .aggregatedEvents(
                      timeline,
                      RelationshipTypes.edit,
                    )
                    .sorted(
                      (a, b) => b.originServerTs.compareTo(a.originServerTs),
                    )
                    .firstOrNull ??
                event;
          }
          final PangeaMessageEvent pMsgEvent = PangeaMessageEvent(
            event: event,
            timeline: timeline,
            ownMessage: true,
          );
          msgs.add(pMsgEvent);
        }
      }
      return msgs;
    } catch (err, s) {
      if (kDebugMode) rethrow;
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
      return [];
    }
  }

  Future<Event?> sendPangeaEvent({
    required Map<String, dynamic> content,
    required String parentEventId,
    required String type,
  }) async {
    try {
      debugPrint("creating $type child for $parentEventId");
      Sentry.addBreadcrumb(Breadcrumb.fromJson(content));
      if (parentEventId.contains("web")) {
        debugger(when: kDebugMode);
        Sentry.addBreadcrumb(
          Breadcrumb(
            message:
                "sendPangeaEvent with likely invalid parentEventId $parentEventId",
          ),
        );
      }
      final Map<String, dynamic> repContent = {
        // what is the functionality of m.reference?
        "m.relates_to": {"rel_type": type, "event_id": parentEventId},
        type: content,
      };

      final String? newEventId = await sendEvent(repContent, type: type);

      if (newEventId == null) {
        debugger(when: kDebugMode);
        return null;
      }

      //PTODO - handle the frequent case of a null newEventId
      final Event? newEvent = await getEventById(newEventId);

      if (newEvent == null) {
        debugger(when: kDebugMode);
      }

      return newEvent;
    } catch (err, stack) {
      // debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "type": type,
          "parentEventId": parentEventId,
          "content": content,
        },
      );
      return null;
    }
  }

  // ConstructEvent? vocabEventLocal(String lemma) {
  //   if (!isAnalyticsRoom) throw Exception("not an analytics room");

  //   final Event? matrixEvent = getState(PangeaEventTypes.vocab, lemma);

  //   return matrixEvent != null ? ConstructEvent(event: matrixEvent) : null;
  // }

  bool get isRoomOwner =>
      getState(EventTypes.RoomCreate)?.senderId == client.userID;

  // Future<ConstructEvent> vocabEvent(
  //   String lemma,
  //   ConstructType type, [
  //   bool makeIfNull = false,
  // ]) async {
  //   try {
  //     if (!isAnalyticsRoom) throw Exception("not an analytics room");

  //     ConstructEvent? localEvent = vocabEventLocal(lemma);

  //     if (localEvent != null) return localEvent;

  //     await postLoad();
  //     localEvent = vocabEventLocal(lemma);

  //     if (localEvent == null && isRoomOwner && makeIfNull) {
  //       final Event matrixEvent = await _createVocabEvent(lemma, type);
  //       localEvent = ConstructEvent(event: matrixEvent);
  //     }

  //     return localEvent!;
  //   } catch (err) {
  //     debugger(when: kDebugMode);
  //     rethrow;
  //   }
  // }

  // Future<List<OneConstructUse>> removeEdittedLemmas(
  //   List<OneConstructUse> lemmaUses,
  // ) async {
  //   final List<String> removeUses = [];
  //   for (final use in lemmaUses) {
  //     if (use.msgId == null) continue;
  //     final List<String> removeIds = await client.getEditHistory(
  //       use.chatId,
  //       use.msgId!,
  //     );
  //     removeUses.addAll(removeIds);
  //   }
  //   lemmaUses.removeWhere((use) => removeUses.contains(use.msgId));
  //   final allEvents = await allConstructEvents;
  //   for (final constructEvent in allEvents) {
  //     await constructEvent.removeEdittedUses(removeUses, client);
  //   }
  //   return lemmaUses;
  // }

  // Future<void> saveConstructUsesSameLemma(
  //   String lemma,
  //   ConstructType type,
  //   List<OneConstructUse> lemmaUses, {
  //   bool isEdit = false,
  // }) async {
  //   final ConstructEvent? localEvent = vocabEventLocal(lemma);

  //   if (isEdit) {
  //     lemmaUses = await removeEdittedLemmas(lemmaUses);
  //   }

  //   // final waitForUpdate = client.onRoomState.stream.firstWhere(
  //   //   (Event event) =>
  //   //       event.type == PangeaEventTypes.vocab && event.stateKey == lemma,
  //   // );

  //   if (localEvent == null) {
  //     await client.setRoomStateWithKey(
  //       id,
  //       PangeaEventTypes.vocab,
  //       lemma,
  //       ConstructUses(lemma: lemma, type: type, uses: lemmaUses).toJson(),
  //     );
  //     await postLoad();
  //   } else {
  //     // migration - remove uses without unique IDs,
  //     // this is used to prevent duplicate saves
  //     localEvent.content.uses.removeWhere((use) => use.id == null);
  //     localEvent.addAll(lemmaUses);
  //     await updateStateEvent(localEvent.event);
  //   }

  //   // await waitForUpdate;
  // }

  // Future<List<ConstructEvent>> get allConstructEvents async {
  //   await postLoad();
  //   return states[PangeaEventTypes.vocab]
  //           ?.values
  //           .map((Event event) => ConstructEvent(event: event))
  //           .toList()
  //           .cast<ConstructEvent>() ??
  //       [];
  // }

  // Future<Event> _createVocabEvent(String lemma, ConstructType type) async {
  //   try {
  //     if (!isRoomOwner) {
  //       throw Exception(
  //         "Tried to create vocab event in room where user is not owner",
  //       );
  //     }
  //     final String eventId = await client.setRoomStateWithKey(
  //       id,
  //       PangeaEventTypes.vocab,
  //       lemma,
  //       ConstructUses(lemma: lemma, type: type).toJson(),
  //     );
  //     final Event? event = await getEventById(eventId);

  //     if (event == null) {
  //       debugger(when: kDebugMode);
  //       throw Exception(
  //         "null event after creation with eventId $eventId in _createVocabEvent",
  //       );
  //     }
  //     return event;
  //   } catch (err, stack) {
  //     debugger(when: kDebugMode);
  //     ErrorHandler.logError(e: err, s: stack, data: powerLevels);
  //     rethrow;
  //   }
  // }

  /// update state event and return eventId
  Future<String> updateStateEvent(Event stateEvent) async {
    if (stateEvent.stateKey == null) {
      throw Exception("stateEvent.stateKey is null");
    }
    final String resp = await client.setRoomStateWithKey(
      id,
      stateEvent.type,
      stateEvent.stateKey!,
      stateEvent.content,
    );
    await postLoad();
    return resp;
  }

  bool canIAddSpaceChild(Room? room) {
    if (!isSpace) {
      ErrorHandler.logError(
        m: "should not call canIAddSpaceChildren on non-space room",
        data: toJson(),
        s: StackTrace.current,
      );
      return false;
    }
    if (room != null && !room.isRoomAdmin) {
      return false;
    }
    if (!pangeaCanSendEvent(EventTypes.spaceChild) && !isRoomAdmin) {
      return false;
    }
    if (room == null) {
      return isRoomAdmin || (pangeaRoomRules?.isCreateRooms ?? false);
    }
    if (room.isExchange) {
      return isRoomAdmin;
    }
    if (!room.isSpace) {
      return pangeaRoomRules?.isCreateRooms ?? false;
    }
    if (room.isPangeaClass) {
      ErrorHandler.logError(
        m: "should not call canIAddSpaceChild with class",
        data: room.toJson(),
        s: StackTrace.current,
      );
      return false;
    }
    return false;
  }

  bool get canIAddSpaceParents =>
      isRoomAdmin || pangeaCanSendEvent(EventTypes.spaceParent);

  bool get showClassEditOptions => isSpace && isRoomAdmin;

  bool get canDelete => isSpaceAdmin;

  bool get isRoomAdmin => ownPowerLevel == ClassDefaultValues.powerLevelOfAdmin;

  //overriding the default canSendEvent to check power levels
  bool pangeaCanSendEvent(String eventType) {
    final powerLevelsMap = getState(EventTypes.RoomPowerLevels)?.content;
    if (powerLevelsMap == null) return 0 <= ownPowerLevel;
    final pl = powerLevelsMap
            .tryGetMap<String, dynamic>('events')
            ?.tryGet<int>(eventType) ??
        100;
    return ownPowerLevel >= pl;
  }

  Future<void> setClassPowerlLevels() async {
    try {
      if (ownPowerLevel < ClassDefaultValues.powerLevelOfAdmin) {
        return;
      }
      final Event? currentPower = getState(EventTypes.RoomPowerLevels);
      final Map<String, dynamic>? currentPowerContent =
          currentPower?.content["events"] as Map<String, dynamic>?;
      final spaceChildPower = currentPowerContent?[EventTypes.spaceChild];

      if (spaceChildPower == null && currentPowerContent != null) {
        currentPowerContent["events"][EventTypes.spaceChild] = 0;
        await client.setRoomStateWithKey(
          id,
          EventTypes.RoomPowerLevels,
          currentPower?.stateKey ?? "",
          currentPowerContent,
        );
      }
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s, data: toJson());
    }
  }

  Future<String?> pangeaSendTextEvent(
    String message, {
    String? txid,
    Event? inReplyTo,
    String? editEventId,
    bool parseMarkdown = true,
    bool parseCommands = false,
    String msgtype = MessageTypes.Text,
    String? threadRootEventId,
    String? threadLastEventId,
    PangeaRepresentation? originalSent,
    PangeaRepresentation? originalWritten,
    PangeaMessageTokens? tokensSent,
    PangeaMessageTokens? tokensWritten,
    ChoreoRecord? choreo,
    UseType? useType,
  }) {
    // if (parseCommands) {
    //   return client.parseAndRunCommand(this, message,
    //       inReplyTo: inReplyTo,
    //       editEventId: editEventId,
    //       txid: txid,
    //       threadRootEventId: threadRootEventId,
    //       threadLastEventId: threadLastEventId);
    // }
    final event = <String, dynamic>{
      'msgtype': msgtype,
      'body': message,
      ModelKey.choreoRecord: choreo?.toJson(),
      ModelKey.originalSent: originalSent?.toJson(),
      ModelKey.originalWritten: originalWritten?.toJson(),
      ModelKey.tokensSent: tokensSent?.toJson(),
      ModelKey.tokensWritten: tokensWritten?.toJson(),
      ModelKey.useType: useType?.string,
    };
    if (parseMarkdown) {
      final html = markdown(
        event['body'],
        getEmotePacks: () => getImagePacksFlat(ImagePackUsage.emoticon),
        getMention: getMention,
      );
      // if the decoded html is the same as the body, there is no need in sending a formatted message
      if (HtmlUnescape().convert(html.replaceAll(RegExp(r'<br />\n?'), '\n')) !=
          event['body']) {
        event['format'] = 'org.matrix.custom.html';
        event['formatted_body'] = html;
      }
    }
    return sendEvent(
      event,
      txid: txid,
      inReplyTo: inReplyTo,
      editEventId: editEventId,
      threadRootEventId: threadRootEventId,
      threadLastEventId: threadLastEventId,
    );
  }

  int? get eventsDefaultPowerLevel => getState(EventTypes.RoomPowerLevels)
      ?.content
      .tryGet<int>('events_default');

  bool get locked {
    if (isDirectChat) return false;
    if (!isSpace) {
      if (eventsDefaultPowerLevel == null) return false;
      return (eventsDefaultPowerLevel ?? 0) >=
          ClassDefaultValues.powerLevelOfAdmin;
    }
    int joinedRooms = 0;
    for (final child in spaceChildren) {
      if (child.roomId == null) continue;
      final Room? room = client.getRoomById(child.roomId!);
      if (room?.locked == false) {
        return false;
      }
      if (room != null) {
        joinedRooms += 1;
      }
    }
    return joinedRooms > 0 ? true : false;
  }

  Future<bool> suggestedInSpace(Room space) async {
    try {
      final Map<String, dynamic> resp =
          await client.getRoomStateWithKey(space.id, EventTypes.spaceChild, id);
      return resp.containsKey('suggested') ? resp['suggested'] as bool : true;
    } catch (err) {
      ErrorHandler.logError(
        e: "Failed to fetch suggestion status of room $id in space ${space.id}",
        s: StackTrace.current,
      );
      return true;
    }
  }

  Future<void> setSuggestedInSpace(bool suggest, Room space) async {
    try {
      await space.setSpaceChild(id, suggested: suggest);
    } catch (err) {
      ErrorHandler.logError(
        e: "Failed to set suggestion status of room $id in space ${space.id}",
        s: StackTrace.current,
      );
      return;
    }
  }

  Future<List<Room>> getChildRooms() async {
    final List<Room> children = [];
    for (final child in spaceChildren) {
      if (child.roomId == null) continue;
      final Room? room = client.getRoomById(child.roomId!);
      if (room != null) {
        children.add(room);
      }
    }
    return children;
  }

  DateTime? get classSettingsUpdatedAt {
    if (!isSpace) return null;
    return languageSettingsStateEvent?.originServerTs ?? creationTime;
  }

  DateTime? get rulesUpdatedAt {
    if (!isSpace) return null;
    return pangeaRoomRulesStateEvent?.originServerTs ?? creationTime;
  }

  Future<bool> get isBotRoom async {
    final List<User> participants = await requestParticipants();
    return participants.any(
      (User user) => user.id == BotName.byEnvironment,
    );
  }

  Future<bool> get isBotDM async =>
      (await isBotRoom) && getParticipants().length == 2;

  BotOptionsModel? get botOptions {
    if (isSpace) return null;
    return BotOptionsModel.fromJson(
      getState(PangeaEventTypes.botOptions)?.content ?? {},
    );
  }

  // add 1 analytics room to 1 space
  Future<void> addAnalyticsRoomToSpace(Room analyticsRoom) async {
    if (!isSpace) {
      debugPrint("addAnalyticsRoomToSpace called on non-space room");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "addAnalyticsRoomToSpace called on non-space room",
        ),
      );
      return Future.value();
    }

    if (spaceChildren.any((sc) => sc.roomId == analyticsRoom.id)) return;
    if (canIAddSpaceChild(null)) {
      try {
        await setSpaceChild(analyticsRoom.id);
      } catch (err) {
        debugPrint(
          "Failed to add analytics room ${analyticsRoom.id} for student to space $id",
        );
        Sentry.addBreadcrumb(
          Breadcrumb(
            message: "Failed to add analytics room to space $id",
          ),
        );
      }
    }
  }

  // Add analytics room to all spaces the user is a student in (1 analytics room to all spaces)
  // So teachers can join them via space hierarchy
  // Will not always work, as there may be spaces where students don't have permission to add chats
  // But allows teachers to join analytics rooms without being invited
  Future<void> addAnalyticsRoomToSpaces() async {
    if (!isAnalyticsRoomOfUser(client.userID!)) {
      debugPrint("addAnalyticsRoomToSpaces called on non-analytics room");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "addAnalyticsRoomToSpaces called on non-analytics room",
        ),
      );
      return;
    }

    for (final Room space in (await client.classesAndExchangesImStudyingIn)) {
      if (space.spaceChildren.any((sc) => sc.roomId == id)) continue;
      await space.addAnalyticsRoomToSpace(this);
    }
  }

  // Add all analytics rooms to space
  // Similar to addAnalyticsRoomToSpaces, but all analytics room to 1 space
  Future<void> addAnalyticsRoomsToSpace() async {
    await postLoad();
    final List<Room> allMyAnalyticsRooms = client.allMyAnalyticsRooms;
    for (final Room analyticsRoom in allMyAnalyticsRooms) {
      await addAnalyticsRoomToSpace(analyticsRoom);
    }
  }

  // invite teachers of 1 space to 1 analytics room
  Future<void> inviteSpaceTeachersToAnalyticsRoom(Room analyticsRoom) async {
    if (!isSpace) {
      debugPrint(
        "inviteSpaceTeachersToAnalyticsRoom called on non-space room",
      );
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              "inviteSpaceTeachersToAnalyticsRoom called on non-space room",
        ),
      );
      return;
    }
    if (!analyticsRoom.participantListComplete) {
      await analyticsRoom.requestParticipants();
    }
    final List<User> participants = analyticsRoom.getParticipants();
    for (final User teacher in (await teachers)) {
      if (!participants.any((p) => p.id == teacher.id)) {
        try {
          await analyticsRoom.invite(teacher.id);
        } catch (err, s) {
          debugPrint(
            "Failed to invite teacher ${teacher.id} to analytics room ${analyticsRoom.id}",
          );
          ErrorHandler.logError(
            e: err,
            m: "Failed to invite teacher ${teacher.id} to analytics room ${analyticsRoom.id}",
            s: s,
          );
        }
      }
    }
  }

  // Invite all teachers to 1 analytics room
  // Handles case when students cannot add analytics room to space
  // So teacher is still able to get analytics data for this student
  Future<void> inviteTeachersToAnalyticsRoom() async {
    if (client.userID == null) {
      debugPrint("inviteTeachersToAnalyticsRoom called with null userId");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "inviteTeachersToAnalyticsRoom called with null userId",
        ),
      );
      return;
    }

    if (!isAnalyticsRoomOfUser(client.userID!)) {
      debugPrint("inviteTeachersToAnalyticsRoom called on non-analytics room");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "inviteTeachersToAnalyticsRoom called on non-analytics room",
        ),
      );
      return;
    }

    for (final Room space in (await client.classesAndExchangesImStudyingIn)) {
      await space.inviteSpaceTeachersToAnalyticsRoom(this);
    }
  }

  // Invite teachers of 1 space to all users' analytics rooms
  Future<void> inviteSpaceTeachersToAnalyticsRooms() async {
    for (final Room analyticsRoom in client.allMyAnalyticsRooms) {
      await inviteSpaceTeachersToAnalyticsRoom(analyticsRoom);
    }
  }

  // Join analytics rooms in space
  // Allows teachers to join analytics rooms without being invited
  Future<void> joinAnalyticsRoomsInSpace() async {
    if (!isSpace) {
      debugPrint("joinAnalyticsRoomsInSpace called on non-space room");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "joinAnalyticsRoomsInSpace called on non-space room",
        ),
      );
      return;
    }

    // added delay because without it power levels don't load and user is not
    // recognized as admin
    await Future.delayed(const Duration(milliseconds: 500));
    await postLoad();

    if (!isRoomAdmin) {
      debugPrint("joinAnalyticsRoomsInSpace called by non-admin");
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "joinAnalyticsRoomsInSpace called by non-admin",
        ),
      );
      return;
    }

    final spaceHierarchy = await client.getSpaceHierarchy(
      id,
      maxDepth: 1,
    );

    final List<String> analyticsRoomIds = spaceHierarchy.rooms
        .where(
          (r) => r.roomType == PangeaRoomTypes.analytics,
        )
        .map((r) => r.roomId)
        .toList();

    for (final String roomID in analyticsRoomIds) {
      try {
        await joinSpaceChild(roomID);
      } catch (err, s) {
        debugPrint("Failed to join analytics room $roomID in space $id");
        ErrorHandler.logError(
          e: err,
          m: "Failed to join analytics room $roomID in space $id",
          s: s,
        );
      }
    }
  }

  Future<void> joinSpaceChild(String roomID) async {
    final Room? child = client.getRoomById(roomID);
    if (child == null) {
      await client.joinRoom(
        roomID,
        serverName: spaceChildren
            .firstWhereOrNull((child) => child.roomId == roomID)
            ?.via,
      );
      if (client.getRoomById(roomID) == null) {
        await client.waitForRoomInSync(roomID, join: true);
      }
      return;
    }

    if (![Membership.invite, Membership.join].contains(child.membership)) {
      final waitForRoom = client.waitForRoomInSync(
        roomID,
        join: true,
      );
      await child.join();
      await waitForRoom;
    }
  }

  // check if analytics room exists for a given language code
  // and if not, create it
  Future<void> ensureAnalyticsRoomExists() async {
    await postLoad();
    if (firstLanguageSettings?.targetLanguage == null) return;
    await client.getMyAnalyticsRoom(firstLanguageSettings!.targetLanguage);
  }

  Future<AnalyticsEvent?> getLastAnalyticsEvent(
    String type,
  ) async {
    final Timeline timeline = await getTimeline();
    int requests = 0;
    Event? lastEvent = timeline.events.firstWhereOrNull(
      (event) => event.type == type,
    );

    while (requests < 10 && timeline.canRequestHistory && lastEvent == null) {
      await timeline.requestHistory();
      lastEvent = timeline.events.firstWhereOrNull(
        (event) => event.type == type,
      );
      requests++;
    }

    if (lastEvent == null) return null;

    switch (type) {
      case PangeaEventTypes.summaryAnalytics:
        return SummaryAnalyticsEvent(event: lastEvent);
      case PangeaEventTypes.construct:
        return ConstructAnalyticsEvent(event: lastEvent);
    }

    return null;
  }

  Future<AnalyticsEvent?> getPrevAnalyticsEvent(
    AnalyticsEvent analyticsEvent,
  ) async {
    if (analyticsEvent.content.prevEventId == null) {
      return null;
    }
    final Event? prevEvent = await getEventById(
      analyticsEvent.content.prevEventId!,
    );
    if (prevEvent == null) return null;

    switch (analyticsEvent.event.type) {
      case PangeaEventTypes.summaryAnalytics:
        return SummaryAnalyticsEvent(event: prevEvent);
      case PangeaEventTypes.construct:
        return ConstructAnalyticsEvent(event: prevEvent);
    }

    return null;
    // } catch (err) {
    //   debugger(when: kDebugMode);
    //   return null;
    // }
  }

  Future<List<AnalyticsEvent>?> getAnalyticsEvents({
    required String type,
    DateTime? since,
  }) async {
    final AnalyticsEvent? mostRecentEvent = await getLastAnalyticsEvent(type);
    if (mostRecentEvent == null) return null;
    final List<AnalyticsEvent> events = [mostRecentEvent];

    bool getAllEvents() =>
        since == null && events.last.content.prevEventId == null;

    bool reachedUpdated() =>
        since != null &&
        (events.last.content.lastUpdated?.isBefore(since) ?? true);

    while (getAllEvents() || !reachedUpdated()) {
      final AnalyticsEvent? prevEvent = await getPrevAnalyticsEvent(
        events.last,
      );
      if (prevEvent == null) break;
      events.add(prevEvent);
    }
    return events;
  }
}
