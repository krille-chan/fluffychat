import 'package:fluffychat/pangea/enum/instructions_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../config/app_config.dart';
import '../../widgets/matrix.dart';
import '../controllers/pangea_controller.dart';
import '../widgets/common/bot_face_svg.dart';
import '../widgets/igc/card_header.dart';
import 'bot_style.dart';
import 'error_handler.dart';
import 'overlay.dart';

class InstructionsController {
  late PangeaController _pangeaController;

  // We have these three methods to make sure that the instructions are not shown too much

  /// Instruction popup was closed by the user
  final Map<String, bool> _instructionsClosed = {};

  /// Instruction popup has already been shown this session
  final Map<String, bool> _instructionsShown = {};

  InstructionsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  void setToggledOff(
    InstructionsEnum key,
    bool value,
  ) {
    _pangeaController.userController.updateProfile((profile) {
      switch (key) {
        case InstructionsEnum.speechToText:
          profile.instructionSettings.showedSpeechToTextTooltip = value;
          break;
        case InstructionsEnum.l1Translation:
          profile.instructionSettings.showedL1TranslationTooltip = value;
          break;
        case InstructionsEnum.translationChoices:
          profile.instructionSettings.showedTranslationChoicesTooltip = value;
          break;
        case InstructionsEnum.tooltipInstructions:
          profile.instructionSettings.showedTooltipInstructions = value;
          break;
        case InstructionsEnum.itInstructions:
          profile.instructionSettings.showedItInstructions = value;
          break;
        case InstructionsEnum.clickMessage:
          profile.instructionSettings.showedClickMessage = value;
          break;
        case InstructionsEnum.blurMeansTranslate:
          profile.instructionSettings.showedBlurMeansTranslate = value;
          break;
        case InstructionsEnum.clickAgainToDeselect:
          profile.instructionSettings.showedClickAgainToDeselect = value;
          break;
        case InstructionsEnum.missingVoice:
          profile.instructionSettings.showedMissingVoice = value;
          break;
        case InstructionsEnum.clickBestOption:
          profile.instructionSettings.showedClickBestOption = value;
          break;
        case InstructionsEnum.unlockedLanguageTools:
          profile.instructionSettings.showedUnlockedLanguageTools = value;
          break;
      }
      return profile;
    });
  }

  /// Instruction Card gives users tips on
  /// how to use Pangea Chat's features
  Future<void> showInstructionsPopup(
    BuildContext context,
    InstructionsEnum key,
    String transformTargetKey, {
    bool showToggle = true,
    Widget? customContent,
    bool forceShow = false,
  }) async {
    final bool userLangsSet =
        await _pangeaController.userController.areUserLanguagesSet;
    if (!userLangsSet) {
      return;
    }

    if ((_instructionsShown[key.toString()] ?? false) && !forceShow) {
      return;
    }
    _instructionsShown[key.toString()] = true;

    if (key.toggledOff() && !forceShow) {
      return;
    }
    if (L10n.of(context) == null) {
      ErrorHandler.logError(
        m: "null context in ITBotButton.showCard",
        s: StackTrace.current,
      );
      return;
    }

    final botStyle = BotStyle.text(context);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (!context.mounted) return;
        OverlayUtil.showPositionedCard(
          context: context,
          backDropToDismiss: false,
          cardToShow: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardHeader(
                text: key.title(L10n.of(context)!),
                botExpression: BotExpression.idle,
                onClose: () => {_instructionsClosed[key.toString()] = true},
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  key.body(L10n.of(context)!),
                  style: botStyle,
                ),
              ),
              if (customContent != null) customContent,
              if (showToggle) InstructionsToggle(instructionsKey: key),
            ],
          ),
          maxHeight: 300,
          maxWidth: 300,
          transformTargetId: transformTargetKey,
          closePrevOverlay: false,
        );
      },
    );
  }
}

/// User can toggle on to prevent Instruction Card
/// from appearing in future sessions
class InstructionsToggle extends StatefulWidget {
  const InstructionsToggle({
    super.key,
    required this.instructionsKey,
  });

  final InstructionsEnum instructionsKey;

  @override
  InstructionsToggleState createState() => InstructionsToggleState();
}

class InstructionsToggleState extends State<InstructionsToggle> {
  PangeaController pangeaController = MatrixState.pangeaController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      activeColor: AppConfig.activeToggleColor,
      title: Text(L10n.of(context)!.doNotShowAgain),
      value: widget.instructionsKey.toggledOff(),
      onChanged: ((value) async {
        pangeaController.instructions.setToggledOff(
          widget.instructionsKey,
          value,
        );
        setState(() {});
      }),
    );
  }
}
