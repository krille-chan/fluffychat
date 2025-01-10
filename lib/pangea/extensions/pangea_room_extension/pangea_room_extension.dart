// ignore_for_file: implementation_imports, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:matrix/matrix.dart' as matrix;
import 'package:matrix/matrix.dart';
import 'package:matrix/src/utils/markdown.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/constants/bot_mode.dart';
import 'package:fluffychat/pangea/constants/class_code_constants.dart';
import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../config/app_config.dart';
import '../../constants/pangea_event_types.dart';
import '../../models/choreo_record.dart';
import '../../models/representation_content_model.dart';

part "room_analytics_extension.dart";
part "room_children_and_parents_extension.dart";
part "room_events_extension.dart";
part "room_information_extension.dart";
part "room_settings_extension.dart";
part "room_space_settings_extension.dart";
part "room_user_permissions_extension.dart";

extension PangeaRoom on Room {
// analytics

  Future<void> joinAnalyticsRooms() async => await _joinAnalyticsRooms();

  Future<DateTime?> analyticsLastUpdated(String userId) async {
    return await _analyticsLastUpdated(userId);
  }

  Future<List<ConstructAnalyticsEvent>?> getAnalyticsEvents({
    required String userId,
    DateTime? since,
  }) async =>
      await _getAnalyticsEvents(since: since, userId: userId);

  String? get madeForLang => _madeForLang;

  bool isMadeForLang(String langCode) => _isMadeForLang(langCode);

  /// Sends construct events to the server.
  ///
  /// The [uses] parameter is a list of [OneConstructUse] objects representing the
  /// constructs to be sent. To prevent hitting the maximum event size, the events
  /// are chunked into smaller lists. Each chunk is sent as a separate event.
  Future<void> sendConstructsEvent(
    List<OneConstructUse> uses,
  ) async =>
      await _sendConstructsEvent(uses);

  // children_and_parents

  List<Room> get joinedChildren => _joinedChildren;

  List<String> get joinedChildrenRoomIds => _joinedChildrenRoomIds;

  Future<List<Room>> getChildRooms() async => await _getChildRooms();

  Future<void> joinSpaceChild(String roomID) async =>
      await _joinSpaceChild(roomID);

  Room? firstParentWithState(String stateType) =>
      _firstParentWithState(stateType);

  List<Room> get pangeaSpaceParents => _pangeaSpaceParents;

  String nameIncludingParents(BuildContext context) =>
      _nameIncludingParents(context);

  Future<void> pangeaSetSpaceChild(
    String roomId, {
    bool? suggested,
  }) async =>
      await _pangeaSetSpaceChild(roomId, suggested: suggested);

  /// Returns a map of child suggestion status for a space.
  ///
  /// If the current object is not a space, an empty map is returned.
  /// Otherwise, it iterates through each child in the `spaceChildren` list
  /// and adds their suggestion status to the `suggestionStatus` map.
  /// The suggestion status is determined by the `suggested` property of each child.
  /// If the `suggested` property is `null`, it defaults to `true`.
  Map<String, bool> get spaceChildSuggestionStatus =>
      _spaceChildSuggestionStatus;

  /// Checks if this space has a parent space
  bool get isSubspace => _isSubspace;

// class_and_exchange_settings

  DateTime? get rulesUpdatedAt => _rulesUpdatedAt;

  String get classCode => _classCode;

  void checkClass() => _checkClass();

  List<User> get students => _students;

  Future<List<User>> get teachers async => await _teachers;

  /// Synchronous version of teachers getter. Does not request
  /// participants, so this list may not be complete.
  List<User> get teachersLocal => _teachersLocal;

  /// If the user is an admin of this space, and the space's
  /// m.space.child power level hasn't yet been set, so it to 0
  Future<void> setClassPowerLevels() async => await _setClassPowerLevels();

  Event? get pangeaRoomRulesStateEvent => _pangeaRoomRulesStateEvent;

// events

  Future<bool> leaveIfFull() async => await _leaveIfFull();
  Future<void> archive() async => await _archive();

  Future<bool> archiveSpace(
    BuildContext context,
    Client client, {
    bool onlyAdmin = false,
  }) async =>
      await _archiveSpace(context, client, onlyAdmin: onlyAdmin);

  Future<void> archiveSubspace() async => await _archiveSubspace();

  Future<bool> leaveSpace(BuildContext context, Client client) async =>
      await _leaveSpace(context, client);

  Future<void> leaveSubspace() async => await _leaveSubspace();

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
      );

  Future<String> updateStateEvent(Event stateEvent) =>
      _updateStateEvent(stateEvent);

// room_information

  Future<int> get numNonAdmins async => await _numNonAdmins;

  DateTime? get creationTime => _creationTime;

  String? get creatorId => _creatorId;

  String get domainString => _domainString;

  bool isChild(String roomId) => _isChild(roomId);

  bool isFirstOrSecondChild(String roomId) => _isFirstOrSecondChild(roomId);

  bool get isDirectChatWithoutMe => _isDirectChatWithoutMe;

  // bool isMadeForLang(String langCode) => _isMadeForLang(langCode);

  Future<bool> get botIsInRoom async => await _botIsInRoom;

  Future<bool> get isBotDM async => await _isBotDM;

  // bool get isLocked => _isLocked;

  bool isAnalyticsRoomOfUser(String userId) => _isAnalyticsRoomOfUser(userId);

  bool get isAnalyticsRoom => _isAnalyticsRoom;

// room_settings

  Future<void> updateRoomCapacity(int newCapacity) =>
      _updateRoomCapacity(newCapacity);

  int? get capacity => _capacity;

  PangeaRoomRules? get pangeaRoomRules => _pangeaRoomRules;

  PangeaRoomRules? get firstRules => _firstRules;

  IconData? get roomTypeIcon => _roomTypeIcon;

  Text nameAndRoomTypeIcon([TextStyle? textStyle]) =>
      _nameAndRoomTypeIcon(textStyle);

  BotOptionsModel? get botOptions => _botOptions;

  Future<void> setSuggested(bool suggested) async =>
      await _setSuggested(suggested);

  Future<bool> isSuggested() async => await _isSuggested();

// user_permissions

  Future<bool> isOnlyAdmin() async => await _isOnlyAdmin();

  bool isMadeByUser(String userId) => _isMadeByUser(userId);

  bool get isSpaceAdmin => _isSpaceAdmin;

  bool isUserRoomAdmin(String userId) => _isUserRoomAdmin(userId);

  bool isUserSpaceAdmin(String userId) => _isUserSpaceAdmin(userId);

  bool get isRoomOwner => _isRoomOwner;

  bool get isRoomAdmin => _isRoomAdmin;

  bool get showClassEditOptions => _showClassEditOptions;

  bool get canDelete => _canDelete;

  bool get canIAddSpaceParents => _canIAddSpaceParents;

  bool pangeaCanSendEvent(String eventType) => _pangeaCanSendEvent(eventType);

  int? get eventsDefaultPowerLevel => _eventsDefaultPowerLevel;
}
