// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/toolbar/widgets/icon_rain.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ConstructNotificationUtil {
  static Completer? closeCompleter;
  static final Set<ConstructIdentifier> unlockedConstructs = {};
  static bool showingNotification = false;

  static void addUnlockedConstruct(
    List<ConstructIdentifier> constructs,
    BuildContext context,
  ) {
    unlockedConstructs.addAll(constructs);
    if (!showingNotification) {
      showUnlockedMorphsSnackbar(context);
    }
  }

  static final Set<String> _closedOverlays = {};

  static void onClose(ConstructIdentifier construct) {
    final overlayKey = "${construct.string}_snackbar";
    if (_closedOverlays.contains(overlayKey)) return;
    _closedOverlays.add(overlayKey);
    MatrixState.pAnyState.closeOverlay(overlayKey);
    unlockedConstructs.remove(construct);
    closeCompleter?.complete();
    closeCompleter = null;
  }

  static Future<void> showUnlockedMorphsSnackbar(BuildContext context) async {
    showingNotification = true;
    while (unlockedConstructs.isNotEmpty) {
      final construct = unlockedConstructs.first;
      try {
        final copy = getGrammarCopy(
          category: construct.category,
          lemma: construct.lemma,
          context: context,
        );
        closeCompleter = Completer();

        final bool result = OverlayUtil.showOverlay(
          overlayKey: "${construct.string}_snackbar",
          context: context,
          child: ConstructNotificationOverlay(
            construct: construct,
            copy: copy,
          ),
          transformTargetId: "",
          position: OverlayPositionEnum.top,
          backDropToDismiss: false,
          closePrevOverlay: false,
          canPop: false,
        );

        // if the overlay could not be shown, break the loop
        if (!result) {
          showingNotification = false;
          break;
        }

        await closeCompleter!.future;
      } catch (e) {
        showingNotification = false;
        break;
      }
    }

    showingNotification = false;
  }
}

class ConstructNotificationOverlay extends StatefulWidget {
  final ConstructIdentifier construct;
  final String? copy;

  const ConstructNotificationOverlay({
    super.key,
    required this.construct,
    this.copy,
  });

  @override
  State<ConstructNotificationOverlay> createState() =>
      ConstructNotificationOverlayState();
}

class ConstructNotificationOverlayState
    extends State<ConstructNotificationOverlay> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: FluffyThemes.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );

    _controller!.forward().then((_) {
      OverlayUtil.showOverlay(
        overlayKey: "${widget.construct.string}_points",
        followerAnchor: Alignment.topCenter,
        targetAnchor: Alignment.topCenter,
        context: context,
        child: IconRain(
          addStars: true,
          icon: MorphIcon(
            size: const Size(8, 8),
            morphFeature: MorphFeaturesEnumExtension.fromString(
              widget.construct.category,
            ),
            morphTag: widget.construct.lemma,
          ),
        ),
        transformTargetId: "${widget.construct.string}_notification",
        closePrevOverlay: false,
        backDropToDismiss: false,
        ignorePointer: true,
      );
      Future.delayed(const Duration(seconds: 15), () {
        if (mounted) _close();
      });
    });
  }

  @override
  void dispose() {
    ConstructNotificationUtil.onClose(widget.construct);
    _controller?.dispose();
    super.dispose();
  }

  void _close() {
    if (_controller?.status == AnimationStatus.completed) {
      //only animate closed if still mounted, not if navigating away
      _controller?.reverse().then((_) {
        ConstructNotificationUtil.onClose(widget.construct);
      });
    } else {
      ConstructNotificationUtil.onClose(widget.construct);
    }
  }

  void _showDetails() {
    context.go(
      "/rooms/analytics/${ConstructTypeEnum.morph.string}/${widget.construct.string}",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);
    return CompositedTransformTarget(
      link: MatrixState.pAnyState
          .layerLinkAndKey("${widget.construct.string}_notification")
          .link,
      child: SafeArea(
        key: MatrixState.pAnyState
            .layerLinkAndKey("${widget.construct.string}_notification")
            .key,
        child: Material(
          type: MaterialType.transparency,
          child: SizeTransition(
            sizeFactor: _animation!,
            axisAlignment: -1.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dy < -10) _close();
                  },
                  onTap: _showDetails,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: AppConfig.gold.withAlpha(200),
                          width: 2.0,
                        ),
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppConfig.borderRadius),
                        bottomRight: Radius.circular(AppConfig.borderRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth >= 600 ? 120.0 : 65.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isColumnMode ? 16.0 : 8.0,
                            ),
                            child: Wrap(
                              spacing: 16.0,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  widget.copy ?? widget.construct.lemma,
                                  style: TextStyle(
                                    fontSize: FluffyThemes.isColumnMode(context)
                                        ? 22.0
                                        : 16.0,
                                    color: AppConfig.gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                MorphIcon(
                                  size: isColumnMode
                                      ? null
                                      : const Size(22.0, 22.0),
                                  morphFeature:
                                      MorphFeaturesEnumExtension.fromString(
                                    widget.construct.category,
                                  ),
                                  morphTag: widget.construct.lemma,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth >= 600 ? 120.0 : 65.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Tooltip(
                                message: L10n.of(context).details,
                                child: constraints.maxWidth >= 600
                                    ? ElevatedButton(
                                        style: IconButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 16.0,
                                          ),
                                        ),
                                        onPressed: _showDetails,
                                        child: Text(
                                          L10n.of(context).details,
                                        ),
                                      )
                                    : SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.info_outline,
                                            ),
                                            style: IconButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                            ),
                                            onPressed: _showDetails,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ),
                                      ),
                              ),
                              SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: Center(
                                  child: Tooltip(
                                    message: L10n.of(context).close,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                      ),
                                      style: IconButton.styleFrom(
                                        padding: const EdgeInsets.all(4.0),
                                      ),
                                      onPressed: _close,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
