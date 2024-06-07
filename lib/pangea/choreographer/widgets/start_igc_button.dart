import 'dart:async';
import 'dart:math' as math;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../pages/chat/chat.dart';

class StartIGCButton extends StatefulWidget {
  const StartIGCButton({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  State<StartIGCButton> createState() => StartIGCButtonState();
}

class StartIGCButtonState extends State<StartIGCButton>
    with SingleTickerProviderStateMixin {
  AssistanceState get assistanceState =>
      widget.controller.choreographer.assistanceState;
  AnimationController? _controller;
  StreamSubscription? choreoListener;
  AssistanceState? prevState;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    choreoListener = widget.controller.choreographer.stateListener.stream
        .listen(updateSpinnerState);
    super.initState();
  }

  void updateSpinnerState(_) {
    if (prevState != AssistanceState.fetching &&
        assistanceState == AssistanceState.fetching) {
      _controller?.repeat();
    } else if (prevState == AssistanceState.fetching &&
        assistanceState != AssistanceState.fetching) {
      _controller?.stop();
      _controller?.reverse();
    }
    setState(() => prevState = assistanceState);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.choreographer.isAutoIGCEnabled) {
      return const SizedBox.shrink();
    }

    final Widget icon = Icon(
      Icons.autorenew_rounded,
      size: 46,
      color: assistanceState.stateColor,
    );

    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        tooltip: assistanceState.tooltip(
          L10n.of(context)!,
        ),
        backgroundColor: Colors.white,
        disabledElevation: 0,
        shape: const CircleBorder(),
        onPressed: () {
          if (assistanceState != AssistanceState.complete) {
            widget.controller.choreographer.getLanguageHelp(
              false,
              true,
            );
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            _controller != null
                ? RotationTransition(
                    turns: Tween(begin: 0.0, end: math.pi * 2)
                        .animate(_controller!),
                    child: icon,
                  )
                : icon,
            Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: assistanceState.stateColor,
              ),
            ),
            const Icon(
              size: 16,
              Icons.check,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

extension AssistanceStateExtension on AssistanceState {
  Color get stateColor {
    switch (this) {
      case AssistanceState.noMessage:
      case AssistanceState.notFetched:
      case AssistanceState.fetching:
        return AppConfig.primaryColor;
      case AssistanceState.fetched:
        return PangeaColors.igcError;
      case AssistanceState.complete:
        return AppConfig.success;
    }
  }

  String tooltip(L10n l10n) {
    switch (this) {
      case AssistanceState.noMessage:
      case AssistanceState.notFetched:
        return l10n.runGrammarCorrection;
      case AssistanceState.fetching:
        return "";
      case AssistanceState.fetched:
        return l10n.grammarCorrectionFailed;
      case AssistanceState.complete:
        return l10n.grammarCorrectionComplete;
    }
  }
}
