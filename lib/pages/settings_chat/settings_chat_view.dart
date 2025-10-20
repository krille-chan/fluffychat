import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hermes/l10n/l10n.dart';
import 'package:hermes/config/setting_keys.dart';
import 'package:hermes/config/themes.dart';
import 'package:hermes/utils/platform_infos.dart';
import 'package:hermes/widgets/layouts/max_width_body.dart';
import 'package:hermes/widgets/matrix.dart';
import 'package:hermes/widgets/settings_switch_list_tile.dart';
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
        automaticallyImplyLeading: !PantheonThemes.isColumnMode(context),
        centerTitle: PantheonThemes.isColumnMode(context),
      ),
      body: ListTileTheme(
        iconColor: theme.textTheme.bodyLarge!.color,
        child: MaxWidthBody(
          child: Column(
            children: [
              SettingsSwitchListTile.adaptive(
                title: L10n.of(context).enableFullScreenSwipe,
                subtitle: L10n.of(context).enableFullScreenSwipeDescription,
                setting: AppSettings.swipePopEnableFullScreenDrag,
              ),
              ListTile(
                title: Text(L10n.of(context).swipeDuration),
                subtitle: Text(L10n.of(context).swipeDuration),
                trailing: Text('${controller.swipeDurationMs.round()} ms'),
              ),
              Slider.adaptive(
                min: 120,
                max: 600,
                divisions: 24,
                value: controller.swipeDurationMs.clamp(120, 600).toDouble(),
                onChanged: controller.swipeEnableFullScreenDrag
                    ? controller.updateSwipeDuration
                    : null,
                onChangeEnd: controller.swipeEnableFullScreenDrag
                    ? controller.saveSwipeDuration
                    : null,
              ),
              ListTile(
                title: Text(L10n.of(context).swipeDistance),
                subtitle: Text(
                  L10n.of(context).swipeDistanceDescription,
                ),
                trailing: Text(
                  '${(controller.swipeMinimumDragFraction * 100).round()}%',
                ),
              ),
              Slider.adaptive(
                min: 0.05,
                max: 1.0,
                divisions: 19,
                value: controller.swipeMinimumDragFraction
                    .clamp(0.05, 1.0)
                    .toDouble(),
                onChanged: controller.swipeEnableFullScreenDrag
                    ? controller.updateSwipeMinimumDragFraction
                    : null,
                onChangeEnd: controller.swipeEnableFullScreenDrag
                    ? controller.saveSwipeMinimumDragFraction
                    : null,
              ),
              ListTile(
                title: Text(L10n.of(context).swipeVelocity),
                subtitle: Text(L10n.of(context).swipeVelocityDescription),
                trailing:
                    Text('${controller.swipeVelocityThreshold.round()} px/s'),
              ),
              Slider.adaptive(
                min: 50,
                max: 2000,
                divisions: 39,
                value: controller.swipeVelocityThreshold
                    .clamp(50.0, 2000.0)
                    .toDouble(),
                onChanged: controller.swipeEnableFullScreenDrag
                    ? controller.updateSwipeVelocityThreshold
                    : null,
                onChangeEnd: controller.swipeEnableFullScreenDrag
                    ? controller.saveSwipeVelocityThreshold
                    : null,
              ),
              Divider(color: theme.dividerColor),
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
