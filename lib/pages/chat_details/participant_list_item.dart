import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/member_actions_popup_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/avatar.dart';

class ParticipantListItem extends StatelessWidget {
  final User user;

  const ParticipantListItem(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final membershipBatch = switch (user.membership) {
      Membership.ban => L10n.of(context).banned,
      Membership.invite => L10n.of(context).invited,
      Membership.join => null,
      Membership.knock => L10n.of(context).knocking,
      Membership.leave => L10n.of(context).leftTheChat,
    };

    final permissionBatch = switch (user.powerLevel.role) {
      PowerLevelRole.user => '',
      PowerLevelRole.moderator => L10n.of(context).moderator,
      PowerLevelRole.admin => L10n.of(context).admin,
      PowerLevelRole.owner => L10n.of(context).owner,
    };

    final isAdminOrOwner =
        user.powerLevel.role == PowerLevelRole.admin ||
        user.powerLevel.role == PowerLevelRole.owner;

    return ListTile(
      onTap: () => showMemberActionsPopupMenu(context: context, user: user),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              user.calcDisplayname(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (permissionBatch.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isAdminOrOwner
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              ),
              child: Text(
                permissionBatch,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isAdminOrOwner
                      ? theme.colorScheme.onTertiary
                      : theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          membershipBatch == null
              ? const SizedBox.shrink()
              : Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      membershipBatch,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
        ],
      ),
      subtitle: Text(user.id, maxLines: 1, overflow: TextOverflow.ellipsis),
      leading: Opacity(
        opacity: user.membership == Membership.join ? 1 : 0.5,
        child: Avatar(
          mxContent: user.avatarUrl,
          name: user.calcDisplayname(),
          presenceUserId: user.stateKey,
        ),
      ),
    );
  }
}
