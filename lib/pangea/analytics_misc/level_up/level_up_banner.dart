import 'dart:async';

import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
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
    player.setVolume(AppSettings.volume.value);

    // Wait for any existing snackbars to dismiss
    await _waitForSnackbars(context);

    await player.play(
      UrlSource(
        "${AppConfig.assetsBaseURL}/${AnalyticsConstants.levelUpAudioFileName}",
      ),
    );

    if (!context.mounted) return;

    OverlayUtil.showOverlay(
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
    while (MatrixState.pAnyState.isOverlayOpen(regex: snackbarRegex)) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}

class LevelUpBanner extends StatelessWidget {
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
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
                  SizedBox(width: constraints.maxWidth >= 600 ? 120.0 : 65.0),
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
                            L10n.of(context).levelUp,
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
                        SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              style: IconButton.styleFrom(
                                padding: const EdgeInsets.all(4.0),
                              ),
                              onPressed: () {
                                MatrixState.pAnyState.closeOverlay(
                                  "level_up_notification",
                                );
                              },
                              constraints: const BoxConstraints(),
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
