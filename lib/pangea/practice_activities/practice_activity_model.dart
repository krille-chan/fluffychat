import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_session_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_match.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';

sealed class PracticeActivityModel {
  final List<PangeaToken> tokens;
  final String langCode;

  const PracticeActivityModel({required this.tokens, required this.langCode});

  String get storageKey =>
      '${activityType.name}-${tokens.map((e) => e.text.content).join("-")}';

  PracticeTarget get practiceTarget => PracticeTarget(
    activityType: activityType,
    tokens: tokens,
    morphFeature: this is MorphPracticeActivityModel
        ? (this as MorphPracticeActivityModel).morphFeature
        : null,
  );

  bool isCorrect(String choice, PangeaToken token) => false;

  ActivityTypeEnum get activityType {
    switch (this) {
      case MorphCategoryPracticeActivityModel():
        return ActivityTypeEnum.grammarCategory;
      case VocabAudioPracticeActivityModel():
        return ActivityTypeEnum.lemmaAudio;
      case VocabMeaningPracticeActivityModel():
        return ActivityTypeEnum.lemmaMeaning;
      case EmojiPracticeActivityModel():
        return ActivityTypeEnum.emoji;
      case LemmaPracticeActivityModel():
        return ActivityTypeEnum.lemmaId;
      case LemmaMeaningPracticeActivityModel():
        return ActivityTypeEnum.wordMeaning;
      case MorphMatchPracticeActivityModel():
        return ActivityTypeEnum.morphId;
      case WordListeningPracticeActivityModel():
        return ActivityTypeEnum.wordFocusListening;
      case GrammarErrorPracticeActivityModel():
        return ActivityTypeEnum.grammarError;
    }
  }

  factory PracticeActivityModel.fromJson(Map<String, dynamic> json) {
    if (json['lang_code'] is! String) {
      Sentry.addBreadcrumb(Breadcrumb(data: {"json": json}));
      throw ("lang_code is not a string in PracticeActivityModel.fromJson");
    }

    final targetConstructsEntry =
        json['tgt_constructs'] ?? json['target_constructs'];
    if (targetConstructsEntry is! List) {
      Sentry.addBreadcrumb(Breadcrumb(data: {"json": json}));
      throw ("tgt_constructs is not a list in PracticeActivityModel.fromJson");
    }

    final type = ActivityTypeEnum.fromString(json['activity_type']);

    final morph = json['morph_feature'] != null
        ? MorphFeaturesEnumExtension.fromString(json['morph_feature'] as String)
        : null;

    final tokens = (json['target_tokens'] as List)
        .map((e) => PangeaToken.fromJson(e as Map<String, dynamic>))
        .toList();

    final langCode = json['lang_code'] as String;

    final multipleChoiceContent = json['content'] != null
        ? MultipleChoiceActivity.fromJson(
            json['content'] as Map<String, dynamic>,
          )
        : null;

    final matchContent = json['match_content'] != null
        ? PracticeMatchActivity.fromJson(
            json['match_content'] as Map<String, dynamic>,
          )
        : null;

    switch (type) {
      case ActivityTypeEnum.grammarCategory:
        assert(
          morph != null,
          "morphFeature is null in PracticeActivityModel.fromJson for grammarCategory",
        );
        assert(
          multipleChoiceContent != null,
          "multipleChoiceContent is null in PracticeActivityModel.fromJson for grammarCategory",
        );
        return MorphCategoryPracticeActivityModel(
          langCode: langCode,
          tokens: tokens,
          morphFeature: morph!,
          multipleChoiceContent: multipleChoiceContent!,
          exampleMessageInfo: json['example_message_info'] != null
              ? ExampleMessageInfo.fromJson(json['example_message_info'])
              : const ExampleMessageInfo(exampleMessage: []),
        );
      case ActivityTypeEnum.lemmaAudio:
        assert(
          multipleChoiceContent != null,
          "multipleChoiceContent is null in PracticeActivityModel.fromJson for lemmaAudio",
        );
        return VocabAudioPracticeActivityModel(
          langCode: langCode,
          tokens: tokens,
          multipleChoiceContent: multipleChoiceContent!,
          roomId: json['room_id'] as String?,
          eventId: json['event_id'] as String?,
          exampleMessage: json['example_message'] != null
              ? ExampleMessageInfo.fromJson(json['example_message'])
              : const ExampleMessageInfo(exampleMessage: []),
        );
      case ActivityTypeEnum.lemmaMeaning:
        assert(
          multipleChoiceContent != null,
          "multipleChoiceContent is null in PracticeActivityModel.fromJson for lemmaMeaning",
        );
        return VocabMeaningPracticeActivityModel(
          langCode: langCode,
          tokens: tokens,
          multipleChoiceContent: multipleChoiceContent!,
        );
      case ActivityTypeEnum.emoji:
        assert(
          matchContent != null,
          "matchContent is null in PracticeActivityModel.fromJson for emoji",
        );
        return EmojiPracticeActivityModel(
          langCode: langCode,
          tokens: tokens,
          matchContent: matchContent!,
        );
      case ActivityTypeEnum.lemmaId:
        assert(
          multipleChoiceContent != null,
          "multipleChoiceContent is null in PracticeActivityModel.fromJson for lemmaId",
        );
        return LemmaPracticeActivityModel(
          langCode: langCode,
          tokens: tokens,
          multipleChoiceContent: multipleChoiceContent!,
        );
      case ActivityTypeEnum.wordMeaning:
        assert(
          matchContent != null,
          "matchContent is null in PracticeActivityModel.fromJson for wordMeaning",
        );
        return LemmaMeaningPracticeActivityModel(
          langCode: langCode,
          tokens: tokens,
          matchContent: matchContent!,
        );
      case ActivityTypeEnum.morphId:
        assert(
          morph != null,
          "morphFeature is null in PracticeActivityModel.fromJson for morphId",
        );
        assert(
          multipleChoiceContent != null,
          "multipleChoiceContent is null in PracticeActivityModel.fromJson for morphId",
        );
        return MorphMatchPracticeActivityModel(
          langCode: langCode,
          tokens: tokens,
          morphFeature: morph!,
          multipleChoiceContent: multipleChoiceContent!,
        );
      case ActivityTypeEnum.wordFocusListening:
        assert(
          matchContent != null,
          "matchContent is null in PracticeActivityModel.fromJson for wordFocusListening",
        );
        return WordListeningPracticeActivityModel(
          langCode: langCode,
          tokens: tokens,
          matchContent: matchContent!,
        );
      case ActivityTypeEnum.grammarError:
        assert(
          multipleChoiceContent != null,
          "multipleChoiceContent is null in PracticeActivityModel.fromJson for grammarError",
        );
        return GrammarErrorPracticeActivityModel(
          langCode: langCode,
          tokens: tokens,
          multipleChoiceContent: multipleChoiceContent!,
          text: json['text'] as String,
          errorOffset: json['error_offset'] as int,
          errorLength: json['error_length'] as int,
          eventID: json['event_id'] as String,
          translation: json['translation'] as String,
        );
      default:
        throw ("Unsupported activity type in PracticeActivityModel.fromJson: $type");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'lang_code': langCode,
      'activity_type': activityType.name,
      'target_tokens': tokens.map((e) => e.toJson()).toList(),
    };
  }
}

sealed class MultipleChoicePracticeActivityModel extends PracticeActivityModel {
  final MultipleChoiceActivity multipleChoiceContent;

  MultipleChoicePracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required this.multipleChoiceContent,
  });

  @override
  bool isCorrect(String choice, PangeaToken _) =>
      multipleChoiceContent.isCorrect(choice);

  List<OneConstructUse> constructUses(String choiceContent) {
    final correct = multipleChoiceContent.isCorrect(choiceContent);
    final useType = correct
        ? activityType.correctUse
        : activityType.incorrectUse;

    return tokens
        .map(
          (token) => OneConstructUse(
            useType: useType,
            constructType: activityType.constructUsesType,
            metadata: ConstructUseMetaData(
              roomId: null,
              timeStamp: DateTime.now(),
            ),
            category: token.pos,
            lemma: token.lemma.text,
            form: token.lemma.text,
            xp: useType.pointValue,
          ),
        )
        .toList();
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['content'] = multipleChoiceContent.toJson();
    return json;
  }
}

sealed class MatchPracticeActivityModel extends PracticeActivityModel {
  final PracticeMatchActivity matchContent;

  MatchPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required this.matchContent,
  });

  @override
  bool isCorrect(String choice, PangeaToken token) =>
      matchContent.matchInfo[token.vocabForm]!.contains(choice);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['match_content'] = matchContent.toJson();
    return json;
  }
}

sealed class MorphPracticeActivityModel
    extends MultipleChoicePracticeActivityModel {
  final MorphFeaturesEnum morphFeature;

  MorphPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.multipleChoiceContent,
    required this.morphFeature,
  });

  @override
  String get storageKey =>
      '${activityType.name}-${tokens.map((e) => e.text.content).join("-")}-${morphFeature.name}';

  @override
  List<OneConstructUse> constructUses(String choiceContent) {
    final correct = multipleChoiceContent.isCorrect(choiceContent);
    final useType = correct
        ? activityType.correctUse
        : activityType.incorrectUse;

    return tokens
        .map(
          (token) => OneConstructUse(
            useType: useType,
            constructType: activityType.constructUsesType,
            metadata: ConstructUseMetaData(
              roomId: null,
              timeStamp: DateTime.now(),
            ),
            category: morphFeature.name,
            lemma: token.getMorphTag(morphFeature)!,
            form: token.lemma.form,
            xp: useType.pointValue,
          ),
        )
        .toList();
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['morph_feature'] = morphFeature.name;
    return json;
  }
}

class MorphCategoryPracticeActivityModel extends MorphPracticeActivityModel {
  final ExampleMessageInfo exampleMessageInfo;
  MorphCategoryPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.morphFeature,
    required super.multipleChoiceContent,
    required this.exampleMessageInfo,
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['example_message_info'] = exampleMessageInfo.toJson();
    return json;
  }
}

class MorphMatchPracticeActivityModel extends MorphPracticeActivityModel {
  MorphMatchPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.morphFeature,
    required super.multipleChoiceContent,
  });
}

class VocabAudioPracticeActivityModel
    extends MultipleChoicePracticeActivityModel {
  final String? roomId;
  final String? eventId;
  final ExampleMessageInfo exampleMessage;

  VocabAudioPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.multipleChoiceContent,
    this.roomId,
    this.eventId,
    required this.exampleMessage,
  });

  @override
  List<OneConstructUse> constructUses(String choiceContent) {
    final correct = multipleChoiceContent.isCorrect(choiceContent);
    final useType = correct
        ? activityType.correctUse
        : activityType.incorrectUse;

    // For audio activities, find the token that matches the clicked word
    final matchingToken = tokens.firstWhere(
      (t) => t.text.content.toLowerCase() == choiceContent.toLowerCase(),
      orElse: () => tokens.first,
    );

    return [
      OneConstructUse(
        useType: useType,
        constructType: activityType.constructUsesType,
        metadata: ConstructUseMetaData(roomId: null, timeStamp: DateTime.now()),
        category: matchingToken.pos,
        lemma: matchingToken.lemma.text,
        form: matchingToken.lemma.text,
        xp: useType.pointValue,
      ),
    ];
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['room_id'] = roomId;
    json['event_id'] = eventId;
    json['example_message'] = exampleMessage.toJson();
    return json;
  }
}

class VocabMeaningPracticeActivityModel
    extends MultipleChoicePracticeActivityModel {
  VocabMeaningPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.multipleChoiceContent,
  });
}

class LemmaPracticeActivityModel extends MultipleChoicePracticeActivityModel {
  LemmaPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.multipleChoiceContent,
  });
}

class GrammarErrorPracticeActivityModel
    extends MultipleChoicePracticeActivityModel {
  final String text;
  final int errorOffset;
  final int errorLength;
  final String eventID;
  final String translation;

  GrammarErrorPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.multipleChoiceContent,
    required this.text,
    required this.errorOffset,
    required this.errorLength,
    required this.eventID,
    required this.translation,
  });

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['text'] = text;
    json['error_offset'] = errorOffset;
    json['error_length'] = errorLength;
    json['event_id'] = eventID;
    json['translation'] = translation;
    return json;
  }
}

class EmojiPracticeActivityModel extends MatchPracticeActivityModel {
  EmojiPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.matchContent,
  });
}

class LemmaMeaningPracticeActivityModel extends MatchPracticeActivityModel {
  LemmaMeaningPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.matchContent,
  });
}

class WordListeningPracticeActivityModel extends MatchPracticeActivityModel {
  WordListeningPracticeActivityModel({
    required super.tokens,
    required super.langCode,
    required super.matchContent,
  });
}
