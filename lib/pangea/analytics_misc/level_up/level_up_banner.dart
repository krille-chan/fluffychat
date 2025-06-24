import 'dart:async';

import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/level_up_manager.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/level_up_popup.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LevelUpConstants {
  static const String starFileName = "star.png";
  static const String dinoLevelUPFileName = "DinoBot-Congratulate.png";
}

class LevelUpUtil {
  static Future<void> showLevelUpDialog(
    int level,
    int prevLevel,
    BuildContext context,
  ) async {
    // Remove delay since GetAnalyticsController._onLevelUp is already async
    final player = AudioPlayer();

    // Wait for any existing snackbars to dismiss
    await _waitForSnackbars(context);

    await player.play(
      UrlSource(
        "${AppConfig.assetsBaseURL}/${AnalyticsConstants.levelUpAudioFileName}",
      ),
    );

    if (!context.mounted) return;

    await OverlayUtil.showOverlay(
      overlayKey: "level_up_notification",
      context: context,
      child: LevelUpBanner(
        level: level,
        prevLevel: prevLevel,
        backButtonOverride: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            MatrixState.pAnyState.closeOverlay("level_up_notification");
          },
        ),
      ),
      transformTargetId: '',
      position: OverlayPositionEnum.top,
      backDropToDismiss: false,
      closePrevOverlay: false,
      canPop: false,
    );

    await Future.delayed(const Duration(seconds: 2));
    player.dispose();
  }

  static Future<void> _waitForSnackbars(BuildContext context) async {
    final snackbarRegex = RegExp(r'_snackbar$');
    while (MatrixState.pAnyState.activeOverlays
        .any((id) => snackbarRegex.hasMatch(id))) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}

class LevelUpBanner extends StatefulWidget {
  final int level;
  final int prevLevel;
  final Widget? backButtonOverride;

  const LevelUpBanner({
    required this.level,
    required this.prevLevel,
    required this.backButtonOverride,
    super.key,
  });

  @override
  LevelUpBannerState createState() => LevelUpBannerState();
}

class LevelUpBannerState extends State<LevelUpBanner>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  bool _showedDetails = false;

  @override
  void initState() {
    super.initState();

    LevelUpManager.instance.preloadAnalytics(
      context,
      widget.level,
      widget.prevLevel,
    );

    _slideController = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      ),
    );

    _slideController.forward();

    Future.delayed(const Duration(seconds: 10), () async {
      if (mounted && !_showedDetails) {
        _close();
      }
    });
  }

  Future<void> _close() async {
    await _slideController.reverse();
    MatrixState.pAnyState.closeOverlay("level_up_notification");
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _toggleDetails() async {
    await _close();
    LevelUpManager.instance.markPopupSeen();
    _showedDetails = true;

    FocusScope.of(context).unfocus();

    await showDialog(
      context: context,
      builder: (context) => const LevelUpPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);

    final style = isColumnMode
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppConfig.gold,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            )
        : Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppConfig.gold,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            );

    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: SlideTransition(
          position: _slideAnimation,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy < -10) _close();
                },
                onTap: _toggleDetails,
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
                      // Spacer for symmetry
                      SizedBox(
                        width: constraints.maxWidth >= 600 ? 120.0 : 65.0,
                      ),
                      // Centered content
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
                                "Level up",
                                style: style,
                                overflow: TextOverflow.ellipsis,
                              ),
                              CachedNetworkImage(
                                imageUrl:
                                    "${AppConfig.assetsBaseURL}/${LevelUpConstants.starFileName}",
                                height: 24,
                                width: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth >= 600 ? 120.0 : 65.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (Environment.isStagingEnvironment)
                              SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    style: IconButton.styleFrom(
                                      padding: const EdgeInsets.all(4.0),
                                    ),
                                    onPressed: _toggleDetails,
                                    constraints: const BoxConstraints(),
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
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
    );
  }
}
