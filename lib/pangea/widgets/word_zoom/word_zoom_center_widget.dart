import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
import 'package:fluffychat/pangea/widgets/chat/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/widgets/word_zoom/lemma_meaning_widget.dart';
import 'package:fluffychat/pangea/widgets/word_zoom/word_zoom_widget.dart';
import 'package:flutter/material.dart';

class WordZoomCenterWidget extends StatelessWidget {
  final WordZoomSelection? selectionType;
  final String? selectedMorphFeature;
  final bool shouldDoActivity;
  final bool locked;
  final WordZoomWidgetState wordDetailsController;

  const WordZoomCenterWidget({
    required this.selectionType,
    required this.selectedMorphFeature,
    required this.shouldDoActivity,
    required this.locked,
    required this.wordDetailsController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (selectionType == null) {
      return const ToolbarContentLoadingIndicator();
    }

    if (shouldDoActivity || locked) {
      return PracticeActivityCard(
        pangeaMessageEvent: wordDetailsController.widget.messageEvent,
        targetTokensAndActivityType: TargetTokensAndActivityType(
          tokens: [wordDetailsController.widget.token],
          activityType: selectionType!.activityType,
        ),
        overlayController: wordDetailsController.widget.overlayController,
        morphFeature: selectedMorphFeature,
        wordDetailsController: wordDetailsController,
      );
    }

    if (selectionType == WordZoomSelection.meaning) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LemmaMeaningWidget(
            lemma: wordDetailsController.widget.token.lemma.text.isNotEmpty
                ? wordDetailsController.widget.token.lemma.text
                : wordDetailsController.widget.token.lemma.form,
            pos: wordDetailsController.widget.token.pos,
            langCode: wordDetailsController
                .widget.messageEvent.messageDisplayLangCode,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActivityAnswerWidget(
            token: wordDetailsController.widget.token,
            selectionType: selectionType!,
            selectedMorphFeature: selectedMorphFeature,
          ),
        ],
      ),
    );
  }
}
