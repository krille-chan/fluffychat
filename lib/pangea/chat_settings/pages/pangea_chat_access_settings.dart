import 'package:flutter/material.dart' hide Visibility;

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_access_settings/chat_access_settings_controller.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class PangeaChatAccessSettingsPageView extends StatelessWidget {
  final ChatAccessSettingsController controller;
  const PangeaChatAccessSettingsPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final room = controller.room;
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_outlined),
            const SizedBox(width: 8),
            Text(L10n.of(context).access),
          ],
        ),
      ),
      body: MaxWidthBody(
        showBorder: false,
        child: StreamBuilder<Object>(
          stream: room.client.onRoomState.stream
              .where((update) => update.roomId == controller.room.id),
          builder: (context, snapshot) {
            return Container(
              width: 400.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: FutureBuilder(
                future: room.client.getRoomVisibilityOnDirectory(room.id),
                builder: (context, snapshot) {
                  return Column(
                    spacing: 16.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ChatAccessTitle(
                        icon: Icons.search_outlined,
                        title: L10n.of(context).howSpaceCanBeFound,
                      ),
                      ChatAccessTile(
                        emoji: "🏡",
                        title: L10n.of(context).private,
                        description: L10n.of(context).cannotBeFoundInSearch,
                        selected: snapshot.data == Visibility.private,
                        onTap: () {
                          if (snapshot.data == Visibility.private) return;
                          controller.setChatVisibilityOnDirectory(false);
                        },
                      ),
                      ChatAccessTile(
                        emoji: "🌏",
                        title: L10n.of(context).public,
                        description: L10n.of(context).visibleToCommunity,
                        selected: snapshot.data == Visibility.public,
                        onTap: () {
                          if (snapshot.data == Visibility.public) return;
                          controller.setChatVisibilityOnDirectory(true);
                        },
                      ),
                      const SizedBox(height: 8.0),
                      ChatAccessTitle(
                        icon: Icons.key_outlined,
                        title: L10n.of(context).howSpaceCanBeJoined,
                      ),
                      ChatAccessTile(
                        emoji: "🤝",
                        title: L10n.of(context).restricted,
                        descriptionWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(L10n.of(context).canBeFoundVia),
                            Text(L10n.of(context).canBeFoundViaInvitation),
                            Text(L10n.of(context).canBeFoundViaCodeOrLink),
                            Text(L10n.of(context).canBeFoundViaKnock),
                          ],
                        ),
                        selected: room.joinRules == JoinRules.knock,
                        onTap: () => controller.setJoinRule(JoinRules.knock),
                      ),
                      ChatAccessTile(
                        emoji: "👐",
                        title: L10n.of(context).open,
                        description: L10n.of(context).anyoneCanJoin,
                        selected: room.joinRules == JoinRules.public,
                        onTap: () => controller.setJoinRule(JoinRules.public),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatAccessTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const ChatAccessTitle({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isColumnMode ? 32.0 : 24.0,
        ),
        SizedBox(width: isColumnMode ? 32.0 : 16.0),
        Text(
          title,
          style: isColumnMode
              ? theme.textTheme.titleLarge
              : theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}

class ChatAccessTile extends StatelessWidget {
  final String emoji;
  final String title;

  final String? description;
  final Widget? descriptionWidget;

  final bool selected;
  final VoidCallback? onTap;

  const ChatAccessTile({
    super.key,
    required this.emoji,
    required this.title,
    this.description,
    this.descriptionWidget,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      child: Opacity(
        opacity: selected ? 1.0 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.outline,
              width: 2,
            ),
            color: selected
                ? theme.colorScheme.primaryContainer.withAlpha(50)
                : null,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                emoji,
                style: isColumnMode
                    ? theme.textTheme.displayMedium
                    : theme.textTheme.displaySmall,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: isColumnMode
                          ? theme.textTheme.titleLarge
                          : theme.textTheme.titleMedium,
                    ),
                    description != null
                        ? Text(description!)
                        : descriptionWidget != null
                            ? descriptionWidget!
                            : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
