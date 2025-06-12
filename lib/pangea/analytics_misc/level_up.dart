import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix_api_lite/generated/model.dart';

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
        backButtonOverride: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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

  late AnimationController _sizeController;

  final bool _showedDetails = false;

  @override
  void initState() {
    super.initState();

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

    _slideController.forward();

    Future.delayed(const Duration(seconds: 10), () async {
      if (mounted && !_showedDetails) _close();
    });
  }

  Future<void> _close() async {
    await _slideController.reverse();
    MatrixState.pAnyState.closeOverlay("level_up_notification");
  }

  @override
  void dispose() {
    _slideController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _toggleDetails() async {
    await _close();

    //if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => LevelUpPopup(widget: widget),
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
                      // Optional staging-only dropdown icon
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

class LevelUpPopup extends StatelessWidget {
  const LevelUpPopup({
    super.key,
    required this.widget,
  });

  final LevelUpBanner widget;

  @override
  Widget build(BuildContext context) {
    return FullWidthDialog(
      maxWidth: 400,
      maxHeight: 800,
      dialogContent: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: kIsWeb
              ? const Text(
                  "You have leveled up!",
                  style: TextStyle(
                    color: AppConfig.gold,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
        body: LevelUpBarAnimation(
          prevLevel: widget.prevLevel,
          level: widget.level,
        ),
      ),
    );
  }
}

//animated progress bar -- move to own file later
class LevelUpBarAnimation extends StatefulWidget {
  final int prevLevel;
  final int level;

  const LevelUpBarAnimation({
    super.key,
    required this.prevLevel,
    required this.level,
  });

  @override
  State<LevelUpBarAnimation> createState() => _LevelUpBarAnimationState();
}

class _LevelUpBarAnimationState extends State<LevelUpBarAnimation>
    with SingleTickerProviderStateMixin {
  late int _endGrammar;
  late int _endVocab;
  late final AnimationController _controller;
  late final Animation<double> _progressAnimation;
  late final Animation<int> _vocabAnimation;
  late final Animation<int> _grammarAnimation;
  late final Animation<double> _skillsOpacity;
  late final Animation<double> _shrinkMultiplier;
  late final Uri? avatarUrl;
  late final Future<Profile> profile;

  late final ConfettiController _confettiController;

  ConstructSummary? _constructSummary;
  String? _error;

  int displayedLevel = -1;
  bool _hasBlastedConfetti = false;

  static const int _startGrammar = 0;
  static const int _startVocab = 0;
  static const String language = "ES";

  static const Duration _animationDuration = Duration(seconds: 6);

  @override
  void initState() {
    super.initState();

    displayedLevel = widget.prevLevel;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _setConstructSummary();
    _setGrammarAndVocab();

    final client = Matrix.of(context).client;
    client.fetchOwnProfile().then((profile) {
      setState(() {
        avatarUrl = profile.avatarUrl;
      });
    });

    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    // halfway through the animation, switch to the new level
    _controller.addListener(() {
      if (_controller.value >= 0.5 && displayedLevel == widget.prevLevel) {
        setState(() {
          displayedLevel = widget.level;
        });
      }
    });

    _controller.addListener(() {
      if (_controller.value >= 0.4 && !_hasBlastedConfetti) {
        _confettiController.play();
        _hasBlastedConfetti = true;
      }
    });

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _vocabAnimation = IntTween(begin: _startVocab, end: _endVocab).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutQuad),
      ),
    );

    _grammarAnimation =
        IntTween(begin: _startGrammar, end: _endGrammar).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutQuad),
      ),
    );

    _skillsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _shrinkMultiplier = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
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

  void _setGrammarAndVocab() {
    _endGrammar = MatrixState.pangeaController.getAnalytics.constructListModel
        .unlockedLemmas(
          ConstructTypeEnum.morph,
        )
        .length;

    _endVocab = MatrixState.pangeaController.getAnalytics.constructListModel
        .unlockedLemmas(
          ConstructTypeEnum.vocab,
        )
        .length;
  }

  int _getSkillXP(LearningSkillsEnum skill) {
    return switch (skill) {
      LearningSkillsEnum.writing =>
        _constructSummary?.writingConstructScore ?? 0,
      LearningSkillsEnum.reading =>
        _constructSummary?.readingConstructScore ?? 0,
      LearningSkillsEnum.speaking =>
        _constructSummary?.speakingConstructScore ?? 0,
      LearningSkillsEnum.hearing =>
        _constructSummary?.hearingConstructScore ?? 0,
      _ => 0,
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final grammarVocabStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        );

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    avatarUrl == null
                        ? const CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: MxcImage(
                              uri: avatarUrl,
                              width: 150 * _shrinkMultiplier.value,
                              height: 150 * _shrinkMultiplier.value,
                            ),
                          ),
                    Text(
                      language,
                      style: TextStyle(
                        fontSize: 24 * _skillsOpacity.value,
                        color: AppConfig.goldLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Avatar and language
              /*AnimatedBuilder(
                animation: _progressAnimation,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<Profile>(
                      future: client.fetchOwnProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const CircularProgressIndicator(); // Or a skeleton
                        }
                        if (snapshot.hasError) {
                          print("Profile fetch error: ${snapshot.error}");
                          return const Text("Error loading profile");
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          print("No profile data!");
                          return const Text("No data");
                        }


                        return ListTile(
                          leading: Avatar(
                            mxContent: snapshot.data?.avatarUrl,
                            size: 20,
                          ),
                          title: Text(profile?.displayName ?? client.userID!),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Text(
                      language,
                      style: TextStyle(
                        fontSize: 24 * _skillsOpacity.value,
                        color: AppConfig.goldLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),*/
              // Progress bar + Level
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (_, __) => Row(
                  children: [
                    Expanded(
                      child: ProgressBar(
                        levelBars: [
                          LevelBarDetails(
                            widthMultiplier: _progressAnimation.value,
                            currentPoints: 0,
                            fillColor: AppConfig.goldLight,
                          ),
                        ],
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "⭐ $displayedLevel",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppConfig.goldLight,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Vocab and grammar row
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.dictionary,
                      color: colorScheme.primary,
                      size: 35,
                    ),
                    const SizedBox(width: 8),
                    Text('${_vocabAnimation.value}', style: grammarVocabStyle),
                    const SizedBox(width: 40),
                    Icon(
                      Symbols.toys_and_games,
                      color: colorScheme.primary,
                      size: 35,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_grammarAnimation.value}',
                      style: grammarVocabStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Skills section
              AnimatedBuilder(
                animation: _skillsOpacity,
                builder: (_, __) => Opacity(
                  opacity: _skillsOpacity.value,
                  child: _error == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSkillsTable(context),
                            const SizedBox(height: 8),
                            if (_constructSummary?.textSummary != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  _constructSummary!.textSummary,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            //const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${AppConfig.assetsBaseURL}/${LevelUpConstants.dinoLevelUPFileName}",
                                width: 400,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )
                      // if error getting construct summary
                      : Row(
                          children: [
                            Tooltip(
                              message: L10n.of(context).oopsSomethingWentWrong,
                              child: Icon(
                                Icons.error,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              // Share button, currently no functionality
              ElevatedButton(
                onPressed: () {
                  // Add share functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Share with Friends",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.ios_share,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Confetti overlay
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            emissionFrequency: 0.1,
            numberOfParticles: 7,
            colors: const [
              AppConfig.goldLight,
              AppConfig.gold,
            ], // manually specify the colors to be used
            createParticlePath: drawStar, // define a custom shape/path.
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsTable(BuildContext context) {
    final visibleSkills = LearningSkillsEnum.values
        .where((skill) => _getSkillXP(skill) > -1)
        .toList();

    const itemsPerRow = 3;
    // chunk into rows of up to 3
    final rows = <List<LearningSkillsEnum>>[
      for (var i = 0; i < visibleSkills.length; i += itemsPerRow)
        visibleSkills.sublist(
          i,
          min(i + itemsPerRow, visibleSkills.length),
        ),
    ];

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: row.map((skill) {
              return Flexible(
                fit: FlexFit.loose,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      skill.tooltip(context),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      skill.icon,
                      size: 25,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+ ${_getSkillXP(skill)} XP',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.gold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }
}
