import 'dart:developer';

import 'package:fluffychat/pangea/enum/instructions_enum.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/missing_voice_button.dart';
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
        e: message,
        m: (message.toString().isNotEmpty) ? message.toString() : 'TTS error',
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

      final voices = (await tts.getVoices) as List?;
      availableLangCodes = (voices ?? [])
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
  }

  Future<void> showMissingVoicePopup(
    BuildContext context,
    String eventID,
  ) async {
    await MatrixState.pangeaController.instructions.showInstructionsPopup(
      context,
      InstructionsEnum.missingVoice,
      eventID,
      showToggle: false,
      customContent: const Padding(
        padding: EdgeInsets.only(top: 12),
        child: MissingVoiceButton(),
      ),
      forceShow: true,
    );
    return;
  }

  /// A safer version of speak, that handles the case of
  /// the language not being supported by the TTS engine
  Future<void> tryToSpeak(
    String text,
    BuildContext context,
    String eventID,
  ) async {
    if (isLanguageFullySupported) {
      await speak(text);
    } else {
      ErrorHandler.logError(
        e: 'Language not supported by TTS engine',
        data: {
          'targetLanguage': targetLanguage,
          'availableLangCodes': availableLangCodes,
        },
      );
      await showMissingVoicePopup(context, eventID);
    }
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
}
