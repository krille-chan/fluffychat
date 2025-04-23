//Possible actions/effects from cards
// Nothing
// useType of viewed definitions
// SpanChoice of text in message from options
// Call to server for additional/followup info

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import '../enums/span_choice_type.dart';
import '../enums/span_data_type.dart';

class SpanData {
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

  factory SpanData.fromJson(Map<String, dynamic> json) {
    final Iterable? choices = json['choices'] ?? json['replacements'];
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
      fullText:
          json['sentence'] ?? json['full_text'] ?? json['fullText'] as String,
      type: SpanDataType.fromJson(json['type'] as Map<String, dynamic>),
      rule: json['rule'] != null
          ? Rule.fromJson(json['rule'] as Map<String, dynamic>)
          : null,
    );
  }

  String? message;
  String? shortMessage;
  List<SpanChoice>? choices;
  int offset;
  int length;
  String fullText;
  SpanDataType type;
  Rule? rule;

  Map<String, dynamic> toJson() => {
        'message': message,
        'short_message': shortMessage,
        'choices': choices != null
            ? List<dynamic>.from(choices!.map((x) => x.toJson()))
            : null,
        'offset': offset,
        'length': length,
        'full_text': fullText,
        'type': type.toJson(),
        'rule': rule?.toJson(),
      };
}

class SpanChoice {
  String value;
  SpanChoiceType type;
  bool selected;
  String? feedback;
  DateTime? timestamp;
  // List<PangeaToken> tokens;

  SpanChoice({
    required this.value,
    required this.type,
    this.feedback,
    this.selected = false,
    this.timestamp,
    // this.tokens = const [],
  });

  factory SpanChoice.fromJson(Map<String, dynamic> json) {
    // final List<PangeaToken> tokensInternal = (json[ModelKey.tokens] != null)
    //     ? (json[ModelKey.tokens] as Iterable)
    //         .map<PangeaToken>(
    //           (e) => PangeaToken.fromJson(e as Map<String, dynamic>),
    //         )
    //         .toList()
    //         .cast<PangeaToken>()
    //     : [];
    return SpanChoice(
      value: json['value'] as String,
      type: json['type'] != null
          ? SpanChoiceType.values.firstWhereOrNull(
                (element) => element.name == json['type'],
              ) ??
              SpanChoiceType.bestCorrection
          : SpanChoiceType.bestCorrection,
      feedback: json['feedback'],
      selected: json['selected'] ?? false,
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      // tokens: tokensInternal,
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'type': type.name,
        'selected': selected,
        'feedback': feedback,
        'timestamp': timestamp?.toIso8601String(),
        // 'tokens': tokens.map((e) => e.toJson()).toList(),
      };

  String feedbackToDisplay(BuildContext context) {
    if (feedback == null) {
      return type.defaultFeedback(context);
    }
    return feedback!;
  }

  bool get isDistractor => type == SpanChoiceType.distractor;

  bool get isBestCorrection => type == SpanChoiceType.bestCorrection;

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
        other.timestamp?.toIso8601String() == timestamp?.toIso8601String();
  }

  @override
  int get hashCode {
    return Object.hashAll([
      value.hashCode,
      type.toString().hashCode,
      selected.hashCode,
      feedback.hashCode,
      timestamp?.toIso8601String().hashCode,
    ]);
  }
}

class Rule {
  Rule({
    required this.id,
  });
  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        id: json['id'] as String,
      );

  String id;

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class SpanDataType {
  SpanDataType({
    required this.typeName,
  });

  factory SpanDataType.fromJson(Map<String, dynamic> json) {
    final String? type =
        json['typeName'] ?? json['type'] ?? json['type_name'] as String?;
    return SpanDataType(
      typeName: type != null
          ? SpanDataTypeEnum.values
                  .firstWhereOrNull((element) => element.name == type) ??
              SpanDataTypeEnum.correction
          : SpanDataTypeEnum.correction,
    );
  }
  SpanDataTypeEnum typeName;

  Map<String, dynamic> toJson() => {
        'type_name': typeName.name,
      };
}
