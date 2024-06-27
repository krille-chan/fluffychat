import 'dart:developer';

import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/controllers/language_list_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/language_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../widgets/user_settings/p_language_dialog.dart';

class LanguageController {
  late PangeaController _pangeaController;

  LanguageController(PangeaController pangeaController) {
    _pangeaController = pangeaController;
  }
  //show diloag when user does not have languages selected
  showDialogOnEmptyLanguage(BuildContext dialogContext, Function callback) {
    if (_pangeaController.userController.userModel?.profile == null) {
      debugger(when: kDebugMode);
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: 'calling showDialogOnEmptyLanguagae with empty user',
        ),
      );
      return;
    }
    if (!languagesSet) {
      pLanguageDialog(dialogContext, callback);
    }
  }

  bool get languagesSet =>
      _userL1Code != null &&
      _userL2Code != null &&
      _userL1Code!.isNotEmpty &&
      _userL2Code!.isNotEmpty &&
      _userL1Code != LanguageKeys.unknownLanguage &&
      _userL2Code != LanguageKeys.unknownLanguage;

  String? get _userL1Code {
    final source =
        _pangeaController.userController.userModel?.profile?.sourceLanguage;
    return source == null || source.isEmpty ? null : source;
  }

  String? get _userL2Code {
    final target =
        _pangeaController.userController.userModel?.profile?.targetLanguage;
    return target == null || target.isEmpty ? null : target;
  }

  LanguageModel? get userL1 {
    return _userL1Code != null ? PangeaLanguage.byLangCode(_userL1Code!) : null;
  }

  LanguageModel? get userL2 {
    return _userL2Code != null ? PangeaLanguage.byLangCode(_userL2Code!) : null;
  }

  String? activeL1Code() {
    return _userL1Code;
    // final String? activeL2 = activeL2Code(roomID: roomID);
    // if (roomID == null || activeL2 != _userL1Code) {
    //   return _userL1Code;
    // }
    // final LanguageSettingsModel? classContext = _pangeaController
    //     .matrixState.client
    //     .getRoomById(roomID)
    //     ?.firstLanguageSettings;
    // final String? classL1 = classContext?.dominantLanguage;
    // if (classL1 == LanguageKeys.mixedLanguage ||
    //     classL1 == LanguageKeys.multiLanguage ||
    //     classL1 == null) {
    //   if (_userL2Code != _userL1Code) {
    //     return _userL2Code;
    //   }
    //   return LanguageKeys.unknownLanguage;
    // }
    // return classL1;
  }

  /// Class languages override user languages within a class context
  String? activeL2Code() {
    return _userL2Code;
    // if (roomID == null) {
    //   return _userL2Code;
    // }
    // final LanguageSettingsModel? classContext = _pangeaController
    //     .matrixState.client
    //     .getRoomById(roomID)
    //     ?.firstLanguageSettings;
    // return classContext?.targetLanguage ?? _userL2Code;
  }

  LanguageModel? activeL1Model() {
    return userL1;
    // final activeL1 = activeL1Code(roomID: roomID);
    // return activeL1 != null ? PangeaLanguage.byLangCode(activeL1) : null;
  }

  LanguageModel? activeL2Model() {
    return userL2;
    // final activeL2 = activeL2Code(roomID: roomID);
    // final model = activeL2 != null ? PangeaLanguage.byLangCode(activeL2) : null;
    // return model;
  }
}
