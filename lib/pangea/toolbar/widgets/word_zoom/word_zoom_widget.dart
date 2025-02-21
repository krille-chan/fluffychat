import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/emoji_practice_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_activity/word_text_with_audio_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/morphs/morphological_list_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/word_zoom_center_widget.dart';

enum WordZoomSelection {
  meaning,
  emoji,
  lemma,
  morph,
}

extension WordZoomSelectionUtils on WordZoomSelection {
  ActivityTypeEnum get activityType {
    switch (this) {
      case WordZoomSelection.meaning:
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
  /// Null if not set yet, since it takes a second to determine if the lemma activity can be shown.
  WordZoomSelection? _selectionType;

  /// If doing a morphological activity, this is the selected morph feature.
  String? _selectedMorphFeature;

  /// If non-null and not complete, the activity will be shown regardless of shouldDoActivity.
  /// Used to show the practice activity card's savor the joy animation.
  /// (Analytics sending triggers the point gain animation, do also
  /// causes shouldDoActivity to be false. This is a workaround.)
  Completer<void>? _activityLock;

  // The function to determine if lemma distractors can be generated
  // is computationally expensive, so we only do it once
  bool _canGenerateLemmaActivity = false;

  bool _hideCenterContent = false;

  @override
  void initState() {
    super.initState();
    _setInitialSelectionType();
  }

  @override
  void didUpdateWidget(covariant WordZoomWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.token != oldWidget.token) {
      _clean();
      _setInitialSelectionType();
    }
  }

  void _clean() {
    if (mounted) {
      setState(() {
        _activityLock = null;
        _selectionType = null;
        _selectedMorphFeature = null;
      });
    }
  }

  Future<void> _setCanGenerateLemmaActivity() async {
    final canGenerate = await widget.token.canGenerateLemmaDistractors();
    if (mounted) setState(() => _canGenerateLemmaActivity = canGenerate);
  }

  Future<void> _setInitialSelectionType() async {
    if (_selectionType != null) return;
    await _setCanGenerateLemmaActivity();
    _setSelectionType(_defaultSelectionType);
  }

  WordZoomSelection get _defaultSelectionType =>
      _shouldShowActivity(WordZoomSelection.lemma)
          ? WordZoomSelection.lemma
          : WordZoomSelection.meaning;

  Future<void> _setSelectionType(
    WordZoomSelection type, {
    String? feature,
  }) async {
    WordZoomSelection newSelectedType = type;
    String? newSelectedFeature;
    if (type != WordZoomSelection.morph) {
      // if setting selectionType to non-morph activity, either set it if it's not
      // already selected, or reset to it the default type
      newSelectedType = _selectionType == type ? _defaultSelectionType : type;
    } else {
      // otherwise (because there could be multiple different morph features), check
      // if the feature is already selected, and if so, reset to the default type.
      // if not, set the selectionType and feature
      newSelectedFeature = _selectedMorphFeature == feature ? null : feature;
      newSelectedType = newSelectedFeature == null
          ? _defaultSelectionType
          : WordZoomSelection.morph;
    }

    // wait for savor the joy animation to finish before changing the selection type
    if (_activityLock != null) await _activityLock!.future;

    _selectionType = newSelectedType;
    _selectedMorphFeature = newSelectedFeature;
    if (mounted) setState(() {});
  }

  void _lockActivity() {
    if (mounted) setState(() => _activityLock = Completer());
  }

  void _unlockActivity() {
    if (_activityLock == null) return;
    _activityLock!.complete();
    _activityLock = null;
    if (mounted) setState(() {});
  }

  void _setHideCenterContent(bool value) {
    if (mounted) setState(() => _hideCenterContent = value);
  }

  /// This function should be called before overlayController.onActivityFinish to
  /// prevent shouldDoActivity being set to false before _forceShowActivity is set to true.
  /// This keep the completed actvity visible to the user for a short time.
  void onActivityFinish({
    Duration savorTheJoyDuration = const Duration(seconds: 1),
  }) {
    _lockActivity();
    Future.delayed(savorTheJoyDuration, () {
      if (_selectionType == WordZoomSelection.lemma) {
        _setSelectionType(WordZoomSelection.meaning);
      }
      _unlockActivity();
    });
  }

  bool _shouldShowActivity(WordZoomSelection selection) {
    final shouldDo = widget.messageEvent.shouldDoActivity(
      token: widget.token,
      a: selection.activityType,
      feature: _selectedMorphFeature,
      tag: _selectedMorphFeature == null
          ? null
          : widget.token.morph[_selectedMorphFeature],
    );
    if (!shouldDo) return false;

    return selection == WordZoomSelection.lemma
        ? _canGenerateLemmaActivity
        : true;
  }

  void onEditDone() => widget.overlayController.initializeTokensAndMode();

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
                      // subtracting 16.0 to account for the padding
                      minWidth: AppConfig.toolbarMinWidth - 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EmojiPracticeButton(
                          token: widget.token,
                          onPressed: () =>
                              _setSelectionType(WordZoomSelection.emoji),
                          isSelected: _selectionType == WordZoomSelection.emoji,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              WordTextWithAudioButton(
                                text: widget.token.text.content,
                                ttsController: widget.tts,
                              ),
                              // if _selectionType is null, we don't know if the lemma activity
                              // can be shown yet, so we don't show the lemma definition
                              if (!_shouldShowActivity(
                                    WordZoomSelection.lemma,
                                  ) &&
                                  _selectionType != null)
                                LemmaWidget(
                                  token: widget.token,
                                  pangeaMessageEvent: widget.messageEvent,
                                  onEdit: () => _setHideCenterContent(true),
                                  onEditDone: () {
                                    _setHideCenterContent(false);
                                    onEditDone();
                                  },
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  if (!_hideCenterContent)
                    WordZoomCenterWidget(
                      selectionType: _selectionType,
                      selectedMorphFeature: _selectedMorphFeature,
                      shouldDoActivity: _selectionType != null
                          ? _shouldShowActivity(_selectionType!)
                          : false,
                      locked:
                          _activityLock != null && !_activityLock!.isCompleted,
                      wordDetailsController: this,
                    ),
                  MorphologicalListWidget(
                    pangeaMessageEvent: widget.messageEvent,
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
