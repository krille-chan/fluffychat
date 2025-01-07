import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/utils/error_handler.dart';
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
  unlockedLanguageTools,
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
      case InstructionsEnum.clickAgainToDeselect:
      case InstructionsEnum.speechToText:
      case InstructionsEnum.l1Translation:
      case InstructionsEnum.translationChoices:
      case InstructionsEnum.clickBestOption:
      case InstructionsEnum.unlockedLanguageTools:
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
      case InstructionsEnum.unlockedLanguageTools:
        return l10n.unlockedLanguageTools;
    }
  }

  bool toggledOff() {
    final instructionSettings =
        MatrixState.pangeaController.userController.profile.instructionSettings;
    switch (this) {
      case InstructionsEnum.itInstructions:
        return instructionSettings.showedItInstructions;
      case InstructionsEnum.clickMessage:
        return instructionSettings.showedClickMessage;
      case InstructionsEnum.blurMeansTranslate:
        return instructionSettings.showedBlurMeansTranslate;
      case InstructionsEnum.tooltipInstructions:
        return instructionSettings.showedTooltipInstructions;
      case InstructionsEnum.speechToText:
        return instructionSettings.showedSpeechToTextTooltip;
      case InstructionsEnum.l1Translation:
        return instructionSettings.showedL1TranslationTooltip;
      case InstructionsEnum.translationChoices:
        return instructionSettings.showedTranslationChoicesTooltip;
      case InstructionsEnum.clickAgainToDeselect:
        return instructionSettings.showedClickAgainToDeselect;
      case InstructionsEnum.missingVoice:
        return instructionSettings.showedMissingVoice;
      case InstructionsEnum.clickBestOption:
        return instructionSettings.showedClickBestOption;
      case InstructionsEnum.unlockedLanguageTools:
        return instructionSettings.showedUnlockedLanguageTools;
    }
  }
}
