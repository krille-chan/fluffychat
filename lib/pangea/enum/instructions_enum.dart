import 'dart:developer';

import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

enum InstructionsEnum {
  itInstructions,
  clickMessage,
  blurMeansTranslate,
  tooltipInstructions,
  speechToText,
  l1Translation,
  translationChoices,
  clickAgainToDeselect,
}

extension InstructionsEnumExtension on InstructionsEnum {
  String title(BuildContext context) {
    if (!context.mounted) {
      ErrorHandler.logError(
        e: Exception("Context not mounted"),
        m: 'InstructionsEnumExtension.title for $this',
      );
      debugger(when: kDebugMode);
      return '';
    }
    switch (this) {
      case InstructionsEnum.itInstructions:
        return L10n.of(context)!.itInstructionsTitle;
      case InstructionsEnum.clickMessage:
        return L10n.of(context)!.clickMessageTitle;
      case InstructionsEnum.blurMeansTranslate:
        return L10n.of(context)!.blurMeansTranslateTitle;
      case InstructionsEnum.tooltipInstructions:
        return L10n.of(context)!.tooltipInstructionsTitle;
      case InstructionsEnum.clickAgainToDeselect:
      case InstructionsEnum.speechToText:
      case InstructionsEnum.l1Translation:
      case InstructionsEnum.translationChoices:
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

  String body(BuildContext context) {
    if (!context.mounted) {
      ErrorHandler.logError(
        e: Exception("Context not mounted"),
        m: 'InstructionsEnumExtension.body for $this',
      );
      debugger(when: kDebugMode);
      return "";
    }
    switch (this) {
      case InstructionsEnum.itInstructions:
        return L10n.of(context)!.itInstructionsBody;
      case InstructionsEnum.clickMessage:
        return L10n.of(context)!.clickMessageBody;
      case InstructionsEnum.blurMeansTranslate:
        return L10n.of(context)!.blurMeansTranslateBody;
      case InstructionsEnum.speechToText:
        return L10n.of(context)!.speechToTextBody;
      case InstructionsEnum.l1Translation:
        return L10n.of(context)!.l1TranslationBody;
      case InstructionsEnum.translationChoices:
        return L10n.of(context)!.translationChoicesBody;
      case InstructionsEnum.clickAgainToDeselect:
        return L10n.of(context)!.clickTheWordAgainToDeselect;
      case InstructionsEnum.tooltipInstructions:
        return PlatformInfos.isMobile
            ? L10n.of(context)!.tooltipInstructionsMobileBody
            : L10n.of(context)!.tooltipInstructionsBrowserBody;
    }
  }

  bool toggledOff(BuildContext context) {
    if (!context.mounted) {
      ErrorHandler.logError(
        e: Exception("Context not mounted"),
        m: 'InstructionsEnumExtension.toggledOff for $this',
      );
      debugger(when: kDebugMode);
      return false;
    }
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
    }
  }
}
