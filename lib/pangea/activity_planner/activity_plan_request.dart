import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class ActivityPlanRequest {
  final String topic;
  final String mode;
  final String objective;
  final MediaEnum media;
  final LanguageLevelTypeEnum cefrLevel;
  final String languageOfInstructions;
  final String targetLanguage;
  final int count;
  final int numberOfParticipants;

  ActivityPlanRequest({
    required this.topic,
    required this.mode,
    required this.objective,
    required this.media,
    required this.cefrLevel,
    required this.languageOfInstructions,
    required this.targetLanguage,
    this.count = 3,
    required this.numberOfParticipants,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'mode': mode,
      'objective': objective,
      'media': media.string,
      'cefr_level': cefrLevel,
      'language_of_instructions': languageOfInstructions,
      'target_language': targetLanguage,
      'count': count,
      'number_of_participants': numberOfParticipants,
    };
  }

  factory ActivityPlanRequest.fromJson(Map<String, dynamic> json) {
    LanguageLevelTypeEnum cefrLevel = LanguageLevelTypeEnum.a1;
    switch (json['cefr_level']) {
      case 'Pre-A1':
        cefrLevel = LanguageLevelTypeEnum.preA1;
        break;
      case 'A1':
        cefrLevel = LanguageLevelTypeEnum.a1;
        break;
      case 'A2':
        cefrLevel = LanguageLevelTypeEnum.a2;
        break;
      case 'B1':
        cefrLevel = LanguageLevelTypeEnum.b1;
        break;
      case 'B2':
        cefrLevel = LanguageLevelTypeEnum.b2;
        break;
      case 'C1':
        cefrLevel = LanguageLevelTypeEnum.c1;
        break;
      case 'C2':
        cefrLevel = LanguageLevelTypeEnum.c2;
        break;
    }
    return ActivityPlanRequest(
      topic: json['topic'],
      mode: json['mode'],
      objective: json['objective'],
      media: MediaEnum.nan.fromString(json['media']),
      cefrLevel: cefrLevel,
      languageOfInstructions: json['language_of_instructions'],
      targetLanguage: json['target_language'],
      count: json['count'],
      numberOfParticipants: json['number_of_participants'],
    );
  }

  String get storageKey =>
      '$topic-$mode-$objective-${media.string}-$cefrLevel-$languageOfInstructions-$targetLanguage-$numberOfParticipants';
}
