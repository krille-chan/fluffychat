import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/widgets/user_settings/country_picker_tile.dart';
import 'package:fluffychat/pangea/widgets/user_settings/language_tile.dart';
import 'package:fluffychat/pangea/widgets/user_settings/p_settings_switch_list_tile.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsLearningView extends StatelessWidget {
  final SettingsLearningController controller;
  const SettingsLearningView(this.controller, {super.key});

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
                    Column(
                      children: [
                        ProfileSettingsSwitchListTile.adaptive(
                          defaultValue: controller.getToolSetting(toolSetting),
                          title: toolSetting.toolName(context),
                          subtitle: toolSetting == ToolSetting.enableTTS &&
                                  !controller.tts.isLanguageFullySupported
                              ? null
                              : toolSetting.toolDescription(context),
                          onChange: (bool value) =>
                              controller.updateToolSetting(
                            toolSetting,
                            value,
                          ),
                          enabled: toolSetting == ToolSetting.enableTTS
                              ? controller.tts.isLanguageFullySupported
                              : true,
                        ),
                        if (toolSetting == ToolSetting.enableTTS &&
                            !controller.tts.isLanguageFullySupported)
                          ListTile(
                            trailing: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(Icons.info_outlined),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                text: L10n.of(context).couldNotFindTTS,
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  if (PlatformInfos.isWindows ||
                                      PlatformInfos.isAndroid)
                                    TextSpan(
                                      text: L10n.of(context)
                                          .ttsInstructionsHyperlink,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launchUrlString(
                                            PlatformInfos.isWindows
                                                ? AppConfig
                                                    .windowsTTSDownloadInstructions
                                                : AppConfig
                                                    .androidTTSDownloadInstructions,
                                          );
                                        },
                                    ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
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
      },
    );
  }
}
