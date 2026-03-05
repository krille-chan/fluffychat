import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_tts/flutter_tts.dart' as flutter_tts;
import 'package:just_audio/just_audio.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/audio_player.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/languages/language_constants.dart';
import 'package:fluffychat/pangea/phonetic_transcription/pt_v2_disambiguation.dart';
import 'package:fluffychat/pangea/phonetic_transcription/pt_v2_repo.dart';
import 'package:fluffychat/pangea/text_to_speech/text_to_speech_repo.dart';
import 'package:fluffychat/pangea/text_to_speech/text_to_speech_request_model.dart';
import 'package:fluffychat/pangea/text_to_speech/text_to_speech_response_model.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart'
    as error_handler;

class TtsController {
  static List<String> _availableLangCodes = [];

  static final _tts = flutter_tts.FlutterTts();
  static final StreamController<bool> loadingChoreoStream =
      StreamController<bool>.broadcast();

  static AudioPlayer? audioPlayer;

  static TextToSpeechRequestModel _request(
    String text,
    String langCode,
    List<PangeaTokenText> tokens,
    String? ttsPhoneme,
  ) => TextToSpeechRequestModel(
    text: text,
    langCode: langCode,
    tokens: tokens,
    userL1:
        MatrixState.pangeaController.userController.userL1Code ??
        LanguageKeys.unknownLanguage,
    userL2:
        MatrixState.pangeaController.userController.userL2Code ??
        LanguageKeys.unknownLanguage,
    ttsPhoneme: ttsPhoneme,
    speakingRate: 1.0,
  );

  static Future<void> _onError(dynamic message) async {
    if (message != 'canceled' && message != 'interrupted') {
      error_handler.ErrorHandler.logError(
        e: 'TTS error',
        data: {'message': message},
      );
    }
  }

  static Future<void> setAvailableLanguages() async {
    try {
      await _tts.awaitSpeakCompletion(true);
      await _setAvailableBaseLanguages();
    } catch (e, s) {
      debugger(when: kDebugMode);
      error_handler.ErrorHandler.logError(e: e, s: s, data: {});
    }
  }

  static Future<void> _setAvailableBaseLanguages() async {
    final voices = (await _tts.getVoices) as List?;
    _availableLangCodes = (voices ?? [])
        .map((v) {
          // on iOS / web, the codes are in 'locale', but on Android, they are in 'name'
          final nameCode = v['name'];
          final localeCode = v['locale'];
          return localeCode.contains("-") ? localeCode : nameCode;
        })
        .toSet()
        .cast<String>()
        .toList();
  }

  static Future<void> _setSpeakingLanguage(String langCode) async {
    String? selectedLangCode;
    final langCodeShort = langCode.split("-").first;
    if (_availableLangCodes.contains(langCode)) {
      selectedLangCode = langCode;
    } else {
      selectedLangCode = _availableLangCodes.firstWhereOrNull(
        (code) => code.startsWith(langCodeShort),
      );
    }

    if (selectedLangCode != null) {
      await (_tts.setLanguage(selectedLangCode));
    } else {
      final jsonData = {
        'langCode': langCode,
        'availableLangCodes': _availableLangCodes,
      };
      debugPrint("TTS: Language not supported: $jsonData");
      Sentry.addBreadcrumb(Breadcrumb.fromJson(jsonData));
    }
  }

  static Future<void> stop() async {
    try {
      // return type is dynamic but apparent its supposed to be 1
      // https://pub.dev/packages/flutter_tts
      final result = await (_tts.stop());
      audioPlayer?.stop();

      if (result != 1) {
        error_handler.ErrorHandler.logError(
          m: 'Unexpected result from tts.stop',
          data: {'result': result},
        );
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      error_handler.ErrorHandler.logError(e: e, s: s, data: {});
    }
  }

  static VoidCallback? _onStop;

  /// Look up the PT v2 cache for [text] and return tts_phoneme if the word is a
  /// heteronym that can be disambiguated. Returns null for single-pronunciation
  /// words or when no PT data is cached.
  static String? _resolveTtsPhonemeFromCache(
    String text,
    String langCode, {
    String? pos,
    Map<String, String>? morph,
  }) {
    final userL1 = MatrixState.pangeaController.userController.userL1Code;
    if (userL1 == null) return null;

    final ptResponse = PTV2Repo.getCachedResponse(text, langCode, userL1);
    debugPrint(
      '[TTS-DEBUG] _resolveTtsPhonemeFromCache: text="$text" lang=$langCode cached=${ptResponse != null} count=${ptResponse?.pronunciations.length ?? 0} pos=$pos morph=$morph',
    );
    if (ptResponse == null || ptResponse.pronunciations.length <= 1) {
      return null;
    }

    final result = disambiguate(
      ptResponse.pronunciations,
      pos: pos,
      morph: morph,
    );
    return result.ttsPhoneme;
  }

  static Future<void> tryToSpeak(
    String text, {
    required String langCode,
    // Target ID for where to show warning popup
    String? targetID,
    BuildContext? context,
    ChatController? chatController,
    VoidCallback? onStart,
    VoidCallback? onStop,

    /// When provided, skip device TTS and use choreo with phoneme tags.
    /// If omitted, the PT v2 cache is checked automatically.
    String? ttsPhoneme,

    /// POS tag for disambiguation when resolving tts_phoneme from cache.
    String? pos,

    /// Morph features for disambiguation when resolving tts_phoneme from cache.
    Map<String, String>? morph,
  }) async {
    // Auto-resolve tts_phoneme from PT cache if not explicitly provided.
    final explicitPhoneme = ttsPhoneme;
    ttsPhoneme ??= _resolveTtsPhonemeFromCache(
      text,
      langCode,
      pos: pos,
      morph: morph,
    );
    debugPrint(
      '[TTS-DEBUG] tryToSpeak: text="$text" explicitPhoneme=$explicitPhoneme resolvedPhoneme=$ttsPhoneme pos=$pos morph=$morph',
    );

    final prevOnStop = _onStop;
    _onStop = onStop;

    if (_availableLangCodes.isEmpty) {
      await setAvailableLanguages();
    }

    _tts.setErrorHandler((message) {
      _onError(message);
      prevOnStop?.call();
    });

    onStart?.call();

    await _tryToSpeak(
      text,
      langCode: langCode,
      targetID: targetID,
      context: context,
      chatController: chatController,
      onStart: onStart,
      onStop: onStop,
      ttsPhoneme: ttsPhoneme,
    );
  }

  /// A safer version of speak, that handles the case of
  /// the language not being supported by the TTS engine
  static Future<void> _tryToSpeak(
    String text, {
    required String langCode,
    // Target ID for where to show warning popup
    String? targetID,
    BuildContext? context,
    ChatController? chatController,
    VoidCallback? onStart,
    VoidCallback? onStop,
    String? ttsPhoneme,
  }) async {
    chatController?.stopMediaStream.add(null);
    MatrixState.pangeaController.matrixState.audioPlayer?.stop();

    await _setSpeakingLanguage(langCode);

    final enableTTS = MatrixState
        .pangeaController
        .userController
        .profile
        .toolSettings
        .enableTTS;

    if (enableTTS) {
      final token = PangeaTokenText(
        offset: 0,
        content: text,
        length: text.length,
      );

      final langSupported = _isLangFullySupported(langCode);

      onStart?.call();

      // When tts_phoneme is provided, skip device TTS and use choreo with phoneme tags.
      if (ttsPhoneme != null || !langSupported) {
        final success = await _speakFromChoreo(
          text,
          langCode,
          [token],
          ttsPhoneme: ttsPhoneme,
          timeout: langSupported
              ? const Duration(seconds: 1)
              : const Duration(seconds: 10),
        );

        // fallback to device TTS if language is supported but choreo fails (e.g. due to timeout)
        if (!success && langSupported) {
          await _speakFromDevice(text, langCode, [token]);
        }
      } else {
        await _speakFromChoreo(text, langCode, [token]);
      }
    } else if (targetID != null && context != null) {
      OverlayUtil.showTTSDisabledPopup(context, targetID);
    }

    onStop?.call();
  }

  static Future<bool> _speakFromDevice(
    String text,
    String langCode,
    List<PangeaTokenText> tokens,
  ) async {
    try {
      await stop();
      text = text.toLowerCase();
      await Future(() => (_tts.speak(text)));
      return true;
    } catch (e, s) {
      debugger(when: kDebugMode);
      error_handler.ErrorHandler.logError(e: e, s: s, data: {'text': text});
      return false;
    } finally {
      await stop();
    }
  }

  static Future<bool> _speakFromChoreo(
    String text,
    String langCode,
    List<PangeaTokenText> tokens, {
    String? ttsPhoneme,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    debugPrint(
      '[TTS-DEBUG] _speakFromChoreo: text="$text" ttsPhoneme=$ttsPhoneme',
    );
    TextToSpeechResponseModel? ttsRes;

    loadingChoreoStream.add(true);
    try {
      final result = await TextToSpeechRepo.get(
        MatrixState.pangeaController.userController.accessToken,
        _request(text, langCode, tokens, ttsPhoneme),
      ).timeout(timeout);
      if (result.isError) return false;
      ttsRes = result.result!;
    } on TimeoutException catch (_) {
      return false;
    } catch (e, s) {
      error_handler.ErrorHandler.logError(
        e: 'Error in TTS API call',
        s: s,
        data: {'text': text, 'error': e.toString()},
      );
      return false;
    } finally {
      loadingChoreoStream.add(false);
    }

    try {
      Logs().i('Speaking from choreo: $text, langCode: $langCode');
      final audioContent = base64Decode(ttsRes.audioContent);
      audioPlayer?.dispose();
      audioPlayer = AudioPlayer();
      await audioPlayer!.setAudioSource(
        BytesAudioSource(audioContent, ttsRes.mimeType),
      );
      await audioPlayer!.play();
      return true;
    } catch (e, s) {
      error_handler.ErrorHandler.logError(
        e: 'Error playing audio',
        s: s,
        data: {'error': e.toString(), 'text': text},
      );
      return false;
    } finally {
      audioPlayer?.dispose();
      audioPlayer = null;
    }
  }

  static bool _isLangFullySupported(String langCode) {
    if (_availableLangCodes.contains(langCode)) {
      return true;
    }

    final langCodeShort = langCode.split("-").first;
    if (langCodeShort.isEmpty) {
      return false;
    }

    return _availableLangCodes.any((lang) => lang.startsWith(langCodeShort));
  }
}
