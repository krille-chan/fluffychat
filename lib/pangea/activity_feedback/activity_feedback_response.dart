import 'package:fluffychat/pangea/events/models/content_feedback.dart';

class ActivityFeedbackResponse implements JsonSerializable {
  final bool shouldMakeEdits;
  final String? cleanedEditPrompt;
  final String userFriendlyResponse;

  ActivityFeedbackResponse({
    required this.shouldMakeEdits,
    this.cleanedEditPrompt,
    required this.userFriendlyResponse,
  });

  factory ActivityFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return ActivityFeedbackResponse(
      shouldMakeEdits: json['should_make_edits'] as bool,
      cleanedEditPrompt: json['cleaned_edit_prompt'] as String?,
      userFriendlyResponse: json['user_friendly_response'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'should_make_edits': shouldMakeEdits,
      'cleaned_edit_prompt': cleanedEditPrompt,
      'user_friendly_response': userFriendlyResponse,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityFeedbackResponse &&
          runtimeType == other.runtimeType &&
          shouldMakeEdits == other.shouldMakeEdits &&
          cleanedEditPrompt == other.cleanedEditPrompt &&
          userFriendlyResponse == other.userFriendlyResponse;

  @override
  int get hashCode =>
      shouldMakeEdits.hashCode ^
      cleanedEditPrompt.hashCode ^
      userFriendlyResponse.hashCode;
}
