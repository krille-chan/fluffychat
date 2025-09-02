import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/hover_builder.dart';

class ActivityParticipantIndicator extends StatelessWidget {
  final String name;
  final String? userId;
  final String? avatarUrl;

  final VoidCallback? onTap;
  final bool selected;
  final double opacity;

  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const ActivityParticipantIndicator({
    super.key,
    required this.name,
    this.avatarUrl,
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
    return AbsorbPointer(
      absorbing: onTap == null,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
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
                          ? avatarUrl == null || avatarUrl!.startsWith("mxc")
                              ? Avatar(
                                  mxContent: avatarUrl != null
                                      ? Uri.parse(avatarUrl!)
                                      : null,
                                  name: userId!.localpart,
                                  size: 60.0,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: CachedNetworkImage(
                                    imageUrl: avatarUrl!,
                                    width: 60.0,
                                    height: 60.0,
                                    fit: BoxFit.cover,
                                  ),
                                )
                          : CircleAvatar(
                              radius: 30.0,
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
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
                          color:
                              (Theme.of(context).brightness == Brightness.light
                                      ? userId?.localpart?.lightColorAvatar
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
      ),
    );
  }
}
