import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_use_model.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class TokenWithXP {
  final PangeaToken token;
  late List<ActivityTypeEnum> targetTypes;

  TokenWithXP({
    required this.token,
  }) {
    targetTypes = [];
  }

  List<ConstructIdentifier> get _constructIDs {
    final List<ConstructIdentifier> ids = [];
    ids.add(
      ConstructIdentifier(
        lemma: token.lemma.text,
        type: ConstructTypeEnum.vocab,
        category: token.pos,
      ),
    );
    for (final morph in token.morph.entries) {
      ids.add(
        ConstructIdentifier(
          lemma: morph.value,
          type: ConstructTypeEnum.morph,
          category: morph.key,
        ),
      );
    }
    return ids;
  }

  List<ConstructUses> get constructs => _constructIDs
      .map(
        (id) =>
            MatrixState.pangeaController.getAnalytics.constructListModel
                .getConstructUses(id) ??
            ConstructUses(
              lemma: id.lemma,
              constructType: id.type,
              category: id.category,
              uses: [],
            ),
      )
      .toList();

  factory TokenWithXP.fromJson(Map<String, dynamic> json) {
    return TokenWithXP(
      token: PangeaToken.fromJson(json['token'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token.toJson(),
      'constructs_with_xp': constructs.map((e) => e.toJson()).toList(),
      'target_types': targetTypes.map((e) => e.string).toList(),
    };
  }

  bool eligibleForActivity(ActivityTypeEnum a) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        return token.isContentWord;
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
        return token.canBeHeard;
    }
  }

  bool didActivity(ActivityTypeEnum a) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        return vocabConstruct.uses
            .map((u) => u.useType)
            .any((u) => a.associatedUseTypes.contains(u));
      case ActivityTypeEnum.wordFocusListening:
        return vocabConstruct.uses
            // TODO - double-check that form is going to be available here
            // .where((u) =>
            //     u.form?.toLowerCase() == token.text.content.toLowerCase(),)
            .map((u) => u.useType)
            .any((u) => a.associatedUseTypes.contains(u));
      case ActivityTypeEnum.hiddenWordListening:
        return vocabConstruct.uses
            // TODO - double-check that form is going to be available here
            // .where((u) =>
            //     u.form?.toLowerCase() == token.text.content.toLowerCase(),)
            .map((u) => u.useType)
            .any((u) => a.associatedUseTypes.contains(u));
    }
  }

  ConstructUses get vocabConstruct {
    final vocab = constructs.firstWhereOrNull(
      (element) => element.id.type == ConstructTypeEnum.vocab,
    );
    if (vocab == null) {
      return ConstructUses(
        lemma: token.lemma.text,
        constructType: ConstructTypeEnum.vocab,
        category: token.pos,
        uses: [],
      );
    }
    return vocab;
  }

  int get xp {
    return constructs.fold<int>(
      0,
      (previousValue, element) => previousValue + element.points,
    );
  }

  ///
  DateTime? get lastUsed => constructs.fold<DateTime?>(
        null,
        (previousValue, element) {
          if (previousValue == null) return element.lastUsed;
          if (element.lastUsed == null) return previousValue;
          return element.lastUsed!.isAfter(previousValue)
              ? element.lastUsed
              : previousValue;
        },
      );

  /// daysSinceLastUse
  int get daysSinceLastUse {
    if (lastUsed == null) return 1000;
    return DateTime.now().difference(lastUsed!).inDays;
  }

  //override operator == and hashCode
  // check that the list of constructs are the same
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenWithXP &&
        const ListEquality().equals(other.constructs, constructs);
  }

  @override
  int get hashCode {
    return const ListEquality().hash(constructs);
  }
}

class ExistingActivityMetaData {
  final String activityEventId;
  final List<ConstructIdentifier> tgtConstructs;
  final ActivityTypeEnum activityType;

  ExistingActivityMetaData({
    required this.activityEventId,
    required this.tgtConstructs,
    required this.activityType,
  });

  factory ExistingActivityMetaData.fromJson(Map<String, dynamic> json) {
    return ExistingActivityMetaData(
      activityEventId: json['activity_event_id'] as String,
      tgtConstructs: ((json['tgt_constructs'] ?? json['target_constructs'])
              as List)
          .map((e) => ConstructIdentifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      activityType: ActivityTypeEnum.values.firstWhere(
        (element) =>
            element.string == json['activity_type'] as String ||
            element.string.split('.').last == json['activity_type'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_event_id': activityEventId,
      'target_constructs': tgtConstructs.map((e) => e.toJson()).toList(),
      'activity_type': activityType.string,
    };
  }
}

// includes feedback text and the bad activity model
class ActivityQualityFeedback {
  final String feedbackText;
  final PracticeActivityModel badActivity;

  ActivityQualityFeedback({
    required this.feedbackText,
    required this.badActivity,
  });

  factory ActivityQualityFeedback.fromJson(Map<String, dynamic> json) {
    return ActivityQualityFeedback(
      feedbackText: json['feedback_text'] as String,
      badActivity: PracticeActivityModel.fromJson(
        json['bad_activity'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_text': feedbackText,
      'bad_activity': badActivity.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityQualityFeedback &&
        other.feedbackText == feedbackText &&
        other.badActivity == badActivity;
  }

  @override
  int get hashCode {
    return feedbackText.hashCode ^ badActivity.hashCode;
  }
}

class MessageActivityRequest {
  final String userL1;
  final String userL2;

  final String messageText;

  final ActivityQualityFeedback? activityQualityFeedback;

  /// tokens with their associated constructs and xp
  final List<TokenWithXP> tokensWithXP;

  /// make the server aware of existing activities for potential reuse
  final List<ExistingActivityMetaData> existingActivities;

  final String messageId;

  final List<ActivityTypeEnum> clientCompatibleActivities;

  final ActivityTypeEnum clientTypeRequest;

  final TokenWithXP clientTokenRequest;

  MessageActivityRequest({
    required this.userL1,
    required this.userL2,
    required this.messageText,
    required this.tokensWithXP,
    required this.messageId,
    required this.existingActivities,
    required this.activityQualityFeedback,
    required this.clientCompatibleActivities,
    required this.clientTokenRequest,
    required this.clientTypeRequest,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_l1': userL1,
      'user_l2': userL2,
      'message_text': messageText,
      'tokens_with_xp': tokensWithXP.map((e) => e.toJson()).toList(),
      'message_id': messageId,
      'existing_activities': existingActivities.map((e) => e.toJson()).toList(),
      'activity_quality_feedback': activityQualityFeedback?.toJson(),
      'iso_8601_time_of_req': DateTime.now().toIso8601String(),
      // this is a list of activity types that the client can handle
      // the server will only return activities of these types
      // this for backwards compatibility with old clients
      'client_version_compatible_activity_types':
          clientCompatibleActivities.map((e) => e.string).toList(),
      'client_type_request': clientTypeRequest.string,
      'client_token_request': clientTokenRequest.toJson(),
    };
  }

  // equals accounts for message_id and last_used of each token
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageActivityRequest &&
        other.messageId == messageId &&
        const ListEquality().equals(other.tokensWithXP, tokensWithXP);
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        const ListEquality().hash(tokensWithXP) ^
        activityQualityFeedback.hashCode;
  }
}

class MessageActivityResponse {
  final PracticeActivityModel? activity;
  final bool finished;
  final String? existingActivityEventId;

  MessageActivityResponse({
    required this.activity,
    required this.finished,
    required this.existingActivityEventId,
  });

  factory MessageActivityResponse.fromJson(Map<String, dynamic> json) {
    return MessageActivityResponse(
      activity: json['activity'] != null
          ? PracticeActivityModel.fromJson(
              json['activity'] as Map<String, dynamic>,
            )
          : null,
      finished: json['finished'] as bool,
      existingActivityEventId: json['existing_activity_event_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity': activity?.toJson(),
      'finished': finished,
      'existing_activity_event_id': existingActivityEventId,
    };
  }
}
