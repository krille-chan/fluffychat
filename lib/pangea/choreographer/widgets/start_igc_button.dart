import 'dart:async';
import 'dart:math' as math;

import 'package:fluffychat/pangea/enum/assistance_state_enum.dart';
import 'package:fluffychat/pangea/widgets/user_settings/p_language_dialog.dart';
import 'package:flutter/material.dart';

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
  StreamSubscription? _choreoListener;
  AssistanceState? _prevState;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _choreoListener = widget.controller.choreographer.stateListener.stream
        .listen(_updateSpinnerState);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _choreoListener?.cancel();
    super.dispose();
  }

  void _updateSpinnerState(_) {
    if (_prevState != AssistanceState.fetching &&
        assistanceState == AssistanceState.fetching) {
      _controller?.repeat();
    } else if (_prevState == AssistanceState.fetching &&
        assistanceState != AssistanceState.fetching) {
      _controller?.reset();
    }
    if (mounted) {
      setState(() => _prevState = assistanceState);
    }
  }

  void _showFirstMatch() {
    final igcData = widget.controller.choreographer.igc.igcTextData;
    if (igcData != null && igcData.matches.isNotEmpty) {
      widget.controller.choreographer.igc.showFirstMatch(context);
    }
  }

  Future<void> _onTap() async {
    switch (assistanceState) {
      case AssistanceState.notFetched:
        await widget.controller.choreographer.getLanguageHelp(
          onlyTokensAndLanguageDetection: false,
          manual: true,
        );
        _showFirstMatch();
        return;
      case AssistanceState.fetched:
        _showFirstMatch();
        return;
      case AssistanceState.complete:
      case AssistanceState.fetching:
      case AssistanceState.noMessage:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: _onTap,
        customBorder: const CircleBorder(),
        onLongPress: () => pLanguageDialog(context, () {}),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _controller != null
                ? RotationTransition(
                    turns: Tween(begin: 0.0, end: math.pi * 2)
                        .animate(_controller!),
                    child: Icon(
                      size: 36,
                      Icons.autorenew_rounded,
                      color: assistanceState.stateColor(context),
                    ),
                  )
                : Icon(
                    size: 36,
                    Icons.autorenew_rounded,
                    color: assistanceState.stateColor(context),
                  ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            Icon(
              size: 16,
              Icons.check,
              color: assistanceState.stateColor(context),
            ),
          ],
        ),
      ),
    );
  }
}
