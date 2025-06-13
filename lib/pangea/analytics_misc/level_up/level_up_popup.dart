import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/level_up_banner.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/level_up_manager.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/level_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix_api_lite/generated/model.dart';

class LevelUpPopup extends StatelessWidget {
  const LevelUpPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FullWidthDialog(
      maxWidth: 400,
      maxHeight: 800,
      dialogContent: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: kIsWeb
              ? Text(
                  L10n.of(context).youHaveLeveledUp,
                  style: const TextStyle(
                    color: AppConfig.gold,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
        body: LevelUpPopupContent(
          prevLevel: LevelUpManager.instance.prevLevel ?? 0,
          level: LevelUpManager.instance.level ?? 0,
        ),
      ),
    );
  }
}

//animated progress bar -- move to own file later
class LevelUpPopupContent extends StatefulWidget {
  final int prevLevel;
  final int level;

  const LevelUpPopupContent({
    super.key,
    required this.prevLevel,
    required this.level,
  });

  @override
  State<LevelUpPopupContent> createState() => _LevelUpPopupContentState();
}

class _LevelUpPopupContentState extends State<LevelUpPopupContent>
    with SingleTickerProviderStateMixin {
  late int _endGrammar;
  late int _endVocab;
  late final AnimationController _controller;

  Uri? avatarUrl;
  late final Future<Profile> profile;

  late final ConfettiController _confettiController;

  int displayedLevel = -1;
  bool _hasBlastedConfetti = false;

  static final int _startGrammar = LevelUpManager.instance.prevGrammar ?? 0;
  static final int _startVocab = LevelUpManager.instance.prevVocab ?? 0;
  static final ConstructSummary? _constructSummary =
      LevelUpManager.instance.constructSummary;
  static final String? _error = LevelUpManager.instance.error;
  static final String language = LevelUpManager.instance.userL2Code ?? "N/A";

  static const Duration _animationDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    LevelUpManager.instance.markPopupSeen();

    displayedLevel = widget.prevLevel;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    // Use LevelUpManager stats instead of fetching separately
    _endGrammar = LevelUpManager.instance.nextGrammar ?? 0;
    _endVocab = LevelUpManager.instance.nextVocab ?? 0;

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

    _controller.forward();
  }

  // Use LevelUpManager's constructSummary instead of local _constructSummary
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
    LevelUpManager.instance.reset();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final Animation<double> progressAnimation =
        Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );

    final Animation<int> vocabAnimation =
        IntTween(begin: _startVocab, end: _endVocab).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutQuad),
      ),
    );

    final Animation<int> grammarAnimation =
        IntTween(begin: _startGrammar, end: _endGrammar).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutQuad),
      ),
    );

    final Animation<double> skillsOpacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    final Animation<double> shrinkMultiplier =
        Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );

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
                animation: _controller,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: avatarUrl == null
                          ? const CircularProgressIndicator()
                          : ClipOval(
                              child: MxcImage(
                                uri: avatarUrl,
                                width: 150 * shrinkMultiplier.value,
                                height: 150 * shrinkMultiplier.value,
                              ),
                            ),
                    ),
                    Text(
                      language,
                      style: TextStyle(
                        fontSize: 24 * skillsOpacity.value,
                        color: AppConfig.goldLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Progress bar + Level
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return LevelBar(
                            details: const LevelBarDetails(
                              fillColor: Colors.green,
                              currentPoints: 0,
                              widthMultiplier: 1,
                            ),
                            progressBarDetails: ProgressBarDetails(
                              totalWidth: constraints.maxWidth *
                                  progressAnimation.value,
                              height: 20,
                              borderColor: colorScheme.surface,
                            ),
                          );
                        },
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
                    Text('${vocabAnimation.value}', style: grammarVocabStyle),
                    const SizedBox(width: 40),
                    Icon(
                      Symbols.toys_and_games,
                      color: colorScheme.primary,
                      size: 35,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${grammarAnimation.value}',
                      style: grammarVocabStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Skills section
              AnimatedBuilder(
                animation: skillsOpacity,
                builder: (_, __) => Opacity(
                  opacity: skillsOpacity.value,
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
            emissionFrequency: 0.2,
            numberOfParticles: 15,
            gravity: 0.1,
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
