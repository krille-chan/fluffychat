import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum InstructionsEnum {
  itInstructions,
  clickMessage,
  blurMeansTranslate,
  tooltipInstructions,
  speechToText,
  l1Translation,
  translationChoices,
  clickAgainToDeselect,
  missingVoice,
  clickBestOption,
  completeActivitiesToUnlock,
  chooseLemmaMeaning,
  activityPlannerOverview,
  ttsDisabled,
  chooseEmoji,
  chooseWordAudio,
  chooseMorphs,
  analyticsVocabList,
  morphAnalyticsList,
  readingAssistanceOverview,
  emptyChatWarning,
}

extension InstructionsEnumExtension on InstructionsEnum {
  String title(L10n l10n) {
    switch (this) {
      case InstructionsEnum.itInstructions:
        return l10n.itInstructionsTitle;
      case InstructionsEnum.clickMessage:
        return l10n.clickMessageTitle;
      case InstructionsEnum.blurMeansTranslate:
        return l10n.blurMeansTranslateTitle;
      case InstructionsEnum.tooltipInstructions:
        return l10n.tooltipInstructionsTitle;
      case InstructionsEnum.missingVoice:
        return l10n.missingVoiceTitle;
      case InstructionsEnum.ttsDisabled:
        return l10n.ttsDisbledTitle;
      case InstructionsEnum.chooseWordAudio:
      case InstructionsEnum.chooseEmoji:
      case InstructionsEnum.activityPlannerOverview:
      case InstructionsEnum.clickAgainToDeselect:
      case InstructionsEnum.speechToText:
      case InstructionsEnum.l1Translation:
      case InstructionsEnum.translationChoices:
      case InstructionsEnum.clickBestOption:
      case InstructionsEnum.completeActivitiesToUnlock:
      case InstructionsEnum.chooseLemmaMeaning:
      case InstructionsEnum.chooseMorphs:
      case InstructionsEnum.analyticsVocabList:
      case InstructionsEnum.morphAnalyticsList:
      case InstructionsEnum.readingAssistanceOverview:
        ErrorHandler.logError(
          e: Exception("No title for this instruction"),
          m: 'InstructionsEnumExtension.title',
          data: {
            'this': this,
          },
        );
        debugger(when: kDebugMode);
        return "";
      case InstructionsEnum.emptyChatWarning:
        return l10n.emptyChatWarningTitle;
    }
  }

  // IconData? get icon {
  //   switch (this) {
  //     case InstructionsEnum.itInstructions:
  //       return Icons.translate;
  //     case InstructionsEnum.clickMessage:
  //       return Icons.touch_app;
  //     case InstructionsEnum.blurMeansTranslate:
  //       return Icons.blur_on;
  //     case InstructionsEnum.tooltipInstructions:
  //       return Icons.help;
  //     case InstructionsEnum.missingVoice:
  //       return Icons.mic_off;
  //   }
  // }

  String body(L10n l10n) {
    switch (this) {
      case InstructionsEnum.itInstructions:
        return l10n.itInstructionsBody;
      case InstructionsEnum.clickMessage:
        return l10n.clickMessageBody;
      case InstructionsEnum.blurMeansTranslate:
        return l10n.blurMeansTranslateBody;
      case InstructionsEnum.speechToText:
        return l10n.speechToTextBody;
      case InstructionsEnum.l1Translation:
        return l10n.l1TranslationBody;
      case InstructionsEnum.translationChoices:
        return l10n.translationChoicesBody;
      case InstructionsEnum.clickAgainToDeselect:
        return l10n.clickTheWordAgainToDeselect;
      case InstructionsEnum.tooltipInstructions:
        return PlatformInfos.isMobile
            ? l10n.tooltipInstructionsMobileBody
            : l10n.tooltipInstructionsBrowserBody;
      case InstructionsEnum.missingVoice:
        return l10n.voiceNotAvailable;
      case InstructionsEnum.clickBestOption:
        return l10n.clickBestOption;
      case InstructionsEnum.completeActivitiesToUnlock:
        return l10n.completeActivitiesToUnlock;
      case InstructionsEnum.chooseLemmaMeaning:
        return l10n.chooseLemmaMeaningInstructionsBody;
      case InstructionsEnum.activityPlannerOverview:
        return l10n.activityPlannerOverviewInstructionsBody;
      case InstructionsEnum.chooseEmoji:
        return l10n.chooseEmojiInstructionsBody;
      case InstructionsEnum.ttsDisabled:
        return l10n.ttsDisabledBody;
      case InstructionsEnum.chooseWordAudio:
        return l10n.chooseWordAudioInstructionsBody;
      case InstructionsEnum.chooseMorphs:
        return l10n.chooseMorphsInstructionsBody;
      case InstructionsEnum.analyticsVocabList:
        return l10n.analyticsVocabListBody;
      case InstructionsEnum.morphAnalyticsList:
        return l10n.morphAnalyticsListBody;
      case InstructionsEnum.readingAssistanceOverview:
        return l10n.readingAssistanceOverviewBody;
      case InstructionsEnum.emptyChatWarning:
        return l10n.emptyChatWarningDesc;
    }
  }

  bool get isToggledOff =>
      MatrixState.pangeaController.userController.profile.instructionSettings
          .getStatus(this);

  void setToggledOff(bool value) {
    final userController = MatrixState.pangeaController.userController;
    final instructionSettings = userController.profile.instructionSettings;
    if (instructionSettings.getStatus(this) == value) return;

    userController.updateProfile((profile) {
      profile.instructionSettings.setStatus(this, value);
      return profile;
    });
  }
}
