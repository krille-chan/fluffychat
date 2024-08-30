import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/instructions_enum.dart';
import 'package:fluffychat/pangea/utils/inline_tooltip.dart';
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

  /// Returns true if the user requested this popup not be shown again
  bool? toggledOff(String key) {
    final bool? instruction = InstructionsEnum.values
        .firstWhereOrNull((value) => value.toString() == key)
        ?.toggledOff;
    final bool? tooltip = InlineInstructions.values
        .firstWhereOrNull((value) => value.toString() == key)
        ?.toggledOff;
    return instruction ?? tooltip;
  }

  InstructionsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  /// Returns true if the instructions were closed
  /// or turned off by the user via the toggle switch
  bool wereInstructionsTurnedOff(String key) {
    return toggledOff(key) ?? _instructionsClosed[key] ?? false;
  }

  void turnOffInstruction(String key) => _instructionsClosed[key] = true;

  void updateEnableInstructions(
    String key,
    bool value,
  ) {
    _pangeaController.userController.updateProfile((profile) {
      if (key == InstructionsEnum.itInstructions.toString()) {
        profile.instructionSettings.showedItInstructions = value;
      }
      if (key == InstructionsEnum.clickMessage.toString()) {
        profile.instructionSettings.showedClickMessage = value;
      }
      if (key == InstructionsEnum.blurMeansTranslate.toString()) {
        profile.instructionSettings.showedBlurMeansTranslate = value;
      }
      if (key == InstructionsEnum.tooltipInstructions.toString()) {
        profile.instructionSettings.showedTooltipInstructions = value;
      }
      if (key == InlineInstructions.speechToText.toString()) {
        profile.instructionSettings.showedSpeechToTextTooltip = value;
      }
      if (key == InlineInstructions.l1Translation.toString()) {
        profile.instructionSettings.showedL1TranslationTooltip = value;
      }
      if (key == InlineInstructions.translationChoices.toString()) {
        profile.instructionSettings.showedTranslationChoicesTooltip = value;
      }
      return profile;
    });
  }

  /// Instruction Card gives users tips on
  /// how to use Pangea Chat's features
  Future<void> showInstructionsPopup(
    BuildContext context,
    InstructionsEnum key,
    String transformTargetKey, [
    bool showToggle = true,
  ]) async {
    if (_instructionsShown[key.toString()] ?? false) {
      return;
    }
    _instructionsShown[key.toString()] = true;

    if (wereInstructionsTurnedOff(key.toString())) {
      return;
    }
    if (L10n.of(context) == null) {
      ErrorHandler.logError(
        m: "null context in ITBotButton.showCard",
        s: StackTrace.current,
      );
      return;
    }

    final bool userLangsSet =
        await _pangeaController.userController.areUserLanguagesSet;
    if (!userLangsSet) {
      return;
    }

    final botStyle = BotStyle.text(context);
    Future.delayed(
      const Duration(seconds: 1),
      () => OverlayUtil.showPositionedCard(
        context: context,
        backDropToDismiss: false,
        cardToShow: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardHeader(
              text: key.title(context),
              botExpression: BotExpression.idle,
              onClose: () => {_instructionsClosed[key.toString()] = true},
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    key.body(context),
                    style: botStyle,
                  ),
                ),
              ),
            ),
            if (showToggle) InstructionsToggle(instructionsKey: key),
          ],
        ),
        cardSize: const Size(300.0, 300.0),
        transformTargetId: transformTargetKey,
        closePrevOverlay: false,
      ),
    );
  }

  /// Returns a widget that will be added to existing widget
  /// which displays hint text defined in the enum extension
  Widget getInstructionInlineTooltip(
    BuildContext context,
    InlineInstructions key,
    VoidCallback onClose,
  ) {
    if (wereInstructionsTurnedOff(key.toString())) {
      return const SizedBox();
    }

    if (L10n.of(context) == null) {
      ErrorHandler.logError(
        m: "null context in ITBotButton.showCard",
        s: StackTrace.current,
      );
      return const SizedBox();
    }

    return InlineTooltip(
      body: InlineInstructions.speechToText.body(context),
      onClose: onClose,
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
      value: pangeaController.instructions.wereInstructionsTurnedOff(
        widget.instructionsKey.toString(),
      ),
      onChanged: ((value) async {
        pangeaController.instructions.updateEnableInstructions(
          widget.instructionsKey.toString(),
          value,
        );
        setState(() {});
      }),
    );
  }
}
