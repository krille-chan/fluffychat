import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
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
      ModelKey.activityRequestTopic: topic,
      ModelKey.activityRequestMode: mode,
      ModelKey.activityRequestObjective: objective,
      ModelKey.activityRequestMedia: media.string,
      ModelKey.activityRequestCefrLevel: cefrLevel.string,
      ModelKey.activityRequestLanguageOfInstructions: languageOfInstructions,
      ModelKey.activityRequestTargetLanguage: targetLanguage,
      ModelKey.activityRequestCount: count,
      ModelKey.activityRequestNumberOfParticipants: numberOfParticipants,
    };
  }

  factory ActivityPlanRequest.fromJson(Map<String, dynamic> json) =>
      ActivityPlanRequest(
        topic: json[ModelKey.activityRequestTopic],
        mode: json[ModelKey.activityRequestMode],
        objective: json[ModelKey.activityRequestObjective],
        media: MediaEnum.nan.fromString(json[ModelKey.activityRequestMedia]),
        cefrLevel: json[ModelKey.activityRequestCefrLevel] != null
            ? LanguageLevelTypeEnumExtension.fromString(
                json[ModelKey.activityRequestCefrLevel],
              )
            : LanguageLevelTypeEnum.a1,
        languageOfInstructions:
            json[ModelKey.activityRequestLanguageOfInstructions],
        targetLanguage: json[ModelKey.activityRequestTargetLanguage],
        count: json[ModelKey.activityRequestCount],
        numberOfParticipants:
            json[ModelKey.activityRequestNumberOfParticipants],
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
