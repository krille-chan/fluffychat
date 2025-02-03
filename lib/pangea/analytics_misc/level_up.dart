import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart' as http;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';

class LevelUpUtil {
  static void showLevelUpDialog(
    int level,
    BuildContext context,
  ) {
    final player = AudioPlayer();
    player.play(
      UrlSource(
        "${AppConfig.assetsBaseURL}/${AnalyticsConstants.levelUpAudioFileName}",
      ),
    );

    showDialog(
      context: context,
      builder: (context) => LevelUpAnimation(
        level: level,
      ),
    ).then((_) => player.dispose());
  }
}

class LevelUpAnimation extends StatefulWidget {
  final int level;

  const LevelUpAnimation({
    required this.level,
    super.key,
  });

  @override
  LevelUpAnimationState createState() => LevelUpAnimationState();
}

class LevelUpAnimationState extends State<LevelUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  Uint8List? bytes;
  final imageURL =
      "${AppConfig.assetsBaseURL}/${AnalyticsConstants.levelUpImageFileName}";

  @override
  void initState() {
    super.initState();
    _loadImageData().then((resp) {
      if (bytes == null) return;
      _animationController.forward().then((_) {
        if (mounted) Navigator.of(context).pop();
      });
    }).catchError((e) {
      if (mounted) Navigator.of(context).pop();
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _slideAnimation = TweenSequence<Offset>(
      <TweenSequenceItem<Offset>>[
        // Slide up from the bottom of the screen to the middle
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 2.0, // Adjust weight for the duration of the slide-up
        ),
        // Pause in the middle
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset.zero, end: Offset.zero)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 8.0, // Adjust weight for the pause duration
        ),
        // Slide up and off the screen
        TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -2))
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 2.0, // Adjust weight for the slide-off duration
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear, // Keep overall animation smooth
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadImageData() async {
    final resp =
        await http.get(Uri.parse(imageURL)).timeout(const Duration(seconds: 5));
    if (resp.statusCode != 200) return;
    if (mounted) {
      setState(() => bytes = resp.bodyBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bytes == null) {
      return const SizedBox();
    }

    Widget content = Image.memory(
      bytes!,
      height: kIsWeb ? 350 : 250,
    );

    if (!kIsWeb) {
      content = OverflowBox(
        maxWidth: double.infinity,
        child: content,
      );
    }

    return GestureDetector(
      onDoubleTap: Navigator.of(context).pop,
      child: Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: Stack(
              alignment: Alignment.center,
              children: [
                content,
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text(
                    L10n.of(context).levelPopupTitle(widget.level),
                    style: const TextStyle(
                      fontSize: kIsWeb ? 40 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
