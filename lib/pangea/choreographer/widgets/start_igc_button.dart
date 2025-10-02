import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/choreographer/enums/assistance_state_enum.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/paywall_card.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
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
    _choreoListener = widget.controller.choreographer.stateStream.stream
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

  bool get _enableFeedback {
    return ![
      AssistanceState.fetching,
      AssistanceState.fetched,
      AssistanceState.complete,
      AssistanceState.noMessage,
    ].contains(assistanceState);
  }

  Future<void> _onTap() async {
    switch (assistanceState) {
      case AssistanceState.noSub:
        OverlayUtil.showPositionedCard(
          context: context,
          cardToShow: PaywallCard(
            chatController: widget.controller,
          ),
          maxHeight: 325,
          maxWidth: 325,
          transformTargetId:
              widget.controller.choreographer.inputTransformTargetKey,
        );
        return;
      case AssistanceState.noMessage:
        showDialog(
          context: context,
          builder: (c) => const SettingsLearning(),
          barrierDismissible: false,
        );
        return;
      case AssistanceState.notFetched:
        if (widget.controller.shouldShowLanguageMismatchPopup) {
          widget.controller.showLanguageMismatchPopup();
        } else {
          await widget.controller.choreographer.getLanguageHelp(manual: true);
          _showFirstMatch();
        }
        return;
      case AssistanceState.fetched:
        _showFirstMatch();
        return;
      case AssistanceState.complete:
      case AssistanceState.fetching:
        return;
    }
  }

  Color get _backgroundColor {
    switch (assistanceState) {
      case AssistanceState.noSub:
      case AssistanceState.noMessage:
      case AssistanceState.fetched:
      case AssistanceState.complete:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
      case AssistanceState.notFetched:
      case AssistanceState.fetching:
        return Theme.of(context).colorScheme.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      size: 36,
      Icons.autorenew_rounded,
      color: assistanceState.stateColor(context),
    );

    return Tooltip(
      message: _enableFeedback ? L10n.of(context).check : "",
      child: Material(
        elevation: _enableFeedback ? 4.0 : 0.0,
        borderRadius: BorderRadius.circular(99.0),
        shadowColor: Theme.of(context).colorScheme.surface.withAlpha(128),
        child: InkWell(
          enableFeedback: _enableFeedback,
          onTap: _enableFeedback ? _onTap : null,
          customBorder: const CircleBorder(),
          onLongPress: _enableFeedback
              ? () => showDialog(
                    context: context,
                    builder: (c) => const SettingsLearning(),
                    barrierDismissible: false,
                  )
              : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                height: 40.0,
                width: 40.0,
                duration: FluffyThemes.animationDuration,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _backgroundColor,
                ),
              ),
              _controller != null
                  ? RotationTransition(
                      turns: Tween(begin: 0.0, end: math.pi * 2)
                          .animate(_controller!),
                      child: icon,
                    )
                  : icon,
              AnimatedContainer(
                width: 20,
                height: 20,
                duration: FluffyThemes.animationDuration,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _backgroundColor,
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
      ),
    );
  }
}
