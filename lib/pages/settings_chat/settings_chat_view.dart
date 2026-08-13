// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/stt/stt_manager.dart';
import 'package:fluffychat/utils/stt/stt_model_picker.dart'
    show sttModelDescription;
import 'package:fluffychat/utils/stt/transcription_cache.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/settings_switch_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'settings_chat.dart';

class SettingsChatView extends StatelessWidget {
  final SettingsChatController controller;
  const SettingsChatView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).chat),
        automaticallyImplyLeading: !FluffyThemes.isColumnMode(context),
        centerTitle: FluffyThemes.isColumnMode(context),
      ),
      body: ListTileTheme(
        iconColor: theme.textTheme.bodyLarge!.color,
        child: MaxWidthBody(
          child: Column(
            children: [
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).formattedMessages,
                subtitle: L10n.of(context).formattedMessagesDescription,
                setting: AppSettings.renderHtml,
              ),
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).hideRedactedMessages,
                subtitle: L10n.of(context).hideRedactedMessagesBody,
                setting: AppSettings.hideRedactedEvents,
              ),
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).hideRoomsInSpaces,
                setting: AppSettings.hideRoomsInSpaces,
              ),
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).hideInvalidOrUnknownMessageFormats,
                setting: AppSettings.hideUnknownEvents,
              ),
              if (PlatformInfos.isMobile)
                SettingsSwitchListTile.adaptive(
                  title: L10n.of(context).autoplayImages,
                  setting: AppSettings.autoplayImages,
                ),
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).sendOnEnter,
                setting: AppSettings.sendOnEnter,
              ),
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).swipeRightToLeftToReply,
                setting: AppSettings.swipeRightToLeftToReply,
              ),
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).showThumbnailsInTimeline,
                setting: AppSettings.showThumbnailsInTimeline,
              ),
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).doubleTapToReact,
                subtitle: L10n.of(context).doubleTapToReactDescription,
                setting: AppSettings.doubleTapToReact,
                onChanged: (_) => controller.updateState(),
              ),
              if (AppSettings.doubleTapToReact.value)
                ListTile(
                  title: Text(L10n.of(context).doubleTapReaction),
                  trailing: Text(
                    AppSettings.doubleTapReaction.value,
                    style: const TextStyle(fontSize: 24),
                  ),
                  onTap: () async {
                    final emoji = await showAdaptiveBottomSheet<String>(
                      context: context,
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(L10n.of(context).doubleTapReaction),
                          leading: CloseButton(
                            onPressed: () => Navigator.of(context).pop(null),
                          ),
                        ),
                        body: SizedBox(
                          height: double.infinity,
                          child: EmojiPicker(
                            onEmojiSelected: (_, emoji) =>
                                Navigator.of(context).pop(emoji.emoji),
                            config: Config(
                              locale: Localizations.localeOf(context),
                              emojiViewConfig: const EmojiViewConfig(
                                backgroundColor: Colors.transparent,
                              ),
                              bottomActionBarConfig:
                                  const BottomActionBarConfig(enabled: false),
                              categoryViewConfig: CategoryViewConfig(
                                initCategory: Category.SMILEYS,
                                backspaceColor: theme.colorScheme.primary,
                                iconColor: theme.colorScheme.primary.withAlpha(
                                  128,
                                ),
                                iconColorSelected: theme.colorScheme.primary,
                                indicatorColor: theme.colorScheme.primary,
                                backgroundColor: theme.colorScheme.surface,
                              ),
                              skinToneConfig: SkinToneConfig(
                                dialogBackgroundColor: Color.lerp(
                                  theme.colorScheme.surface,
                                  theme.colorScheme.primaryContainer,
                                  0.75,
                                )!,
                                indicatorColor: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    if (emoji != null) {
                      await AppSettings.doubleTapReaction.setItem(emoji);
                      controller.updateState();
                    }
                  },
                ),
              Divider(color: theme.dividerColor),
              ListTile(
                title: Text(
                  L10n.of(context).customEmojisAndStickers,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text(L10n.of(context).customEmojisAndStickers),
                subtitle: Text(L10n.of(context).customEmojisAndStickersBody),
                onTap: () => context.go('/rooms/settings/chat/emotes'),
                trailing: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.chevron_right_outlined),
                ),
              ),
              Divider(color: theme.dividerColor),
              ListTile(
                title: Text(
                  L10n.of(context).speechToText,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).sttEnable,
                subtitle: L10n.of(context).sttEnableDescription,
                setting: AppSettings.sttEnabled,
                onChanged: (_) => controller.updateState(),
              ),
              if (AppSettings.sttEnabled.value &&
                  Matrix.of(context).stt.onDeviceAvailable) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    L10n.of(context).sttModel,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ValueListenableBuilder<Map<String, ModelDownloadState>>(
                  valueListenable: Matrix.of(context).stt.modelDownloads,
                  builder: (context, downloads, _) {
                    return RadioGroup<String>(
                      groupValue: AppSettings.sttModel.value,
                      onChanged: (value) => controller.selectModel(value!),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final model in SttManager.models)
                            _SttModelRow(
                              controller: controller,
                              model: model,
                              download: downloads[model],
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              Divider(color: theme.dividerColor),
              ListTile(
                title: Text(
                  L10n.of(context).calls,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).experimentalVideoCalls,
                onChanged: (b) {
                  Matrix.of(context).createVoipPlugin();
                  return;
                },
                setting: AppSettings.experimentalVoip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SttModelRow extends StatelessWidget {
  final SettingsChatController controller;
  final String model;
  final ModelDownloadState? download;

  const _SttModelRow({
    required this.controller,
    required this.model,
    required this.download,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final downloaded = controller.sttModelDownloadStatus[model] == true;
    final sizeBytes = controller.sttModelSizes[model];
    final selected = model == AppSettings.sttModel.value;
    final isDownloading = download != null;
    return RadioListTile<String>.adaptive(
      value: model,
      enabled: !isDownloading,
      title: Row(
        children: [
          Text(model),
          if (sizeBytes != null) ...[
            const SizedBox(width: 8),
            Text(
              '${(sizeBytes / 1048576).toStringAsFixed(0)} MB',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
          const Spacer(),
          if (isDownloading)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: download!.hasTotal ? download!.progress : null,
              ),
            )
          else if (!downloaded)
            IconButton(
              icon: const Icon(Icons.cloud_download_outlined),
              tooltip: l10n.sttDownloadModel,
              onPressed: () => controller.downloadModel(model),
            )
          else if (!selected)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.delete,
              onPressed: () => controller.deleteModel(model),
            )
          else
            const Icon(Icons.download_done, size: 18, color: Colors.green),
        ],
      ),
      subtitle: isDownloading
          ? Padding(
              padding: const EdgeInsets.only(top: 6),
              child: LinearProgressIndicator(
                value: download!.hasTotal ? download!.progress : null,
              ),
            )
          : Text(sttModelDescription(context, model)),
    );
  }
}
