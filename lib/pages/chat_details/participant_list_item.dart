// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import '../../widgets/avatar.dart';
import '../user_bottom_sheet/user_bottom_sheet.dart';

class ParticipantListItem extends StatelessWidget {
  final User user;

  const ParticipantListItem(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final membershipBatch = <Membership, String>{
      Membership.join: '',
      Membership.ban: L10n.of(context)!.banned,
      Membership.invite: L10n.of(context)!.invited,
      Membership.leave: L10n.of(context)!.leftTheChat,
    };
    final permissionBatch = user.powerLevel == 100
        ? L10n.of(context)!.admin
        : user.powerLevel >= 50
            ? L10n.of(context)!.moderator
            : '';

    // #Pangea
    if (user.id == BotName.byEnvironment) {
      return const SizedBox();
    }
    // Pangea#

    return Opacity(
      //#Pangea
      // opacity: user.membership == Membership.join? 1 : 0.5,
      opacity:
          user.membership == Membership.join && user.id != BotName.byEnvironment
              ? 1
              : 0.5,
      //Pangea#
      child: ListTile(
        //#Pangea
        // onTap: () => showAdaptiveBottomSheet(
        onTap: user.id == BotName.byEnvironment
            ? null
            : () => showAdaptiveBottomSheet(
                  //Pangea#
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
                  horizontal: 4,
                  vertical: 2,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  // #Pangea
                  // color: Theme.of(context).colorScheme.primaryContainer,
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(8),
                  // border: Border.all(
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                  // Pangea#
                ),
                child: Text(
                  permissionBatch,
                  // #Pangea
                  // style: TextStyle(
                  //   fontSize: 14,
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                  // Pangea#
                ),
              ),
            membershipBatch[user.membership]!.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Center(child: Text(membershipBatch[user.membership]!)),
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
