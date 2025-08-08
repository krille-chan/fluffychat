import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/hover_builder.dart';

class ActivityParticipantIndicator extends StatelessWidget {
  final bool selected;

  final ActivityRoleModel? role;
  final String? displayname;

  final VoidCallback? onTap;

  const ActivityParticipantIndicator({
    super.key,
    this.selected = false,
    this.role,
    this.displayname,
    this.onTap,
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
                opacity: onTap == null ? 0.7 : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: hovered || selected
                        ? theme.colorScheme.primaryContainer.withAlpha(
                            selected ? 100 : 50,
                          )
                        : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundColor: theme.colorScheme.primaryContainer,
                      ),
                      Text(
                        role?.role ?? L10n.of(context).participant,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        displayname ?? L10n.of(context).openRoleLabel,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: displayname?.lightColorAvatar ??
                              role?.role?.lightColorAvatar,
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
