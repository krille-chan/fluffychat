import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/analytics_misc/message_analytics_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/toolbar/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_positioner.dart';
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
  /////////////////////////////////////
  /// Variables
  /////////////////////////////////////
  MessageMode toolbarMode = MessageMode.noneSelected;

  /// If doing a morphological activity, this is the selected morph feature.
  String? selectedMorphFeature;

  PangeaTokenText? _selectedSpan;
  List<PangeaTokenText>? _highlightedTokens;
  bool initialized = false;
  bool isPlayingAudio = false;

  /// If non-null and not complete, the activity will be shown regardless of shouldDoActivity.
  /// Used to show the practice activity card's savor the joy animation.
  /// (Analytics sending triggers the point gain animation, do also
  /// causes shouldDoActivity to be false. This is a workaround.)
  Completer<void>? _activityLock;

  // final bool _hideCenterContent = false;

  /// The text that the toolbar should target
  /// If there is no selectedSpan, then the whole message is the target
  /// If there is a selectedSpan, then the target is the selected text
  String get targetText {
    if (_selectedSpan == null || pangeaMessageEvent == null) {
      return pangeaMessageEvent?.messageDisplayText ?? widget._event.body;
    }

    return pangeaMessageEvent!.messageDisplayText.substring(
      _selectedSpan!.offset,
      _selectedSpan!.offset + _selectedSpan!.length,
    );
  }

  PangeaToken? get selectedToken =>
      pangeaMessageEvent?.messageDisplayRepresentation?.tokens
          ?.firstWhereOrNull(isTokenSelected);

  /// Whether the overlay is currently displaying a selection
  bool get isSelection => _selectedSpan != null || _highlightedTokens != null;

  PangeaTokenText? get selectedSpan => _selectedSpan;

  /////////////////////////////////////
  /// Lifecycle
  /////////////////////////////////////

  @override
  void initState() {
    super.initState();
    initializeTokensAndMode();
  }

  Future<void> initializeTokensAndMode() async {
    try {
      RepresentationEvent? repEvent =
          pangeaMessageEvent?.messageDisplayRepresentation;
      repEvent ??= await _fetchNewRepEvent();

      if (repEvent?.event != null) {
        await repEvent!.sendTokensEvent(
          repEvent.event!.eventId,
          widget._event.room,
          MatrixState.pangeaController.languageController.userL1!.langCode,
          MatrixState.pangeaController.languageController.userL2!.langCode,
        );
      }
      // If repEvent is originalSent but it's missing tokens, then fetch tokens.
      // An edge case, but has happened with some bot message.
      else if (repEvent != null &&
          repEvent.tokens == null &&
          repEvent.content.originalSent) {
        final tokens = await repEvent.tokensGlobal(
          pangeaMessageEvent!.senderId,
          pangeaMessageEvent!.event.originServerTs,
        );
        await pangeaMessageEvent!.room.pangeaSendTextEvent(
          pangeaMessageEvent!.messageDisplayText,
          editEventId: pangeaMessageEvent!.eventId,
          originalSent: pangeaMessageEvent!.originalSent?.content,
          originalWritten: pangeaMessageEvent!.originalWritten?.content,
          tokensSent: PangeaMessageTokens(tokens: tokens),
          choreo: pangeaMessageEvent!.originalSent?.choreo,
        );
      }
    } catch (e, s) {
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
    if (pangeaMessageEvent?.isAudioMessage ?? false) {
      updateToolbarMode(MessageMode.messageTextToSpeech);
      return;
    }

    // 1) if we have a hidden word activity, then we should start with that
    if (messageAnalyticsEntry?.nextActivity?.activityType ==
        ActivityTypeEnum.hiddenWordListening) {
      updateToolbarMode(MessageMode.practiceActivity);
      return;
    }

    if (selectedToken != null) {
      updateToolbarMode(selectedToken!.modeForToken);
      return;
    }

    // Note: this setting is now hidden so this will always be false
    // leaving this here in case we want to bring it back
    // if (MatrixState.pangeaController.userController.profile.userSettings
    //     .autoPlayMessages) {
    //   return setState(() => toolbarMode = MessageMode.textToSpeech);
    // }

    // defaults to noneSelected
  }

  /// Decides whether an _initialSelectedToken should be used
  /// for a first practice activity on the word meaning
  void _initializeSelectedToken() {
    // if there is no initial selected token, then we don't need to do anything
    if (widget._initialSelectedToken == null || messageAnalyticsEntry == null) {
      return;
    }

    // should not already be involved in a hidden word activity
    final isInHiddenWordActivity =
        messageAnalyticsEntry!.isTokenInHiddenWordActivity(
      widget._initialSelectedToken!,
    );

    // whether the activity should generally be involved in an activity
    final selected =
        !isInHiddenWordActivity ? widget._initialSelectedToken : null;

    if (selected != null) {
      _updateSelectedSpan(selected.text);
    }
  }

  /////////////////////////////////////
  /// State setting
  /////////////////////////////////////

  /// We need to check if the setState call is safe to call immediately
  /// Kept getting the error: setState() or markNeedsBuild() called during build.
  /// This is a workaround to prevent that error
  @override
  void setState(VoidCallback fn) {
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (mounted &&
        (phase == SchedulerPhase.idle ||
            phase == SchedulerPhase.postFrameCallbacks)) {
      // It's safe to call setState immediately
      try {
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

  /// Update to [selectedSpan]
  /// [forceMode] is used to force a specific mode
  void _updateSelectedSpan(
    PangeaTokenText selectedSpan, [
    MessageMode? forceMode,
  ]) {
    if (forceMode == null && selectedSpan == _selectedSpan) {
      _selectedSpan = null;
      updateToolbarMode(MessageMode.noneSelected);
      setState(() {});
      return;
    }

    _selectedSpan = selectedSpan;

    if (!(messageAnalyticsEntry?.hasHiddenWordActivity ?? false)) {
      widget.chatController.choreographer.tts.tryToSpeak(
        selectedSpan.content,
        context,
        targetID: null,
      );
    }

    final nextModeForToken = forceMode ?? selectedToken!.modeForToken;
    if (toolbarMode != nextModeForToken) {
      debugPrint("_updateSelectedSpan: setting toolbarMode to wordZoom");
      updateToolbarMode(nextModeForToken);
    }

    setState(() {});
  }

  void updateToolbarMode(MessageMode mode, [String? feature]) => setState(() {
        debugger(
          when: kDebugMode &&
              selectedToken == null &&
              [
                MessageMode.wordMorph,
                MessageMode.wordZoom,
                MessageMode.wordEmoji,
                MessageMode.wordZoom,
              ].contains(mode),
        );

        if (toolbarMode == mode) {
          if (selectedToken == null) {
            toolbarMode = MessageMode.noneSelected;
            selectedMorphFeature = null;
          } else if (mode != MessageMode.wordMorph) {
            debugPrint('toolbarMode == mode: setting toolbarMode to wordZoom');
            toolbarMode = MessageMode.wordZoom;
          } else {
            if (selectedMorphFeature != feature) {
              selectedMorphFeature = feature;
            } else {
              selectedMorphFeature = null;
              toolbarMode = MessageMode.wordZoom;
            }
          }
        } else {
          switch (mode) {
            case MessageMode.noneSelected:
              selectedMorphFeature = null;
              break;
            case MessageMode.wordMorph:
              selectedMorphFeature =
                  feature ?? selectedToken?.nextMorphFeatureEligibleForActivity;
              if (selectedMorphFeature == null) {
                updateToolbarMode(MessageMode.wordZoom);
                return;
              }
              break;
            case MessageMode.wordZoom:
              selectedMorphFeature = null;
              break;
            case MessageMode.wordEmoji:
              selectedMorphFeature = null;
              break;
            case MessageMode.wordMeaning:
              selectedMorphFeature = null;
              break;
            case MessageMode.practiceActivity:
              if (messageAnalyticsEntry?.nextActivity?.activityType ==
                  ActivityTypeEnum.hiddenWordListening) {
                _lockActivity();
              }
              break;
            case MessageMode.messageTextToSpeech:
              if (isPlayingAudio) {
                //TODO stop audio
              } else {
                // Play audio
              }
              break;
            case MessageMode.messageSpeechToText:
              _selectedSpan = null;
              break;
            case MessageMode.messageTranslation:
              _selectedSpan = null;
              break;
            case MessageMode.messageMeaning:
              _selectedSpan = null;
              break;
          }

          toolbarMode = mode;
          if (mode != MessageMode.messageTextToSpeech) {
            _highlightedTokens = null;
          }
        }
      });

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

  int get activitiesLeftToComplete => messageAnalyticsEntry?.numActivities ?? 0;

  bool get isPracticeComplete =>
      (pangeaMessageEvent?.proportionOfActivitiesCompleted ?? 1) >= 1 ||
      !messageInUserL2;

  MessageAnalyticsEntry? get messageAnalyticsEntry =>
      pangeaMessageEvent?.messageDisplayRepresentation?.tokens != null
          ? MatrixState.pangeaController.getAnalytics.perMessage.get(
              pangeaMessageEvent!.messageDisplayRepresentation!.tokens!,
              pangeaMessageEvent!,
            )
          : null;

  bool get messageInUserL2 =>
      pangeaMessageEvent?.messageDisplayLangCode ==
      MatrixState.pangeaController.languageController.userL2?.langCode;

  ///////////////////////////////////
  /// User action handlers
  /////////////////////////////////////
  void onRequestForMeaningChallenge() {
    if (messageAnalyticsEntry == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: "MessageAnalyticsEntry is null in onRequestForMeaningChallenge",
        data: {},
      );
      return;
    }
    messageAnalyticsEntry!.addMessageMeaningActivity();

    if (mounted) {
      setState(() {});
    }
  }

  void onNextActivityRequest() {
    if (pangeaMessageEvent?.messageDisplayRepresentation?.tokens == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: "Tokens are null in onNextActivityRequest",
        data: {},
      );
      return;
    }

    for (final token in pangeaMessageEvent!
        .messageDisplayRepresentation!.tokens!
        .where((t) => t.lemma.saveVocab)) {
      final MessageMode nextActivityMode = token.modeForToken;
      if (nextActivityMode != MessageMode.wordZoom) {
        _selectedSpan = token.text;
        _updateSelectedSpan(token.text, nextActivityMode);
        return;
      }
    }
  }

  ///////////////////////////////////
  /// Functions
  /////////////////////////////////////

  ///@ggurdin - is this still needed?
  void _lockActivity() {
    if (mounted) setState(() => _activityLock = Completer());
  }

  void _unlockActivity() {
    if (_activityLock == null) return;
    _activityLock!.complete();
    _activityLock = null;
    if (mounted) setState(() {});
  }

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
  void onActivityFinish(ActivityTypeEnum activityType) {
    if (activityType == ActivityTypeEnum.hiddenWordListening) {
      _unlockActivity();
    }

    messageAnalyticsEntry!.onActivityComplete();

    if (selectedToken == null) {
      updateToolbarMode(MessageMode.noneSelected);
    }

    updateToolbarMode(selectedToken!.modeForToken);

    if (!mounted) return;
    setState(() {});
  }

  /// In some cases, we need to exit the practice flow and let the user
  /// interact with the toolbar without completing activities
  void exitPracticeFlow() {
    messageAnalyticsEntry?.exitPracticeFlow();
    setState(() {});
  }

  void onClickOverlayMessageToken(
    PangeaToken token,
  ) {
    if (toolbarMode == MessageMode.practiceActivity &&
        messageAnalyticsEntry?.nextActivity?.activityType ==
            ActivityTypeEnum.hiddenWordListening) {
      return;
    }

    _updateSelectedSpan(token.text);
    setState(() {});
  }

  /// Whether the given token is currently selected or highlighted
  bool isTokenSelected(PangeaToken token) {
    final isSelected = _selectedSpan?.offset == token.text.offset &&
        _selectedSpan?.length == token.text.length;
    return isSelected;
  }

  bool isTokenHighlighted(PangeaToken token) {
    if (_highlightedTokens == null) return false;
    return _highlightedTokens!.any(
      (t) => t.offset == token.text.offset && t.length == token.text.length,
    );
  }

  void setIsPlayingAudio(bool isPlaying) {
    if (mounted) {
      setState(() => isPlayingAudio = isPlaying);
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
