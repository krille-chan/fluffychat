import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/get_analytics_controller.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// display the construct xp widget
/// listen to analytics stream and, if the lemmaCategory has changed,
/// animate the constructSvg by making it animate in then rise up and float away

class ConstructXpWidget extends StatefulWidget {
  final ConstructIdentifier id;
  final VoidCallback? onTap;
  final double size;

  const ConstructXpWidget({
    super.key,
    required this.id,
    this.onTap,
    this.size = 24.0,
  });

  @override
  ConstructXpWidgetState createState() => ConstructXpWidgetState();
}

class ConstructXpWidgetState extends State<ConstructXpWidget>
    with SingleTickerProviderStateMixin {
  ConstructLevelEnum? constructLemmaCategory;
  bool didChange = false;

  late AnimationController _controller;

  StreamSubscription<AnalyticsStreamUpdate>? _sub;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    setState(() => constructLemmaCategory = constructUse?.lemmaCategory);

    debugPrint('constructLemmaCategory: $constructLemmaCategory');

    _sub = stream.listen((_) {
      if (constructUse?.lemmaCategory != constructLemmaCategory) {
        setState(() {
          constructLemmaCategory = constructUse?.lemmaCategory;
          didChange = true;
          //_controller.reset();
          //_controller.forward();
        });
      }
    });
  }

  ConstructUses? get constructUse =>
      MatrixState.pangeaController.getAnalytics.constructListModel
          .getConstructUses(widget.id);

  Stream<AnalyticsStreamUpdate> get stream =>
      MatrixState.pangeaController.getAnalytics.analyticsStream.stream;

  Widget? get svg => constructLemmaCategory?.icon();

  @override
  void dispose() {
    _controller.dispose();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onTap: svg != null ? widget.onTap : null,
        child: MouseRegion(
          cursor:
              svg != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Stack(
            alignment: Alignment.center,
            children: [
              //replaces rise animation, remove 116 and uncomment everything to revert
              svg != null ? svg! : const SizedBox.shrink(),
              // AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 1000),
              //   child: svg,
              // ),
              // if (didChange)
              //   SlideTransition(
              //     position: _offsetAnimation,
              //     child: FadeTransition(
              //       opacity: _fadeAnimation,
              //       child: svg,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
