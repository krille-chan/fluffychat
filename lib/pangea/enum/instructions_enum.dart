import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

enum InstructionsEnum {
  itInstructions,
  clickMessage,
  blurMeansTranslate,
  tooltipInstructions,
  speechToText,
}

extension Copy on InstructionsEnum {
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
      case InstructionsEnum.speechToText:
        return L10n.of(context)!.hintTitle;
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
      case InstructionsEnum.speechToText:
        return L10n.of(context)!.speechToTextBody;
      case InstructionsEnum.tooltipInstructions:
        return PlatformInfos.isMobile
            ? L10n.of(context)!.tooltipInstructionsMobileBody
            : L10n.of(context)!.tooltipInstructionsBrowserBody;
    }
  }

  Widget inlineTooltip(BuildContext context) {
    switch (this) {
      case InstructionsEnum.speechToText:
        return Column(
          children: [
            Text(
              title(context),
              style: BotStyle.text(context),
            ),
            Text(
              body(context),
              style: BotStyle.text(context),
            ),
            // ),
          ],
        );
      default:
        debugPrint('inlineTooltip not implemented for $this');
        return const SizedBox();
    }
  }
}
