// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:fluffychat/pangea/choreographer/controllers/choreographer.dart';
import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';

class MessageOptions {
  Choreographer choreographer;
  LanguageModel? _selectedDisplayLang;

  MessageOptions(this.choreographer);

  LanguageModel? get selectedDisplayLang {
    if (_selectedDisplayLang != null &&
        _selectedDisplayLang!.langCode != LanguageKeys.unknownLanguage) {
      return _selectedDisplayLang;
    }
    _selectedDisplayLang = choreographer.l2Lang;
    return _selectedDisplayLang;
  }

  bool get isTranslationOn =>
      _selectedDisplayLang?.langCode != choreographer.l2LangCode;

  // void setSelectedDisplayLang(LanguageModel? newLang) {
  //   _selectedDisplayLang = newLang;
  //   choreographer.setState();
  // }

  void toggleSelectedDisplayLang() {
    if (_selectedDisplayLang?.langCode == choreographer.l2LangCode) {
      _selectedDisplayLang = choreographer.l1Lang;
    } else {
      _selectedDisplayLang = choreographer.l2Lang;
    }
    debugPrint('toggleSelectedDisplayLang: ${_selectedDisplayLang?.langCode}');
    choreographer.setState();
    GoogleAnalytics.messageTranslate();
  }

  void resetSelectedDisplayLang() {
    _selectedDisplayLang = choreographer.l2Lang;
    choreographer.setState();
  }
}
