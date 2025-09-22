import 'dart:math';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/spaces/utils/load_participants_util.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/member_actions_popup_menu_button.dart';

class TopicParticipantList extends StatelessWidget {
  final Room room;
  final List<User> users;
  final double avatarSize;
  final int maxVisible;
  final double overlap;

  const TopicParticipantList({
    super.key,
    required this.room,
    required this.users,
    this.avatarSize = 50.0,
    this.maxVisible = 6,
    this.overlap = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth =
        (avatarSize - overlap) * min(users.length, maxVisible) + overlap;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: maxWidth,
          height: avatarSize,
          child: LoadParticipantsBuilder(
            room: room,
            loadProfiles: true,
            builder: (context, participantsLoader) {
              final publicProfiles = Map.fromEntries(
                users.map(
                  (u) => MapEntry(
                    u.id,
                    participantsLoader.getAnalyticsProfile(u.id)?.level,
                  ),
                ),
              );

              users.sort((a, b) {
                final aLevel = publicProfiles[a.id];
                final bLevel = publicProfiles[b.id];
                if (aLevel != null && bLevel != null) {
                  return bLevel.compareTo(aLevel);
                }
                return 0;
              });

              return Stack(
                children: users.take(maxVisible).mapIndexed((index, user) {
                  final level = publicProfiles[user.id];
                  final LinearGradient? gradient =
                      level != null ? index.leaderboardGradient : null;
                  return Positioned(
                    left: index * (avatarSize - overlap),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => showMemberActionsPopupMenu(
                          context: context,
                          user: user,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (gradient != null)
                              CircleAvatar(
                                radius: avatarSize / 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: gradient,
                                  ),
                                ),
                              )
                            else
                              SizedBox(
                                height: avatarSize,
                                width: avatarSize,
                              ),
                            Center(
                              child: Avatar(
                                mxContent: user.avatarUrl,
                                name: user.calcDisplayname(),
                                size: avatarSize - 6.0,
                                userId: user.id,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        if (users.length > maxVisible)
          Text(
            L10n.of(context).additionalParticipants(users.length - maxVisible),
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
      ],
    );
  }
}
