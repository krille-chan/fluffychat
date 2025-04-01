// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
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

  static void onClose(ConstructIdentifier construct) {
    MatrixState.pAnyState.closeOverlay("${construct.string}_snackbar");
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

        OverlayUtil.showOverlay(
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
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) _close();
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _close() {
    _controller?.reverse().then((_) {
      ConstructNotificationUtil.onClose(widget.construct);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizeTransition(
        sizeFactor: _animation!,
        axisAlignment: -1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 50.0,
                height: 50.0,
              ),
              Expanded(
                child: Wrap(
                  spacing: 16.0,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      L10n.of(context).youUnlocked,
                      style: TextStyle(
                        fontSize:
                            FluffyThemes.isColumnMode(context) ? 32.0 : 16.0,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16.0,
                      children: [
                        Flexible(
                          child: Text(
                            widget.copy ?? widget.construct.lemma,
                            style: TextStyle(
                              fontSize: FluffyThemes.isColumnMode(context)
                                  ? 32.0
                                  : 16.0,
                              color: AppConfig.gold,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        MorphIcon(
                          morphFeature: MorphFeaturesEnumExtension.fromString(
                            widget.construct.category,
                          ),
                          morphTag: widget.construct.lemma,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 50.0,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: _close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
