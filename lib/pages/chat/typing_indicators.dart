import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class TypingIndicators extends StatelessWidget {
  final ChatController controller;
  const TypingIndicators(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typingUsers = controller.room.typingUsers
      ..removeWhere((u) => u.stateKey == Matrix.of(context).client.userID);
    const topPadding = 20.0;
    const bottomPadding = 4.0;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: AnimatedContainer(
        constraints:
            const BoxConstraints(maxWidth: FluffyThemes.columnWidth * 2.5),
        height: typingUsers.isEmpty ? 0 : Avatar.defaultSize + bottomPadding,
        duration: FluffyThemes.animationDuration,
        curve: FluffyThemes.animationCurve,
        alignment: controller.timeline!.events.isNotEmpty &&
                controller.timeline!.events.first.senderId ==
                    Matrix.of(context).client.userID
            ? Alignment.topRight
            : Alignment.topLeft,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.only(
          left: 8.0,
          bottom: bottomPadding,
        ),
        child: Row(
          children: [
            SizedBox(
              height: Avatar.defaultSize,
              width: typingUsers.length < 2
                  ? Avatar.defaultSize
                  : Avatar.defaultSize + 16,
              child: Stack(
                children: [
                  if (typingUsers.isNotEmpty)
                    Avatar(
                      mxContent: typingUsers.first.avatarUrl,
                      name: typingUsers.first.calcDisplayname(),
                    ),
                  if (typingUsers.length == 2)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Avatar(
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
            Padding(
              padding: const EdgeInsets.only(top: topPadding),
              child: Material(
                color: Theme.of(context).appBarTheme.backgroundColor,
                elevation: 6,
                shadowColor:
                    Theme.of(context).secondaryHeaderColor.withAlpha(100),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(AppConfig.borderRadius),
                  bottomLeft: Radius.circular(AppConfig.borderRadius),
                  bottomRight: Radius.circular(AppConfig.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: typingUsers.isEmpty
                      ? null
                      : Image.asset(
                          'assets/typing.gif',
                          height: 30,
                          filterQuality: FilterQuality.medium,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
