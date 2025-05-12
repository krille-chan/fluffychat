import 'dart:async';

import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
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
    final player = AudioPlayer();

    final snackbarRegex = RegExp(r'_snackbar$');

    while (MatrixState.pAnyState.activeOverlays
        .any((overlayId) => snackbarRegex.hasMatch(overlayId))) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    player
        .play(
          UrlSource(
            "${AppConfig.assetsBaseURL}/${AnalyticsConstants.levelUpAudioFileName}",
          ),
        )
        .then(
          (_) => Future.delayed(
            const Duration(seconds: 2),
            () => player.dispose(),
          ),
        );

    OverlayUtil.showOverlay(
      overlayKey: "level_up_notification",
      context: context,
      child: LevelUpBanner(
        level: level,
        prevLevel: prevLevel,
      ),
      transformTargetId: '',
      position: OverlayPositionEnum.top,
      backDropToDismiss: false,
      closePrevOverlay: false,
      canPop: false,
    );
  }
}

class LevelUpBanner extends StatefulWidget {
  final int level;
  final int prevLevel;

  const LevelUpBanner({
    required this.level,
    required this.prevLevel,
    super.key,
  });

  @override
  LevelUpBannerState createState() => LevelUpBannerState();
}

class LevelUpBannerState extends State<LevelUpBanner>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  bool _showDetails = false;
  bool _showedDetails = false;

  ConstructSummary? _constructSummary;
  String? _error;

  @override
  void initState() {
    super.initState();
    _setConstructSummary();

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

    _sizeController = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    _sizeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _sizeController,
        curve: Curves.easeOut,
      ),
    );

    _slideController.forward();

    Future.delayed(const Duration(seconds: 15), () async {
      if (mounted && !_showedDetails) _close();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _setConstructSummary() async {
    try {
      _constructSummary = await MatrixState.pangeaController.getAnalytics
          .generateLevelUpAnalytics(
        widget.level,
        widget.prevLevel,
      );
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> _close() async {
    await _slideController.reverse();
    MatrixState.pAnyState.closeOverlay("level_up_notification");
  }

  int _skillsPoints(LearningSkillsEnum skill) {
    switch (skill) {
      case LearningSkillsEnum.writing:
        return _constructSummary?.writingConstructScore ?? 0;
      case LearningSkillsEnum.reading:
        return _constructSummary?.readingConstructScore ?? 0;
      case LearningSkillsEnum.speaking:
        return _constructSummary?.speakingConstructScore ?? 0;
      case LearningSkillsEnum.hearing:
        return _constructSummary?.hearingConstructScore ?? 0;
      default:
        return 0;
    }
  }

  Future<void> _toggleDetails() async {
    if (!Environment.isStaging) return;

    if (mounted) {
      setState(() {
        _showDetails = !_showDetails;
        if (_showDetails && !_showedDetails) {
          _showedDetails = true;
        }
      });

      await (_showDetails
          ? _sizeController.forward()
          : _sizeController.reverse());

      if (!_showDetails) {
        await Future.delayed(
          const Duration(milliseconds: 300),
          () async {
            if (!mounted) return;
            _close();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = FluffyThemes.isColumnMode(context)
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            )
        : Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            );

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onPanUpdate: (details) {
                          if (details.delta.dy < -10) _close();
                        },
                        onTap: _toggleDetails,
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 8.0,
                            children: [
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: L10n.of(context)
                                            .congratulationsOnReaching(
                                          widget.level,
                                        ),
                                        style: style,
                                      ),
                                      TextSpan(
                                        text: "  ",
                                        style: style,
                                      ),
                                      WidgetSpan(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${AppConfig.assetsBaseURL}/${LevelUpConstants.starFileName}",
                                          height: 24,
                                          width: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  if (Environment.isStaging)
                                    AnimatedSize(
                                      duration: FluffyThemes.animationDuration,
                                      child: _error == null
                                          ? FluffyThemes.isColumnMode(context)
                                              ? ElevatedButton(
                                                  style: IconButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 16.0,
                                                    ),
                                                  ),
                                                  onPressed: _toggleDetails,
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
                                                      style:
                                                          IconButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(
                                                          4.0,
                                                        ),
                                                      ),
                                                      onPressed: _toggleDetails,
                                                      constraints:
                                                          const BoxConstraints(),
                                                    ),
                                                  ),
                                                )
                                          : Row(
                                              children: [
                                                Tooltip(
                                                  message: L10n.of(context)
                                                      .oopsSomethingWentWrong,
                                                  child: Icon(
                                                    Icons.error,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: _close,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizeTransition(
                        sizeFactor: _sizeAnimation,
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.75,
                          ),
                          margin: const EdgeInsets.only(
                            top: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 24.0,
                              children: [
                                Table(
                                  columnWidths: const {
                                    0: IntrinsicColumnWidth(),
                                    1: FlexColumnWidth(),
                                    2: IntrinsicColumnWidth(),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    ...LearningSkillsEnum.values
                                        .where(
                                      (v) =>
                                          v.isVisible && _skillsPoints(v) > -1,
                                    )
                                        .map((skill) {
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 9.0,
                                              horizontal: 18.0,
                                            ),
                                            child: Icon(
                                              skill.icon,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 9.0,
                                              horizontal: 18.0,
                                            ),
                                            child: Text(
                                              skill.tooltip(context),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 9.0,
                                              horizontal: 18.0,
                                            ),
                                            child: Text(
                                              "+ ${_skillsPoints(skill)} XP",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                                CachedNetworkImage(
                                  imageUrl:
                                      "${AppConfig.assetsBaseURL}/${LevelUpConstants.dinoLevelUPFileName}",
                                  width: 400,
                                  fit: BoxFit.cover,
                                ),
                                if (_constructSummary?.textSummary != null)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _constructSummary!.textSummary,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                const SizedBox(
                                  height: 24,
                                ),
                                // Share button, currently no functionality
                                // ElevatedButton(
                                //   onPressed: () {
                                //     // Add share functionality
                                //   },
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: Colors.white,
                                //     foregroundColor: Colors.black,
                                //     padding: const EdgeInsets.symmetric(
                                //       vertical: 12,
                                //       horizontal: 24,
                                //     ),
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //   ),
                                //   child: const Row(
                                //     mainAxisSize: MainAxisSize
                                //         .min,
                                //     children: [
                                //       Text(
                                //         "Share with Friends",
                                //         style: TextStyle(
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //       SizedBox(
                                //         width: 8,
                                //       ),
                                //       Icon(
                                //         Icons.ios_share,
                                //         size: 20,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
