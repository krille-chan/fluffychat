import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/put_analytics_controller.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/widgets/chat/tts_controller.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordFocusListeningActivity extends StatefulWidget {
  final PracticeActivityModel activity;
  final PracticeActivityCardState practiceCardController;

  const WordFocusListeningActivity({
    super.key,
    required this.activity,
    required this.practiceCardController,
  });

  @override
  WordFocusListeningActivityState createState() =>
      WordFocusListeningActivityState();

  ActivityContent get activityContent => activity.content;
}

class WordFocusListeningActivityState
    extends State<WordFocusListeningActivity> {
  int? selectedChoiceIndex;

  TtsController tts = TtsController();

  final double buttonSize = 40;

  PracticeActivityRecordModel? get currentRecordModel =>
      widget.practiceCardController.currentCompletionRecord;

  initializeTTS() async {
    tts.setupTTS().then((value) => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    initializeTTS();
  }

  void checkAnswer(int index) {
    final String value = widget.activityContent.choices[index];

    if (currentRecordModel?.hasTextResponse(value) ?? false) {
      return;
    }

    final bool isCorrect = widget.activity.content.isCorrect(value, index);

    currentRecordModel?.addResponse(
      text: value,
      score: isCorrect ? 1 : 0,
    );

    if (currentRecordModel == null ||
        currentRecordModel!.latestResponse == null) {
      debugger(when: kDebugMode);
      return;
    }

    MatrixState.pangeaController.putAnalytics.setState(
      AnalyticsStream(
        // note - this maybe should be the activity event id
        eventId:
            widget.practiceCardController.widget.pangeaMessageEvent.eventId,
        roomId: widget.practiceCardController.widget.pangeaMessageEvent.room.id,
        constructs: currentRecordModel!.latestResponse!.toUses(
          widget.practiceCardController.currentActivity!,
          widget.practiceCardController.metadata,
        ),
        origin: AnalyticsUpdateOrigin.practiceActivity,
      ),
    );
    setState(() {
      selectedChoiceIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Text question at the top
        Text(
          widget.activityContent.question,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // Blank slot for the answer
        DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return CircleAvatar(
              radius: buttonSize,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppConfig.primaryColor.withAlpha(100),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            );
          },
          onAcceptWithDetails: (details) => checkAnswer(details.data),
        ),
        const SizedBox(height: 10),
        // Audio options as draggable buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            widget.activityContent.choices.length,
            (index) => Draggable<int>(
              data: index,
              feedback: _buildAudioButton(context, theme, index),
              childWhenDragging: _buildAudioButton(context, theme, index, true),
              child: _buildAudioButton(context, theme, index),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build the audio buttons
  Widget _buildAudioButton(
    BuildContext context,
    ThemeData theme,
    int index, [
    bool dragging = false,
  ]) {
    final isAnswerCorrect = widget.activityContent.isCorrect(
      widget.activityContent.choices[index],
      index,
    );
    Color buttonColor;
    if (selectedChoiceIndex == index) {
      buttonColor = isAnswerCorrect
          ? theme.colorScheme.secondary.withAlpha(180) // Correct: Green
          : theme.colorScheme.error.withAlpha(180); // Incorrect: Red
    } else {
      buttonColor =
          AppConfig.primaryColor.withAlpha(100); // Default: Primary color
    }

    return GestureDetector(
      onTap: () => tts.tryToSpeak(
        widget.activityContent.choices[index],
        context,
        widget.practiceCardController.widget.pangeaMessageEvent.eventId,
      ),
      child: CircleAvatar(
        radius: buttonSize,
        backgroundColor: dragging ? Colors.grey.withAlpha(128) : buttonColor,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
