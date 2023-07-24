import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/matrix.dart';
import 'settings_chat_view.dart';

class SettingsChat extends StatefulWidget {
  const SettingsChat({super.key});

  @override
  SettingsChatController createState() => SettingsChatController();
}

class SettingsChatController extends State<SettingsChat> {
  @override
  Widget build(BuildContext context) => SettingsChatView(this);

  bool get autoplayAnimations =>
      Matrix.of(context).client.autoplayAnimatedContent ?? !kIsWeb;

  Future<void> setAutoplayAnimations(bool value) async {
    try {
      final client = Matrix.of(context).client;
      await client.setAutoplayAnimatedContent(value);
    } catch (e) {
      Logs().w('Error storing animation preferences.', e);
    } finally {
      setState(() {});
    }
  }
}

extension AutoplayAnimatedContentExtension on Client {
  static const _elementWebKey = 'im.vector.web.settings';

  /// returns whether user preferences configured to autoplay motion
  /// message content such as gifs, webp, apng, videos or animations.
  bool? get autoplayAnimatedContent {
    if (!accountData.containsKey(_elementWebKey)) return null;
    try {
      final elementWebData = accountData[_elementWebKey]?.content;
      return elementWebData?['autoplayGifs'] as bool?;
    } catch (e) {
      return null;
    }
  }

  Future<void> setAutoplayAnimatedContent(bool autoplay) async {
    final elementWebData = accountData[_elementWebKey]?.content ?? {};
    elementWebData['autoplayGifs'] = autoplay;
    final uid = userID;
    if (uid != null) {
      await setAccountData(
        uid,
        _elementWebKey,
        elementWebData,
      );
    }
  }
}
