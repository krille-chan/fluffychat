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

  // if targetLanguage isn't set here, it needs to be set later
  TtsController() {
    setupTTS();
  }

  Future<void> setupTTS() async {
    try {
      targetLanguage ??=
          MatrixState.pangeaController.languageController.userL2?.langCode;

      debugger(when: kDebugMode && targetLanguage == null);

      debugPrint('setupTTS targetLanguage: $targetLanguage');

      tts.setLanguage(
        targetLanguage ?? "en",
      );

      await tts.awaitSpeakCompletion(true);

      final voices = await tts.getVoices;
      availableLangCodes = (voices as List)
          .map((v) {
            // debugPrint('v: $v');

            //@ggurdin i changed this from name to locale
            //in my testing, that's where the language code is stored
            // maybe it's different for different devices? was it different in your android testing?
            // return v['name']?.split("-").first;
            return v['locale']?.split("-").first;
          })
          .toSet()
          .cast<String>()
          .toList();

      debugPrint("lang supported? $isLanguageFullySupported");
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s);
    }
  }

  Future<void> speak(String text) async {
    targetLanguage ??=
        MatrixState.pangeaController.languageController.userL2?.langCode;

    await tts.stop();
    return tts.speak(text);
  }

  bool get isLanguageFullySupported =>
      availableLangCodes.contains(targetLanguage);

  // @ggurdin
  Widget get missingVoiceButton => targetLanguage != null &&
          (kIsWeb || isLanguageFullySupported || !PlatformInfos.isAndroid)
      ? const SizedBox.shrink()
      : MissingVoiceButton(
          targetLangCode: targetLanguage!,
        );
}
