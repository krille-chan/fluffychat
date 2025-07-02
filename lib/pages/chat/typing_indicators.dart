import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

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
            syncUpdate.rooms?.join?[controller.room.id]?.ephemeral
                ?.any((ephemeral) => ephemeral.type == 'm.typing') ??
            false,
      ),
      builder: (context, _) {
        final typingUsers = controller.room.typingUsers
          ..removeWhere((u) => u.stateKey == Matrix.of(context).client.userID);

        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: AnimatedContainer(
            constraints:
                const BoxConstraints(maxWidth: FluffyThemes.maxTimelineWidth),
            height: typingUsers.isEmpty ? 0 : avatarSize + 8,
            duration: FluffyThemes.animationDuration,
            curve: FluffyThemes.animationCurve,
            alignment: controller.timeline!.events.isNotEmpty &&
                    controller.timeline!.events.first.senderId ==
                        Matrix.of(context).client.userID
                ? Alignment.topRight
                : Alignment.topLeft,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
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
                    child: typingUsers.isEmpty ? null : const _TypingDots(),
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

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => __TypingDotsState();
}

class __TypingDotsState extends State<_TypingDots> {
  int _tick = 0;

  late final Timer _timer;

  static const Duration animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    _timer = Timer.periodic(
      animationDuration,
      (_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _tick = (_tick + 1) % 4;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const size = 8.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 3; i++)
          AnimatedContainer(
            duration: animationDuration * 1.5,
            curve: FluffyThemes.animationCurve,
            width: size,
            height: _tick == i ? size * 2 : size,
            margin: EdgeInsets.symmetric(
              horizontal: 2,
              vertical: _tick == i ? 4 : 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 2),
              color: theme.colorScheme.secondary,
            ),
          ),
      ],
    );
  }
}
