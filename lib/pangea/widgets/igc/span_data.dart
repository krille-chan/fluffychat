//Possible actions/effects from cards
// Nothing
// useType of viewed definitions
// SpanChoice of text in message from options
// Call to server for additional/followup info

// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import '../../enum/span_choice_type.dart';
import '../../enum/span_data_type.dart';

class SpanData {
  String? message;
  String? shortMessage;
  List<SpanChoice>? choices;
  List<Replacement>? replacements;
  int offset;
  int length;
  String fullText;
  Context? context;
  SpanDataTypeEnum type;
  Rule? rule;

  SpanData({
    this.message,
    this.shortMessage,
    this.choices,
    this.replacements,
    required this.offset,
    required this.length,
    required this.fullText,
    this.context,
    required this.type,
    this.rule,
  });

  factory SpanData.fromJson(Map<String, dynamic> json) {
    return SpanData(
      message: json['message'],
      shortMessage: json['shortMessage'],
      choices: json['choices'] != null
          ? List<SpanChoice>.from(
              json['choices'].map((x) => SpanChoice.fromJson(x)))
          : null,
      replacements: json['replacements'] != null
          ? List<Replacement>.from(
              json['replacements'].map((x) => Replacement.fromJson(x)))
          : null,
      offset: json['offset'],
      length: json['length'],
      fullText: json['full_text'],
      context:
          json['context'] != null ? Context.fromJson(json['context']) : null,
      type: SpanDataTypeEnum.values.firstWhereOrNull(
              (e) => e.toString() == 'SpanDataTypeEnum.${json['type']}') ??
          SpanDataTypeEnum.correction,
      rule: json['rule'] != null ? Rule.fromJson(json['rule']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['shortMessage'] = shortMessage;
    if (choices != null) {
      data['choices'] = choices!.map((x) => x.toJson()).toList();
    }
    if (replacements != null) {
      data['replacements'] = replacements!.map((x) => x.toJson()).toList();
    }
    data['offset'] = offset;
    data['length'] = length;
    data['full_text'] = fullText;
    if (context != null) {
      data['context'] = context!.toJson();
    }
    data['type'] = type.toString().split('.').last;
    if (rule != null) {
      data['rule'] = rule!.toJson();
    }
    return data;
  }
}

class Context {
  String sentence;
  int offset;
  int length;

  Context({required this.sentence, required this.offset, required this.length});

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      sentence: json['sentence'],
      offset: json['offset'],
      length: json['length'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sentence'] = sentence;
    data['offset'] = offset;
    data['length'] = length;
    return data;
  }
}

class SpanChoice {
  String value;
  bool selected;

  SpanChoice({required this.value, required this.selected});

  factory SpanChoice.fromJson(Map<String, dynamic> json) {
    return SpanChoice(
      value: json['value'],
      selected: json['selected'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['selected'] = selected;
    return data;
  }
}

class Replacement {
  String value;

  Replacement({required this.value});

  factory Replacement.fromJson(Map<String, dynamic> json) {
    return Replacement(
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}

class Rule {
  String id;

  Rule({required this.id});

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class SpanDataType {
  String type;

  SpanDataType({required this.type});

  factory SpanDataType.fromJson(Map<String, dynamic> json) {
    return SpanDataType(
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    return data;
  }
}
