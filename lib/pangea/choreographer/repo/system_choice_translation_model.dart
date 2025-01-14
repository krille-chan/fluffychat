import '../../common/constants/model_keys.dart';

class SystemChoiceRequestModel {
  String translationId;
  int? nextWordIndex;
  String? customInput;
  String userId;
  String roomId;
  String targetLangCode;
  String sourceLangCode;
  String? classId;

  SystemChoiceRequestModel({
    required this.translationId,
    this.nextWordIndex,
    this.customInput,
    required this.userId,
    required this.roomId,
    required this.targetLangCode,
    required this.sourceLangCode,
    this.classId,
  });

  toJson() => {
        'translation_id': translationId,
        'next_word_index': nextWordIndex,
        'custom_input': customInput,
        'user_id': userId,
        'room_id': roomId,
        ModelKey.tgtLang: targetLangCode,
        ModelKey.srcLang: sourceLangCode,
        'class_id': classId,
      };

  factory SystemChoiceRequestModel.fromJson(json) => SystemChoiceRequestModel(
        translationId: json['translation_id'],
        nextWordIndex: json['next_word_index'],
        customInput: json['custom_input'],
        userId: json['user_id'],
        roomId: json['room_id'],
        targetLangCode: json[ModelKey.tgtLang],
        sourceLangCode: json[ModelKey.srcLang],
        classId: json['class_id'],
      );
}
