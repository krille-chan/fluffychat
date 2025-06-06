import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_bar/progress_bar_details.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  ConstructSummary? _constructSummary;
  String? _error;

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
    if (!Environment.isStagingEnvironment) return;

    await _close();

    //if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => FullWidthDialog(
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
      ),
    );
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
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppConfig.gold,
                            ),
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
                                      child: IconButton(
                                        style: IconButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
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
                                      ),
                                    ),
                                ],
                              ),
                            ],
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
  late final AnimationController _controller;
  late final Animation<double> _progressAnimation;
  late final Animation<int> _vocabAnimation;
  late final Animation<int> _grammarAnimation;
  late final Animation<double> _skillsOpacity;
  late final Animation<double> _shrinkMultiplier;

  ConstructSummary? _constructSummary;

  static const int _startGrammar = 23;
  static const int _endGrammar = 78;
  static const int _startVocab = 54;
  static const int _endVocab = 64;

  static const double _startOpacity = 0.0;
  static const double _endOpacity = 1.0;
  static const Duration _animationDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    _loadConstructSummary();

    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

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

    _skillsOpacity =
        Tween<double>(begin: _startOpacity, end: _endOpacity).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _shrinkMultiplier = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  Future<void> _loadConstructSummary() async {
    final summary = await MatrixState.pangeaController.getAnalytics
        .generateLevelUpAnalytics(widget.level, widget.prevLevel);
    setState(() => _constructSummary = summary);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final grammarVocabStyle =
        TextStyle(color: colorScheme.primary, fontSize: 24);

    return Column(
      children: [
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (_, __) => Column(
            children: [
              // Avatar (static size)
              ClipOval(
                child: Image.asset(
                  '../../../assets/favicon.png',
                  width: 150 * _shrinkMultiplier.value,
                  height: 150 * _shrinkMultiplier.value,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10 * _shrinkMultiplier.value),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // Animated progress bar
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (_, __) => ProgressBar(
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
                const SizedBox(height: 25),
                // Animated vocab and grammar row
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
                      Text(
                        '${_vocabAnimation.value}',
                        style: grammarVocabStyle,
                      ),
                      const SizedBox(width: 40),
                      Icon(
                        Symbols.toys_and_games,
                        color: colorScheme.primary,
                        size: 35,
                      ),
                      Text(
                        '${_grammarAnimation.value}',
                        style: grammarVocabStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Skills section (fades in)
                AnimatedBuilder(
                  animation: _skillsOpacity,
                  builder: (_, __) => Opacity(
                    opacity: _skillsOpacity.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildSkillsTable(context),
                        const SizedBox(height: 24),
                        if (_constructSummary?.textSummary != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              _constructSummary!.textSummary,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        CachedNetworkImage(
                          imageUrl:
                              "${AppConfig.assetsBaseURL}/${LevelUpConstants.dinoLevelUPFileName}",
                          width: 400,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsTable(BuildContext context) {
    final visibleSkills = LearningSkillsEnum.values.where(
      (skill) => skill.isVisible && _getSkillXP(skill) > -1,
    );

    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: visibleSkills.map((skill) {
        return TableRow(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 9.0, horizontal: 18.0),
              child: Icon(
                skill.icon,
                size: 25,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 9.0, horizontal: 18.0),
              child: Text(
                skill.tooltip(context),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 9.0, horizontal: 18.0),
              child: Text(
                "+ ${_getSkillXP(skill)} XP",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
