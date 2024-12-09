import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/widgets/user_settings/country_picker_tile.dart';
import 'package:fluffychat/pangea/widgets/user_settings/language_tile.dart';
import 'package:fluffychat/pangea/widgets/user_settings/p_settings_switch_list_tile.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SettingsLearningView extends StatelessWidget {
  final SettingsLearningController controller;
  const SettingsLearningView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final dialogContent = Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          L10n.of(context).learningSettings,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(context).pop,
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
              const Divider(height: 1),
              ListTile(
                title: Text(L10n.of(context).toggleToolSettingsDescription),
              ),
              for (final toolSetting in ToolSetting.values
                  .where((tool) => tool.isAvailableSetting))
                ProfileSettingsSwitchListTile.adaptive(
                  defaultValue: controller.getToolSetting(toolSetting),
                  title: toolSetting.toolName(context),
                  subtitle: toolSetting.toolDescription(context),
                  onChange: (bool value) => controller.updateToolSetting(
                    toolSetting,
                    value,
                  ),
                ),
              // ProfileSettingsSwitchListTile.adaptive(
              //   defaultValue: controller.pangeaController.userController.profile
              //       .userSettings.itAutoPlay,
              //   title:
              //       L10n.of(context).interactiveTranslatorAutoPlaySliderHeader,
              //   subtitle: L10n.of(context).interactiveTranslatorAutoPlayDesc,
              //   onChange: (bool value) => controller
              //       .pangeaController.userController
              //       .updateProfile((profile) {
              //     profile.userSettings.itAutoPlay = value;
              //     return profile;
              //   }),
              // ),
              // ProfileSettingsSwitchListTile.adaptive(
              //   defaultValue: controller.pangeaController.userController.profile
              //       .userSettings.autoPlayMessages,
              //   title: L10n.of(context).autoPlayTitle,
              //   subtitle: L10n.of(context).autoPlayDesc,
              //   onChange: (bool value) => controller
              //       .pangeaController.userController
              //       .updateProfile((profile) {
              //     profile.userSettings.autoPlayMessages = value;
              //     return profile;
              //   }),
              // ),
            ],
          ),
        ),
      ),
    );

    return kIsWeb
        ? Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
                maxHeight: 600,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: dialogContent,
              ),
            ),
          )
        : Dialog.fullscreen(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: dialogContent,
            ),
          );
  }
}
