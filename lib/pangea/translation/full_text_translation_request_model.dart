import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/models/llm_feedback_model.dart';
import 'package:fluffychat/pangea/translation/full_text_translation_response_model.dart';

class FullTextTranslationRequestModel {
  final String text;
  final String? srcLang;
  final String tgtLang;
  final String userL1;
  final String userL2;
  final bool? deepL;
  final int? offset;
  final int? length;
  final List<LLMFeedbackModel<FullTextTranslationResponseModel>>? feedback;

  const FullTextTranslationRequestModel({
    required this.text,
    this.srcLang,
    required this.tgtLang,
    required this.userL2,
    required this.userL1,
    this.deepL = false,
    this.offset,
    this.length,
    this.feedback,
  });

  Map<String, dynamic> toJson() => {
    ModelKey.text: text,
    ModelKey.srcLang: srcLang,
    ModelKey.tgtLang: tgtLang,
    ModelKey.userL2: userL2,
    ModelKey.userL1: userL1,
    ModelKey.deepL: deepL,
    ModelKey.offset: offset,
    ModelKey.length: length,
    if (feedback != null)
      ModelKey.feedback: feedback!.map((f) => f.toJson()).toList(),
  };

  // override equals and hashcode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FullTextTranslationRequestModel &&
        other.text == text &&
        other.srcLang == srcLang &&
        other.tgtLang == tgtLang &&
        other.userL2 == userL2 &&
        other.userL1 == userL1 &&
        other.deepL == deepL &&
        other.offset == offset &&
        other.length == length &&
        ListEquality().equals(other.feedback, feedback);
  }

  @override
  int get hashCode =>
      text.hashCode ^
      srcLang.hashCode ^
      tgtLang.hashCode ^
      userL2.hashCode ^
      userL1.hashCode ^
      deepL.hashCode ^
      offset.hashCode ^
      length.hashCode ^
      ListEquality().hash(feedback);
}
