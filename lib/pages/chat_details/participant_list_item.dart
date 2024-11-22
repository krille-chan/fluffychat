import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import '../../widgets/avatar.dart';
import '../user_bottom_sheet/user_bottom_sheet.dart';

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

    final permissionBatch = user.powerLevel >= 100
        ? L10n.of(context).admin
        : user.powerLevel >= 50
            ? L10n.of(context).moderator
            : '';

    return Opacity(
      opacity: user.membership == Membership.join ? 1 : 0.5,
      child: ListTile(
        onTap: () => showAdaptiveBottomSheet(
          context: context,
          builder: (c) => UserBottomSheet(
            user: user,
            outerContext: context,
          ),
        ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: user.powerLevel >= 100
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(
                    AppConfig.borderRadius,
                  ),
                ),
                child: Text(
                  permissionBatch,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: user.powerLevel >= 100
                        ? theme.colorScheme.onTertiary
                        : theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            membershipBatch == null
                ? const SizedBox.shrink()
                : Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: theme.secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        membershipBatch,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ),
          ],
        ),
        subtitle: Text(user.id),
        leading: Avatar(
          mxContent: user.avatarUrl,
          name: user.calcDisplayname(),
          presenceUserId: user.stateKey,
        ),
      ),
    );
  }
}
