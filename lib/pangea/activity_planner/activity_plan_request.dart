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
  int numberOfParticipants;

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
      'activity_cefr_level': cefrLevel.string,
      'language_of_instructions': languageOfInstructions,
      'target_language': targetLanguage,
      'count': count,
      'number_of_participants': numberOfParticipants,
    };
  }

  factory ActivityPlanRequest.fromJson(Map<String, dynamic> json) =>
      ActivityPlanRequest(
        topic: json['topic'],
        mode: json['mode'],
        objective: json['objective'],
        media: MediaEnum.nan.fromString(json['media']),
        cefrLevel: json['activity_cefr_level'] != null
            ? LanguageLevelTypeEnumExtension.fromString(
                json['activity_cefr_level'],
              )
            : LanguageLevelTypeEnum.a1,
        languageOfInstructions: json['language_of_instructions'],
        targetLanguage: json['target_language'],
        count: json['count'],
        numberOfParticipants: json['number_of_participants'],
      );

  String get storageKey =>
      '$topic-$mode-$objective-${media.string}-$cefrLevel-$languageOfInstructions-$targetLanguage-$numberOfParticipants';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityPlanRequest &&
        other.topic == topic &&
        other.mode == mode &&
        other.objective == objective &&
        other.media == media &&
        other.cefrLevel == cefrLevel &&
        other.languageOfInstructions == languageOfInstructions &&
        other.targetLanguage == targetLanguage &&
        other.count == count &&
        other.numberOfParticipants == numberOfParticipants;
  }

  @override
  int get hashCode =>
      topic.hashCode ^
      mode.hashCode ^
      objective.hashCode ^
      media.hashCode ^
      cefrLevel.hashCode ^
      languageOfInstructions.hashCode ^
      targetLanguage.hashCode ^
      count.hashCode ^
      numberOfParticipants.hashCode;
}
