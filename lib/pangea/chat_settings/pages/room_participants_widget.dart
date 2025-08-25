import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/level_display_name.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/spaces/utils/load_participants_util.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/member_actions_popup_menu_button.dart';

class RoomParticipantsSection extends StatelessWidget {
  final Room room;

  const RoomParticipantsSection({
    required this.room,
    super.key,
  });

  final double _width = 100.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LoadParticipantsUtil(
      space: room,
      builder: (participantsLoader) {
        final filteredParticipants = participantsLoader.sortedParticipants();

        final originalLeaders = filteredParticipants.take(3).toList();
        filteredParticipants.sort((a, b) {
          // always sort bot to the end
          final aIsBot = a.id == BotName.byEnvironment;
          final bIsBot = b.id == BotName.byEnvironment;
          if (aIsBot && !bIsBot) {
            return 1;
          } else if (bIsBot && !aIsBot) {
            return -1;
          }

          // put knocking users at the front
          if (a.membership == Membership.knock &&
              b.membership != Membership.knock) {
            return -1;
          } else if (b.membership == Membership.knock &&
              a.membership != Membership.knock) {
            return 1;
          }

          // then invited users
          if (a.membership == Membership.invite &&
              b.membership != Membership.invite) {
            return -1;
          } else if (b.membership == Membership.invite &&
              a.membership != Membership.invite) {
            return 1;
          }

          // then admins
          if (a.powerLevel == 100 && b.powerLevel != 100) {
            return -1;
          } else if (b.powerLevel == 100 && a.powerLevel != 100) {
            return 1;
          }

          return 0;
        });

        return Wrap(
          spacing: 8.0,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [...filteredParticipants, null].mapIndexed((index, user) {
            if (user == null) {
              return room.canInvite
                  ? MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => context.go(
                          "/rooms/${room.id}/details/invite",
                        ),
                        child: HoverBuilder(
                          builder: (context, hovered) {
                            return Container(
                              decoration: BoxDecoration(
                                color: hovered
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withAlpha(50)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              width: _width,
                              child: Column(
                                spacing: 4.0,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.person_add_outlined,
                                      size: 50.0,
                                    ),
                                  ),
                                  Text(
                                    L10n.of(context).invite,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox();
            }
            final permissionBatch = user.powerLevel >= 100
                ? L10n.of(context).admin
                : user.powerLevel >= 50
                    ? L10n.of(context).moderator
                    : '';

            final membershipBatch = switch (user.membership) {
              Membership.ban => null,
              Membership.invite => L10n.of(context).invited,
              Membership.join => null,
              Membership.knock => L10n.of(context).knocking,
              Membership.leave => null,
            };

            final publicProfile = participantsLoader.getAnalyticsProfile(
              user.id,
            );

            final leaderIndex = originalLeaders.indexOf(user);
            LinearGradient? gradient;
            if (leaderIndex != -1) {
              gradient = leaderIndex.leaderboardGradient;
              if (user.id == BotName.byEnvironment ||
                  publicProfile == null ||
                  publicProfile.level == null) {
                gradient = null;
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                width: _width,
                child: Opacity(
                  opacity: user.membership == Membership.join ? 1.0 : 0.5,
                  child: Column(
                    spacing: 4.0,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (gradient != null)
                            CircleAvatar(
                              radius: _width / 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: gradient,
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              height: _width,
                              width: _width,
                            ),
                          Builder(
                            builder: (context) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => showMemberActionsPopupMenu(
                                    context: context,
                                    user: user,
                                  ),
                                  child: Center(
                                    child: Avatar(
                                      mxContent: user.avatarUrl,
                                      name: user.calcDisplayname(),
                                      size: _width - 6.0,
                                      presenceUserId: user.id,
                                      presenceOffset: const Offset(0, 0),
                                      presenceSize: 18.0,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        user.calcDisplayname(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        height: 20.0,
                        alignment: Alignment.center,
                        child: LevelDisplayName(
                          userId: user.id,
                          textStyle: theme.textTheme.labelSmall,
                        ),
                      ),
                      Container(
                        height: 24.0,
                        alignment: Alignment.center,
                        child: membershipBatch != null
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(
                                    AppConfig.borderRadius,
                                  ),
                                ),
                                child: Text(
                                  membershipBatch,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              )
                            : permissionBatch.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
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
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: user.powerLevel >= 100
                                            ? theme.colorScheme.onTertiary
                                            : theme.colorScheme
                                                .onTertiaryContainer,
                                      ),
                                    ),
                                  )
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
