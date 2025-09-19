import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/instructions/instruction_settings.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning_view.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/spaces/models/space_model.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/user/models/user_model.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SettingsLearning extends StatefulWidget {
  final bool isDialog;

  const SettingsLearning({
    this.isDialog = true,
    super.key,
  });

  @override
  SettingsLearningController createState() => SettingsLearningController();
}

class SettingsLearningController extends State<SettingsLearning> {
  PangeaController pangeaController = MatrixState.pangeaController;
  late Profile _profile;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? languageMatchError;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _profile = pangeaController.userController.profile.copy();
    TtsController.setAvailableLanguages().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    TtsController.stop();
    scrollController.dispose();
    super.dispose();
  }

  bool get haveSettingsBeenChanged =>
      pangeaController.userController.profile != _profile;

  // if the settings have been changed, show a dialog the user wants to exit without saving
  // if the settings have not been changed, just close the settings page
  void onSettingsClose() {
    if (haveSettingsBeenChanged) {
      showOkCancelAlertDialog(
        title: L10n.of(context).exitWithoutSaving,
        okLabel: L10n.of(context).submit,
        cancelLabel: L10n.of(context).leave,
        context: context,
      ).then((value) {
        if (value == OkCancelResult.ok) {
          submit();
        } else {
          Navigator.of(context).pop();
        }
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  bool get hasIdenticalLanguages =>
      selectedSourceLanguage?.langCodeShort ==
      selectedTargetLanguage?.langCodeShort;

  Future<void> submit() async {
    if (hasIdenticalLanguages) {
      setState(() {
        languageMatchError = L10n.of(context).noIdenticalLanguages;
      });

      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    setState(() {
      languageMatchError = null; // Clear error if languages don't match
    });

    if (!isTTSSupported) {
      updateToolSetting(ToolSetting.enableTTS, false);
    }

    if (formKey.currentState!.validate()) {
      await showFutureLoadingDialog(
        context: context,
        future: () async => pangeaController.userController
            .updateProfile(
              (_) => _profile,
              waitForDataInSync: true,
            )
            .timeout(const Duration(seconds: 15)),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> resetInstructionTooltips() async {
    _profile.instructionSettings = InstructionSettings();
    await showFutureLoadingDialog(
      context: context,
      future: () async => pangeaController.userController.updateProfile(
        (profile) {
          profile.instructionSettings = InstructionSettings();
          return profile;
        },
        waitForDataInSync: true,
      ),
      onError: (e, s) {
        debugPrint("Error resetting instruction tooltips: $e");
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {"resetInstructionTooltips": true},
        );
        return null;
      },
    );
    if (mounted) setState(() {});
  }

  Future<void> setSelectedLanguage({
    LanguageModel? sourceLanguage,
    LanguageModel? targetLanguage,
  }) async {
    if (sourceLanguage != null) {
      _profile.userSettings.sourceLanguage = sourceLanguage.langCode;
    }
    if (targetLanguage != null) {
      _profile.userSettings.targetLanguage = targetLanguage.langCode;
      if (!_profile.toolSettings.enableTTS && isTTSSupported) {
        updateToolSetting(ToolSetting.enableTTS, true);
      }
    }

    if (mounted) setState(() {});
  }

  void setPublicProfile(bool isPublic) {
    _profile.userSettings.publicProfile = isPublic;
    if (mounted) setState(() {});
  }

  void setCefrLevel(LanguageLevelTypeEnum? cefrLevel) {
    _profile.userSettings.cefrLevel = cefrLevel ?? LanguageLevelTypeEnum.a1;
    if (mounted) setState(() {});
  }

  void changeCountry(Country? country) {
    _profile.userSettings.country = country?.name;
    if (mounted) setState(() {});
  }

  void updateToolSetting(ToolSetting toolSetting, bool value) {
    switch (toolSetting) {
      case ToolSetting.interactiveTranslator:
        _profile.toolSettings.interactiveTranslator = value;
        break;
      case ToolSetting.interactiveGrammar:
        _profile.toolSettings.interactiveGrammar = value;
        break;
      case ToolSetting.immersionMode:
        _profile.toolSettings.immersionMode = value;
        break;
      case ToolSetting.definitions:
        _profile.toolSettings.definitions = value;
        break;
      case ToolSetting.autoIGC:
        _profile.toolSettings.autoIGC = value;
        break;
      case ToolSetting.enableTTS:
        _profile.toolSettings.enableTTS = value;
        break;
      case ToolSetting.enableAutocorrect:
        _profile.toolSettings.enableAutocorrect = value;
        break;
    }
    if (mounted) setState(() {});
  }

  LanguageModel? get _targetLanguage =>
      _profile.userSettings.targetLanguage != null
          ? PLanguageStore.byLangCode(_profile.userSettings.targetLanguage!)
          : null;

  bool getToolSetting(ToolSetting toolSetting) {
    final toolSettings = _profile.toolSettings;
    switch (toolSetting) {
      case ToolSetting.interactiveTranslator:
        return toolSettings.interactiveTranslator;
      case ToolSetting.interactiveGrammar:
        return toolSettings.interactiveGrammar;
      case ToolSetting.immersionMode:
        return toolSettings.immersionMode;
      case ToolSetting.definitions:
        return toolSettings.definitions;
      case ToolSetting.autoIGC:
        return toolSettings.autoIGC;
      case ToolSetting.enableTTS:
        return _profile.userSettings.targetLanguage != null &&
            _targetLanguage != null &&
            toolSettings.enableTTS;
      case ToolSetting.enableAutocorrect:
        return toolSettings.enableAutocorrect;
    }
  }

  bool get isTTSSupported =>
      _profile.userSettings.targetLanguage != null && _targetLanguage != null;

  LanguageModel? get selectedSourceLanguage {
    return _selectedBaseLanguage ??
        pangeaController.languageController.systemLanguage;
  }

  LanguageModel? get selectedTargetLanguage {
    return _selectedTargetLanguage ??
        ((selectedSourceLanguage?.langCode != 'en')
            ? PLanguageStore.byLangCode('en')
            : PLanguageStore.byLangCode('es'));
  }

  LanguageModel? get _selectedBaseLanguage =>
      _profile.userSettings.sourceLanguage != null
          ? PLanguageStore.byLangCode(_profile.userSettings.sourceLanguage!)
          : null;

  LanguageModel? get _selectedTargetLanguage =>
      _profile.userSettings.targetLanguage != null
          ? PLanguageStore.byLangCode(_profile.userSettings.targetLanguage!)
          : null;

  LanguageModel? get userL1 => pangeaController.languageController.userL1;
  LanguageModel? get userL2 => pangeaController.languageController.userL2;

  bool get publicProfile => _profile.userSettings.publicProfile ?? false;

  LanguageLevelTypeEnum get cefrLevel => _profile.userSettings.cefrLevel;

  Country? get country =>
      CountryService().findByName(_profile.userSettings.country);

  @override
  Widget build(BuildContext context) {
    return SettingsLearningView(this);
  }
}
