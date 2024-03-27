import 'dart:convert';

import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../enum/use_type.dart';

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

class StudentAnalyticsSummary {
  late List<RecentMessageRecord> _messages;
  DateTime lastUpdated;

  StudentAnalyticsSummary({
    required List<RecentMessageRecord> messages,
    required this.lastUpdated,
  }) {
    _messages = messages;
  }

  void addAll(List<RecentMessageRecord> msgs) {
    for (final msg in msgs) {
      if (_messages.any((element) => element.eventId == msg.eventId)) {
        ErrorHandler.logError(
          m: "adding message twice in StudentAnalyticsSummary.add",
        );
      } else {
        _messages.add(msg);
      }
    }
  }

  void removeEdittedMessages(Client client, List<String> removeEventIds) {
    _messages.removeWhere(
      (element) => removeEventIds.contains(element.eventId),
    );
  }

  List<RecentMessageRecord> get messages => _messages;

  static const _messagesKey = "msgs";
  static const _lastUpdatedKey = "lupt";

  Map<String, dynamic> toJson() => {
        _messagesKey: jsonEncode(_messages.map((e) => e.toJson()).toList()),
        _lastUpdatedKey: lastUpdated.toIso8601String(),
      };

  factory StudentAnalyticsSummary.fromJson(json) {
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
    return StudentAnalyticsSummary(
      messages: savedMessages,
      lastUpdated: DateTime.parse(json[_lastUpdatedKey]),
    );
  }
}
