import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/widgets/chat/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/widgets/word_zoom/lemma_meaning_widget.dart';
import 'package:fluffychat/pangea/widgets/word_zoom/morphs/morphological_center_widget.dart';
import 'package:fluffychat/pangea/widgets/word_zoom/word_zoom_widget.dart';

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

  PangeaToken get token => wordDetailsController.widget.token;

  Widget content(BuildContext context, WordZoomSelection selectionType) {
    switch (selectionType) {
      case WordZoomSelection.morph:
        if (selectedMorphFeature == null) {
          debugger(when: kDebugMode);
          return const Text("Morphological feature is null");
        }
        return MorphologicalCenterWidget(
          token: token,
          morphFeature: selectedMorphFeature!,
          pangeaMessageEvent: wordDetailsController.widget.messageEvent,
        );
      case WordZoomSelection.lemma:
        return Text(token.lemma.text, textAlign: TextAlign.center);
      case WordZoomSelection.emoji:
        return token.getEmoji() != null
            ? Text(token.getEmoji()!)
            : const Text("emoji is null");
      case WordZoomSelection.meaning:
        return LemmaMeaningWidget(
          lemma:
              token.lemma.text.isNotEmpty ? token.lemma.text : token.lemma.form,
          pos: token.pos,
          langCode:
              wordDetailsController.widget.messageEvent.messageDisplayLangCode,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shouldDoActivity || locked) {
      return PracticeActivityCard(
        pangeaMessageEvent: wordDetailsController.widget.messageEvent,
        targetTokensAndActivityType: TargetTokensAndActivityType(
          tokens: [token],
          activityType: selectionType!.activityType,
        ),
        overlayController: wordDetailsController.widget.overlayController,
        morphFeature: selectedMorphFeature,
        wordDetailsController: wordDetailsController,
      );
    }

    if (selectionType == null) {
      return const ToolbarContentLoadingIndicator();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [content(context, selectionType!)],
      ),
    );
  }
}
