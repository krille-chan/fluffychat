import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/enums/span_data_type.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import '../constants/match_rule_ids.dart';
import 'igc_text_data_model.dart';
import 'span_data.dart';

enum PangeaMatchStatus { open, ignored, accepted, automatic, unknown }

class PangeaMatch {
  SpanData match;

  PangeaMatchStatus status;

  // String source;

  PangeaMatch({
    required this.match,
    required this.status,
    // required this.source,
  });

  factory PangeaMatch.fromJson(Map<String, dynamic> json) {
    // try {
    return PangeaMatch(
      match: SpanData.fromJson(json[_matchKey] as Map<String, dynamic>),
      status: json[_statusKey] != null
          ? _statusStringToEnum(json[_statusKey])
          : PangeaMatchStatus.open,
      // source: json[_matchKey]["source"] ?? "unk",
    );
    // } catch (err) {
    //   debugger(when: kDebugMode);
    //   ErrorHandler.logError(
    //       m: "unknown error in PangeaMatch.fromJson", data: json);
    //   rethrow;
    // }
  }

  String _statusEnumToString(dynamic status) =>
      status.toString().split('.').last;

  static PangeaMatchStatus _statusStringToEnum(String status) {
    final String lastPart = status.toString().split('.').last;
    switch (lastPart) {
      case 'open':
        return PangeaMatchStatus.open;
      case 'ignored':
        return PangeaMatchStatus.ignored;
      case 'accepted':
        return PangeaMatchStatus.accepted;
      default:
        return PangeaMatchStatus.unknown;
    }
  }

  static const _matchKey = "match";
  static const _statusKey = "status";

  bool get isl1SpanMatch => needsTranslation;

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

  Map<String, dynamic> toJson() => {
        _matchKey: match.toJson(),
        // _detectionsKey: detections.map((e) => e.toJson()).toList(),
        _statusKey: _statusEnumToString(status),
      };

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

  Color get underlineColor {
    if (status == PangeaMatchStatus.automatic) {
      return const Color.fromARGB(187, 132, 96, 224);
    }

    switch (match.rule?.id ?? "unknown") {
      case MatchRuleIds.interactiveTranslation:
        return const Color.fromARGB(187, 132, 96, 224);
      case MatchRuleIds.tokenNeedsTranslation:
      case MatchRuleIds.tokenSpanNeedsTranslation:
        return const Color.fromARGB(186, 255, 132, 0);
      default:
        return const Color.fromARGB(149, 255, 17, 0);
    }
  }

  TextStyle textStyle(TextStyle? existingStyle) =>
      existingStyle?.merge(IGCTextData.underlineStyle(underlineColor)) ??
      IGCTextData.underlineStyle(underlineColor);

  PangeaMatch get copyWith => PangeaMatch.fromJson(toJson());

  int get beginning => match.offset < 0 ? 0 : match.offset;
  int get end => match.offset + match.length > match.fullText.length
      ? match.fullText.length
      : match.offset + match.length;
}
