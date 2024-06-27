import 'package:fluffychat/utils/platform_infos.dart';
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

  /// Instruction popup was closed by the user
  final Map<InstructionsEnum, bool> _instructionsClosed = {};

  /// Instructions that were shown in that session
  final Map<InstructionsEnum, bool> _instructionsShown = {};

  /// Returns true if the instructions were turned off by the user via the toggle switch
  bool? toggledOff(InstructionsEnum key) =>
      _pangeaController.pStoreService.read(key.toString());

  /// We have these three methods to make sure that the instructions are not shown too much

  InstructionsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  /// Returns true if the instructions were turned off by the user
  /// via the toggle switch
  bool wereInstructionsTurnedOff(InstructionsEnum key) =>
      toggledOff(key) ?? _instructionsClosed[key] ?? false;

  Future<void> updateEnableInstructions(
    InstructionsEnum key,
    bool value,
  ) async =>
      await _pangeaController.pStoreService.save(
        key.toString(),
        value,
      );

  // return a text widget with constainer that expands to fill a parent container
  // and displays instructions text defined in the enum extension
  Future<Widget> getInlineTooltip(
    BuildContext context,
    InstructionsEnum key,
  ) async {
    if (wereInstructionsTurnedOff(key)) {
      return const SizedBox();
    }
    if (L10n.of(context) == null) {
      ErrorHandler.logError(
        m: "null context in ITBotButton.showCard",
        s: StackTrace.current,
      );
      return const SizedBox();
    }
    if (_instructionsShown[key] ?? false) {
      return const SizedBox();
    }

    return key.inlineTooltip(context);
  }

  Future<void> showInstructionsPopup(
    BuildContext context,
    InstructionsEnum key,
    String transformTargetKey, [
    bool showToggle = true,
  ]) async {
    if (wereInstructionsTurnedOff(key)) {
      return;
    }
    if (L10n.of(context) == null) {
      ErrorHandler.logError(
        m: "null context in ITBotButton.showCard",
        s: StackTrace.current,
      );
      return;
    }
    if (_instructionsShown[key] ?? false) {
      return;
    }

    final bool userLangsSet =
        await _pangeaController.userController.areUserLanguagesSet;
    if (!userLangsSet) {
      return;
    }

    _instructionsShown[key] = true;

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
              botExpression: BotExpression.surprised,
              onClose: () => {_instructionsClosed[key] = true},
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
}

enum InstructionsEnum {
  itInstructions,
  clickMessage,
  blurMeansTranslate,
  tooltipInstructions,
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

  Widget inlineTooltip(BuildContext context) {
    switch (this) {
      case InstructionsEnum.itInstructions:
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            body(context),
            style: BotStyle.text(context),
          ),
        );
      default:
        print('inlineTooltip not implemented for $this');
        return const SizedBox();
    }
  }
}

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
      value: pangeaController.instructions
          .wereInstructionsTurnedOff(widget.instructionsKey),
      onChanged: ((value) async {
        await pangeaController.instructions.updateEnableInstructions(
          widget.instructionsKey,
          value,
        );
        setState(() {});
      }),
    );
  }
}
