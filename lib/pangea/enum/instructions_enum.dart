import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

enum InstructionsEnum {
  itInstructions,
  clickMessage,
  blurMeansTranslate,
  tooltipInstructions,
}

extension InstructionsEnumExtension on InstructionsEnum {
  String title(BuildContext context) {
    switch (this) {
      case InstructionsEnum.itInstructions:
        return L10n.of(context)!.itInstructionsTitle;
      case InstructionsEnum.clickMessage:
        return L10n.of(context)!.clickMessageTitle;
      case InstructionsEnum.blurMeansTranslate:
        return L10n.of(context)!.blurMeansTranslateTitle;
      case InstructionsEnum.tooltipInstructions:
        return L10n.of(context)!.tooltipInstructionsTitle;
    }
  }

  String body(BuildContext context) {
    switch (this) {
      case InstructionsEnum.itInstructions:
        return L10n.of(context)!.itInstructionsBody;
      case InstructionsEnum.clickMessage:
        return L10n.of(context)!.clickMessageBody;
      case InstructionsEnum.blurMeansTranslate:
        return L10n.of(context)!.blurMeansTranslateBody;
      case InstructionsEnum.tooltipInstructions:
        return PlatformInfos.isMobile
            ? L10n.of(context)!.tooltipInstructionsMobileBody
            : L10n.of(context)!.tooltipInstructionsBrowserBody;
    }
  }

  bool get toggledOff {
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
    }
  }
}

enum InlineInstructions {
  speechToText,
  l1Translation,
  translationChoices,
}

extension InlineInstructionsExtension on InlineInstructions {
  String body(BuildContext context) {
    switch (this) {
      case InlineInstructions.speechToText:
        return L10n.of(context)!.speechToTextBody;
      case InlineInstructions.l1Translation:
        return L10n.of(context)!.l1TranslationBody;
      case InlineInstructions.translationChoices:
        return L10n.of(context)!.translationChoicesBody;
    }
  }

  bool get toggledOff {
    final instructionSettings =
        MatrixState.pangeaController.userController.profile.instructionSettings;
    switch (this) {
      case InlineInstructions.speechToText:
        return instructionSettings.showedSpeechToTextTooltip;
      case InlineInstructions.l1Translation:
        return instructionSettings.showedL1TranslationTooltip;
      case InlineInstructions.translationChoices:
        return instructionSettings.showedTranslationChoicesTooltip;
    }
  }
}
