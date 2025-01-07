import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/controllers/get_analytics_controller.dart';
import 'package:fluffychat/pangea/controllers/put_analytics_controller.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PointsGainedAnimation extends StatefulWidget {
  final Color? gainColor;
  final Color? loseColor;
  final AnalyticsUpdateOrigin origin;

  const PointsGainedAnimation({
    super.key,
    required this.origin,
    this.gainColor,
    this.loseColor = Colors.red,
  });

  @override
  PointsGainedAnimationState createState() => PointsGainedAnimationState();
}

class PointsGainedAnimationState extends State<PointsGainedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  StreamSubscription? _pointsSubscription;
  int? get _prevXP =>
      MatrixState.pangeaController.getAnalytics.constructListModel.prevXP;
  int? get _currentXP =>
      MatrixState.pangeaController.getAnalytics.constructListModel.totalXP;
  int? _addedPoints;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -1.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _pointsSubscription = MatrixState
        .pangeaController.getAnalytics.analyticsStream.stream
        .listen(_showPointsGained);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pointsSubscription?.cancel();
    super.dispose();
  }

  void _showPointsGained(AnalyticsStreamUpdate update) {
    if (update.origin != widget.origin) return;
    setState(() => _addedPoints = (_currentXP ?? 0) - (_prevXP ?? 0));
    if (_prevXP != _currentXP) {
      _controller.reset();
      _controller.forward();
    }
  }

  bool get animate =>
      _currentXP != null &&
      _prevXP != null &&
      _addedPoints != null &&
      _prevXP! != _currentXP!;

  @override
  Widget build(BuildContext context) {
    if (!animate) return const SizedBox();

    final textColor = _addedPoints! > 0 ? widget.gainColor : widget.loseColor;

    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          '${_addedPoints! > 0 ? '+' : ''}$_addedPoints',
          style: BotStyle.text(
            context,
            big: true,
            setColor: textColor == null,
            existingStyle: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
