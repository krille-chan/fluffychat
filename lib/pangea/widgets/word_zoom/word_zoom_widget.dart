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
  ActivityTypeEnum? _activityType;

  // morphological activities
  String? _selectedMorphFeature;

  /// used to trigger a rebuild of the morph activity
  /// button when a morph activity is completed
  int completedMorphActivities = 0;

  // defintion activities
  String? _definition;

  // lemma activities
  String? _lemma;

  // emoji activities
  String? _emoji;

  // whether activity type can be generated
  Map<ActivityTypeEnum, bool> canGenerateActivity = {
    ActivityTypeEnum.morphId: true,
    ActivityTypeEnum.wordMeaning: true,
    ActivityTypeEnum.lemmaId: false,
    ActivityTypeEnum.emoji: true,
  };

  Future<void> _initCanGenerateActivity() async {
    widget.token.canGenerateDistractors(ActivityTypeEnum.lemmaId).then((value) {
      if (mounted) {
        setState(() {
          canGenerateActivity[ActivityTypeEnum.lemmaId] = value;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initCanGenerateActivity();
  }

  @override
  void didUpdateWidget(covariant WordZoomWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.token != oldWidget.token) {
      _clean();
      _initCanGenerateActivity();
    }
  }

  bool _showActivityCard(ActivityTypeEnum? activityType) {
    if (activityType == null) return false;
    final shouldDo = widget.token.shouldDoActivity(
      a: activityType,
      feature: _selectedMorphFeature,
      tag: _selectedMorphFeature == null
          ? null
          : widget.token.morph[_selectedMorphFeature],
    );

    return canGenerateActivity[activityType]! && shouldDo;
  }

  void _clean() {
    if (mounted) {
      setState(() {
        _activityType = null;
        _selectedMorphFeature = null;
        _definition = null;
        _lemma = null;
        _emoji = null;
      });
    }
  }

  void _setSelectedMorphFeature(String? feature) {
    _selectedMorphFeature = _selectedMorphFeature == feature ? null : feature;
    _setActivityType(
      _selectedMorphFeature == null ? null : ActivityTypeEnum.morphId,
    );
  }

  void _setActivityType(ActivityTypeEnum? activityType) {
    if (mounted) setState(() => _activityType = activityType);
  }

  void _setDefinition(String definition) {
    if (mounted) setState(() => _definition = definition);
  }

  void _setLemma(String lemma) {
    if (mounted) setState(() => _lemma = lemma);
  }

  void _setEmoji(String emoji) {
    if (mounted) setState(() => _emoji = emoji);
  }

  void onActivityFinish({
    required ActivityTypeEnum activityType,
    String? correctAnswer,
  }) {
    switch (activityType) {
      case ActivityTypeEnum.morphId:
        if (mounted) setState(() => completedMorphActivities++);
        break;
      case ActivityTypeEnum.wordMeaning:
        if (correctAnswer == null) return;
        _setDefinition(correctAnswer);
        break;
      case ActivityTypeEnum.lemmaId:
        if (correctAnswer == null) return;
        _setLemma(correctAnswer);
        break;
      case ActivityTypeEnum.emoji:
        if (correctAnswer == null) return;
        widget.token
            .setEmoji(correctAnswer)
            .then((_) => _setEmoji(correctAnswer));
        break;
      default:
        break;
    }
  }

  Widget get _activityAnswer {
    switch (_activityType) {
      case ActivityTypeEnum.morphId:
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
      case ActivityTypeEnum.wordMeaning:
        return _definition != null
            ? Text(_definition!)
            : const Text("defintion is null");
      case ActivityTypeEnum.lemmaId:
        return _lemma != null ? Text(_lemma!) : const Text("lemma is null");
      case ActivityTypeEnum.emoji:
        return _emoji != null ? Text(_emoji!) : const Text("emoji is null");
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minHeight: AppConfig.toolbarMinHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints:
                    const BoxConstraints(minWidth: AppConfig.toolbarMinWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EmojiPracticeButton(
                      emoji: _emoji,
                      token: widget.token,
                      onPressed: () => _setActivityType(
                        _activityType == ActivityTypeEnum.emoji
                            ? null
                            : ActivityTypeEnum.emoji,
                      ),
                      setEmoji: _setEmoji,
                    ),
                    WordTextWithAudioButton(
                      text: widget.token.text.content,
                      ttsController: widget.tts,
                      eventID: widget.messageEvent.eventId,
                    ),
                    LemmaWidget(
                      token: widget.token,
                      onPressed: () => _setActivityType(
                        _activityType == ActivityTypeEnum.lemmaId
                            ? null
                            : ActivityTypeEnum.lemmaId,
                      ),
                      lemma: _lemma,
                      setLemma: _setLemma,
                    ),
                  ],
                ),
              ),
              if (_activityType != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_showActivityCard(_activityType))
                      PracticeActivityCard(
                        pangeaMessageEvent: widget.messageEvent,
                        targetTokensAndActivityType:
                            TargetTokensAndActivityType(
                          tokens: [widget.token],
                          activityType: _activityType!,
                        ),
                        overlayController: widget.overlayController,
                        morphFeature: _selectedMorphFeature,
                        wordDetailsController: this,
                      )
                    else
                      _activityAnswer,
                  ],
                )
              else
                ContextualTranslationWidget(
                  token: widget.token,
                  fullText: widget.messageEvent.messageDisplayText,
                  langCode: widget.messageEvent.messageDisplayLangCode,
                  onPressed: () =>
                      _setActivityType(ActivityTypeEnum.wordMeaning),
                  definition: _definition,
                  setDefinition: _setDefinition,
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MorphologicalListWidget(
                    token: widget.token,
                    setMorphFeature: _setSelectedMorphFeature,
                    selectedMorphFeature: _selectedMorphFeature,
                    completedActivities: completedMorphActivities,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
