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
  lemmaMeaning,
  activityPlannerOverview,
  ttsDisabled,
  chooseEmoji,
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
      case InstructionsEnum.chooseEmoji:
      case InstructionsEnum.activityPlannerOverview:
      case InstructionsEnum.clickAgainToDeselect:
      case InstructionsEnum.speechToText:
      case InstructionsEnum.l1Translation:
      case InstructionsEnum.translationChoices:
      case InstructionsEnum.clickBestOption:
      case InstructionsEnum.completeActivitiesToUnlock:
      case InstructionsEnum.lemmaMeaning:
        ErrorHandler.logError(
          e: Exception("No title for this instruction"),
          m: 'InstructionsEnumExtension.title',
          data: {
            'this': this,
          },
        );
        debugger(when: kDebugMode);
        return "";
    }
  }

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
      case InstructionsEnum.lemmaMeaning:
        return l10n.lemmaMeaningInstructionsBody;
      case InstructionsEnum.activityPlannerOverview:
        return l10n.activityPlannerOverviewInstructionsBody;
      case InstructionsEnum.chooseEmoji:
        return l10n.chooseEmojiInstructionsBody;
      case InstructionsEnum.ttsDisabled:
        return l10n.ttsDisabledBody;
    }
  }

  bool get isToggledOff =>
      MatrixState.pangeaController.userController.profile.instructionSettings
          .getStatus(this);

  void setToggledOff(bool value) =>
      MatrixState.pangeaController.userController.updateProfile((profile) {
        profile.instructionSettings.setStatus(this, value);
        return profile;
      });
}
