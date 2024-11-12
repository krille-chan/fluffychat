import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/activity_display_instructions_enum.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ConstructIdentifier {
  final String lemma;
  final ConstructTypeEnum type;
  final String category;

  ConstructIdentifier({
    required this.lemma,
    required this.type,
    required this.category,
  });

  factory ConstructIdentifier.fromJson(Map<String, dynamic> json) {
    final categoryEntry = json['cat'] ?? json['categories'];
    String? category;
    if (categoryEntry != null) {
      if (categoryEntry is String) {
        category = categoryEntry;
      } else if (categoryEntry is List) {
        category = categoryEntry.first;
      }
    }

    try {
      return ConstructIdentifier(
        lemma: json['lemma'] as String,
        type: ConstructTypeEnum.values.firstWhere(
          (e) => e.string == json['type'],
        ),
        category: category ?? "",
      );
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s, data: json);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'lemma': lemma,
      'type': type.string,
      'cat': category,
    };
  }

  // override operator == and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConstructIdentifier &&
        other.lemma == lemma &&
        other.type == type;
  }

  @override
  int get hashCode {
    return lemma.hashCode ^ type.hashCode;
  }

  String get string =>
      "$lemma-${type.string}${category != "" ? "-$category" : "-other"}";
}

class CandidateMessage {
  final String msgId;
  final String roomId;
  final String text;

  CandidateMessage({
    required this.msgId,
    required this.roomId,
    required this.text,
  });

  factory CandidateMessage.fromJson(Map<String, dynamic> json) {
    return CandidateMessage(
      msgId: json['msg_id'] as String,
      roomId: json['room_id'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg_id': msgId,
      'room_id': roomId,
      'text': text,
    };
  }
}

enum PracticeActivityMode { focus, srs }

extension on PracticeActivityMode {
  String get value {
    switch (this) {
      case PracticeActivityMode.focus:
        return 'focus';
      case PracticeActivityMode.srs:
        return 'srs';
    }
  }
}

class PracticeActivityRequest {
  final PracticeActivityMode? mode;
  final List<ConstructIdentifier>? targetConstructs;
  final List<CandidateMessage>? candidateMessages;
  final List<String>? userIds;
  final ActivityTypeEnum? activityType;
  final int? numActivities;

  PracticeActivityRequest({
    this.mode,
    this.targetConstructs,
    this.candidateMessages,
    this.userIds,
    this.activityType,
    this.numActivities,
  });

  factory PracticeActivityRequest.fromJson(Map<String, dynamic> json) {
    return PracticeActivityRequest(
      mode: PracticeActivityMode.values.firstWhere(
        (e) => e.value == json['mode'],
      ),
      targetConstructs: (json['target_constructs'] as List?)
          ?.map((e) => ConstructIdentifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      candidateMessages: (json['candidate_msgs'] as List)
          .map((e) => CandidateMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      userIds: (json['user_ids'] as List?)?.map((e) => e as String).toList(),
      activityType: ActivityTypeEnum.values.firstWhere(
        (e) => e.toString().split('.').last == json['activity_type'],
      ),
      numActivities: json['num_activities'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode?.value,
      'target_constructs': targetConstructs?.map((e) => e.toJson()).toList(),
      'candidate_msgs': candidateMessages?.map((e) => e.toJson()).toList(),
      'user_ids': userIds,
      'activity_type': activityType?.toString().split('.').last,
      'num_activities': numActivities,
    };
  }

  // override operator == and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PracticeActivityRequest &&
        other.mode == mode &&
        other.targetConstructs == targetConstructs &&
        other.candidateMessages == candidateMessages &&
        other.userIds == userIds &&
        other.activityType == activityType &&
        other.numActivities == numActivities;
  }

  @override
  int get hashCode {
    return mode.hashCode ^
        targetConstructs.hashCode ^
        candidateMessages.hashCode ^
        userIds.hashCode ^
        activityType.hashCode ^
        numActivities.hashCode;
  }
}

class PracticeActivityModel {
  final List<ConstructIdentifier> tgtConstructs;
  final String langCode;
  final String msgId;
  final ActivityTypeEnum activityType;
  final ActivityContent content;

  PracticeActivityModel({
    required this.tgtConstructs,
    required this.langCode,
    required this.msgId,
    required this.activityType,
    required this.content,
  });

  String get question => content.question;

  factory PracticeActivityModel.fromJson(Map<String, dynamic> json) {
    // moving from multiple_choice to content as the key
    // this is to make the model more generic
    // here for backward compatibility
    final Map<String, dynamic>? contentMap =
        (json['content'] ?? json["multiple_choice"]) as Map<String, dynamic>?;

    if (contentMap == null) {
      Sentry.addBreadcrumb(
        Breadcrumb(data: {"json": json}),
      );
      throw ("content is null in PracticeActivityModel.fromJson");
    }

    return PracticeActivityModel(
      tgtConstructs: ((json['tgt_constructs'] ?? json['target_constructs'])
              as List)
          .map((e) => ConstructIdentifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      langCode: json['lang_code'] as String,
      msgId: json['msg_id'] as String,
      activityType:
          ActivityTypeEnum.wordMeaning.fromString(json['activity_type']),
      content: ActivityContent.fromJson(contentMap),
    );
  }

  RelevantSpanDisplayDetails? get relevantSpanDisplayDetails =>
      content.spanDisplayDetails;

  Map<String, dynamic> toJson() {
    return {
      'target_constructs': tgtConstructs.map((e) => e.toJson()).toList(),
      'lang_code': langCode,
      'msg_id': msgId,
      'activity_type': activityType.string,
      'content': content.toJson(),
    };
  }

  // override operator == and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PracticeActivityModel &&
        const ListEquality().equals(other.tgtConstructs, tgtConstructs) &&
        other.langCode == langCode &&
        other.msgId == msgId &&
        other.activityType == activityType &&
        other.content == content;
  }

  @override
  int get hashCode {
    return const ListEquality().hash(tgtConstructs) ^
        langCode.hashCode ^
        msgId.hashCode ^
        activityType.hashCode ^
        content.hashCode;
  }
}

/// For those activities with a relevant span, this class will hold the details
/// of the span and how it should be displayed
/// e.g. hide the span for conjugation activities
class RelevantSpanDisplayDetails {
  final int offset;
  final int length;
  final ActivityDisplayInstructionsEnum displayInstructions;

  RelevantSpanDisplayDetails({
    required this.offset,
    required this.length,
    required this.displayInstructions,
  });

  factory RelevantSpanDisplayDetails.fromJson(Map<String, dynamic> json) {
    final ActivityDisplayInstructionsEnum? display =
        ActivityDisplayInstructionsEnum.values.firstWhereOrNull(
      (e) => e.string == json['display_instructions'],
    );
    if (display == null) {
      debugger(when: kDebugMode);
    }
    return RelevantSpanDisplayDetails(
      offset: json['offset'] as int,
      length: json['length'] as int,
      displayInstructions: display ?? ActivityDisplayInstructionsEnum.nothing,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'length': length,
      'display_instructions': displayInstructions.string,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RelevantSpanDisplayDetails &&
        other.offset == offset &&
        other.length == length &&
        other.displayInstructions == displayInstructions;
  }

  @override
  int get hashCode {
    return offset.hashCode ^ length.hashCode ^ displayInstructions.hashCode;
  }
}
