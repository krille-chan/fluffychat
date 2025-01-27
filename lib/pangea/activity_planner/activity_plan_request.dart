import 'package:fluffychat/pangea/activity_planner/media_enum.dart';

class ActivityPlanRequest {
  final String topic;
  final String mode;
  final String objective;
  final MediaEnum media;
  final int cefrLevel;
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
      'cefr_level': cefrLanguageLevel,
      'language_of_instructions': languageOfInstructions,
      'target_language': targetLanguage,
      'count': count,
      'number_of_participants': numberOfParticipants,
    };
  }

  factory ActivityPlanRequest.fromJson(Map<String, dynamic> json) {
    int cefrLevel = 0;
    switch (json['cefr_level']) {
      case 'Pre-A1':
        cefrLevel = 0;
        break;
      case 'A1':
        cefrLevel = 1;
        break;
      case 'A2':
        cefrLevel = 2;
        break;
      case 'B1':
        cefrLevel = 3;
        break;
      case 'B2':
        cefrLevel = 4;
        break;
      case 'C1':
        cefrLevel = 5;
        break;
      case 'C2':
        cefrLevel = 6;
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

  String get cefrLanguageLevel {
    switch (cefrLevel) {
      case 0:
        return 'Pre-A1';
      case 1:
        return 'A1';
      case 2:
        return 'A2';
      case 3:
        return 'B1';
      case 4:
        return 'B2';
      case 5:
        return 'C1';
      case 6:
        return 'C2';
      default:
        return 'Pre-A1';
    }
  }
}
