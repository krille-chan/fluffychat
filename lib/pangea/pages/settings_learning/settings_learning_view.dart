import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/widgets/user_settings/country_picker_tile.dart';
import 'package:fluffychat/pangea/widgets/user_settings/language_tile.dart';
import 'package:fluffychat/pangea/widgets/user_settings/p_settings_switch_list_tile.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SettingsLearningView extends StatelessWidget {
  final SettingsLearningController controller;
  const SettingsLearningView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          L10n.of(context)!.learningSettings,
        ),
      ),
      body: ListTileTheme(
        iconColor: Theme.of(context).textTheme.bodyLarge!.color,
        child: MaxWidthBody(
          withScrolling: true,
          child: Column(
            children: [
              LanguageTile(controller),
              CountryPickerTile(controller),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              // if (controller.pangeaController.permissionsController.isUser18())
              //   SwitchListTile.adaptive(
              //     activeColor: AppConfig.activeToggleColor,
              //     title: Text(L10n.of(context)!.publicProfileTitle),
              //     subtitle: Text(L10n.of(context)!.publicProfileDesc),
              //     value: controller.pangeaController.userController.isPublic,
              //     onChanged: (bool isPublicProfile) =>
              //         controller.setPublicProfile(isPublicProfile),
              //   ),
              ListTile(
                subtitle: Text(L10n.of(context)!.toggleToolSettingsDescription),
              ),
              for (final toolSetting in ToolSetting.values)
                ProfileSettingsSwitchListTile.adaptive(
                  defaultValue: controller.getToolSetting(toolSetting),
                  title: toolSetting.toolName(context),
                  subtitle: toolSetting.toolDescription(context),
                  onChange: (bool value) => controller.updateToolSetting(
                    toolSetting,
                    value,
                  ),
                ),
              ProfileSettingsSwitchListTile.adaptive(
                defaultValue: controller.pangeaController.userController.profile
                    .userSettings.itAutoPlay,
                title:
                    L10n.of(context)!.interactiveTranslatorAutoPlaySliderHeader,
                subtitle: L10n.of(context)!.interactiveTranslatorAutoPlayDesc,
                onChange: (bool value) => controller
                    .pangeaController.userController
                    .updateProfile((profile) {
                  profile.userSettings.itAutoPlay = value;
                  return profile;
                }),
              ),
              ProfileSettingsSwitchListTile.adaptive(
                defaultValue: controller.pangeaController.userController.profile
                    .userSettings.autoPlayMessages,
                title: L10n.of(context)!.autoPlayTitle,
                subtitle: L10n.of(context)!.autoPlayDesc,
                onChange: (bool value) => controller
                    .pangeaController.userController
                    .updateProfile((profile) {
                  profile.userSettings.autoPlayMessages = value;
                  return profile;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
