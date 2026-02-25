import 'package:fluffychat/pangea/choreographer/igc/pangea_match_status_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/replacement_type_enum.dart';
import 'match_rule_id_model.dart';
import 'span_data_model.dart';

class PangeaMatch {
  final SpanData match;
  final PangeaMatchStatusEnum status;

  const PangeaMatch({required this.match, required this.status});

  /// Parse PangeaMatch from JSON.
  ///
  /// Supports two formats:
  /// - V1/Legacy: {"match": {...span_data...}, "status": "open"}
  /// - V2: {...span_data...} (SpanData directly, status defaults to open)
  ///
  /// [fullText] is passed to SpanData as fallback when the span JSON doesn't
  /// contain full_text (e.g., when using original_input from parent response).
  factory PangeaMatch.fromJson(Map<String, dynamic> json, {String? fullText}) {
    // Check if this is V1 format (has "match" wrapper) or V2 format (flat SpanData)
    final bool isV1Format = json[_matchKey] is Map<String, dynamic>;

    final Map<String, dynamic> spanJson = isV1Format
        ? json[_matchKey] as Map<String, dynamic>
        : json;

    final statusEntry = json[_statusKey] as String?;

    return PangeaMatch(
      match: SpanData.fromJson(spanJson, parentFullText: fullText),
      // V1 format may have status; V2 format always defaults to open
      status: isV1Format && statusEntry != null
          ? PangeaMatchStatusEnum.values.firstWhere(
              (status) => status.name == statusEntry,
              orElse: () => PangeaMatchStatusEnum.open,
            )
          : PangeaMatchStatusEnum.open,
    );
  }

  Map<String, dynamic> toJson() => {
    _matchKey: match.toJson(),
    _statusKey: status.name,
  };

  static const _matchKey = "match";
  static const _statusKey = "status";

  bool get isITStart =>
      match.rule?.id == MatchRuleIdModel.interactiveTranslation ||
      match.type == ReplacementTypeEnum.itStart;

  bool get _needsTranslation => match.rule?.id != null
      ? [
          MatchRuleIdModel.tokenNeedsTranslation,
          MatchRuleIdModel.tokenSpanNeedsTranslation,
        ].contains(match.rule!.id)
      : false;

  bool get isOutOfTargetMatch => isITStart || _needsTranslation;

  bool get isGrammarMatch => !isOutOfTargetMatch;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PangeaMatch) return false;
    return other.match == match && other.status == status;
  }

  @override
  int get hashCode {
    return match.hashCode ^ status.hashCode;
  }
}
