import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class ActivitySearchRequest {
  final String targetLanguage;
  final String languageOfInstructions;
  final LanguageLevelTypeEnum? languageLevel;

  final String? mode;
  final String? learningObjective;
  final String? topic;
  final MediaEnum? media;
  final int? numberOfParticipants;

  ActivitySearchRequest({
    required this.targetLanguage,
    required this.languageOfInstructions,
    this.mode,
    this.learningObjective,
    this.topic,
    this.media,
    this.numberOfParticipants = 2,
    this.languageLevel = LanguageLevelTypeEnum.preA1,
  });

  Map<String, dynamic> toJson() {
    return {
      'target_language': targetLanguage,
      'language_of_instructions': languageOfInstructions,
      'language_level': languageLevel,
      'mode': mode,
      'objective': learningObjective,
      'topic': topic,
      'media': media,
      'number_of_participants': numberOfParticipants,
    };
  }
}
