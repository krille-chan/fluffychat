import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/member_actions_popup_menu_button.dart';

class ActivityParticipantIndicator extends StatelessWidget {
  final String name;
  final String? userId;
  final User? user;

  final VoidCallback? onTap;
  final bool selected;
  final double opacity;

  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const ActivityParticipantIndicator({
    super.key,
    required this.name,
    this.user,
    this.userId,
    this.selected = false,
    this.onTap,
    this.opacity = 1.0,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ??
            (user != null
                ? () => showMemberActionsPopupMenu(
                      context: context,
                      user: user!,
                    )
                : null),
        child: HoverBuilder(
          builder: (context, hovered) {
            return Opacity(
              opacity: opacity,
              child: Container(
                padding: padding ??
                    const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                decoration: BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(8.0),
                  color: hovered || selected
                      ? theme.colorScheme.surfaceContainerHighest
                      : Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    userId != null
                        ? user?.avatarUrl == null ||
                                user!.avatarUrl!.toString().startsWith("mxc")
                            ? Avatar(
                                mxContent: user?.avatarUrl != null
                                    ? user!.avatarUrl!
                                    : null,
                                name: userId!.localpart,
                                size: 60.0,
                                userId: userId,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: CachedNetworkImage(
                                  imageUrl: user!.avatarUrl!.toString(),
                                  width: 60.0,
                                  height: 60.0,
                                  fit: BoxFit.cover,
                                ),
                              )
                        : CircleAvatar(
                            radius: 30.0,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: const Icon(
                              Icons.question_mark,
                              size: 30.0,
                            ),
                          ),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      userId?.localpart ?? L10n.of(context).openRoleLabel,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: (Theme.of(context).brightness == Brightness.light
                                ? userId?.localpart?.darkColor
                                : userId?.localpart?.lightColorText) ??
                            name.lightColorAvatar,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
