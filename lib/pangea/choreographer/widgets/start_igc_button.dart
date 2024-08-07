import 'dart:async';
import 'dart:math' as math;

import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/enum/assistance_state_enum.dart';
import 'package:fluffychat/pangea/widgets/user_settings/p_language_dialog.dart';
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
      duration: const Duration(seconds: 2),
    );
    choreoListener = widget.controller.choreographer.stateListener.stream
        .listen(updateSpinnerState);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    choreoListener?.cancel();
    super.dispose();
  }

  void updateSpinnerState(_) {
    if (prevState != AssistanceState.fetching &&
        assistanceState == AssistanceState.fetching) {
      _controller?.repeat();
    } else if (prevState == AssistanceState.fetching &&
        assistanceState != AssistanceState.fetching) {
      _controller?.reset();
    }
    if (mounted) {
      setState(() => prevState = assistanceState);
    }
  }

  bool get itEnabled => widget.controller.choreographer.itEnabled;
  bool get igcEnabled => widget.controller.choreographer.igcEnabled;
  CanSendStatus get canSendStatus =>
      widget.controller.pangeaController.subscriptionController.canSendStatus;
  bool get grammarCorrectionEnabled =>
      (itEnabled || igcEnabled) && canSendStatus == CanSendStatus.subscribed;

  @override
  Widget build(BuildContext context) {
    if (!grammarCorrectionEnabled ||
        widget.controller.choreographer.isAutoIGCEnabled ||
        widget.controller.choreographer.choreoMode == ChoreoMode.it) {
      return const SizedBox.shrink();
    }

    final Widget icon = Icon(
      Icons.autorenew_rounded,
      size: 46,
      color: assistanceState.stateColor(context),
    );

    return SizedBox(
      height: 50,
      width: 50,
      child: InkWell(
        customBorder: const CircleBorder(),
        onLongPress: () => pLanguageDialog(context, () {}),
        child: FloatingActionButton(
          tooltip: assistanceState.tooltip(
            L10n.of(context)!,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          disabledElevation: 0,
          shape: const CircleBorder(),
          onPressed: () {
            if (assistanceState != AssistanceState.fetching) {
              widget.controller.choreographer
                  .getLanguageHelp(
                onlyTokensAndLanguageDetection: false,
                manual: true,
              )
                  .then((_) {
                if (widget.controller.choreographer.igc.igcTextData != null &&
                    widget.controller.choreographer.igc.igcTextData!.matches
                        .isNotEmpty) {
                  widget.controller.choreographer.igc.showFirstMatch(context);
                }
              });
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: assistanceState.stateColor(context),
                ),
              ),
              Icon(
                size: 16,
                Icons.check,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
