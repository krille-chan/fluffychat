import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';

class ConstructWithXP {
  final ConstructIdentifier id;
  int xp;
  DateTime? lastUsed;

  ConstructWithXP({
    required this.id,
    required this.xp,
    required this.lastUsed,
  });

  factory ConstructWithXP.fromJson(Map<String, dynamic> json) {
    return ConstructWithXP(
      id: ConstructIdentifier.fromJson(
        json['construct_id'] as Map<String, dynamic>,
      ),
      xp: json['xp'] as int,
      lastUsed: json['last_used'] != null
          ? DateTime.parse(json['last_used'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'construct_id': id.toJson(),
      'xp': xp,
      'last_used': lastUsed?.toIso8601String(),
    };
  }
}

class TokenWithXP {
  final PangeaToken token;
  final List<ConstructWithXP> constructs;

  DateTime? get lastUsed {
    return constructs.fold<DateTime?>(
      null,
      (previousValue, element) {
        if (previousValue == null) return element.lastUsed;
        if (element.lastUsed == null) return previousValue;
        return element.lastUsed!.isAfter(previousValue)
            ? element.lastUsed
            : previousValue;
      },
    );
  }

  int get xp {
    return constructs.fold<int>(
      0,
      (previousValue, element) => previousValue + element.xp,
    );
  }

  TokenWithXP({
    required this.token,
    required this.constructs,
  });

  factory TokenWithXP.fromJson(Map<String, dynamic> json) {
    return TokenWithXP(
      token: PangeaToken.fromJson(json['token'] as Map<String, dynamic>),
      constructs: (json['constructs'] as List)
          .map((e) => ConstructWithXP.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token.toJson(),
      'constructs_with_xp': constructs.map((e) => e.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokenWithXP &&
        other.token.text == token.text &&
        other.lastUsed == lastUsed;
  }

  @override
  int get hashCode {
    return token.text.hashCode ^ lastUsed.hashCode;
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
      tgtConstructs: (json['tgt_constructs'] as List)
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
      'tgt_constructs': tgtConstructs.map((e) => e.toJson()).toList(),
      'activity_type': activityType.string,
    };
  }
}

class MessageActivityRequest {
  final String userL1;
  final String userL2;

  final String messageText;

  /// tokens with their associated constructs and xp
  final List<TokenWithXP> tokensWithXP;

  /// make the server aware of existing activities for potential reuse
  final List<ExistingActivityMetaData> existingActivities;

  final String messageId;

  MessageActivityRequest({
    required this.userL1,
    required this.userL2,
    required this.messageText,
    required this.tokensWithXP,
    required this.messageId,
    required this.existingActivities,
  });

  factory MessageActivityRequest.fromJson(Map<String, dynamic> json) {
    return MessageActivityRequest(
      userL1: json['user_l1'] as String,
      userL2: json['user_l2'] as String,
      messageText: json['message_text'] as String,
      tokensWithXP: (json['tokens_with_xp'] as List)
          .map((e) => TokenWithXP.fromJson(e as Map<String, dynamic>))
          .toList(),
      messageId: json['message_id'] as String,
      existingActivities: (json['existing_activities'] as List)
          .map(
            (e) => ExistingActivityMetaData.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_l1': userL1,
      'user_l2': userL2,
      'message_text': messageText,
      'tokens_with_xp': tokensWithXP.map((e) => e.toJson()).toList(),
      'message_id': messageId,
      'existing_activities': existingActivities.map((e) => e.toJson()).toList(),
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
    return messageId.hashCode ^ const ListEquality().hash(tokensWithXP);
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
