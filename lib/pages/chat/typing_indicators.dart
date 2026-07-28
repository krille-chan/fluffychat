// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/typing_animation.dart';
import 'package:flutter/material.dart';

class TypingIndicators extends StatelessWidget {
  final ChatController controller;
  const TypingIndicators(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const avatarSize = Avatar.defaultSize / 2;

    return StreamBuilder<Object>(
      stream: controller.room.client.onSync.stream.where(
        (syncUpdate) =>
            syncUpdate.rooms?.join?[controller.room.id]?.ephemeral?.any(
              (ephemeral) => ephemeral.type == 'm.typing',
            ) ??
            false,
      ),
      builder: (context, _) {
        final typingUsers = controller.room.typingUsers
          ..removeWhere((u) => u.stateKey == Matrix.of(context).client.userID);

        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: AnimatedContainer(
            constraints: const BoxConstraints(
              maxWidth: FluffyThemes.maxTimelineWidth,
            ),
            height: typingUsers.isEmpty ? 0 : avatarSize + 8,
            duration: FluffyThemes.animationDuration,
            curve: FluffyThemes.animationCurve,
            alignment:
                controller.timeline!.events.isNotEmpty &&
                    controller.timeline!.events.first.senderId ==
                        Matrix.of(context).client.userID
                ? Alignment.topRight
                : Alignment.topLeft,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: avatarSize,
                  width: Avatar.defaultSize,
                  child: Stack(
                    children: [
                      if (typingUsers.isNotEmpty)
                        Avatar(
                          size: avatarSize,
                          mxContent: typingUsers.first.avatarUrl,
                          name: typingUsers.first.calcDisplayname(),
                        ),
                      if (typingUsers.length == 2)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Avatar(
                            size: avatarSize,
                            mxContent: typingUsers.length == 2
                                ? typingUsers.last.avatarUrl
                                : null,
                            name: typingUsers.length == 2
                                ? typingUsers.last.calcDisplayname()
                                : '+${typingUsers.length - 1}',
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppConfig.borderRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: typingUsers.isEmpty ? null : const TypingAnimation(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
