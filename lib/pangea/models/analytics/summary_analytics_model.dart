import 'dart:convert';

import 'package:fluffychat/pangea/enum/use_type.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/analytics/analytics_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';

class SummaryAnalyticsModel extends AnalyticsModel {
  late List<RecentMessageRecord> _messages;

  SummaryAnalyticsModel({
    required List<RecentMessageRecord> messages,
  }) {
    _messages = messages;
  }

  List<RecentMessageRecord> get messages => _messages;

  static const _messagesKey = "msgs";

  Map<String, dynamic> toJson() => {
        _messagesKey: jsonEncode(_messages.map((e) => e.toJson()).toList()),
      };

  factory SummaryAnalyticsModel.fromJson(json) {
    List<RecentMessageRecord> savedMessages = [];
    try {
      savedMessages = json[_messagesKey] != null
          ? (jsonDecode(json[_messagesKey] ?? "[]") as Iterable)
              .map((e) => RecentMessageRecord.fromJson(e))
              .toList()
              .cast<RecentMessageRecord>()
          : [];
    } catch (err, stack) {
      if (kDebugMode) rethrow;
      ErrorHandler.logError(e: err, s: stack);
    }
    return SummaryAnalyticsModel(
      messages: savedMessages,
    );
  }

  static List<RecentMessageRecord> formatSummaryContent(
    List<PangeaMessageEvent> recentMsgs,
  ) {
    final List<PangeaMessageEvent> filtered = List.from(recentMsgs);
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
}

class RecentMessageRecord {
  String eventId;
  String chatId;
  UseType useType;
  DateTime time;

  RecentMessageRecord({
    required this.eventId,
    required this.chatId,
    required this.useType,
    required this.time,
  });

  factory RecentMessageRecord.fromJson(Map<String, dynamic> json) =>
      RecentMessageRecord(
        eventId: json[_eventIdKey],
        chatId: json[_chatIdKey],
        useType: _typeStringToEnum(json[_typeOfUseKey]),
        time: DateTime.parse(json[_timeKey]),
      );

  Map<String, dynamic> toJson() => {
        _eventIdKey: eventId,
        _chatIdKey: chatId,
        _typeOfUseKey: _typeEnumToString(useType),
        _timeKey: time.toIso8601String(),
      };

  String _typeEnumToString(dynamic status) => status.toString().split('.').last;

  static UseType _typeStringToEnum(String useType) {
    final String lastPart = useType.toString().split('.').last;
    switch (lastPart) {
      case 'ta':
        return UseType.ta;
      case 'ga':
        return UseType.ga;
      case 'wa':
        return UseType.wa;
      default:
        return UseType.un;
    }
  }

  static const _eventIdKey = "m.id";
  static const _chatIdKey = "c.id";
  static const _typeOfUseKey = "typ";
  static const _timeKey = "t";
}
