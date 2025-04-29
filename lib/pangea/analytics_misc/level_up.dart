import 'dart:async';

import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LevelUpConstants {
  static const String starFileName = "star.png";
  static const String dinoLevelUPFileName = "DinoBot-Congratulate.png";
}

class LevelUpUtil {
  static Future<void> showLevelUpDialog(
    int level,
    String? analyticsRoomId,
    ConstructSummary? constructSummary,
    BuildContext context,
  ) async {
    final player = AudioPlayer();

    final snackbarRegex = RegExp(r'_snackbar$');

    while (MatrixState.pAnyState.activeOverlays
        .any((overlayId) => snackbarRegex.hasMatch(overlayId))) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    player.play(
      UrlSource(
        "${AppConfig.assetsBaseURL}/${AnalyticsConstants.levelUpAudioFileName}",
      ),
    );

    final ValueNotifier<bool> showDetailsClicked = ValueNotifier(false);

    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => LevelUpBanner(
        level: level,
        constructSummary: constructSummary,
        onDetailsClicked: () {
          showDetailsClicked.value = true;
        },
        onOverlayExit: () {
          overlayEntry.remove();
          player.dispose();
        },
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 5), () {
      if (!showDetailsClicked.value) {
        overlayEntry.remove();
        player.dispose();
      }
    });
  }
}

class LevelUpBanner extends StatefulWidget {
  final int level;
  final ConstructSummary? constructSummary;
  final VoidCallback onDetailsClicked;
  final VoidCallback onOverlayExit;

  const LevelUpBanner({
    required this.level,
    this.constructSummary,
    required this.onDetailsClicked,
    required this.onOverlayExit,
    super.key,
  });

  @override
  LevelUpBannerState createState() => LevelUpBannerState();
}

class LevelUpBannerState extends State<LevelUpBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _skillsPoints(LearningSkillsEnum skill) {
    switch (skill) {
      case LearningSkillsEnum.writing:
        return widget.constructSummary?.writingConstructScore ?? 0;
      case LearningSkillsEnum.reading:
        return widget.constructSummary?.readingConstructScore ?? 0;
      case LearningSkillsEnum.speaking:
        return widget.constructSummary?.speakingConstructScore ?? 0;
      case LearningSkillsEnum.hearing:
        return widget.constructSummary?.hearingConstructScore ?? 0;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_showDetails)
          GestureDetector(
            onTap: () {
              setState(() {
                _showDetails = false;
              });
              widget.onOverlayExit();
            },
            child: Container(
              color: Colors.black.withAlpha(180),
            ),
          ),
        SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: widget.level > 10
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: L10n.of(context).congratulationsOnReaching,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            TextSpan(
                              text: "${L10n.of(context).level} ",
                              style: const TextStyle(
                                color: AppConfig.gold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            TextSpan(
                              text: "${widget.level} ",
                              style: const TextStyle(
                                color: AppConfig.gold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
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
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showDetails = !_showDetails;
                          });
                          widget.onDetailsClicked();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "${L10n.of(context).seeDetails} ",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: AppConfig.gold,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(
                                4.0,
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _showDetails
                      ? Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.75,
                          ),
                          margin: const EdgeInsets.only(
                            top: 16,
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
                                if (widget.constructSummary?.textSummary !=
                                    null)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      widget.constructSummary!.textSummary,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
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
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
