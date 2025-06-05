import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/gain_points_animation.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  bool _showingLevelingAnimation = false;

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
    if (!Environment.isStagingEnvironment) return;

    if (mounted) {
      if (!_showedDetails) {
        setState(() {
          _showingLevelingAnimation = true;
        });
      }

      setState(() {
        _showDetails = !_showDetails;
        if (_showDetails && _showedDetails) {
          _showedDetails = true;
        }
      });

      await (_showDetails
          ? _sizeController.forward()
          : _sizeController.reverse());

      if (_showDetails && _showingLevelingAnimation) {
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        setState(() {
          _showingLevelingAnimation = false;
        });
      }

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
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
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
                                        //Hardcoded for now, put in translations later
                                        text: "Level up",
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
                                  if (Environment.isStagingEnvironment)
                                    AnimatedSize(
                                      duration: FluffyThemes.animationDuration,
                                      child: _error == null
                                          ? FluffyThemes.isColumnMode(context)
                                              ? IconButton(
                                                  style: IconButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 16.0,
                                                    ),
                                                  ),
                                                  onPressed: _toggleDetails,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizeTransition(
                        sizeFactor: _sizeAnimation,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width * .5,
                          margin: const EdgeInsets.only(
                            top: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: _showingLevelingAnimation
                              ? const Expanded(
                                  child: LevelUpBarAnimation(),
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                v.isVisible &&
                                                _skillsPoints(v) > -1,
                                          )
                                              .map((skill) {
                                            return TableRow(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 9.0,
                                                    horizontal: 18.0,
                                                  ),
                                                  child: Icon(
                                                    skill.icon,
                                                    size: 25,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 9.0,
                                                    horizontal: 18.0,
                                                  ),
                                                  child: Text(
                                                    skill.tooltip(context),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 9.0,
                                                    horizontal: 18.0,
                                                  ),
                                                  child: Text(
                                                    "+ ${_skillsPoints(skill)} XP",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                      if (_constructSummary?.textSummary !=
                                          null)
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            _constructSummary!.textSummary,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
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

//animated progress bar -- move to own file later
class LevelUpBarAnimation extends StatefulWidget {
  const LevelUpBarAnimation({super.key});

  @override
  State<LevelUpBarAnimation> createState() => _LevelUpBarAnimationState();
}

class _LevelUpBarAnimationState extends State<LevelUpBarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<int> _newVocab;
  late Animation<int> _newGrammar;

  final int startGrammar = 23;
  final int endGrammar = 78;
  final int startVocab = 54;
  final int endVocab = 64;

  //add vocab and grammar animation controllers, then display their values in the text fields below. Easy!

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _newVocab = IntTween(begin: startVocab, end: endVocab).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _newGrammar = IntTween(begin: startGrammar, end: endGrammar).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color grammarVocabColor = Theme.of(context).colorScheme.primary;
    final TextStyle grammarVocabText =
        TextStyle(color: grammarVocabColor, fontSize: 24);
    const TextStyle titleText =
        TextStyle(color: AppConfig.goldLight, fontSize: 20);

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Column(
          children: [
            ClipOval(
              child: Image.asset(
                '../../../assets/favicon.png',
                width: 150, // Adjust the size as needed
                height: 150,
                fit: BoxFit.cover, // Use BoxFit.cover to fill the circle
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              //Language fix later
              "You have reached a new level!",
              style: titleText,
            ),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, _) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      ProgressBar(
                        levelBars: [
                          LevelBarDetails(
                            widthMultiplier: _progressAnimation.value,
                            currentPoints: 0,
                            fillColor: AppConfig.goldLight,
                          ),
                        ],
                        height: 20,
                      ),
                      const SizedBox(height: 45),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.dictionary,
                            color: grammarVocabColor,
                            size: 35,
                          ),
                          Text(
                            "${_newVocab.value}",
                            style: grammarVocabText,
                          ),
                          const SizedBox(width: 40),
                          Icon(
                            Symbols.toys_and_games,
                            color: grammarVocabColor,
                            size: 35,
                          ),
                          Text(
                            "${_newGrammar.value}",
                            style: grammarVocabText,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const PointsGainedAnimation(
          points: 10,
          targetID: "targetID?",
        ),
      ],
    );
  }
}
