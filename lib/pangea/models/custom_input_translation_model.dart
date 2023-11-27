// Project imports:
import 'package:fluffychat/pangea/constants/model_keys.dart';

class CustomInputRequestModel {
  String text;
  String customInput;
  String sourceLangCode;
  String targetLangCode;
  String userId;
  String roomId;
  String? classId;

  CustomInputRequestModel({
    required this.text,
    required this.customInput,
    required this.sourceLangCode,
    required this.targetLangCode,
    required this.userId,
    required this.roomId,
    required this.classId,
  });

  factory CustomInputRequestModel.fromJson(json) => CustomInputRequestModel(
        text: json['text'],
        customInput: json['custom_input'],
        sourceLangCode: json[ModelKey.srcLang],
        targetLangCode: json[ModelKey.tgtLang],
        userId: json['user_id'],
        roomId: json['room_id'],
        classId: json['class_id'],
      );

  toJson() => {
        'text': text,
        'custom_input': customInput,
        ModelKey.srcLang: sourceLangCode,
        ModelKey.tgtLang: targetLangCode,
        'user_id': userId,
        'room_id': roomId,
        'class_id': classId
      };
}
