//Possible actions/effects from cards
// Nothing
// useType of viewed definitions
// SpanChoice of text in message from options
// Call to server for additional/followup info

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../enum/span_choice_type.dart';
import '../enum/span_data_type.dart';

class SpanData {
  SpanData({
    required this.message,
    required this.shortMessage,
    required this.choices,
    required this.offset,
    required this.length,
    required this.context,
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
      context:
          json['context'] != null ? Context.fromJson(json['context']) : null,
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
  Context? context;
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
        'context': context?.toJson(),
        'full_text': fullText,
        'type': type.toJson(),
        'rule': rule?.toJson(),
      };
}

class Context {
  Context({
    required this.text,
    required this.offset,
    required this.length,
  });

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      text: json['text'] as String,
      offset: json['offset'] as int,
      length: json['length'] as int,
    );
  }

  /// full text of the message
  String text;
  int offset;
  int length;

  Map<String, dynamic> toJson() => {
        'text': text,
        'offset': offset,
        'length': length,
      };
}

class SpanChoice {
  SpanChoice({
    required this.value,
    required this.type,
    this.feedback,
    this.selected = false,
  });
  factory SpanChoice.fromJson(Map<String, dynamic> json) {
    return SpanChoice(
      value: json['value'] as String,
      type: json['type'] != null
          ? SpanChoiceType.values.firstWhereOrNull(
                  (element) => element.name == json['type']) ??
              SpanChoiceType.bestCorrection
          : SpanChoiceType.bestCorrection,
      feedback: json['feedback'],
      selected: json['selected'] ?? false,
    );
  }

  String value;
  SpanChoiceType type;
  bool selected;
  String? feedback;

  Map<String, dynamic> toJson() => {
        'value': value,
        'type': type.name,
        'selected': selected,
        'feedback': feedback,
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
