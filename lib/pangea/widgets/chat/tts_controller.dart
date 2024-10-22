import 'dart:developer';

import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/missing_voice_button.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart' as flutter_tts;

class TtsController {
  String? targetLanguage;

  List<String> availableLangCodes = [];
  final flutter_tts.FlutterTts tts = flutter_tts.FlutterTts();

  TtsController() {
    setupTTS();
  }

  Future<void> dispose() async {
    await tts.stop();
  }

  onError(dynamic message) => ErrorHandler.logError(
        m: 'TTS error',
        data: {
          'message': message,
        },
      );

  Future<void> setupTTS() async {
    try {
      tts.setErrorHandler(onError);

      targetLanguage ??=
          MatrixState.pangeaController.languageController.userL2?.langCode;

      debugger(when: kDebugMode && targetLanguage == null);

      tts.setLanguage(
        targetLanguage ?? "en",
      );

      await tts.awaitSpeakCompletion(true);

      final voices = await tts.getVoices;
      availableLangCodes = (voices as List)
          .map((v) {
            // on iOS / web, the codes are in 'locale', but on Android, they are in 'name'
            final nameCode = v['name']?.split("-").first;
            final localeCode = v['locale']?.split("-").first;
            return nameCode.length == 2 ? nameCode : localeCode;
          })
          .toSet()
          .cast<String>()
          .toList();

      debugPrint("availableLangCodes: $availableLangCodes");

      debugger(when: kDebugMode && !isLanguageFullySupported);
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s);
    }
  }

  Future<void> stop() async {
    try {
      // return type is dynamic but apparent its supposed to be 1
      // https://pub.dev/packages/flutter_tts
      final result = await tts.stop();
      if (result != 1) {
        ErrorHandler.logError(
          m: 'Unexpected result from tts.stop',
          data: {
            'result': result,
          },
        );
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s);
    }
    await tts.stop();
  }

  Future<void> speak(String text) async {
    try {
      stop();

      targetLanguage ??=
          MatrixState.pangeaController.languageController.userL2?.langCode;

      final result = await tts.speak(text);

      // return type is dynamic but apparent its supposed to be 1
      // https://pub.dev/packages/flutter_tts
      if (result != 1 && !kIsWeb) {
        ErrorHandler.logError(
          m: 'Unexpected result from tts.speak',
          data: {
            'result': result,
            'text': text,
          },
        );
      }
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s);
    }
  }

  bool get isLanguageFullySupported =>
      availableLangCodes.contains(targetLanguage);

  Widget get missingVoiceButton => targetLanguage != null &&
          (kIsWeb || isLanguageFullySupported || !PlatformInfos.isAndroid)
      ? const SizedBox.shrink()
      : MissingVoiceButton(
          targetLangCode: targetLanguage!,
        );
}
