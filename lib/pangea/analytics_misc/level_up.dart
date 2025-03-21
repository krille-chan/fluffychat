import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:http/http.dart' as http;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'level_summary.dart';

class LevelUpUtil {
  static void showLevelUpDialog(
    int level,
    String? analyticsRoomId,
    String? summaryStateEventId,
    ConstructSummary? constructSummary,
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
        analyticsRoomId: analyticsRoomId,
        summaryStateEventId: summaryStateEventId,
        constructSummary: constructSummary,
      ),
    ).then((_) => player.dispose());
  }
}

class LevelUpAnimation extends StatefulWidget {
  final int level;
  final String? analyticsRoomId;
  final String? summary;
  final String? summaryStateEventId;
  final ConstructSummary? constructSummary;

  const LevelUpAnimation({
    required this.level,
    required this.analyticsRoomId,
    this.summary,
    this.summaryStateEventId,
    this.constructSummary,
    super.key,
  });

  @override
  LevelUpAnimationState createState() => LevelUpAnimationState();
}

class LevelUpAnimationState extends State<LevelUpAnimation> {
  Uint8List? bytes;
  final imageURL =
      "${AppConfig.assetsBaseURL}/${AnalyticsConstants.levelUpImageFileName}";

  @override
  void initState() {
    super.initState();
    _loadImageData().catchError((e) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
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

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Banner image
          Image.memory(
            bytes!,
            height: kIsWeb ? 350 : 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Overlay: centered title and close button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: kIsWeb ? 200 : 100,
                ), // Added hardcoded padding above the text
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(L10n.of(context).close),
                  ),
                  const SizedBox(width: 16),
                  if (widget.summaryStateEventId != null &&
                      widget.analyticsRoomId != null)
                    // Show summary button
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => LevelSummaryDialog(
                            level: widget.level,
                            analyticsRoomId: widget.analyticsRoomId!,
                            summaryStateEventId: widget.summaryStateEventId!,
                            constructSummary: widget.constructSummary,
                          ),
                        );
                      },
                      child: Text(L10n.of(context).levelSummaryTrigger),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
