// ignore_for_file: implementation_imports, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:matrix/matrix.dart' as matrix;
import 'package:matrix/matrix.dart';
import 'package:matrix/src/utils/markdown.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/constructs_event.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/constants/bot_mode.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/pangea/spaces/models/space_model.dart';
import '../choreographer/models/choreo_record.dart';
import '../events/constants/pangea_event_types.dart';
import '../events/models/representation_content_model.dart';

part "../analytics_misc/room_analytics_extension.dart";
part "room_children_and_parents_extension.dart";
part "room_events_extension.dart";
part "room_information_extension.dart";
part "room_settings_extension.dart";
part "room_space_settings_extension.dart";
part "room_user_permissions_extension.dart";

extension PangeaRoom on Room {
// analytics

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

  Future<List<Room>> getChildRooms() async => await _getChildRooms();

  Room? firstParentWithState(String stateType) =>
      _firstParentWithState(stateType);

  List<Room> get pangeaSpaceParents => _pangeaSpaceParents;

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

// class_and_exchange_settings

  String classCode(BuildContext context) => _classCode(context);

  void checkClass() => _checkClass();

  Future<List<User>> get teachers async => await _teachers;

  Event? get pangeaRoomRulesStateEvent => _pangeaRoomRulesStateEvent;

// events

  Future<bool> leaveIfFull() async => await _leaveIfFull();

  Future<void> leaveSpace() async => await _leaveSpace();

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
    String? messageTag,
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
        messageTag: messageTag,
      );

  String sendFakeMessage({
    required String text,
    Event? inReplyTo,
    String? editEventId,
  }) =>
      _sendFakeMessage(
        text: text,
        inReplyTo: inReplyTo,
        editEventId: editEventId,
      );

// room_information

  Future<int> get numNonAdmins async => await _numNonAdmins;

  DateTime? get creationTime => _creationTime;

  String? get creatorId => _creatorId;

  bool isFirstOrSecondChild(String roomId) => _isFirstOrSecondChild(roomId);

  // bool isMadeForLang(String langCode) => _isMadeForLang(langCode);

  Future<bool> get botIsInRoom async => await _botIsInRoom;

  bool get isBotDM => _isBotDM;

  // bool get isLocked => _isLocked;

  bool isAnalyticsRoomOfUser(String userId) => _isAnalyticsRoomOfUser(userId);

  bool get isAnalyticsRoom => _isAnalyticsRoom;

// room_settings

  Future<void> updateRoomCapacity(int newCapacity) =>
      _updateRoomCapacity(newCapacity);

  int? get capacity => _capacity;

  PangeaRoomRules? get pangeaRoomRules => _pangeaRoomRules;

  IconData? get roomTypeIcon => _roomTypeIcon;

  Text nameAndRoomTypeIcon([TextStyle? textStyle]) =>
      _nameAndRoomTypeIcon(textStyle);

  BotOptionsModel? get botOptions => _botOptions;

// user_permissions

  Future<bool> isOnlyAdmin() async => await _isOnlyAdmin();

  bool isMadeByUser(String userId) => _isMadeByUser(userId);

  bool get isSpaceAdmin => _isSpaceAdmin;

  bool isUserRoomAdmin(String userId) => _isUserRoomAdmin(userId);

  bool get isRoomAdmin => _isRoomAdmin;

  bool pangeaCanSendEvent(String eventType) => _pangeaCanSendEvent(eventType);
}
