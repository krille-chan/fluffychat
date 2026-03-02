import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fluffychat/pangea/analytics_misc/lemma_emoji_setter_mixin.dart';
import 'package:fluffychat/pangea/common/models/llm_feedback_model.dart';
import 'package:fluffychat/pangea/common/utils/async_state.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/speech_to_text/speech_to_text_response_model.dart';
import 'package:fluffychat/pangea/toolbar/message_practice/message_audio_card.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance/select_mode_buttons.dart';
import 'package:fluffychat/pangea/translation/full_text_translation_response_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class _TranscriptionLoader extends AsyncLoader<SpeechToTextResponseModel> {
  final PangeaMessageEvent messageEvent;
  _TranscriptionLoader(this.messageEvent) : super();

  @override
  Future<SpeechToTextResponseModel> fetch() => messageEvent.requestSpeechToText(
    MatrixState.pangeaController.userController.userL1!.langCodeShort,
    MatrixState.pangeaController.userController.userL2!.langCodeShort,
  );
}

class _STTTranslationLoader extends AsyncLoader<String> {
  final PangeaMessageEvent messageEvent;
  _STTTranslationLoader(this.messageEvent) : super();

  @override
  Future<String> fetch() => messageEvent.requestSttTranslation(
    langCode: MatrixState.pangeaController.userController.userL1!.langCodeShort,
    l1Code: MatrixState.pangeaController.userController.userL1!.langCodeShort,
    l2Code: MatrixState.pangeaController.userController.userL2!.langCodeShort,
  );
}

class _AudioLoader extends AsyncLoader<(PangeaAudioFile, File?)> {
  final PangeaMessageEvent messageEvent;
  _AudioLoader(this.messageEvent) : super();

  @override
  Future<(PangeaAudioFile, File?)> fetch() async {
    final audioBytes = await messageEvent.requestTextToSpeech(
      messageEvent.messageDisplayLangCode,
      MatrixState.pangeaController.userController.voice,
    );

    File? audioFile;
    if (!kIsWeb) {
      final tempDir = await getTemporaryDirectory();

      File? file;
      file = File('${tempDir.path}/${audioBytes.name}');
      await file.writeAsBytes(audioBytes.bytes);
      audioFile = file;
    }

    return (audioBytes, audioFile);
  }
}

typedef _TranslationLoader = ValueNotifier<AsyncState<String>>;

class SelectModeController with LemmaEmojiSetter {
  final PangeaMessageEvent messageEvent;
  final _TranscriptionLoader _transcriptLoader;
  final _TranslationLoader _translationLoader;

  final _AudioLoader _audioLoader;
  final _STTTranslationLoader _sttTranslationLoader;

  SelectModeController(this.messageEvent)
    : _transcriptLoader = _TranscriptionLoader(messageEvent),
      _translationLoader = _TranslationLoader(AsyncIdle<String>()),
      _audioLoader = _AudioLoader(messageEvent),
      _sttTranslationLoader = _STTTranslationLoader(messageEvent);

  ValueNotifier<SelectMode?> selectedMode = ValueNotifier<SelectMode?>(null);

  FullTextTranslationResponseModel? _lastTranslationResponse;

  // Sometimes the same token is clicked twice. Setting it to the same value
  // won't trigger the notifier, so use the bool for force it to trigger.
  ValueNotifier<(PangeaTokenText?, bool)> playTokenNotifier =
      ValueNotifier<(PangeaTokenText?, bool)>((null, false));

  void dispose() {
    selectedMode.dispose();
    playTokenNotifier.dispose();
    _transcriptLoader.dispose();
    _translationLoader.dispose();
    _sttTranslationLoader.dispose();
    _audioLoader.dispose();
  }

  static List<SelectMode> get _textModes => [
    SelectMode.audio,
    SelectMode.translate,
    SelectMode.practice,
    SelectMode.emoji,
  ];

  static List<SelectMode> get _audioModes => [SelectMode.speechTranslation];

  ValueNotifier<AsyncState<String>> get translationState => _translationLoader;

  ValueNotifier<AsyncState<SpeechToTextResponseModel>> get transcriptionState =>
      _transcriptLoader.state;

  ValueNotifier<AsyncState<String>> get speechTranslationState =>
      _sttTranslationLoader.state;

  (PangeaAudioFile, File?)? get audioFile => _audioLoader.value;

  List<SelectMode> allModes({bool enableRefresh = false}) {
    final validTypes = {MessageTypes.Text, MessageTypes.Audio};
    if (!messageEvent.event.status.isSent ||
        messageEvent.event.type != EventTypes.Message ||
        !validTypes.contains(messageEvent.event.messageType)) {
      return [];
    }

    final types = messageEvent.event.messageType == MessageTypes.Text
        ? _textModes
        : _audioModes;

    if (enableRefresh) {
      return [...types, SelectMode.requestRegenerate];
    }

    return types;
  }

  List<SelectMode> readingAssistanceModes({bool enableRefresh = false}) {
    final validTypes = {MessageTypes.Text, MessageTypes.Audio};
    if (!messageEvent.event.status.isSent ||
        messageEvent.event.type != EventTypes.Message ||
        !validTypes.contains(messageEvent.event.messageType)) {
      return [];
    }

    List<SelectMode> modes = [];
    final lang = messageEvent.messageDisplayLangCode.split("-").first;

    final matchesL1 =
        lang ==
        MatrixState.pangeaController.userController.userL1!.langCodeShort;

    if (messageEvent.event.messageType == MessageTypes.Text) {
      final matchesL2 =
          lang ==
          MatrixState.pangeaController.userController.userL2!.langCodeShort;

      modes = matchesL2
          ? _textModes
          : matchesL1
          ? []
          : [SelectMode.translate];
    } else {
      modes = matchesL1 ? [] : _audioModes;
    }

    if (enableRefresh) {
      modes = [...modes, SelectMode.requestRegenerate];
    }

    return modes;
  }

  bool get isLoading => currentModeStateNotifier?.value is AsyncLoading;

  bool get isShowingExtraContent =>
      (selectedMode.value == SelectMode.translate &&
          _translationLoader.value is AsyncLoaded<String>) ||
      (selectedMode.value == SelectMode.speechTranslation &&
          _sttTranslationLoader.isLoaded) ||
      _transcriptLoader.isLoaded ||
      _transcriptLoader.isError;

  ValueNotifier<AsyncState>? get currentModeStateNotifier =>
      modeStateNotifier(selectedMode.value);

  ValueNotifier<AsyncState>? modeStateNotifier(SelectMode? mode) =>
      switch (mode) {
        SelectMode.audio => _audioLoader.state,
        SelectMode.translate => _translationLoader,
        SelectMode.speechTranslation => _sttTranslationLoader.state,
        _ => null,
      };

  void setSelectMode(SelectMode? mode) {
    if (selectedMode.value == mode) return;
    selectedMode.value = mode;
  }

  void setPlayingToken(PangeaTokenText? token) =>
      playTokenNotifier.value = (token, !playTokenNotifier.value.$2);

  Future<void> fetchAudio() => _audioLoader.load();
  Future<void> fetchTranscription() => _transcriptLoader.load();
  Future<void> fetchSpeechTranslation() => _sttTranslationLoader.load();

  Future<void> fetchTranslation({String? feedback}) async {
    try {
      _translationLoader.value = AsyncLoading();

      List<LLMFeedbackModel<FullTextTranslationResponseModel>>? feedbackModel;
      if (feedback != null && _lastTranslationResponse != null) {
        feedbackModel = [
          LLMFeedbackModel<FullTextTranslationResponseModel>(
            feedback: feedback,
            content: _lastTranslationResponse!,
            contentToJson: (c) => c.toJson(),
          ),
        ];
      }

      final resp = await messageEvent.requestTranslationByL1(
        feedback: feedbackModel,
      );

      _lastTranslationResponse = resp;
      _translationLoader.value = AsyncLoaded(resp.bestTranslation);
    } catch (e) {
      _translationLoader.value = AsyncError(e.toString());
    }
  }
}
