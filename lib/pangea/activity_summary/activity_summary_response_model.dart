class ParticipantSummaryModel {
  final String participantId;
  final String feedback;
  final String cefrLevel;
  final List<String> superlatives;

  ParticipantSummaryModel({
    required this.participantId,
    required this.feedback,
    required this.cefrLevel,
    required this.superlatives,
  });

  factory ParticipantSummaryModel.fromJson(Map<String, dynamic> json) {
    return ParticipantSummaryModel(
      participantId: json['participant_id'] as String,
      feedback: json['feedback'] as String,
      cefrLevel: json['cefr_level'] as String,
      superlatives:
          (json['superlatives'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participant_id': participantId,
      'feedback': feedback,
      'cefr_level': cefrLevel,
      'superlatives': superlatives,
    };
  }
}

class ActivitySummaryResponseModel {
  final List<ParticipantSummaryModel> participants;
  final String summary;

  ActivitySummaryResponseModel({
    required this.participants,
    required this.summary,
  });

  factory ActivitySummaryResponseModel.fromJson(Map<String, dynamic> json) {
    return ActivitySummaryResponseModel(
      participants: (json['participants'] as List)
          .map((e) => ParticipantSummaryModel.fromJson(e))
          .toList(),
      summary: json['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants.map((e) => e.toJson()).toList(),
      'summary': summary,
    };
  }
}
