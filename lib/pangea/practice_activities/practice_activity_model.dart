import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_form.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/lemmas/user_set_lemma_info.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_match.dart';
import 'package:fluffychat/pangea/practice_activities/practice_record.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';
import 'package:fluffychat/pangea/practice_activities/relevant_span_display_details.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PracticeActivityModel {
  List<PangeaToken> targetTokens;
  final ActivityTypeEnum activityType;
  final MorphFeaturesEnum? morphFeature;

  final String langCode;

  final MultipleChoiceActivity? multipleChoiceContent;
  final PracticeMatch? matchContent;

  PracticeActivityModel({
    required this.targetTokens,
    required this.langCode,
    required this.activityType,
    this.morphFeature,
    this.multipleChoiceContent,
    this.matchContent,
  }) {
    if (matchContent == null && multipleChoiceContent == null) {
      debugger(when: kDebugMode);
      throw ("both matchContent and multipleChoiceContent are null in PracticeActivityModel");
    }
    if (matchContent != null && multipleChoiceContent != null) {
      debugger(when: kDebugMode);
      throw ("both matchContent and multipleChoiceContent are not null in PracticeActivityModel");
    }
    if (activityType == ActivityTypeEnum.morphId && morphFeature == null) {
      debugger(when: kDebugMode);
      throw ("morphFeature is null in PracticeActivityModel");
    }
  }

  bool get isComplete => practiceTarget.isComplete;

  void onMultipleChoiceSelect(
    PangeaToken token,
    ConstructForm choice,
    PangeaMessageEvent? event,
    void Function() callback,
  ) {
    if (multipleChoiceContent == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "in onMultipleChoiceSelect with null multipleChoiceContent",
        s: StackTrace.current,
        data: toJson(),
      );
      return;
    }

    if (practiceTarget.record.hasTextResponse(choice.form) || isComplete) {
      // the user has already selected this choice
      // so we don't want to record it again
      return;
    }

    final bool isCorrect = multipleChoiceContent!.answers.any(
      (answer) => answer.toLowerCase() == choice.form.toLowerCase(),
    );

    // NOTE: the response is associated with the contructId of the choice, not the selected token
    // example: the user selects the word "cat" to match with the emoji 🐶
    // the response is associated with correct word "dog", not the word "cat"
    practiceTarget.record.addResponse(
      cId: choice.cId,
      target: practiceTarget,
      text: choice.form,
      score: isCorrect ? 1 : 0,
    );

    debugPrint(
      "onMultipleChoiceSelect: ${choice.form} ${responseUseType(choice)}",
    );

    MatrixState.pangeaController.putAnalytics.setState(
      AnalyticsStream(
        eventId: event?.eventId,
        roomId: event?.room.id,
        constructs: [
          OneConstructUse(
            useType: responseUseType(choice)!,
            lemma: choice.cId.lemma,
            constructType: choice.cId.type,
            metadata: ConstructUseMetaData(
              roomId: event?.room.id,
              timeStamp: DateTime.now(),
              eventId: event?.eventId,
            ),
            category: choice.cId.category,
            form: choice.form,
          ),
        ],
        targetID: targetTokens.first.text.uniqueKey,
      ),
    );

    callback();
  }

  /// only set up for vocab constructs atm
  void onMatch(
    PangeaToken token,
    ConstructForm choice,
    PangeaMessageEvent? event,
    void Function() callback,
  ) {
    // the user has already selected this choice
    // so we don't want to record it again
    if (practiceTarget.record.hasTextResponse(choice.form) || isComplete) {
      return;
    }

    bool isCorrect = false;
    if (multipleChoiceContent != null) {
      isCorrect = multipleChoiceContent!.answers.any(
        (answer) => answer.toLowerCase() == choice.form.toLowerCase(),
      );
    } else if (matchContent != null) {
      isCorrect = matchContent!.matchInfo[token.vocabConstructID]!
          .contains(choice.form);
    } else {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "in onMatch with null matchContent and multipleChoiceContent",
        s: StackTrace.current,
        data: toJson(),
      );
      return;
    }

    // NOTE: the response is associated with the contructId of the choice, not the selected token
    // example: the user selects the word "cat" to match with the emoji 🐶
    // the response is associated with correct word "dog", not the word "cat"
    practiceTarget.record.addResponse(
      cId: choice.cId,
      text: choice.form,
      target: practiceTarget,
      score: isCorrect ? 1 : 0,
    );

    // we don't take off points for incorrect emoji matches
    if (ActivityTypeEnum.emoji != activityType || isCorrect) {
      MatrixState.pangeaController.putAnalytics.setState(
        AnalyticsStream(
          eventId: event?.eventId,
          roomId: event?.room.id,
          constructs: [
            OneConstructUse(
              useType: responseUseType(choice)!,
              lemma: choice.cId.lemma,
              constructType: choice.cId.type,
              metadata: ConstructUseMetaData(
                roomId: event?.room.id,
                timeStamp: DateTime.now(),
                eventId: event?.eventId,
              ),
              category: choice.cId.category,
              // in the case of a wrong answer, the cId doesn't match the token
              form: token.text.content,
            ),
          ],
          targetID: token.text.uniqueKey,
        ),
      );
    }
    if (isCorrect) {
      if (activityType == ActivityTypeEnum.emoji) {
        // final allEmojis = ;

        choice.cId
            .setUserLemmaInfo(UserSetLemmaInfo(emojis: [choice.form]))
            .then((value) {
          callback();
        });
      }

      if (activityType == ActivityTypeEnum.wordMeaning) {
        choice.cId
            .setUserLemmaInfo(UserSetLemmaInfo(meaning: choice.form))
            .then((value) {
          callback();
        });
      }
    }
    callback();
  }

  bool? wasCorrectChoice(String choice) {
    for (final response in practiceTarget.record.responses) {
      if (response.text == choice) {
        return multipleChoiceContent?.answers
            .any((answer) => answer.toLowerCase() == choice.toLowerCase());
      }
    }
    return null;
  }

  /// if null, it means the user has not yet responded with that choice
  bool? wasCorrectMatch(ConstructForm choice) {
    for (final response in practiceTarget.record.responses) {
      if (response.cId == choice.cId && response.isCorrect) {
        return true;
      }
    }
    for (final response in practiceTarget.record.responses) {
      if (response.cId == choice.cId) {
        return false;
      }
    }
    return null;
  }

  ConstructUseTypeEnum? responseUseType(ConstructForm choice) {
    for (final response in practiceTarget.record.responses) {
      if (response.cId == choice.cId) {
        return response.useType(activityType);
      }
    }
    return null;
  }

  PracticeRecord get record => practiceTarget.record;

  PracticeTarget get practiceTarget => PracticeTarget(
        tokens: targetTokens,
        activityType: activityType,
        userL2: langCode,
        morphFeature: morphFeature,
      );

  String get targetLemma => targetTokens.first.lemma.text;

  String get partOfSpeech => targetTokens.first.pos;

  String get targetWordForm => targetTokens.first.text.content;

  /// we were setting the question copy on creation of the activity
  /// but, in order to localize the question using the same system
  /// as other copy, we should do it with context, when it is built
  /// some types are doing this now, others should be migrated
  String question(BuildContext context, MorphFeaturesEnum? morphFeature) {
    switch (activityType) {
      case ActivityTypeEnum.hiddenWordListening:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.lemmaId:
      case ActivityTypeEnum.messageMeaning:
        return multipleChoiceContent?.question ?? "You can do it!";
      case ActivityTypeEnum.emoji:
        return L10n.of(context).pickAnEmoji(targetLemma, partOfSpeech);
      case ActivityTypeEnum.wordMeaning:
        return L10n.of(context).whatIsMeaning(targetLemma, partOfSpeech);
      case ActivityTypeEnum.morphId:
        return L10n.of(context).whatIsTheMorphTag(
          morphFeature!.getDisplayCopy(context),
          targetWordForm,
        );
    }
  }

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

    if (json['lang_code'] is! String) {
      Sentry.addBreadcrumb(
        Breadcrumb(data: {"json": json}),
      );
      throw ("lang_code is not a string in PracticeActivityModel.fromJson");
    }

    final targetConstructsEntry =
        json['tgt_constructs'] ?? json['target_constructs'];
    if (targetConstructsEntry is! List) {
      Sentry.addBreadcrumb(
        Breadcrumb(data: {"json": json}),
      );
      throw ("tgt_constructs is not a list in PracticeActivityModel.fromJson");
    }

    return PracticeActivityModel(
      langCode: json['lang_code'] as String,
      activityType:
          ActivityTypeEnum.wordMeaning.fromString(json['activity_type']),
      multipleChoiceContent: json['content'] != null
          ? MultipleChoiceActivity.fromJson(contentMap)
          : null,
      targetTokens: (json['target_tokens'] as List)
          .map((e) => PangeaToken.fromJson(e as Map<String, dynamic>))
          .toList(),
      matchContent: json['match_content'] != null
          ? PracticeMatch.fromJson(contentMap)
          : null,
      morphFeature: json['morph_feature'] != null
          ? MorphFeaturesEnumExtension.fromString(
              json['morph_feature'] as String,
            )
          : null,
    );
  }

  RelevantSpanDisplayDetails? get relevantSpanDisplayDetails =>
      multipleChoiceContent?.spanDisplayDetails;

  Map<String, dynamic> toJson() {
    return {
      'lang_code': langCode,
      'activity_type': activityType.string,
      'content': multipleChoiceContent?.toJson(),
      'target_tokens': targetTokens.map((e) => e.toJson()).toList(),
      'match_content': matchContent?.toJson(),
      'morph_feature': morphFeature?.name,
    };
  }

  // override operator == and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PracticeActivityModel &&
        const ListEquality().equals(other.targetTokens, targetTokens) &&
        other.langCode == langCode &&
        other.activityType == activityType &&
        other.multipleChoiceContent == multipleChoiceContent &&
        other.matchContent == matchContent &&
        other.morphFeature == morphFeature;
  }

  @override
  int get hashCode {
    return const ListEquality().hash(targetTokens) ^
        langCode.hashCode ^
        activityType.hashCode ^
        multipleChoiceContent.hashCode ^
        matchContent.hashCode ^
        morphFeature.hashCode;
  }
}
