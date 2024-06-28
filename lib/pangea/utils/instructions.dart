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
  final Map<InstructionsEnum, bool> _instructionsClosed = {};

  /// Instruction popup has already been shown this session
  final Map<InstructionsEnum, bool> _instructionsShown = {};

  /// Returns true if the user requested this popup not be shown again
  bool? toggledOff(InstructionsEnum key) =>
      _pangeaController.pStoreService.read(key.toString());

  InstructionsController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }

  /// Returns true if the instructions were closed
  /// or turned off by the user via the toggle switch
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

  /// Instruction Card gives users tips on
  /// how to use Pangea Chat's features
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

  /// Returns a widget that will be added to existing widget
  /// which displays hint text defined in the enum extension
  Widget getInlineTooltip(
    BuildContext context,
    InstructionsEnum key,
    Function refreshOnClose,
  ) {
    if (wereInstructionsTurnedOff(key)) {
      // Uncomment this line to make hint viewable again
      // _instructionsClosed[key] = false;
      return const SizedBox();
    }
    if (L10n.of(context) == null) {
      ErrorHandler.logError(
        m: "null context in ITBotButton.showCard",
        s: StackTrace.current,
      );
      return const SizedBox();
    }
    return Badge(
      offset: const Offset(0, -7),
      backgroundColor: Colors.transparent,
      label: CircleAvatar(
        radius: 10,
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(20),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.close_outlined,
            size: 15,
          ),
          onPressed: () {
            _instructionsClosed[key] = true;
            refreshOnClose();
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          color: Theme.of(context).colorScheme.primary.withAlpha(20),
          // border: Border.all(
          //   color: Theme.of(context).colorScheme.primary.withAlpha(50),
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: key.inlineTooltip(context),
        ),
      ),
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
