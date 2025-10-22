import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/choreographer/enums/span_data_type.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import '../constants/match_rule_ids.dart';
import 'span_data.dart';

enum PangeaMatchStatus {
  open,
  ignored,
  accepted,
  automatic,
  unknown;

  static PangeaMatchStatus fromString(String status) {
    final String lastPart = status.toString().split('.').last;
    switch (lastPart) {
      case 'open':
        return PangeaMatchStatus.open;
      case 'ignored':
        return PangeaMatchStatus.ignored;
      case 'accepted':
        return PangeaMatchStatus.accepted;
      case 'automatic':
        return PangeaMatchStatus.automatic;
      default:
        return PangeaMatchStatus.unknown;
    }
  }
}

class PangeaMatch {
  SpanData match;
  PangeaMatchStatus status;

  PangeaMatch({
    required this.match,
    required this.status,
  });

  factory PangeaMatch.fromJson(Map<String, dynamic> json) {
    return PangeaMatch(
      match: SpanData.fromJson(json[_matchKey] as Map<String, dynamic>),
      status: json[_statusKey] != null
          ? PangeaMatchStatus.fromString(json[_statusKey] as String)
          : PangeaMatchStatus.open,
    );
  }

  Map<String, dynamic> toJson() => {
        _matchKey: match.toJson(),
        _statusKey: status.name,
      };

  static const _matchKey = "match";
  static const _statusKey = "status";

  bool get isITStart =>
      match.rule?.id == MatchRuleIds.interactiveTranslation ||
      [SpanDataTypeEnum.itStart, SpanDataTypeEnum.itStart.name]
          .contains(match.type.typeName);

  bool get needsTranslation => match.rule?.id != null
      ? [
          MatchRuleIds.tokenNeedsTranslation,
          MatchRuleIds.tokenSpanNeedsTranslation,
        ].contains(match.rule!.id)
      : false;

  bool get isOutOfTargetMatch => isITStart || needsTranslation;

  bool get isGrammarMatch => !isOutOfTargetMatch;

  String get matchContent {
    late int beginning;
    late int end;
    if (match.offset < 0) {
      beginning = 0;
      debugger(when: kDebugMode);
      ErrorHandler.logError(m: "match.offset < 0", data: match.toJson());
    } else {
      beginning = match.offset;
    }
    if (match.offset + match.length > match.fullText.length) {
      end = match.fullText.length;
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "match.offset + match.length > match.fullText.length",
        data: match.toJson(),
      );
    } else {
      end = match.offset + match.length;
    }
    return match.fullText.substring(beginning, end);
  }

  bool isOffsetInMatchSpan(int offset) =>
      offset >= match.offset && offset < match.offset + match.length;

  PangeaMatch get copyWith => PangeaMatch.fromJson(toJson());
}
