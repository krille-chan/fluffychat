import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/class_code.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
// import markdown.dart
import 'package:html_unescape/html_unescape.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/src/utils/markdown.dart';
import 'package:matrix/src/utils/space_child.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../config/app_config.dart';
import '../../constants/pangea_event_types.dart';
import '../../enum/construct_type_enum.dart';
import '../../enum/use_type.dart';
import '../../matrix_event_wrappers/construct_analytics_event.dart';
import '../../models/choreo_record.dart';
import '../../models/constructs_analytics_model.dart';
import '../../models/representation_content_model.dart';
import '../../models/student_analytics_event.dart';
import '../../models/student_analytics_summary_model.dart';
import '../../utils/p_store.dart';
import '../client_extension/client_extension.dart';

part "children_and_parents_extension.dart";
part "class_and_exchange_settings_extension.dart";
part "events_extension.dart";
part "room_analytics_extension.dart";
part "room_information_extension.dart";
part "room_settings_extension.dart";
part "user_permissions_extension.dart";

extension PangeaRoom on Room {
// analytics

  Future<void> joinAnalyticsRoomsInSpace() async =>
      await _joinAnalyticsRoomsInSpace();

  Future<void> ensureAnalyticsRoomExists() async =>
      await _ensureAnalyticsRoomExists();

  Future<void> addAnalyticsRoomToSpace(Room analyticsRoom) async =>
      await _addAnalyticsRoomToSpace(analyticsRoom);

  Future<void> addAnalyticsRoomToSpaces() async =>
      await _addAnalyticsRoomToSpaces();

  Future<void> addAnalyticsRoomsToSpace() async =>
      await _addAnalyticsRoomsToSpace();

  Future<StudentAnalyticsEvent?> getStudentAnalytics(
    String studentId, {
    bool forcedUpdate = false,
  }) async =>
      await _getStudentAnalytics(studentId, forcedUpdate: forcedUpdate);

  Future<List<StudentAnalyticsEvent?>> getClassAnalytics([
    List<String>? studentIds,
  ]) async =>
      await _getClassAnalytics(
        studentIds,
      );

  Future<void> updateMyLearningAnalyticsForClass([
    PLocalStore? storageService,
  ]) async =>
      await _updateMyLearningAnalyticsForClass(
        storageService,
      );

  Future<void> inviteSpaceTeachersToAnalyticsRoom(Room analyticsRoom) async =>
      await _inviteSpaceTeachersToAnalyticsRoom(analyticsRoom);

  Future<void> inviteTeachersToAnalyticsRoom() async =>
      await _inviteTeachersToAnalyticsRoom();

  // Invite teachers of 1 space to all users' analytics rooms
  Future<void> inviteSpaceTeachersToAnalyticsRooms() async =>
      await _inviteSpaceTeachersToAnalyticsRooms();

  // children_and_parents

  List<Room> get joinedChildren => _joinedChildren;

  List<String> get joinedChildrenRoomIds => _joinedChildrenRoomIds;

  List<SpaceChild> get childrenAndGrandChildren => _childrenAndGrandChildren;

  List<String> get childrenAndGrandChildrenDirectChatIds =>
      _childrenAndGrandChildrenDirectChatIds;

  Future<List<Room>> getChildRooms() async => await _getChildRooms();

  Future<void> joinSpaceChild(String roomID) async =>
      await _joinSpaceChild(roomID);

  Room? firstParentWithState(String stateType) =>
      _firstParentWithState(stateType);

  List<Room> get immediateClassParents => _immediateClassParents;

  List<Room> get pangeaSpaceParents => _pangeaSpaceParents;

// class_and_exchange_settings

  DateTime? get rulesUpdatedAt => _rulesUpdatedAt;

  String get classCode => _classCode;

  void checkClass() => _checkClass();

  List<User> get students => _students;

  Future<List<User>> get teachers async => await _teachers;

  Future<void> setClassPowerLevels() async => await _setClassPowerLevels();

  DateTime? get classSettingsUpdatedAt => _classSettingsUpdatedAt;

  ClassSettingsModel? get classSettings => _classSettings;

  Event? get languageSettingsStateEvent => _languageSettingsStateEvent;

  Event? get pangeaRoomRulesStateEvent => _pangeaRoomRulesStateEvent;

  ClassSettingsModel? get firstLanguageSettings => _firstLanguageSettings;

// events

  Future<bool> leaveIfFull(BuildContext context) async =>
      await _leaveIfFull(context);

  Future<Event?> sendPangeaEvent({
    required Map<String, dynamic> content,
    required String parentEventId,
    required String type,
  }) async =>
      await _sendPangeaEvent(
        content: content,
        parentEventId: parentEventId,
        type: type,
      );

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
  }) =>
      _pangeaSendTextEvent(
        message,
        txid: txid,
        inReplyTo: inReplyTo,
        editEventId: editEventId,
        parseMarkdown: parseMarkdown,
        parseCommands: parseCommands,
        msgtype: msgtype,
        threadRootEventId: threadRootEventId,
        threadLastEventId: threadLastEventId,
        originalSent: originalSent,
        originalWritten: originalWritten,
        tokensSent: tokensSent,
        tokensWritten: tokensWritten,
        choreo: choreo,
        useType: useType,
      );

  Future<String> updateStateEvent(Event stateEvent) =>
      _updateStateEvent(stateEvent);

  Future<ConstructEvent> vocabEvent(
    String lemma,
    ConstructType type, [
    bool makeIfNull = false,
  ]) =>
      _vocabEvent(lemma, type, makeIfNull);

  Future<List<OneConstructUse>> removeEditedLemmas(
    List<OneConstructUse> lemmaUses,
  ) async =>
      await _removeEditedLemmas(lemmaUses);

  Future<void> saveConstructUsesSameLemma(
    String lemma,
    ConstructType type,
    List<OneConstructUse> lemmaUses, {
    bool isEdit = false,
  }) async =>
      await _saveConstructUsesSameLemma(lemma, type, lemmaUses, isEdit: isEdit);

  Future<List<ConstructEvent>> get allConstructEvents async =>
      await _allConstructEvents;

// room_information

  Future<int> get numNonAdmins async => await _numNonAdmins;

  DateTime? get creationTime => _creationTime;

  String? get creatorId => _creatorId;

  String get domainString => _domainString;

  bool isChild(String roomId) => _isChild(roomId);

  bool isFirstOrSecondChild(String roomId) => _isFirstOrSecondChild(roomId);

  bool get isExchange => _isExchange;

  bool get isDirectChatWithoutMe => _isDirectChatWithoutMe;

  bool isMadeForLang(String langCode) => _isMadeForLang(langCode);

  Future<bool> get isBotRoom async => await _isBotRoom;

  Future<bool> get isBotDM async => await _isBotDM;

  bool get isLocked => _isLocked;

  bool get isPangeaClass => _isPangeaClass;

  bool isAnalyticsRoomOfUser(String userId) => _isAnalyticsRoomOfUser(userId);

  bool get isAnalyticsRoom => _isAnalyticsRoom;

// room_settings

  Future<String> updateRoomCapacity(String newCapacity) =>
      _updateRoomCapacity(newCapacity);

  String? get capacity => _capacity;

  PangeaRoomRules? get pangeaRoomRules => _pangeaRoomRules;

  PangeaRoomRules? get firstRules => _firstRules;

  IconData? get roomTypeIcon => _roomTypeIcon;

  Text nameAndRoomTypeIcon([TextStyle? textStyle]) =>
      _nameAndRoomTypeIcon(textStyle);

  BotOptionsModel? get botOptions => _botOptions;

  Future<bool> suggestedInSpace(Room space) async =>
      await _suggestedInSpace(space);

  Future<void> setSuggestedInSpace(bool suggest, Room space) async =>
      await _setSuggestedInSpace(suggest, space);

// user_permissions

  bool isMadeByUser(String userId) => _isMadeByUser(userId);

  bool get isSpaceAdmin => _isSpaceAdmin;

  bool isUserRoomAdmin(String userId) => _isUserRoomAdmin(userId);

  bool isUserSpaceAdmin(String userId) => _isUserSpaceAdmin(userId);

  bool get isRoomOwner => _isRoomOwner;

  bool get isRoomAdmin => _isRoomAdmin;

  bool get showClassEditOptions => _showClassEditOptions;

  bool get canDelete => _canDelete;

  bool canIAddSpaceChild(Room? room) => _canIAddSpaceChild(room);

  bool get canIAddSpaceParents => _canIAddSpaceParents;

  bool pangeaCanSendEvent(String eventType) => _pangeaCanSendEvent(eventType);

  int? get eventsDefaultPowerLevel => _eventsDefaultPowerLevel;
}
