import 'package:fluffychat/pangea/choreographer/models/it_response_model.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';

class CustomInputRequestModel {
  String text;
  String customInput;
  String sourceLangCode;
  String targetLangCode;
  String userId;
  String roomId;

  String? goldTranslation;
  List<Continuance>? goldContinuances;

  CustomInputRequestModel({
    required this.text,
    required this.customInput,
    required this.sourceLangCode,
    required this.targetLangCode,
    required this.userId,
    required this.roomId,
    required this.goldTranslation,
    required this.goldContinuances,
  });

  factory CustomInputRequestModel.fromJson(json) => CustomInputRequestModel(
        text: json['text'],
        customInput: json['custom_input'],
        sourceLangCode: json[ModelKey.srcLang],
        targetLangCode: json[ModelKey.tgtLang],
        userId: json['user_id'],
        roomId: json['room_id'],
        goldTranslation: json['gold_translation'],
        goldContinuances: json['gold_continuances'] != null
            ? List.from(json['gold_continuances'])
                .map((e) => Continuance.fromJson(e))
                .toList()
            : null,
      );

  toJson() => {
        'text': text,
        'custom_input': customInput,
        ModelKey.srcLang: sourceLangCode,
        ModelKey.tgtLang: targetLangCode,
        'user_id': userId,
        'room_id': roomId,
        'gold_translation': goldTranslation,
        'gold_continuances': goldContinuances != null
            ? List.from(goldContinuances!.map((e) => e.toJson()))
            : null,
      };
}
