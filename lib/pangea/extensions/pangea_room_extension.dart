import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/src/utils/space_child.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../config/app_config.dart';
import '../constants/pangea_event_types.dart';
import '../enum/construct_type_enum.dart';
import '../enum/use_type.dart';
import '../models/choreo_record.dart';
import '../models/construct_analytics_event.dart';
import '../models/constructs_analytics_model.dart';
import '../models/message_data_models.dart';
import '../models/student_analytics_event.dart';
import '../models/student_analytics_summary_model.dart';
import '../utils/p_store.dart';
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

  bool isFirstOrSecondChild(String roomId) =>
      isSpace && spaceChildren.any((room) => room.roomId == roomId) ||
      spaceChildren
          .where(
            (sc) => sc.roomId != null,
          )
          .map(
            (sc) => client.getRoomById(sc.roomId!),
          )
          .any(
            (room) =>
                room != null &&
                room.spaceChildren.any((room) => room.roomId == roomId),
          );

  //note this only will return rooms that the user has joined or been invited to
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

  bool isMadeForLang(String langCode) =>
      getState(EventTypes.RoomCreate)
          ?.content
          .tryGet<String>(ModelKey.langCode) ==
      langCode;

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

  StudentAnalyticsEvent? _getStudentAnalyticsLocal(String studentId) {
    if (!isSpace) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "calling getStudentAnalyticsLocal on non-space room",
        s: StackTrace.current,
      );
      return null;
    }

    final Event? matrixEvent = getState(
      PangeaEventTypes.studentAnalyticsSummary,
      studentId,
    );

    return matrixEvent != null
        ? StudentAnalyticsEvent(event: matrixEvent)
        : null;
  }

  Future<StudentAnalyticsEvent?> getStudentAnalytics(
    String studentId, {
    bool forcedUpdate = false,
  }) async {
    try {
      debugPrint("getStudentAnalytics $studentId");
      if (!isSpace) {
        debugger(when: kDebugMode);
        throw Exception("calling getStudentAnalyticsLocal on non-space room");
      }
      StudentAnalyticsEvent? localEvent = _getStudentAnalyticsLocal(studentId);

      if (localEvent == null) {
        await postLoad();
        localEvent = _getStudentAnalyticsLocal(studentId);
      }

      if (studentId == client.userID && localEvent == null) {
        final Event? matrixEvent = await _createStudentAnalyticsEvent();
        if (matrixEvent != null) {
          localEvent = StudentAnalyticsEvent(event: matrixEvent);
        }
      }

      return localEvent;
    } catch (err) {
      debugger(when: kDebugMode);
      rethrow;
    }
  }

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

  /// if [studentIds] is null, returns all students
  Future<List<StudentAnalyticsEvent?>> getClassAnalytics([
    List<String>? studentIds,
  ]) async {
    await postLoad();
    await requestParticipants();
    final List<Future<StudentAnalyticsEvent?>> sassFutures = [];
    final List<String> filteredIds = students
        .where(
          (element) => studentIds == null || studentIds.contains(element.id),
        )
        .map((e) => e.id)
        .toList();
    for (final id in filteredIds) {
      sassFutures.add(
        getStudentAnalytics(
          id,
        ),
      );
    }
    return Future.wait(sassFutures);
  }

  ///   if [isSpace]
  ///     for all child chats, call _getChatAnalyticsGlobal and merge results
  ///   else
  ///     get analytics from pangea chat server
  ///     do any needed conversion work
  ///   save RoomAnalytics object to PangeaEventTypes.analyticsSummary event
  Future<Event?> _createStudentAnalyticsEvent() async {
    try {
      if (!pangeaCanSendEvent(PangeaEventTypes.studentAnalyticsSummary)) {
        ErrorHandler.logError(
          m: "null powerLevels in createStudentAnalytics",
          s: StackTrace.current,
        );
        return null;
      }
      if (client.userID == null) {
        debugger(when: kDebugMode);
        throw Exception("null userId in createStudentAnalytics");
      }
      await postLoad();
      final String eventId = await client.setRoomStateWithKey(
        id,
        PangeaEventTypes.studentAnalyticsSummary,
        client.userID!,
        StudentAnalyticsSummary(
          // studentId: client.userID!,
          lastUpdated: DateTime.now(),
          messages: [],
        ).toJson(),
      );
      final Event? event = await getEventById(eventId);

      if (event == null) {
        debugger(when: kDebugMode);
        throw Exception(
          "null event after creation with eventId $eventId in createStudentAnalytics",
        );
      }
      return event;
    } catch (err, stack) {
      ErrorHandler.logError(e: err, s: stack, data: powerLevels);
      return null;
    }
  }

  ///   for each chat in class
  ///     get timeline back to january 15
  ///     get messages
  ///     discard timeline
  ///   save messages to StudentAnalyticsSummary
  Future<void> updateMyLearningAnalyticsForClass([
    PLocalStore? storageService,
  ]) async {
    try {
      final String migratedAnalyticsKey =
          "MIGRATED_ANALYTICS_KEY${id.localpart}";

      if (storageService?.read(migratedAnalyticsKey) ?? false) return;

      if (!isPangeaClass) {
        throw Exception(
          "In updateMyLearningAnalyticsForClass with room that is not not a class",
        );
      }

      if (client.userID == null) {
        debugger(when: kDebugMode);
        return;
      }

      final StudentAnalyticsEvent? myAnalEvent =
          await getStudentAnalytics(client.userID!);

      if (myAnalEvent == null) {
        debugPrint("null analytcs event for $id");
        if (pangeaCanSendEvent(PangeaEventTypes.studentAnalyticsSummary)) {
          // debugger(when: kDebugMode);
        }
        return;
      }

      myAnalEvent.bulkUpdate(await _messageListForAllChildChats);

      storageService?.save(migratedAnalyticsKey, true);
    } catch (err, s) {
      if (kDebugMode) rethrow;
      // debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
    }
  }

  Future<List<RecentMessageRecord>> get _messageListForAllChildChats async {
    try {
      if (!isSpace) return [];
      final List<Room> spaceChats = spaceChildren
          .where((e) => e.roomId != null)
          .map((e) => client.getRoomById(e.roomId!))
          .where((element) => element != null)
          .cast<Room>()
          .where((element) => !element.isSpace)
          .toList();

      if (spaceChildren.length != spaceChats.length) {
        // debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "spaceChildren.length > chats.length in updateMyLearningAnalyticsForClass",
        );
      }

      final List<Future<List<RecentMessageRecord>>> msgListFutures = [];
      for (final chat in spaceChats) {
        msgListFutures.add(chat._messageListForChat);
      }
      final List<List<RecentMessageRecord>> msgLists =
          await Future.wait(msgListFutures);

      final List<RecentMessageRecord> joined = [];
      for (final msgList in msgLists) {
        joined.addAll(msgList);
      }
      return joined;
    } catch (err) {
      // debugger(when: kDebugMode);
      rethrow;
    }
  }

  Future<List<RecentMessageRecord>> get _messageListForChat async {
    try {
      int numberOfSearches = 0;

      if (isSpace) {
        throw Exception(
          "In messageListForChat with room that is not a chat",
        );
      }
      final Timeline timeline = await getTimeline();

      while (timeline.canRequestHistory && numberOfSearches < 50) {
        await timeline.requestHistory(historyCount: 100);
        numberOfSearches += 1;
      }
      if (timeline.canRequestHistory) {
        debugger(when: kDebugMode);
      }

      final List<RecentMessageRecord> msgs = [];
      for (final event in timeline.events) {
        if (event.senderId == client.userID &&
            event.type == EventTypes.Message) {
          if (event.content['msgtype'] == MessageTypes.Text) {
            final PangeaMessageEvent pMsgEvent = PangeaMessageEvent(
              event: event,
              timeline: timeline,
              ownMessage: true,
              selected: false,
            );
            msgs.add(
              RecentMessageRecord(
                eventId: event.eventId,
                chatId: id,
                useType: pMsgEvent.useType,
                time: event.originServerTs,
              ),
            );
          } else {
            debugger(when: kDebugMode);
          }
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
      }

      //PTODO - handle the frequent case of a null newEventId
      final Event? newEvent = await getEventById(newEventId!);

      if (newEvent == null) {
        debugger(when: kDebugMode);
      }

      return newEvent;
    } catch (err, stack) {
      debugger(when: kDebugMode);
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

  ConstructEvent? _vocabEventLocal(String lemma) {
    if (!isAnalyticsRoom) throw Exception("not an analytics room");

    final Event? matrixEvent = getState(PangeaEventTypes.vocab, lemma);

    return matrixEvent != null ? ConstructEvent(event: matrixEvent) : null;
  }

  bool get isRoomOwner =>
      getState(EventTypes.RoomCreate)?.senderId == client.userID;

  Future<ConstructEvent> vocabEvent(
    String lemma,
    ConstructType type, [
    bool makeIfNull = false,
  ]) async {
    try {
      if (!isAnalyticsRoom) throw Exception("not an analytics room");

      ConstructEvent? localEvent = _vocabEventLocal(lemma);

      if (localEvent != null) return localEvent;

      await postLoad();
      localEvent = _vocabEventLocal(lemma);

      if (localEvent == null && isRoomOwner && makeIfNull) {
        final Event matrixEvent = await _createVocabEvent(lemma, type);
        localEvent = ConstructEvent(event: matrixEvent);
      }

      return localEvent!;
    } catch (err) {
      debugger(when: kDebugMode);
      rethrow;
    }
  }

  Future<void> saveConstructUsesSameLemma(
    String lemma,
    ConstructType type,
    List<OneConstructUse> lemmaUses,
  ) async {
    final ConstructEvent? localEvent = _vocabEventLocal(lemma);

    if (localEvent == null) {
      final json =
          ConstructUses(lemma: lemma, type: type, uses: lemmaUses).toJson();
      await client.setRoomStateWithKey(
        id,
        PangeaEventTypes.vocab,
        lemma,
        ConstructUses(lemma: lemma, type: type, uses: lemmaUses).toJson(),
      );
    } else {
      localEvent.addAll(lemmaUses);
      await updateStateEvent(localEvent.event);
    }
  }

  Future<List<ConstructEvent>> get allConstructEvents async {
    await postLoad();

    return states[PangeaEventTypes.vocab]
            ?.values
            .map((Event event) => ConstructEvent(event: event))
            .toList()
            .cast<ConstructEvent>() ??
        [];
  }

  Future<Event> _createVocabEvent(String lemma, ConstructType type) async {
    try {
      if (!isRoomOwner) {
        throw Exception(
          "Tried to create vocab event in room where user is not owner",
        );
      }
      final String eventId = await client.setRoomStateWithKey(
        id,
        PangeaEventTypes.vocab,
        lemma,
        ConstructUses(lemma: lemma, type: type).toJson(),
      );
      final Event? event = await getEventById(eventId);

      if (event == null) {
        debugger(when: kDebugMode);
        throw Exception(
          "null event after creation with eventId $eventId in _createVocabEvent",
        );
      }
      return event;
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack, data: powerLevels);
      rethrow;
    }
  }

  Future<void> makeSureTeachersAreInvitedToAnalyticsRoom() async {
    try {
      if (!isAnalyticsRoom) {
        throw Exception("not an analytics room");
      }
      if (!participantListComplete) {
        await requestParticipants();
      }
      final toAdd = [
        ...getParticipants([Membership.invite, Membership.join])
            .map((e) => e.id),
        BotName.byEnvironment,
      ];
      for (final teacher in await client.myTeachers) {
        if (!toAdd.contains(teacher.id)) {
          debugPrint("inviting ${teacher.id} to analytics room");
          await invite(teacher.id);
        }
      }
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack);
    }
  }

  /// update state event and return eventId
  Future<String> updateStateEvent(Event stateEvent) {
    return client.setRoomStateWithKey(
      id,
      stateEvent.type,
      stateEvent.stateKey!,
      stateEvent.content,
    );
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
      final currentPower = getState(EventTypes.RoomPowerLevels);
      final Map<String, dynamic>? currentPowerContent =
          currentPower!.content["events"] as Map<String, dynamic>?;
      final spaceChildPower = currentPowerContent?[EventTypes.spaceChild];
      final studentAnalyticsPower =
          currentPowerContent?[PangeaEventTypes.studentAnalyticsSummary];

      if (spaceChildPower == null || studentAnalyticsPower == null) {
        currentPowerContent!["events"][EventTypes.spaceChild] = 0;
        currentPowerContent["events"]
            [PangeaEventTypes.studentAnalyticsSummary] = 0;

        await client.setRoomStateWithKey(
          id,
          EventTypes.RoomPowerLevels,
          currentPower.stateKey ?? "",
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
    bool parseMarkdown = false,
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
    // if (parseMarkdown) {
    //   final html = markdown(event['body'],
    //       getEmotePacks: () => getImagePacksFlat(ImagePackUsage.emoticon),
    //       getMention: getMention);
    //   // if the decoded html is the same as the body, there is no need in sending a formatted message
    //   if (HtmlUnescape().convert(html.replaceAll(RegExp(r'<br />\n?'), '\n')) !=
    //       event['body']) {
    //     event['format'] = 'org.matrix.custom.html';
    //     event['formatted_body'] = html;
    //   }
    // }
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

  bool? get locked {
    if (isDirectChat) return false;
    if (!isSpace) {
      if (eventsDefaultPowerLevel == null) return null;
      return eventsDefaultPowerLevel! >= ClassDefaultValues.powerLevelOfAdmin;
    }
    for (final child in spaceChildren) {
      if (child.roomId == null) continue;
      final Room? room = client.getRoomById(child.roomId!);
      if (room?.locked == false && (room?.canChangePowerLevel ?? false)) {
        return false;
      }
    }
    return true;
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
}
