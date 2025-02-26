import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_tts/flutter_tts.dart' as flutter_tts;
import 'package:matrix/matrix_api_lite/utils/logs.dart';
import 'package:text_to_speech/text_to_speech.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_show_popup.dart';
import 'package:fluffychat/pangea/toolbar/widgets/missing_voice_button.dart';
import 'package:fluffychat/pangea/user/controllers/user_controller.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

class TtsController {
  String? get l2LangCode =>
      MatrixState.pangeaController.languageController.userL2?.langCode;

  String? get l2LangCodeShort =>
      MatrixState.pangeaController.languageController.userL2?.langCodeShort;

  List<String> _availableLangCodes = [];
  final flutter_tts.FlutterTts _tts = flutter_tts.FlutterTts();
  final TextToSpeech _alternativeTTS = TextToSpeech();
  StreamSubscription? _languageSubscription;

  UserController get userController =>
      MatrixState.pangeaController.userController;

  TtsController() {
    setupTTS();
    _languageSubscription =
        userController.stateStream.listen((_) => setupTTS());
  }

  bool get _useAlternativeTTS {
    return PlatformInfos.isWindows;
  }

  Future<void> dispose() async {
    await _tts.stop();
    await _languageSubscription?.cancel();
  }

  void _onError(dynamic message) {
    // the package treats this as an error, but it's not
    // don't send to sentry
    if (message == 'canceled' || message == 'interrupted') {
      return;
    }

    ErrorHandler.logError(
      e: 'TTS error',
      data: {
        'message': message,
      },
    );
  }

  Future<void> _setAvailableLanguages() async {
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

  Future<void> _setAvailableAltLanguages() async {
    final languages = await _alternativeTTS.getLanguages();
    _availableLangCodes = languages.toSet().toList();
  }

  Future<void> _setLanguage() async {
    String? langCode;
    if (l2LangCode != null && _availableLangCodes.contains(l2LangCode)) {
      langCode = l2LangCode;
    } else if (l2LangCodeShort != null) {
      final langCodeShort = l2LangCodeShort!;
      langCode = _availableLangCodes.firstWhereOrNull(
        (code) => code.startsWith(langCodeShort),
      );
    }

    if (langCode != null) {
      await (_useAlternativeTTS
          ? _alternativeTTS.setLanguage(langCode)
          : _tts.setLanguage(langCode));
    }
  }

  Future<void> setupTTS() async {
    try {
      if (_useAlternativeTTS) {
        await _setAvailableAltLanguages();
      } else {
        _tts.setErrorHandler(_onError);
        debugger(when: kDebugMode && l2LangCode == null);

        await _tts.awaitSpeakCompletion(true);
        await _setAvailableLanguages();
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {},
      );
    }
  }

  Future<void> stop() async {
    try {
      // return type is dynamic but apparent its supposed to be 1
      // https://pub.dev/packages/flutter_tts
      final result =
          await (_useAlternativeTTS ? _alternativeTTS.stop() : _tts.stop());

      if (!_useAlternativeTTS && result != 1) {
        ErrorHandler.logError(
          m: 'Unexpected result from tts.stop',
          data: {
            'result': result,
          },
        );
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {},
      );
    }
  }

  Future<void> _showMissingVoicePopup(
    BuildContext context,
    String targetID,
  ) async =>
      instructionsShowPopup(
        context,
        InstructionsEnum.missingVoice,
        targetID,
        showToggle: false,
        customContent: const Padding(
          padding: EdgeInsets.only(top: 12),
          child: MissingVoiceButton(),
        ),
        forceShow: true,
      );

  Future<void> _showTTSDisabledPopup(
    BuildContext context,
    String targetID,
  ) async =>
      instructionsShowPopup(
        context,
        InstructionsEnum.ttsDisabled,
        targetID,
        showToggle: false,
        forceShow: true,
      );

  /// A safer version of speak, that handles the case of
  /// the language not being supported by the TTS engine
  Future<void> tryToSpeak(
    String text,
    BuildContext context, {
    // Target ID for where to show warning popup
    String? targetID,
  }) async {
    await _setLanguage();
    final enableTTS = MatrixState
        .pangeaController.userController.profile.toolSettings.enableTTS;

    if (_isL2FullySupported && enableTTS) {
      await _speak(text);
    } else if (!_isL2FullySupported && targetID != null) {
      await _showMissingVoicePopup(context, targetID);
    } else if (!enableTTS && targetID != null) {
      await _showTTSDisabledPopup(context, targetID);
    }
  }

  Future<void> _speak(String text) async {
    try {
      stop();
      text = text.toLowerCase();

      Logs().i('Speaking: $text');
      final result = await Future(
        () => (_useAlternativeTTS
                ? _alternativeTTS.speak(text)
                : _tts.speak(text))
            .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            ErrorHandler.logError(
              e: "Timeout on tts.speak",
              data: {"text": text},
            );
          },
        ),
      );
      Logs().i('Finished speaking: $text, result: $result');

      // return type is dynamic but apparent its supposed to be 1
      // https://pub.dev/packages/flutter_tts
      // if (result != 1 && !kIsWeb) {
      //   ErrorHandler.logError(
      //     m: 'Unexpected result from tts.speak',
      //     data: {
      //       'result': result,
      //       'text': text,
      //     },
      //     level: SentryLevel.warning,
      //   );
      // }
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'text': text,
        },
      );
    }
  }

  bool get _isL2FullySupported =>
      _availableLangCodes.contains(l2LangCode) ||
      (l2LangCodeShort != null &&
          _availableLangCodes.any((lang) => lang.startsWith(l2LangCodeShort!)));

  bool isLanguageSupported(String langCode) =>
      _availableLangCodes.contains(langCode) ||
      _availableLangCodes.any((lang) => lang.startsWith(langCode));
}
