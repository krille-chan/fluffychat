import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning_view.dart';
import 'package:fluffychat/pangea/learning_settings/utils/language_list_util.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_language_dialog.dart';
import 'package:fluffychat/pangea/spaces/models/space_model.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/user/models/user_model.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SettingsLearning extends StatefulWidget {
  const SettingsLearning({super.key});

  @override
  SettingsLearningController createState() => SettingsLearningController();
}

class SettingsLearningController extends State<SettingsLearning> {
  PangeaController pangeaController = MatrixState.pangeaController;
  final tts = TtsController();

  LanguageModel? get selectedSourceLanguage {
    return userL1 ?? pangeaController.languageController.systemLanguage;
  }

  LanguageModel? get selectedTargetLanguage {
    return userL2 ??
        ((selectedSourceLanguage?.langCode != 'en')
            ? PangeaLanguage.byLangCode('en')!
            : PangeaLanguage.byLangCode('es')!);
  }

  LanguageModel? get userL1 => pangeaController.languageController.userL1;
  LanguageModel? get userL2 => pangeaController.languageController.userL2;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tts.setupTTS().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    tts.dispose();
    super.dispose();
  }

  Future<void> setSelectedLanguage({
    LanguageModel? sourceLanguage,
    LanguageModel? targetLanguage,
  }) async {
    if (targetLanguage == null && sourceLanguage == null) return;
    if (!formKey.currentState!.validate()) return;

    await showFutureLoadingDialog(
      context: context,
      future: () async {
        pangeaController.userController.updateProfile(
          (profile) {
            if (sourceLanguage != null) {
              profile.userSettings.sourceLanguage = sourceLanguage.langCode;
            }
            if (targetLanguage != null) {
              profile.userSettings.targetLanguage = targetLanguage.langCode;
            }
            return profile;
          },
          waitForDataInSync: true,
        );
      },
    );
    if (mounted) setState(() {});
  }

  void setPublicProfile(bool isPublic) {
    pangeaController.userController.updateProfile(
      (profile) {
        // set user DOB to younger that 18 if private and older than 18 if public
        profile.userSettings.publicProfile = isPublic;
        return profile;
      },
    );
    setState(() {});
  }

  void setCefrLevel(LanguageLevelTypeEnum? cefrLevel) {
    pangeaController.userController.updateProfile(
      (profile) {
        profile.userSettings.cefrLevel = cefrLevel ?? LanguageLevelTypeEnum.a1;
        return profile;
      },
    );
    setState(() {});
  }

  void changeLanguage() {
    pLanguageDialog(context, () {}).then((_) => setState(() {}));
  }

  void changeCountry(Country country) {
    pangeaController.userController.updateProfile((Profile profile) {
      profile.userSettings.country = country.displayNameNoCountryCode;
      return profile;
    });
    setState(() {});
  }

  void updateToolSetting(ToolSetting toolSetting, bool value) {
    pangeaController.userController.updateProfile((Profile profile) {
      switch (toolSetting) {
        case ToolSetting.interactiveTranslator:
          return profile..toolSettings.interactiveTranslator = value;
        case ToolSetting.interactiveGrammar:
          return profile..toolSettings.interactiveGrammar = value;
        case ToolSetting.immersionMode:
          return profile..toolSettings.immersionMode = value;
        case ToolSetting.definitions:
          return profile..toolSettings.definitions = value;
        case ToolSetting.autoIGC:
          return profile..toolSettings.autoIGC = value;
        case ToolSetting.enableTTS:
          return profile..toolSettings.enableTTS = value;
      }
    });
  }

  bool getToolSetting(ToolSetting toolSetting) {
    final toolSettings = pangeaController.userController.profile.toolSettings;
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
        return toolSettings.enableTTS;
    }
  }

  bool get publicProfile =>
      pangeaController.userController.profile.userSettings.publicProfile;

  LanguageLevelTypeEnum get cefrLevel =>
      pangeaController.userController.profile.userSettings.cefrLevel;

  @override
  Widget build(BuildContext context) {
    return SettingsLearningView(this);
  }
}
