import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix_api_lite/generated/model.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/level_up_banner.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/level_up_manager.dart';
import 'package:fluffychat/pangea/analytics_misc/level_up/rain_confetti.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/level_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class LevelUpPopup extends StatelessWidget {
  final Completer<ConstructSummary> constructSummaryCompleter;
  const LevelUpPopup({
    required this.constructSummaryCompleter,
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
          prevLevel: LevelUpManager.instance.prevLevel,
          level: LevelUpManager.instance.level,
          constructSummaryCompleter: constructSummaryCompleter,
        ),
      ),
    );
  }
}

class LevelUpPopupContent extends StatefulWidget {
  final int prevLevel;
  final int level;
  final Completer<ConstructSummary> constructSummaryCompleter;

  const LevelUpPopupContent({
    super.key,
    required this.prevLevel,
    required this.level,
    required this.constructSummaryCompleter,
  });

  @override
  State<LevelUpPopupContent> createState() => _LevelUpPopupContentState();
}

class _LevelUpPopupContentState extends State<LevelUpPopupContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final ConfettiController _confettiController;
  late final Future<Profile> profile;

  int displayedLevel = -1;
  Uri? avatarUrl;
  bool _hasBlastedConfetti = false;

  String language = MatrixState.pangeaController.languageController
          .activeL2Code()
          ?.toUpperCase() ??
      LanguageKeys.unknownLanguage;

  ConstructSummary? _constructSummary;
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadConstructSummary();
    LevelUpManager.instance.markPopupSeen();
    displayedLevel = widget.prevLevel;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));

    final client = Matrix.of(context).client;
    client.fetchOwnProfile().then((profile) {
      setState(() => avatarUrl = profile.avatarUrl);
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
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
      if (_controller.value >= 0.5 && !_hasBlastedConfetti) {
        _hasBlastedConfetti = true;
        rainConfetti(context);
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    LevelUpManager.instance.reset();
    stopConfetti();
    super.dispose();
  }

  int get _startGrammar => LevelUpManager.instance.prevGrammar;
  int get _startVocab => LevelUpManager.instance.prevVocab;

  get _endGrammar => LevelUpManager.instance.nextGrammar;
  get _endVocab => LevelUpManager.instance.nextVocab;

  Future<void> _loadConstructSummary() async {
    try {
      _constructSummary = await widget.constructSummaryCompleter.future;
    } catch (e) {
      _error = e;
    } finally {
      setState(() => _loading = false);
    }
  }

  int _getSkillXP(LearningSkillsEnum skill) {
    if (_constructSummary == null) return 0;
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
    final username =
        Matrix.of(context).client.userID?.split(':').first.substring(1) ?? '';

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
                          ? Avatar(
                              name: username,
                              showPresence: false,
                              size: 150 * shrinkMultiplier.value,
                            )
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
                              fillColor: AppConfig.goldLight,
                              currentPoints: 0,
                              widthMultiplier: 1,
                            ),
                            progressBarDetails: ProgressBarDetails(
                              totalWidth: constraints.maxWidth *
                                  progressAnimation.value,
                              height: 20,
                              borderColor: colorScheme.primary,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "⭐",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedFlipCounter(
                        value: displayedLevel,
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppConfig.goldLight,
                            ),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "+ ${_endVocab - _startVocab}",
                          style: const TextStyle(
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Symbols.dictionary,
                              color: colorScheme.primary,
                              size: 35,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${vocabAnimation.value}',
                              style: grammarVocabStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "+ ${_endGrammar - _startGrammar}",
                          style: const TextStyle(
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
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
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_loading)
                const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: AppConfig.goldLight,
                    ),
                  ),
                )
              else if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ErrorIndicator(
                    message: L10n.of(context).errorFetchingLevelSummary,
                  ),
                )
              else if (_constructSummary != null)
                // Skills section
                AnimatedBuilder(
                  animation: skillsOpacity,
                  builder: (_, __) => Opacity(
                    opacity: skillsOpacity.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildSkillsTable(context),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _constructSummary!.textSummary,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
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
                    ),
                  ),
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
              //     mainAxisSize: MainAxisSize.min,
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
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsTable(BuildContext context) {
    final visibleSkills = LearningSkillsEnum.values
        .where((skill) => (_getSkillXP(skill) > -1) && skill.isVisible)
        .toList();

    const itemsPerRow = 4;
    // chunk into rows of up to 4
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
}
