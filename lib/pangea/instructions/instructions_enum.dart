import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum InstructionsEnum {
  clickMessage,
  speechToText,
  l1Translation,
  translationChoices,
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
  activityAnalyticsList,
  levelAnalytics,
  readingAssistanceOverview,
  emptyChatWarning,
  activityStatsMenu,
  chatListTooltip,
}

extension InstructionsEnumExtension on InstructionsEnum {
  String title(L10n l10n) {
    switch (this) {
      case InstructionsEnum.clickMessage:
        return l10n.clickMessageTitle;
      case InstructionsEnum.ttsDisabled:
        return l10n.ttsDisbledTitle;
      case InstructionsEnum.chooseWordAudio:
      case InstructionsEnum.chooseEmoji:
      case InstructionsEnum.activityPlannerOverview:
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
      case InstructionsEnum.activityStatsMenu:
      case InstructionsEnum.chatListTooltip:
      case InstructionsEnum.activityAnalyticsList:
      case InstructionsEnum.levelAnalytics:
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

  String body(L10n l10n) {
    switch (this) {
      case InstructionsEnum.clickMessage:
        return l10n.clickMessageBody;
      case InstructionsEnum.speechToText:
        return l10n.speechToTextBody;
      case InstructionsEnum.l1Translation:
        return l10n.l1TranslationBody;
      case InstructionsEnum.translationChoices:
        return l10n.translationChoicesBody;
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
      case InstructionsEnum.activityAnalyticsList:
        return l10n.activityAnalyticsTooltipBody;
      case InstructionsEnum.readingAssistanceOverview:
        return l10n.readingAssistanceOverviewBody;
      case InstructionsEnum.emptyChatWarning:
        return l10n.emptyChatWarningDesc;
      case InstructionsEnum.activityStatsMenu:
        return l10n.activityStatsButtonInstruction;
      case InstructionsEnum.chatListTooltip:
        return l10n.chatListTooltip;
      case InstructionsEnum.levelAnalytics:
        return l10n.levelInfoTooltip;
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
