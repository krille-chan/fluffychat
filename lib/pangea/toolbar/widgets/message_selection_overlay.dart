import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/message_token_text/tokens_util.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_choice.dart';
import 'package:fluffychat/pangea/practice_activities/practice_selection.dart';
import 'package:fluffychat/pangea/practice_activities/practice_selection_repo.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';
import 'package:fluffychat/pangea/toolbar/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/reading_assistance_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/morph_selection.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_positioner.dart';
import 'package:fluffychat/pangea/toolbar/widgets/reading_assistance_content.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Controls data at the top level of the toolbar (mainly token / toolbar mode selection)
class MessageSelectionOverlay extends StatefulWidget {
  final ChatController chatController;
  final Event _event;
  final Event? _nextEvent;
  final Event? _prevEvent;
  final PangeaToken? _initialSelectedToken;
  final Timeline _timeline;

  const MessageSelectionOverlay({
    required this.chatController,
    required Event event,
    required PangeaToken? initialSelectedToken,
    required Event? nextEvent,
    required Event? prevEvent,
    required Timeline timeline,
    super.key,
  })  : _initialSelectedToken = initialSelectedToken,
        _nextEvent = nextEvent,
        _prevEvent = prevEvent,
        _event = event,
        _timeline = timeline;

  @override
  MessageOverlayController createState() => MessageOverlayController();
}

class MessageOverlayController extends State<MessageSelectionOverlay>
    with SingleTickerProviderStateMixin {
  Event get event => widget._event;
  /////////////////////////////////////
  /// Variables
  /////////////////////////////////////
  MessageMode toolbarMode = MessageMode.noneSelected;

  /// set and cleared by the PracticeActivityCard
  /// has to be at this level so drag targets can access it
  PracticeActivityModel? activity;

  /// selectedMorph is used for morph activities
  MorphSelection? selectedMorph;

  /// tracks selected choice
  PracticeChoice? selectedChoice;

  PangeaTokenText? _selectedSpan;

  List<PangeaTokenText>? _highlightedTokens;
  bool initialized = false;

  final GlobalKey<ReadingAssistanceContentState> wordZoomKey = GlobalKey();

  ReadingAssistanceMode? readingAssistanceMode; // default mode

  SpeechToTextModel? transcription;
  String? transcriptionError;

  bool showTranslation = false;
  String? translation;

  bool showSpeechTranslation = false;
  String? speechTranslation;

  final StreamController contentChangedStream = StreamController.broadcast();

  double maxWidth = AppConfig.toolbarMinWidth;

  /////////////////////////////////////
  /// Lifecycle
  /////////////////////////////////////

  @override
  void initState() {
    super.initState();
    initializeTokensAndMode();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.chatController.setSelectedEvent(event),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.chatController.clearSelectedEvents(),
    );
    contentChangedStream.close();
    super.dispose();
  }

  Future<void> initializeTokensAndMode() async {
    try {
      if (pangeaMessageEvent?.event.messageType != MessageTypes.Text) {
        return;
      }

      RepresentationEvent? repEvent =
          pangeaMessageEvent?.messageDisplayRepresentation;

      if (repEvent == null ||
          (repEvent.event == null && repEvent.tokens == null)) {
        repEvent = await _fetchNewRepEvent();
      }

      if (repEvent?.event != null) {
        await repEvent!.sendTokensEvent(
          repEvent.event!.eventId,
          widget._event.room,
          MatrixState.pangeaController.languageController.userL1!.langCode,
          MatrixState.pangeaController.languageController.userL2!.langCode,
        );
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "eventID": pangeaMessageEvent?.eventId,
        },
      );
    } finally {
      _initializeSelectedToken();
      _setInitialToolbarMode();
      initialized = true;
      if (mounted) setState(() {});
    }
  }

  Future<void> _setInitialToolbarMode() async {
    // 1) if we have a hidden word activity, then we should start with that
    if (practiceSelection?.hasHiddenWordActivity ?? false) {
      updateToolbarMode(MessageMode.practiceActivity);
      return;
    }
  }

  /// Decides whether an _initialSelectedToken should be used
  /// for a first practice activity on the word meaning
  Future<void> _initializeSelectedToken() async {
    // if there is no initial selected token, then we don't need to do anything
    if (widget._initialSelectedToken == null || practiceSelection == null) {
      return;
    }

    // should not already be involved in a hidden word activity
    // final isInHiddenWordActivity =
    //     messageAnalyticsEntry!.isTokenInHiddenWordActivity(
    //   widget._initialSelectedToken!,
    // );

    // // whether the activity should generally be involved in an activity
    if (practiceSelection?.hasHiddenWordActivity == true) {
      return;
    }

    updateSelectedSpan(widget._initialSelectedToken!.text);

    // int retries = 0;
    // while (retries < 5 &&
    //     selectedToken != null &&
    //     !MatrixState.pAnyState.isOverlayOpen(
    //       selectedToken!.text.uniqueKey,
    //     )) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    //   _showReadingAssistanceContent();
    //   retries++;
    // }
  }

  /////////////////////////////////////
  /// State setting
  /////////////////////////////////////

  /// We need to check if the setState call is safe to call immediately
  /// Kept getting the error: setState() or markNeedsBuild() called during build.
  /// This is a workaround to prevent that error
  @override
  void setState(VoidCallback fn) {
    // if (pangeaMessageEvent != null) {
    //   debugger(when: kDebugMode);
    //   modeLevel = toolbarMode.currentChoiceMode(this, pangeaMessageEvent!);
    // } else {
    //   debugger(when: kDebugMode);
    // }

    final phase = SchedulerBinding.instance.schedulerPhase;
    if (mounted &&
        (phase == SchedulerPhase.idle ||
            phase == SchedulerPhase.postFrameCallbacks)) {
      // It's safe to call setState immediately
      try {
        wordZoomKey.currentState?.setState(() {});

        super.setState(fn);
      } catch (e, s) {
        ErrorHandler.logError(
          e: "Error calling setState in MessageSelectionOverlay: $e",
          s: s,
          data: {},
        );
      }
    } else {
      // Defer the setState call to after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          if (mounted) super.setState(fn);
        } catch (e, s) {
          ErrorHandler.logError(
            e: "Error calling setState in MessageSelectionOverlay after postframeCallback: $e",
            s: s,
            data: {},
          );
        }
      });
    }
  }

  /// Update [selectedSpan]
  void updateSelectedSpan(PangeaTokenText? selectedSpan) {
    if (selectedSpan == _selectedSpan) return;
    if (selectedMorph != null) {
      selectedMorph = null;
    }
    // close overlay of previous token
    if (selectedToken != null) {
      MatrixState.pAnyState.closeOverlay(
        "${selectedToken!.text.uniqueKey}_toolbar",
      );
    }

    _selectedSpan = selectedSpan;
    if (mounted) setState(() {});

    //Commented out so onSelectNewTokens can be manually called after animation is finished
    // if (selectedToken != null && isNewToken(selectedToken!)) {
    //   _onSelectNewToken(selectedToken!);
    // }
  }

  void updateToolbarMode(MessageMode mode) => setState(() {
        selectedChoice = null;

        // close overlay of any selected token
        if (_selectedSpan != null) {
          updateSelectedSpan(_selectedSpan!);
        }

        toolbarMode = mode;
        if (toolbarMode != MessageMode.wordMorph) {
          selectedMorph = null;
        }
      });

  ///////////////////////////////////
  /// User action handlers
  /////////////////////////////////////
  void onRequestForMeaningChallenge() {
    if (practiceSelection == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: "MessageAnalyticsEntry is null in onRequestForMeaningChallenge",
        data: {},
      );
      return;
    }
    practiceSelection!.addMessageMeaningActivity();

    if (mounted) {
      setState(() {});
    }
  }

  void onChoiceSelect(PracticeChoice? choice, [bool force = false]) {
    if (selectedChoice == choice && !force) {
      selectedChoice = null;
    } else {
      selectedChoice = choice;
    }

    setState(() {});
  }

  void onMorphActivitySelect(MorphSelection newMorph) {
    toolbarMode = MessageMode.wordMorph;
    // // close overlay of previous token
    if (_selectedSpan != null && _selectedSpan != newMorph.token.text) {
      updateSelectedSpan(_selectedSpan!);
    }
    selectedMorph = newMorph;
    setState(() {});
  }

  /////////////////////////////////////
  /// Getters
  ////////////////////////////////////
  PangeaMessageEvent? get pangeaMessageEvent => PangeaMessageEvent(
        event: widget._event,
        timeline: widget._timeline,
        ownMessage: widget._event.room.client.userID == widget._event.senderId,
      );

  bool get showToolbarButtons =>
      pangeaMessageEvent != null &&
      pangeaMessageEvent!.event.messageType == MessageTypes.Text;

  bool get hideWordCardContent =>
      readingAssistanceMode == ReadingAssistanceMode.practiceMode;

  bool get isPracticeComplete => isTranslationUnlocked;

  bool get isEmojiDone =>
      practiceSelection
          ?.activities(ActivityTypeEnum.emoji)
          .every((a) => a.isComplete) ==
      true;

  bool get isMeaningDone =>
      practiceSelection
          ?.activities(ActivityTypeEnum.wordMeaning)
          .every((a) => a.isComplete) ==
      true;

  bool get isListeningDone =>
      practiceSelection
          ?.activities(ActivityTypeEnum.wordFocusListening)
          .every((a) => a.isComplete) ==
      true;

  bool get isMorphDone =>
      practiceSelection
          ?.activities(ActivityTypeEnum.morphId)
          .every((a) => a.isComplete) ==
      true;

  /// you have to complete one of the mode mini-games to unlock translation
  bool get isTranslationUnlocked =>
      pangeaMessageEvent?.ownMessage == true ||
      !messageInUserL2 ||
      isEmojiDone ||
      isMeaningDone ||
      isListeningDone ||
      isMorphDone;

  bool get isTotallyDone =>
      isEmojiDone && isMeaningDone && isListeningDone && isMorphDone;

  PracticeSelection? get practiceSelection =>
      pangeaMessageEvent?.messageDisplayRepresentation?.tokens != null
          ? PracticeSelectionRepo.get(
              pangeaMessageEvent!.messageDisplayLangCode,
              pangeaMessageEvent!.messageDisplayRepresentation!.tokens!,
            )
          : null;

  bool get messageInUserL2 =>
      pangeaMessageEvent?.messageDisplayLangCode.split("-")[0] ==
      MatrixState.pangeaController.languageController.userL2?.langCodeShort;

  PangeaToken? get selectedToken {
    if (pangeaMessageEvent?.isAudioMessage == true) {
      final stt = pangeaMessageEvent!.getSpeechToTextLocal();
      if (stt == null || stt.transcript.sttTokens.isEmpty) return null;
      return stt.transcript.sttTokens
          .firstWhereOrNull((t) => isTokenSelected(t.token))
          ?.token;
    }

    return pangeaMessageEvent?.messageDisplayRepresentation?.tokens
        ?.firstWhereOrNull(isTokenSelected);
  }

  /// Whether the overlay is currently displaying a selection
  bool get isSelection => _selectedSpan != null || _highlightedTokens != null;

  PangeaTokenText? get selectedSpan => _selectedSpan;

  bool get showingExtraContent =>
      (showTranslation && translation != null) ||
      (showSpeechTranslation && speechTranslation != null) ||
      transcription != null ||
      transcriptionError != null;

  bool get showLanguageAssistance {
    if (!event.status.isSent || event.type != EventTypes.Message) {
      return false;
    }

    if (event.messageType == MessageTypes.Text) {
      return pangeaMessageEvent != null &&
          pangeaMessageEvent!.messageDisplayLangCode.split("-").first ==
              MatrixState
                  .pangeaController.languageController.userL2!.langCodeShort;
    }

    return event.messageType == MessageTypes.Audio;
  }

  ///////////////////////////////////
  /// Functions
  /////////////////////////////////////

  /// If sentence TTS is playing a word, highlight that word in message overlay
  void highlightCurrentText(int currentPosition, List<TTSToken> ttsTokens) {
    final List<TTSToken> textToSelect = [];
    // Check if current time is between start and end times of tokens
    for (final TTSToken token in ttsTokens) {
      if (token.endMS > currentPosition) {
        if (token.startMS < currentPosition) {
          textToSelect.add(token);
        } else {
          break;
        }
      }
    }

    if (const ListEquality().equals(textToSelect, _highlightedTokens)) return;
    _highlightedTokens =
        textToSelect.isEmpty ? null : textToSelect.map((t) => t.text).toList();
    setState(() {});
  }

  Future<RepresentationEvent?> _fetchNewRepEvent() async {
    final RepresentationEvent? repEvent =
        pangeaMessageEvent?.messageDisplayRepresentation;

    if (repEvent != null) return repEvent;
    final eventID =
        await pangeaMessageEvent?.representationByDetectedLanguage();

    if (eventID == null) return null;
    final event = await widget._event.room.getEventById(eventID);
    if (event == null) return null;
    return RepresentationEvent(
      timeline: pangeaMessageEvent!.timeline,
      parentMessageEvent: pangeaMessageEvent!.event,
      event: event,
    );
  }

  /// When an activity is completed, we need to update the state
  /// and check if the toolbar should be unlocked
  void onActivityFinish(ActivityTypeEnum activityType, PangeaToken? token) {
    // if (selectedToken == null) {
    //   updateToolbarMode(MessageMode.noneSelected);
    // }

    if (!mounted) return;
    setState(() {});
  }

  /// In some cases, we need to exit the practice flow and let the user
  /// interact with the toolbar without completing activities
  void exitPracticeFlow() {
    practiceSelection?.exitPracticeFlow();
    setState(() {});
  }

  void onClickOverlayMessageToken(
    PangeaToken token,
  ) {
    if (practiceSelection?.hasHiddenWordActivity == true ||
        readingAssistanceMode == ReadingAssistanceMode.practiceMode) {
      return;
    }

    /// we don't want to associate the audio with the text in this mode
    if (pangeaMessageEvent?.messageDisplayLangCode != null &&
            practiceSelection?.hasActiveActivityByToken(
                  ActivityTypeEnum.wordFocusListening,
                  token,
                ) ==
                false ||
        !hideWordCardContent) {
      TtsController.tryToSpeak(
        token.text.content,
        targetID: null,
        langCode: pangeaMessageEvent!.messageDisplayLangCode,
      );
    }

    updateSelectedSpan(token.text);
  }

  void onSelectNewToken(PangeaToken token) {
    if (!isNewToken(token)) return;
    MatrixState.pangeaController.putAnalytics.setState(
      AnalyticsStream(
        eventId: event.eventId,
        roomId: event.room.id,
        constructs: [
          OneConstructUse(
            useType: ConstructUseTypeEnum.click,
            lemma: token.lemma.text,
            constructType: ConstructTypeEnum.vocab,
            metadata: ConstructUseMetaData(
              roomId: event.room.id,
              timeStamp: DateTime.now(),
              eventId: event.eventId,
            ),
            category: token.pos,
            form: token.text.content,
            xp: ConstructUseTypeEnum.click.pointValue,
          ),
        ],
        targetID: "word-zoom-card-${token.text.uniqueKey}",
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  PracticeTarget? practiceTargetForToken(PangeaToken token) {
    if (toolbarMode.associatedActivityType == null) return null;
    return practiceSelection
        ?.activities(toolbarMode.associatedActivityType!)
        .firstWhereOrNull((a) => a.tokens.contains(token));
  }

  /// Whether the given token is currently selected or highlighted
  bool isTokenSelected(PangeaToken token) {
    final isSelected = _selectedSpan?.offset == token.text.offset &&
        _selectedSpan?.length == token.text.length;
    return isSelected;
  }

  bool isNewToken(PangeaToken token) =>
      TokensUtil.isNewToken(token, pangeaMessageEvent!);

  bool isTokenHighlighted(PangeaToken token) {
    if (_highlightedTokens == null) return false;
    return _highlightedTokens!.any(
      (t) => t.offset == token.text.offset && t.length == token.text.length,
    );
  }

  void setTranslation(String value) {
    if (mounted) {
      setState(() {
        translation = value;
        contentChangedStream.add(true);
      });
    }
  }

  void setShowTranslation(bool show) {
    if (!mounted) return;
    if (translation == null) {
      setState(() => showTranslation = false);
    }

    if (showTranslation == show) return;
    setState(() {
      showTranslation = show;
      contentChangedStream.add(true);
    });
  }

  void setSpeechTranslation(String value) {
    if (mounted) {
      setState(() {
        speechTranslation = value;
        contentChangedStream.add(true);
      });
    }
  }

  void setShowSpeechTranslation(bool show) {
    if (!mounted) return;
    if (speechTranslation == null) {
      setState(() => showSpeechTranslation = false);
    }

    if (showSpeechTranslation == show) return;
    setState(() {
      showSpeechTranslation = show;
      contentChangedStream.add(true);
    });
  }

  void setTranscription(SpeechToTextModel value) {
    if (mounted) {
      setState(() {
        transcriptionError = null;
        transcription = value;
        contentChangedStream.add(true);
      });
    }
  }

  void setTranscriptionError(String value) {
    if (mounted) {
      setState(() {
        transcriptionError = value;
        contentChangedStream.add(true);
      });
    }
  }

  /////////////////////////////////////
  /// Build
  /////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return MessageSelectionPositioner(
      overlayController: this,
      chatController: widget.chatController,
      event: widget._event,
      nextEvent: widget._nextEvent,
      prevEvent: widget._prevEvent,
      pangeaMessageEvent: pangeaMessageEvent,
      initialSelectedToken: widget._initialSelectedToken,
    );
  }
}
