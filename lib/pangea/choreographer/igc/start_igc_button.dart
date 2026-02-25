import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/choreographer/assistance_state_enum.dart';
import 'package:fluffychat/pangea/choreographer/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/choreographer_state_extension.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_state_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/replacement_type_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/segmented_circular_progress.dart';
import 'package:fluffychat/pangea/learning_settings/settings_learning.dart';

class StartIGCButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Choreographer choreographer;
  final AssistanceStateEnum initialState;
  final Color initialForegroundColor;

  const StartIGCButton({
    super.key,
    required this.onPressed,
    required this.choreographer,
    required this.initialState,
    required this.initialForegroundColor,
  });

  @override
  State<StartIGCButton> createState() => _StartIGCButtonState();
}

class _StartIGCButtonState extends State<StartIGCButton>
    with TickerProviderStateMixin {
  late final AnimationController _spinController;
  late final Animation<double> _rotation;

  late StreamSubscription _matchSubscription;

  late AnimationController _segmentController;

  AssistanceStateEnum? _prevState;
  bool _shouldStop = false;

  List<Segment> _prevSegments = [];
  List<Segment> _currentSegments = [];

  final Duration _animationDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    _spinController =
        AnimationController(vsync: this, duration: _animationDuration)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (_shouldStop) {
                _spinController.stop();
                _spinController.value = 0;
              } else {
                _spinController.forward(from: 0);
              }
            }
          });

    _rotation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _spinController, curve: Curves.linear));

    _segmentController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _currentSegments = _segmentsForState(
      widget.initialState,
      widget.choreographer.igcController.activeMatch.value,
      overrideColor: widget.initialForegroundColor,
    );

    _prevSegments = List.from(_currentSegments);
    _segmentController.forward(from: 0.0);

    _prevState = widget.initialState;

    widget.choreographer.addListener(_handleStateChange);
    widget.choreographer.igcController.activeMatch.addListener(_updateSegments);
    _matchSubscription = widget
        .choreographer
        .igcController
        .matchUpdateStream
        .stream
        .listen((_) => _updateSegments());
  }

  @override
  void dispose() {
    widget.choreographer.removeListener(_handleStateChange);
    _spinController.dispose();
    _segmentController.dispose();
    _matchSubscription.cancel();
    super.dispose();
  }

  void _handleStateChange() {
    final prev = _prevState;
    final current = widget.choreographer.assistanceState;
    _prevState = current;
    if (!mounted || prev == current) return;

    if (current == AssistanceStateEnum.fetching) {
      _shouldStop = false;
      _spinController.forward(from: 0.0);
    } else if (prev == AssistanceStateEnum.fetching) {
      _shouldStop = true;
    }

    _updateSegments();
  }

  void _updateSegments() {
    final activeMatch = widget.choreographer.igcController.activeMatch.value;
    final assistanceState = widget.choreographer.assistanceState;

    final newSegments = _segmentsForState(assistanceState, activeMatch);
    if (_segmentsEqual(newSegments, _currentSegments)) return;

    _prevSegments = List.from(_currentSegments);
    _currentSegments = List.from(newSegments);
    _segmentController.forward(from: 0.0);
  }

  List<Segment> _segmentsForState(
    AssistanceStateEnum state,
    PangeaMatchState? activeMatch, {
    Color? overrideColor,
  }) {
    switch (state) {
      case AssistanceStateEnum.noSub:
      case AssistanceStateEnum.noMessage:
      case AssistanceStateEnum.notFetched:
      case AssistanceStateEnum.fetching:
        final segmentPercent = (100 - 5 * 5) / 5; // size of each segment
        return List.generate(5, (_) {
          return Segment(
            segmentPercent,
            overrideColor ?? state.stateColor(context),
          );
        });
      case AssistanceStateEnum.fetched:
      case AssistanceStateEnum.complete:
        final matches = widget.choreographer.igcController.sortedMatches;
        if (matches.isEmpty) {
          return [Segment(100, AppConfig.success)];
        }

        final segmentPercent = 100 / matches.length;
        return matches.map((m) {
          final isActiveMatch =
              m.originalMatch.match.offset ==
                  activeMatch?.originalMatch.match.offset &&
              m.originalMatch.match.length ==
                  activeMatch?.originalMatch.match.length;

          final opacity = isActiveMatch
              ? 1.0
              : m.updatedMatch.status.igcButtonOpacity;

          return Segment(
            segmentPercent,
            m.updatedMatch.status.isOpen
                ? m.updatedMatch.match.type.color
                : AppConfig.success,
            opacity: opacity,
          );
        }).toList();
      case AssistanceStateEnum.error:
        break;
    }
    return [];
  }

  List<Segment> _getAnimatedSegments(double t) {
    final maxLength = max(_prevSegments.length, _currentSegments.length);

    return List.generate(maxLength, (i) {
      final prev = i < _prevSegments.length
          ? _prevSegments[i]
          : Segment(0, _currentSegments[i].color, opacity: 0);

      final curr = i < _currentSegments.length
          ? _currentSegments[i]
          : Segment(0, _prevSegments[i].color, opacity: 0);

      return Segment(
        lerpDouble(prev.value, curr.value, t)!,
        Color.lerp(prev.color, curr.color, t)!,
        opacity: lerpDouble(prev.opacity, curr.opacity, t)!,
      );
    }).where((s) => s.value > 0).toList();
  }

  bool _segmentsEqual(List<Segment> a, List<Segment> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.choreographer,
      builder: (_, _) {
        final assistanceState = widget.choreographer.assistanceState;
        final enableFeedback = assistanceState.allowsFeedback;
        return Tooltip(
          message: enableFeedback ? L10n.of(context).check : "",
          child: Material(
            elevation: enableFeedback ? 4.0 : 0.0,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            shadowColor: Theme.of(context).colorScheme.surface.withAlpha(128),
            child: InkWell(
              enableFeedback: enableFeedback,
              customBorder: const CircleBorder(),
              onTap: enableFeedback ? widget.onPressed : null,
              onLongPress: enableFeedback
                  ? () => showDialog(
                      context: context,
                      builder: (c) => const SettingsLearning(),
                      barrierDismissible: false,
                    )
                  : null,
              child: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(2.0),
                child: AnimatedBuilder(
                  animation: Listenable.merge([_rotation, _segmentController]),
                  builder: (context, _) {
                    final segments = _getAnimatedSegments(
                      _segmentController.value,
                    );
                    return Transform.rotate(
                      angle: _rotation.value * 2 * pi,
                      child: SegmentedCircularProgress(
                        strokeWidth: 3,
                        segments: segments,
                        child: AnimatedOpacity(
                          duration: _animationDuration,
                          opacity: assistanceState.showIcon ? 1.0 : 0.0,
                          child: Icon(
                            size: 18,
                            Icons.check,
                            color: assistanceState.stateColor(context),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
