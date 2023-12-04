import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/user_settings/country_picker_tile.dart';
import 'package:fluffychat/pangea/widgets/user_settings/language_tile.dart';
import 'package:fluffychat/pangea/widgets/user_settings/p_settings_switch_list_tile.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import '../../../config/app_config.dart';

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
              LanguageTile(),
              CountryPickerTile(),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              if (controller.pangeaController.permissionsController.isUser18())
                SwitchListTile.adaptive(
                  activeColor: AppConfig.activeToggleColor,
                  title: Text(L10n.of(context)!.publicProfileTitle),
                  subtitle: Text(L10n.of(context)!.publicProfileDesc),
                  value: controller.pangeaController.userController.isPublic,
                  onChanged: (bool isPublicProfile) => showFutureLoadingDialog(
                    context: context,
                    future: () => controller.setPublicProfile(isPublicProfile),
                    onError: (err) =>
                        ErrorHandler.logError(e: err, s: StackTrace.current),
                  ),
                ),
              ListTile(
                subtitle: Text(L10n.of(context)!.toggleToolSettingsDescription),
              ),
              for (final setting in ToolSetting.values)
                PSettingsSwitchListTile.adaptive(
                  defaultValue: controller.pangeaController.localSettings
                      .userLanguageToolSetting(setting),
                  title: setting.toolName(context),
                  subtitle: setting.toolDescription(context),
                  pStoreKey: setting.toString(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
