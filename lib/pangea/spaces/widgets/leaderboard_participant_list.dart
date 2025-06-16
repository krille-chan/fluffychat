import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/status_msg_list.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/spaces/utils/load_participants_util.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/user_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/presence_builder.dart';

class LeaderboardParticipantList extends StatefulWidget {
  final Room space;

  const LeaderboardParticipantList({
    required this.space,
    super.key,
  });

  static const double height = 116;

  @override
  State<LeaderboardParticipantList> createState() =>
      LeaderboardParticipantListState();
}

class LeaderboardParticipantListState
    extends State<LeaderboardParticipantList> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final theme = Theme.of(context);

    return StreamBuilder(
      stream: client.onSync.stream.rateLimit(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        return LoadParticipantsUtil(
          space: widget.space,
          builder: (participantsLoader) {
            final participants = participantsLoader.filteredParticipants("");

            return AnimatedSize(
              duration: FluffyThemes.animationDuration,
              curve: Curves.easeInOut,
              child: SizedBox(
                height: 130.0,
                child: Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      8.0,
                      8.0,
                      8.0,
                      16.0,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: participants.length,
                    itemBuilder: (context, i) {
                      final user = participants[i];
                      final publicProfile = participantsLoader.getPublicProfile(
                        user.id,
                      );

                      LinearGradient? gradient = i.leaderboardGradient;

                      if (user.id == BotName.byEnvironment ||
                          publicProfile == null ||
                          publicProfile.level == null) {
                        gradient = null;
                      }

                      return PresenceBuilder(
                        userId: user.id,
                        builder: (context, presence) {
                          Color? dotColor;
                          if (presence != null) {
                            dotColor = presence.presence.isOnline
                                ? Colors.green
                                : presence.presence.isUnavailable
                                    ? Colors.orange
                                    : Colors.grey;
                          }

                          return PresenceAvatar(
                            presence: presence ??
                                CachedPresence(
                                  PresenceType.unavailable,
                                  null,
                                  null,
                                  null,
                                  user.id,
                                ),
                            height: StatusMessageList.height,
                            onTap: (profile) => UserDialog.show(
                              context: context,
                              profile: profile,
                            ),
                            gradient: gradient,
                            showPresence: false,
                            floatingIndicator: Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      width: 1,
                                      color: theme.colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

extension LeaderboardGradient on int {
  LinearGradient? get leaderboardGradient {
    final Color? color = this == 0
        ? AppConfig.gold
        : this == 1
            ? Colors.grey[400]!
            : this == 2
                ? Colors.brown[400]!
                : null;

    if (color == null) return null;

    return LinearGradient(
      colors: [
        color,
        Colors.white,
        color,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
