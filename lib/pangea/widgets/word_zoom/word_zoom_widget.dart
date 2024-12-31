import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/utils/grammar/get_grammar_copy.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/chat/tts_controller.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/emoji_practice_button.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_card.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/word_text_with_audio_button.dart';
import 'package:fluffychat/pangea/widgets/word_zoom/contextual_translation_widget.dart';
import 'package:fluffychat/pangea/widgets/word_zoom/lemma_widget.dart';
import 'package:fluffychat/pangea/widgets/word_zoom/morphological_widget.dart';
import 'package:flutter/material.dart';

enum WordZoomSelection {
  translation,
  emoji,
  lemma,
  morph,
}

extension on WordZoomSelection {
  ActivityTypeEnum get activityType {
    switch (this) {
      case WordZoomSelection.translation:
        return ActivityTypeEnum.wordMeaning;
      case WordZoomSelection.emoji:
        return ActivityTypeEnum.emoji;
      case WordZoomSelection.lemma:
        return ActivityTypeEnum.lemmaId;
      case WordZoomSelection.morph:
        return ActivityTypeEnum.morphId;
    }
  }
}

class WordZoomWidget extends StatefulWidget {
  final PangeaToken token;
  final PangeaMessageEvent messageEvent;
  final TtsController tts;
  final MessageOverlayController overlayController;

  const WordZoomWidget({
    super.key,
    required this.token,
    required this.messageEvent,
    required this.tts,
    required this.overlayController,
  });

  @override
  WordZoomWidgetState createState() => WordZoomWidgetState();
}

class WordZoomWidgetState extends State<WordZoomWidget> {
  /// The currently selected word zoom activity type.
  /// If an activity should be shown for this type, shows that activity.
  /// If not, shows the info related to that activity type.
  /// Defaults to the lemma translation.
  WordZoomSelection _selectionType = WordZoomSelection.translation;

  /// If doing a morphological activity, this is the selected morph feature.
  String? _selectedMorphFeature;

  /// If true, the activity will be shown regardless of shouldDoActivity.
  /// Used to show the practice activity card's savor the joy animation.
  /// (Analytics sending triggers the point gain animation, do also
  /// causes shouldDoActivity to be false. This is a workaround.)
  bool _forceShowActivity = false;

  // The function to determine if lemma distractors can be generated
  // is computationally expensive, so we only do it once
  bool canGenerateLemmaActivity = false;

  @override
  void initState() {
    super.initState();
    _setCanGenerateLemmaActivity();
  }

  @override
  void didUpdateWidget(covariant WordZoomWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.token != oldWidget.token) {
      _clean();
      _setCanGenerateLemmaActivity();
    }
  }

  void _clean() {
    if (mounted) {
      setState(() {
        _selectionType = WordZoomSelection.translation;
        _selectedMorphFeature = null;
        _forceShowActivity = false;
      });
    }
  }

  void _setCanGenerateLemmaActivity() {
    widget.token.canGenerateDistractors(ActivityTypeEnum.lemmaId).then((value) {
      if (mounted) setState(() => canGenerateLemmaActivity = value);
    });
  }

  void _setSelectionType(WordZoomSelection type, {String? feature}) {
    WordZoomSelection newSelectedType = type;
    String? newSelectedFeature;
    if (type != WordZoomSelection.morph) {
      // if setting selectionType to non-morph activity, either set it if it's not
      // already selected, or reset to it the default type
      newSelectedType =
          _selectionType == type ? WordZoomSelection.translation : type;
    } else {
      // otherwise (because there could be multiple different morph features), check
      // if the feature is already selected, and if so, reset to the default type.
      // if not, set the selectionType and feature
      newSelectedFeature = _selectedMorphFeature == feature ? null : feature;
      newSelectedType = newSelectedFeature == null
          ? WordZoomSelection.translation
          : WordZoomSelection.morph;
    }

    _selectionType = newSelectedType;
    _selectedMorphFeature = newSelectedFeature;
    if (mounted) setState(() {});
  }

  void _setForceShowActivity(bool showActivity) {
    if (mounted) setState(() => _forceShowActivity = showActivity);
  }

  /// This function should be called before overlayController.onActivityFinish to
  /// prevent shouldDoActivity being set to false before _forceShowActivity is set to true.
  /// This keep the completed actvity visible to the user for a short time.
  void onActivityFinish({
    Duration savorTheJoyDuration = const Duration(seconds: 1),
  }) {
    _setForceShowActivity(true);
    Future.delayed(savorTheJoyDuration, () {
      _setForceShowActivity(false);
    });
  }

  Widget get _wordZoomCenterWidget {
    final showActivity = widget.token.shouldDoActivity(
          a: _selectionType.activityType,
          feature: _selectedMorphFeature,
          tag: _selectedMorphFeature == null
              ? null
              : widget.token.morph[_selectedMorphFeature],
        ) &&
        (_selectionType != WordZoomSelection.lemma || canGenerateLemmaActivity);

    if (showActivity || _forceShowActivity) {
      return PracticeActivityCard(
        pangeaMessageEvent: widget.messageEvent,
        targetTokensAndActivityType: TargetTokensAndActivityType(
          tokens: [widget.token],
          activityType: _selectionType.activityType,
        ),
        overlayController: widget.overlayController,
        morphFeature: _selectedMorphFeature,
        wordDetailsController: this,
      );
    }

    if (_selectionType == WordZoomSelection.translation) {
      return ContextualTranslationWidget(
        token: widget.token,
        langCode: widget.messageEvent.messageDisplayLangCode,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_activityAnswer],
      ),
    );
  }

  Widget get _activityAnswer {
    switch (_selectionType) {
      case WordZoomSelection.morph:
        if (_selectedMorphFeature == null) {
          return const Text("There should be a selected morph feature");
        }
        final String morphTag = widget.token.morph[_selectedMorphFeature!];
        final copy = getGrammarCopy(
          category: _selectedMorphFeature!,
          lemma: morphTag,
          context: context,
        );
        return Text(copy ?? morphTag);
      case WordZoomSelection.lemma:
        return Text(widget.token.lemma.text);
      case WordZoomSelection.emoji:
        return widget.token.getEmoji() != null
            ? Text(widget.token.getEmoji()!)
            : const Text("emoji is null");
      case WordZoomSelection.translation:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppConfig.toolbarMinHeight,
        maxHeight: AppConfig.toolbarMaxHeight,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicWidth(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppConfig.toolbarMinHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: AppConfig.toolbarMinWidth,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        EmojiPracticeButton(
                          token: widget.token,
                          onPressed: () =>
                              _setSelectionType(WordZoomSelection.emoji),
                          isSelected: _selectionType == WordZoomSelection.emoji,
                        ),
                        WordTextWithAudioButton(
                          text: widget.token.text.content,
                          ttsController: widget.tts,
                          eventID: widget.messageEvent.eventId,
                        ),
                        LemmaWidget(
                          token: widget.token,
                          onPressed: () =>
                              _setSelectionType(WordZoomSelection.lemma),
                          isSelected: _selectionType == WordZoomSelection.lemma,
                        ),
                      ],
                    ),
                  ),
                  _wordZoomCenterWidget,
                  MorphologicalListWidget(
                    token: widget.token,
                    setMorphFeature: (feature) => _setSelectionType(
                      WordZoomSelection.morph,
                      feature: feature,
                    ),
                    selectedMorphFeature: _selectedMorphFeature,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
