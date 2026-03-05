import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/choreographer/igc/text_normalization_util.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'replacement_type_enum.dart';
import 'span_choice_type_enum.dart';

class SpanData {
  final String? message;
  final String? shortMessage;
  final List<SpanChoice>? choices;
  final int offset;
  final int length;
  final String fullText;
  final ReplacementTypeEnum type;
  final Rule? rule;

  SpanData({
    required this.message,
    required this.shortMessage,
    required this.choices,
    required this.offset,
    required this.length,
    required this.fullText,
    required this.type,
    required this.rule,
  });

  SpanData copyWith({
    String? message,
    String? shortMessage,
    List<SpanChoice>? choices,
    int? offset,
    int? length,
    String? fullText,
    ReplacementTypeEnum? type,
    Rule? rule,
  }) {
    return SpanData(
      message: message ?? this.message,
      shortMessage: shortMessage ?? this.shortMessage,
      choices: choices ?? this.choices,
      offset: offset ?? this.offset,
      length: length ?? this.length,
      fullText: fullText ?? this.fullText,
      type: type ?? this.type,
      rule: rule ?? this.rule,
    );
  }

  /// Parse SpanData from JSON.
  ///
  /// [parentFullText] is used as fallback when the span JSON doesn't contain
  /// full_text (e.g., when the server omits it to reduce payload size and
  /// the full text is available at the response level as original_input).
  factory SpanData.fromJson(
    Map<String, dynamic> json, {
    String? parentFullText,
  }) {
    final Iterable? choices = json['choices'] ?? json['replacements'];
    final dynamic rawType =
        json['type'] ?? json['type_name'] ?? json['typeName'];
    final String? typeString = rawType is Map<String, dynamic>
        ? (rawType['type_name'] ?? rawType['type'] ?? rawType['typeName'])
              as String?
        : rawType as String?;

    // Try to get fullText from span JSON, fall back to parent's original_input
    final String? spanFullText =
        json['sentence'] ?? json['full_text'] ?? json['fullText'];
    final String fullText = spanFullText ?? parentFullText ?? '';

    return SpanData(
      message: json['message'],
      shortMessage: json['shortMessage'] ?? json['short_message'],
      choices: choices
          ?.map<SpanChoice>(
            (e) => SpanChoice.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      offset: json['offset'] as int,
      length: json['length'] as int,
      fullText: fullText,
      type:
          SpanDataTypeEnumExt.fromString(typeString) ??
          ReplacementTypeEnum.other,
      rule: json['rule'] != null
          ? Rule.fromJson(json['rule'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'offset': offset,
      'length': length,
      'full_text': fullText,
      'type': type.name,
    };

    if (message != null) {
      data['message'] = message;
    }

    if (shortMessage != null) {
      data['short_message'] = shortMessage;
    }

    if (choices != null) {
      data['choices'] = List<dynamic>.from(choices!.map((x) => x.toJson()));
    }

    if (rule != null) {
      data['rule'] = rule!.toJson();
    }

    return data;
  }

  bool isOffsetInMatchSpan(int offset) =>
      offset >= this.offset && offset <= this.offset + length;

  SpanChoice? get bestChoice {
    return choices?.firstWhereOrNull((choice) => choice.type.isSuggestion);
  }

  int get selectedChoiceIndex {
    if (choices == null) {
      return -1;
    }

    SpanChoice? mostRecent;
    for (int i = 0; i < choices!.length; i++) {
      final choice = choices![i];
      if (choice.timestamp != null &&
          (mostRecent == null ||
              choice.timestamp!.isAfter(mostRecent.timestamp!))) {
        mostRecent = choice;
      }
    }
    return mostRecent != null ? choices!.indexOf(mostRecent) : -1;
  }

  SpanChoice? get selectedChoice {
    final index = selectedChoiceIndex;
    if (index == -1) {
      return null;
    }
    return choices![index];
  }

  bool get isSelectedChoiceCorrection =>
      selectedChoice != null && selectedChoice!.type.isSuggestion;

  String get errorSpan =>
      fullText.characters.skip(offset).take(length).toString();

  /// Whether this span is a minor correction that should be auto-applied.
  /// Returns true if:
  /// 1. The type is explicitly marked as auto-apply (e.g., punct, spell, cap, diacritics), OR
  /// 2. For backwards compatibility with old data that lacks new types:
  ///    the type is NOT auto-apply AND the normalized strings match.
  bool isNormalizationError({String? errorSpanOverride}) {
    // New data with explicit auto-apply types
    if (type.isAutoApply) {
      return true;
    }

    final correctChoice = choices
        ?.firstWhereOrNull((c) => c.type.isSuggestion)
        ?.value;

    final l2Code =
        MatrixState.pangeaController.userController.userL2?.langCodeShort;

    return correctChoice != null &&
        l2Code != null &&
        normalizeString(correctChoice, l2Code) ==
            normalizeString(errorSpanOverride ?? errorSpan, l2Code);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SpanData) return false;
    if (other.message != message) return false;
    if (other.shortMessage != shortMessage) return false;
    if (other.offset != offset) return false;
    if (other.length != length) return false;
    if (other.fullText != fullText) return false;
    if (other.type != type) return false;
    if (other.rule != rule) return false;
    if (const ListEquality().equals(
          other.choices?.sorted((a, b) => b.value.compareTo(a.value)),
          choices?.sorted((a, b) => b.value.compareTo(a.value)),
        ) ==
        false) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        shortMessage.hashCode ^
        Object.hashAll(
          (choices ?? [])
              .sorted((a, b) => b.value.compareTo(a.value))
              .map((choice) => choice.hashCode),
        ) ^
        offset.hashCode ^
        length.hashCode ^
        fullText.hashCode ^
        type.hashCode ^
        rule.hashCode;
  }
}

class SpanChoice {
  final String value;
  final SpanChoiceTypeEnum type;
  final bool selected;
  final String? feedback;
  final DateTime? timestamp;

  SpanChoice({
    required this.value,
    required this.type,
    this.feedback,
    this.selected = false,
    this.timestamp,
  });

  SpanChoice copyWith({
    String? value,
    SpanChoiceTypeEnum? type,
    String? feedback,
    bool? selected,
    DateTime? timestamp,
  }) {
    return SpanChoice(
      value: value ?? this.value,
      type: type ?? this.type,
      feedback: feedback ?? this.feedback,
      selected: selected ?? this.selected,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory SpanChoice.fromJson(Map<String, dynamic> json) {
    return SpanChoice(
      value: json['value'] as String,
      type: json['type'] != null
          ? SpanChoiceTypeEnum.values.firstWhereOrNull(
                  (element) => element.name == json['type'],
                ) ??
                SpanChoiceTypeEnum.suggestion
          : SpanChoiceTypeEnum.suggestion,
      feedback: json['feedback'],
      selected: json['selected'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'value': value, 'type': type.name};

    // V2 format: use selected_at instead of separate selected + timestamp
    if (selected && timestamp != null) {
      data['selected_at'] = timestamp!.toIso8601String();
    }

    if (feedback != null) {
      data['feedback'] = feedback;
    }

    return data;
  }

  String displayFeedback(BuildContext context) {
    if (feedback == null) {
      return type.defaultFeedback(context);
    }
    return feedback!;
  }

  Color get color => type.color;

  // override == operator and hashcode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpanChoice &&
        other.value == value &&
        other.type.toString() == type.toString() &&
        other.selected == selected &&
        other.feedback == feedback &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return value.hashCode ^
        type.hashCode ^
        selected.hashCode ^
        feedback.hashCode ^
        timestamp.hashCode;
  }
}

class Rule {
  final String id;

  const Rule({required this.id});

  factory Rule.fromJson(Map<String, dynamic> json) =>
      Rule(id: json['id'] as String);

  Map<String, dynamic> toJson() => {'id': id};

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Rule) return false;
    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
