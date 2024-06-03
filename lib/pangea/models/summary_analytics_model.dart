import 'dart:convert';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/models/analytics_model.dart';
import 'package:fluffychat/pangea/models/student_analytics_summary_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';

class SummaryAnalyticsModel extends AnalyticsModel {
  late List<RecentMessageRecord> _messages;

  SummaryAnalyticsModel({
    required List<RecentMessageRecord> messages,
    super.lastUpdated,
    super.prevEventId,
    super.prevLastUpdated,
  }) {
    _messages = messages;
  }

  List<RecentMessageRecord> get messages => _messages;

  static const _messagesKey = "msgs";
  static const _lastUpdatedKey = "lupt";

  Map<String, dynamic> toJson() => {
        _messagesKey: jsonEncode(_messages.map((e) => e.toJson()).toList()),
        _lastUpdatedKey: lastUpdated?.toIso8601String(),
        ModelKey.prevEventId: prevEventId,
        ModelKey.prevLastUpdated: prevLastUpdated?.toIso8601String(),
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
      lastUpdated: json[_lastUpdatedKey] != null
          ? DateTime.parse(json[_lastUpdatedKey])
          : null,
      prevEventId: json[ModelKey.prevEventId],
      prevLastUpdated: json[ModelKey.prevLastUpdated] != null
          ? DateTime.parse(json[ModelKey.prevLastUpdated])
          : null,
    );
  }
}
