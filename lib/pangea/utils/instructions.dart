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

  final Map<InstructionsEnum, bool> _instructionsClosed = {};
  final Map<InstructionsEnum, bool> _instructionsShown = {};

  InstructionsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  bool wereInstructionsTurnedOff(InstructionsEnum key) =>
      _pangeaController.pStoreService.read(key.toString()) ??
      _instructionsClosed[key] ??
      false;

  Future<void> updateEnableInstructions(
    InstructionsEnum key,
    bool value,
  ) async =>
      await _pangeaController.pStoreService.save(
        key.toString(),
        value,
      );

  Future<void> show(
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
      ),
    );
  }
}

enum InstructionsEnum {
  itInstructions,
  clickMessage,
  blurMeansTranslate,
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
