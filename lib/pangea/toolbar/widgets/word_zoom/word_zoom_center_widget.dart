import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_misc/message_analytics_controller.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/morphs/morphological_center_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/word_zoom_widget.dart';

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

  MessageOverlayController get overlayController =>
      wordDetailsController.widget.overlayController;

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
          overlayController: overlayController,
          onEditDone: wordDetailsController.onEditDone,
        );
      case WordZoomSelection.lemma:
        return Text(token.lemma.text, textAlign: TextAlign.center);
      case WordZoomSelection.emoji:
        return token.getEmoji() != null
            ? Text(token.getEmoji()!)
            : const Text("emoji is null");
      case WordZoomSelection.meaning:
        return LemmaMeaningWidget(
          text:
              token.lemma.text.isEmpty ? token.text.content : token.lemma.text,
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
