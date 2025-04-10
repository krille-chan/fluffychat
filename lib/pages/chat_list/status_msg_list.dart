import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../widgets/adaptive_dialogs/user_dialog.dart';

class StatusMessageList extends StatelessWidget {
  final void Function() onStatusEdit;

  const StatusMessageList({
    required this.onStatusEdit,
    super.key,
  });

  static const double height = 116;

  void _onStatusTab(BuildContext context, Profile profile) {
    final client = Matrix.of(context).client;
    if (profile.userId == client.userID) return onStatusEdit();

    UserDialog.show(
      context: context,
      profile: profile,
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final interestingPresences = client.interestingPresences;

    return StreamBuilder(
      stream: client.onSync.stream.rateLimit(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        return AnimatedSize(
          duration: FluffyThemes.animationDuration,
          curve: Curves.easeInOut,
          child: FutureBuilder(
            initialData: interestingPresences
                // ignore: deprecated_member_use
                .map((userId) => client.presences[userId])
                .whereType<CachedPresence>(),
            future: Future.wait(
              client.interestingPresences.map(
                (userId) => client.fetchCurrentPresence(
                  userId,
                  fetchOnlyFromCached: true,
                ),
              ),
            ),
            builder: (context, snapshot) {
              final presences =
                  snapshot.data?.where(isInterestingPresence).toList();

              // If no other presences than the own entry is interesting, we
              // hide the presence header.
              if (presences == null || presences.length <= 1) {
                return const SizedBox.shrink();
              }

              // Make sure own entry is at the first position. Sort by last
              // active instead.
              presences.sort((a, b) {
                if (a.userid == client.userID) return -1;
                if (b.userid == client.userID) return 1;
                return b.sortOrderDateTime.compareTo(a.sortOrderDateTime);
              });

              return SizedBox(
                height: StatusMessageList.height,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  itemCount: presences.length,
                  itemBuilder: (context, i) => PresenceAvatar(
                    presence: presences[i],
                    height: StatusMessageList.height,
                    onTap: (profile) => _onStatusTab(context, profile),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class PresenceAvatar extends StatelessWidget {
  final CachedPresence presence;
  final double height;
  final void Function(Profile) onTap;

  const PresenceAvatar({
    required this.presence,
    required this.height,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = height - 16 - 16 - 8;
    final client = Matrix.of(context).client;
    return FutureBuilder<Profile>(
      future: client.getProfileFromUserId(presence.userid),
      builder: (context, snapshot) {
        final theme = Theme.of(context);

        final profile = snapshot.data;
        final displayName = profile?.displayName ??
            presence.userid.localpart ??
            presence.userid;
        final statusMsg = presence.statusMsg;

        const statusMsgBubbleElevation = 6.0;
        final statusMsgBubbleShadowColor = theme.colorScheme.surface;
        final statusMsgBubbleColor = Colors.white.withAlpha(230);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: avatarSize,
            child: Column(
              children: [
                HoverBuilder(
                  builder: (context, hovered) {
                    return AnimatedScale(
                      scale: hovered ? 1.15 : 1.0,
                      duration: FluffyThemes.animationDuration,
                      curve: FluffyThemes.animationCurve,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(avatarSize),
                        onTap: profile == null ? null : () => onTap(profile),
                        child: Material(
                          borderRadius: BorderRadius.circular(avatarSize),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  gradient: presence.gradient,
                                  borderRadius:
                                      BorderRadius.circular(avatarSize),
                                ),
                                child: Avatar(
                                  name: displayName,
                                  mxContent: profile?.avatarUrl,
                                  size: avatarSize - 6,
                                ),
                              ),
                              if (presence.userid == client.userID)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: FloatingActionButton.small(
                                      heroTag: null,
                                      onPressed: () => onTap(
                                        profile ??
                                            Profile(userId: presence.userid),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.add_outlined,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              if (statusMsg != null) ...[
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  right: 8,
                                  child: Material(
                                    elevation: statusMsgBubbleElevation,
                                    shadowColor: statusMsgBubbleShadowColor,
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius / 2,
                                    ),
                                    color: statusMsgBubbleColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        statusMsg,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 8,
                                  top: 32,
                                  child: Material(
                                    color: statusMsgBubbleColor,
                                    elevation: statusMsgBubbleElevation,
                                    shadowColor: statusMsgBubbleShadowColor,
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius / 2,
                                    ),
                                    child: const SizedBox(
                                      width: 8,
                                      height: 8,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 14,
                                  top: 40,
                                  child: Material(
                                    color: statusMsgBubbleColor,
                                    elevation: statusMsgBubbleElevation,
                                    shadowColor: statusMsgBubbleShadowColor,
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius / 2,
                                    ),
                                    child: const SizedBox(
                                      width: 4,
                                      height: 4,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    displayName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension on Client {
  Set<String> get interestingPresences {
    final allHeroes = rooms.map((room) => room.summary.mHeroes).fold(
      <String>{},
      (previousValue, element) => previousValue..addAll(element ?? {}),
    );
    allHeroes.add(userID!);
    return allHeroes;
  }
}

bool isInterestingPresence(CachedPresence presence) =>
    !presence.presence.isOffline || (presence.statusMsg?.isNotEmpty ?? false);

extension on CachedPresence {
  DateTime get sortOrderDateTime =>
      lastActiveTimestamp ??
      (currentlyActive == true
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(0));

  LinearGradient get gradient => presence.isOnline == true
      ? LinearGradient(
          colors: [
            Colors.green,
            Colors.green.shade200,
            Colors.green.shade900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : presence.isUnavailable
          ? LinearGradient(
              colors: [
                Colors.yellow,
                Colors.yellow.shade200,
                Colors.yellow.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : LinearGradient(
              colors: [
                Colors.grey,
                Colors.grey.shade200,
                Colors.grey.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            );
}
