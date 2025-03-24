import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app_settings/app_settings.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/language_level_dropdown.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/pangea/instructions/reset_instructions_list_tile.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/country_picker_tile.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_language_dropdown.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_settings_switch_list_tile.dart';
import 'package:fluffychat/pangea/spaces/models/space_model.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SettingsLearningView extends StatelessWidget {
  final SettingsLearningController controller;
  const SettingsLearningView(this.controller, {super.key});

  void _showKeyboardSettingsDialog(BuildContext context) {
    String title;
    String? steps;
    String? description;
    String buttonText;
    VoidCallback buttonAction;

    if (kIsWeb) {
      title = L10n.of(context).autocorrectNotAvailable; // Default
      buttonText = 'OK';
      buttonAction = () {
        Navigator.of(context).pop();
      };
    } else if (Platform.isIOS) {
      title = L10n.of(context).enableAutocorrectPopupTitle;
      steps = L10n.of(context).enableAutocorrectPopupSteps;
      description = L10n.of(context).enableAutocorrectPopupDescription;
      buttonText = L10n.of(context).settings;
      buttonAction = () {
        AppSettings.openAppSettings();
      };
    } else {
      title = L10n.of(context).downloadGboardTitle;
      steps = L10n.of(context).downloadGboardSteps;
      description = L10n.of(context).downloadGboardDescription;
      buttonText = L10n.of(context).downloadGboard;
      buttonAction = () {
        launchUrlString(
          'https://play.google.com/store/apps/details?id=com.google.android.inputmethod.latin',
        );
      };
    }

    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(L10n.of(context).enableAutocorrectWarning),
          content: SingleChildScrollView(
            child: Column(
              spacing: 8.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title),
                if (steps != null)
                  Text(
                    steps,
                    textAlign: TextAlign.start,
                  ),
                if (description != null) Text(description),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(L10n.of(context).close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: buttonAction,
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Matrix.of(context).client.onSync.stream.where((update) {
        return update.accountData != null &&
            update.accountData!.any(
              (event) => event.type == ModelKey.userProfile,
            );
      }),
      builder: (context, _) {
        final dialogContent = Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              L10n.of(context).learningSettings,
            ),
            leading: controller.widget.isDialog
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.onSettingsClose,
                  )
                : null,
          ),
          body: Form(
            key: controller.formKey,
            child: ListTileTheme(
              iconColor: Theme.of(context).textTheme.bodyLarge!.color,
              child: MaxWidthBody(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          spacing: 16.0,
                          children: [
                            PLanguageDropdown(
                              onChange: (lang) =>
                                  controller.setSelectedLanguage(
                                sourceLanguage: lang,
                              ),
                              initialLanguage:
                                  controller.selectedSourceLanguage ??
                                      LanguageModel.unknown,
                              languages: MatrixState
                                  .pangeaController.pLanguageStore.baseOptions,
                              isL2List: false,
                              decorationText: L10n.of(context).myBaseLanguage,
                              hasError: controller.languageMatchError != null,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHigh,
                            ),
                            PLanguageDropdown(
                              onChange: (lang) =>
                                  controller.setSelectedLanguage(
                                targetLanguage: lang,
                              ),
                              initialLanguage:
                                  controller.selectedTargetLanguage,
                              languages: MatrixState.pangeaController
                                  .pLanguageStore.targetOptions,
                              isL2List: true,
                              decorationText: L10n.of(context).iWantToLearn,
                              error: controller.languageMatchError,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHigh,
                            ),
                            CountryPickerDropdown(controller),
                            LanguageLevelDropdown(
                              initialLevel: controller.cefrLevel,
                              onChanged: controller.setCefrLevel,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white54,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ProfileSettingsSwitchListTile.adaptive(
                                    defaultValue: controller.getToolSetting(
                                      ToolSetting.autoIGC,
                                    ),
                                    title:
                                        ToolSetting.autoIGC.toolName(context),
                                    subtitle: ToolSetting.autoIGC
                                        .toolDescription(context),
                                    onChange: (bool value) =>
                                        controller.updateToolSetting(
                                      ToolSetting.autoIGC,
                                      value,
                                    ),
                                    enabled: true,
                                  ),
                                  ProfileSettingsSwitchListTile.adaptive(
                                    defaultValue: controller.getToolSetting(
                                      ToolSetting.enableAutocorrect,
                                    ),
                                    title: ToolSetting.enableAutocorrect
                                        .toolName(context),
                                    subtitle: ToolSetting.enableAutocorrect
                                        .toolDescription(context),
                                    onChange: (bool value) {
                                      controller.updateToolSetting(
                                        ToolSetting.enableAutocorrect,
                                        value,
                                      );
                                      if (value) {
                                        _showKeyboardSettingsDialog(
                                          context,
                                        );
                                      }
                                    },
                                    enabled: true,
                                  ),
                                ],
                              ),
                            ),
                            for (final toolSetting in ToolSetting.values.where(
                              (tool) =>
                                  tool.isAvailableSetting &&
                                  tool != ToolSetting.autoIGC &&
                                  tool != ToolSetting.enableAutocorrect,
                            ))
                              Column(
                                children: [
                                  ProfileSettingsSwitchListTile.adaptive(
                                    defaultValue:
                                        controller.getToolSetting(toolSetting),
                                    title: toolSetting.toolName(context),
                                    subtitle: toolSetting ==
                                                ToolSetting.enableTTS &&
                                            !controller.isTTSSupported
                                        ? null
                                        : toolSetting.toolDescription(context),
                                    onChange: (bool value) =>
                                        controller.updateToolSetting(
                                      toolSetting,
                                      value,
                                    ),
                                  ),
                                ],
                              ),
                            SwitchListTile.adaptive(
                              value: controller.publicProfile,
                              onChanged: controller.setPublicProfile,
                              title: Text(
                                L10n.of(context).publicProfileTitle,
                              ),
                              subtitle: Text(
                                L10n.of(context).publicProfileDesc,
                              ),
                              activeColor: AppConfig.activeToggleColor,
                              contentPadding: EdgeInsets.zero,
                            ),
                            ResetInstructionsListTile(controller: controller),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.submit,
                          child: Text(L10n.of(context).saveChanges),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        if (!controller.widget.isDialog) return dialogContent;

        return FullWidthDialog(
          dialogContent: dialogContent,
          maxWidth: 600,
          maxHeight: 800,
        );
      },
    );
  }
}
