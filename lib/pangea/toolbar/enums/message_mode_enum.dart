import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

enum MessageMode {
  practiceActivity,

  wordZoom,
  wordEmoji,
  wordMeaning,
  wordMorph,
  // wordZoomTextToSpeech,
  // wordZoomSpeechToText,

  messageMeaning,
  listening,
  messageSpeechToText,
  messageTranslation,

  // message not selected
  noneSelected,
}

extension MessageModeExtension on MessageMode {
  IconData get icon {
    switch (this) {
      case MessageMode.messageTranslation:
        return Icons.translate;
      case MessageMode.listening:
        return Icons.volume_up;
      case MessageMode.messageSpeechToText:
        return Symbols.speech_to_text;
      case MessageMode.practiceActivity:
        return Symbols.fitness_center;
      case MessageMode.wordZoom:
      case MessageMode.wordMeaning:
        return Symbols.dictionary;
      case MessageMode.noneSelected:
        return Icons.error;
      case MessageMode.messageMeaning:
        return Icons.star;
      case MessageMode.wordEmoji:
        return Icons.add_reaction_outlined;
      case MessageMode.wordMorph:
        return Symbols.toys_and_games;
    }
  }

  String title(BuildContext context) {
    switch (this) {
      case MessageMode.messageTranslation:
        return L10n.of(context).translations;
      case MessageMode.listening:
        return L10n.of(context).messageAudio;
      case MessageMode.messageSpeechToText:
        return L10n.of(context).speechToTextTooltip;
      case MessageMode.practiceActivity:
        return L10n.of(context).practice;
      case MessageMode.wordZoom:
        return L10n.of(context).vocab;
      case MessageMode.noneSelected:
        return '';
      case MessageMode.messageMeaning:
        return L10n.of(context).meaning;
      //TODO: add L10n
      case MessageMode.wordEmoji:
        return "Emoji";
      case MessageMode.wordMorph:
        return "Grammar";
      case MessageMode.wordMeaning:
        return "Meaning";
    }
  }

  String tooltip(BuildContext context) {
    switch (this) {
      case MessageMode.messageTranslation:
        return L10n.of(context).translationTooltip;
      case MessageMode.listening:
        return L10n.of(context).listen;
      case MessageMode.messageSpeechToText:
        return L10n.of(context).speechToTextTooltip;
      case MessageMode.practiceActivity:
        return L10n.of(context).practice;
      case MessageMode.wordZoom:
        return L10n.of(context).vocab;
      case MessageMode.noneSelected:
        return '';
      case MessageMode.messageMeaning:
        return L10n.of(context).meaning;
      //TODO: add L10n
      case MessageMode.wordEmoji:
        return "Emoji";
      case MessageMode.wordMorph:
        return "Grammar";
      case MessageMode.wordMeaning:
        return "Meaning";
    }
  }

  InstructionsEnum? get instructionsEnum {
    switch (this) {
      case MessageMode.wordMorph:
        return InstructionsEnum.chooseMorphs;
      case MessageMode.messageSpeechToText:
        return InstructionsEnum.speechToText;
      case MessageMode.wordMeaning:
        return InstructionsEnum.chooseLemmaMeaning;
      case MessageMode.listening:
        return InstructionsEnum.chooseWordAudio;
      case MessageMode.wordEmoji:
        return InstructionsEnum.chooseEmoji;
      case MessageMode.noneSelected:
        return InstructionsEnum.readingAssistanceOverview;
      case MessageMode.messageTranslation:
      case MessageMode.messageMeaning:
      case MessageMode.wordZoom:
      case MessageMode.practiceActivity:
        return null;
    }
  }

  double get pointOnBar {
    switch (this) {
      // case MessageMode.stats:
      //   return 1;
      case MessageMode.noneSelected:
        return 1;
      case MessageMode.wordMorph:
        return 0.7;
      case MessageMode.wordMeaning:
        return 0.5;
      case MessageMode.listening:
        return 0.3;
      case MessageMode.messageTranslation:
      case MessageMode.messageSpeechToText:
      case MessageMode.wordZoom:
      case MessageMode.wordEmoji:
      case MessageMode.messageMeaning:
      case MessageMode.practiceActivity:
        return 0;
    }
  }

  bool isUnlocked(
    MessageOverlayController overlayController,
  ) {
    switch (this) {
      case MessageMode.messageTranslation:
        return overlayController.isTranslationUnlocked;
      case MessageMode.practiceActivity:
      case MessageMode.listening:
      case MessageMode.messageSpeechToText:
      case MessageMode.messageMeaning:
      case MessageMode.wordZoom:
      case MessageMode.wordEmoji:
      case MessageMode.wordMorph:
      case MessageMode.wordMeaning:
      case MessageMode.noneSelected:
        return true;
    }
  }

  bool get showButton => this != MessageMode.practiceActivity;

  bool isModeDone(MessageOverlayController overlayController) {
    switch (this) {
      case MessageMode.messageTranslation:
        return overlayController.isTotallyDone;
      case MessageMode.listening:
        return overlayController.isListeningDone;
      case MessageMode.wordEmoji:
        return overlayController.isEmojiDone;
      case MessageMode.wordMorph:
        return overlayController.isMorphDone;
      case MessageMode.wordMeaning:
        return overlayController.isMeaningDone;
      default:
        return false;
    }
  }

  Color iconButtonColor(
    BuildContext context,
    MessageOverlayController overlayController,
  ) {
    if (overlayController.isTotallyDone) {
      return AppConfig.gold;
    }

    //locked
    if (!isUnlocked(overlayController)) {
      return barAndLockedButtonColor(context);
    }

    //unlocked
    return isModeDone(overlayController)
        ? AppConfig.gold
        : Theme.of(context).colorScheme.primaryContainer;
  }

  static Color barAndLockedButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[200]!;
  }

  ActivityTypeEnum? get associatedActivityType {
    switch (this) {
      case MessageMode.wordMeaning:
        return ActivityTypeEnum.wordMeaning;
      case MessageMode.listening:
        return ActivityTypeEnum.wordFocusListening;

      case MessageMode.wordEmoji:
        return ActivityTypeEnum.emoji;

      case MessageMode.wordMorph:
        return ActivityTypeEnum.morphId;

      case MessageMode.noneSelected:
      case MessageMode.messageMeaning:
      case MessageMode.messageTranslation:
      case MessageMode.wordZoom:
      case MessageMode.messageSpeechToText:
      case MessageMode.practiceActivity:
        return null;
    }
  }

  /// returns a nullable string of the current level of the message
  /// if string is null, then user has completed all levels
  /// should be resolvable into a part of speech or morph feature using fromString
  /// of the respective enum, PartOfSpeechEnum or MorphFeatureEnum
  String? currentChoiceMode(
    MessageOverlayController overlayController,
    PangeaMessageEvent pangeaMessage,
  ) {
    switch (this) {
      case MessageMode.wordMeaning:
      case MessageMode.listening:
      case MessageMode.wordEmoji:
        // get the pos with some tokens left to practice, from most to least important for learning
        return pangeaMessage.messageDisplayRepresentation!
            .posSetToPractice(associatedActivityType!)
            .firstWhereOrNull(
              (pos) => pangeaMessage.messageDisplayRepresentation!.tokens!.any(
                (t) => t.vocabConstructID.isActivityProbablyLevelAppropriate(
                  associatedActivityType!,
                  t.text.content,
                ),
              ),
            )
            ?.name;

      case MessageMode.wordMorph:
        // get the morph feature with some tokens left to practice, from most to least important for learning
        return pangeaMessage
            .messageDisplayRepresentation!.morphFeatureSetToPractice
            .firstWhereOrNull(
              (feature) =>
                  pangeaMessage.messageDisplayRepresentation!.tokens!.any((t) {
                final String? morphTag = t.getMorphTag(feature.name);

                if (morphTag == null) {
                  return false;
                }

                return ConstructIdentifier(
                  lemma: morphTag,
                  type: ConstructTypeEnum.morph,
                  category: feature.name,
                ).isActivityProbablyLevelAppropriate(
                  associatedActivityType!,
                  t.text.content,
                );
              }),
            )
            ?.name;

      case MessageMode.noneSelected:
      case MessageMode.messageMeaning:
      case MessageMode.messageTranslation:
      case MessageMode.wordZoom:
      case MessageMode.messageSpeechToText:
      case MessageMode.practiceActivity:
        return null;
    }

    // final feature = MorphFeaturesEnumExtension.fromString(overlayController);

    // if (feature != null) {
    //   for (int i; i < pangeaMessage.messageDisplayRepresentation!.morphFeatureSetToPractice.length; i++) {
    //     if (pangeaMessage.messageDisplayRepresentation?.tagsByFeature(feature).isNotEmpty ?? false) {
    //       return i;
    //     }
    //   }

    //   for (final feature in pangeaMessage.messageDisplayRepresentation?.tagsByFeature(feature)) ?? []) {
    //     if (pangeaMessage.messageDisplayRepresentation?.tagsByFeature(feature).isNotEmpty ?? false) {
    //       return feature.index;
    //     }
    //   }
    // }
  }

  // List<MessageModeChoiceLevelWidget> messageModeChoiceLevel(
  //   MessageOverlayController overlayController,
  //   PangeaMessageEvent pangeaMessage,
  // ) {
  //   switch (this) {
  //     case MessageMode.wordMorph:
  //       final morphFeatureSet = pangeaMessage
  //           .messageDisplayRepresentation?.morphFeatureSetToPractice;

  //       if (morphFeatureSet == null) {
  //         debugger(when: kDebugMode);
  //         return [];
  //       }

  //       // sort by the list of priority of parts of speech, defined by their order in the enum
  //       morphFeatureSet.toList().sort((a, b) => a.index.compareTo(b.index));

  //       debugPrint(
  //         "morphFeatureSet: ${morphFeatureSet.map((e) => e.name).toList()}",
  //       );
  //       return morphFeatureSet
  //           .map(
  //             (feature) => MessageModeChoiceLevelWidget(
  //               overlayController: overlayController,
  //               pangeaMessageEvent: pangeaMessage,
  //               morphFeature: feature,
  //             ),
  //           )
  //           .toList();
  //     case MessageMode.noneSelected:
  //     case MessageMode.messageMeaning:
  //     case MessageMode.messageTranslation:
  //     case MessageMode.messageTextToSpeech:
  //     case MessageMode.messageSpeechToText:
  //     case MessageMode.practiceActivity:
  //     case MessageMode.wordZoom:
  //     case MessageMode.wordMeaning:
  //     case MessageMode.wordEmoji:
  //       if (associatedActivityType == null) {
  //         debugger(when: kDebugMode);
  //         return [];
  //       }
  //       final posSet = pangeaMessage.messageDisplayRepresentation
  //           ?.posSetToPractice(associatedActivityType!);

  //       if (posSet == null) {
  //         debugger(when: kDebugMode);
  //         return [];
  //       }

  //       // sort by the list of priority of parts of speech, defined by their order in the enum
  //       posSet.toList().sort((a, b) => a.index.compareTo(b.index));

  //       debugPrint("posSet: ${posSet.map((e) => e.name).toList()}");

  //       final widgets = posSet
  //           .map(
  //             (pos) => MessageModeChoiceLevelWidget(
  //               partOfSpeech: pos,
  //               overlayController: overlayController,
  //               pangeaMessageEvent: pangeaMessage,
  //             ),
  //           )
  //           .toList();

  //       return widgets;
  //   }
  // }
}
