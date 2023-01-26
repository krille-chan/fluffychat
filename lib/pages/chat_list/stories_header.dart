import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/utils/matrix_sdk_extensions/client_stories_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum ContextualRoomAction {
  mute,
  unmute,
  leave,
}

class StoriesHeader extends StatelessWidget {
  final String filter;

  const StoriesHeader({required this.filter, Key? key}) : super(key: key);

  void _addToStoryAction(BuildContext context) =>
      VRouter.of(context).to('/stories/create');

  void _goToStoryAction(BuildContext context, String roomId) async {
    final room = Matrix.of(context).client.getRoomById(roomId);
    if (room == null) return;
    if (room.membership != Membership.join) {
      final result = await showFutureLoadingDialog(
        context: context,
        future: room.join,
      );
      if (result.error != null) return;
    }
    VRouter.of(context).toSegments(['stories', roomId]);
  }

  void _contextualActions(BuildContext context, Room room) async {
    final action = await showModalActionSheet<ContextualRoomAction>(
      cancelLabel: L10n.of(context)!.cancel,
      context: context,
      actions: [
        if (room.pushRuleState != PushRuleState.notify)
          SheetAction(
            label: L10n.of(context)!.unmuteChat,
            key: ContextualRoomAction.unmute,
            icon: Icons.notifications_outlined,
          )
        else
          SheetAction(
            label: L10n.of(context)!.muteChat,
            key: ContextualRoomAction.mute,
            icon: Icons.notifications_off_outlined,
          ),
        SheetAction(
          label: L10n.of(context)!.unsubscribeStories,
          key: ContextualRoomAction.leave,
          icon: Icons.unsubscribe_outlined,
          isDestructiveAction: true,
        ),
      ],
    );
    if (action == null) return;
    switch (action) {
      case ContextualRoomAction.mute:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.setPushRuleState(PushRuleState.dontNotify),
        );
        break;
      case ContextualRoomAction.unmute:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.setPushRuleState(PushRuleState.notify),
        );
        break;
      case ContextualRoomAction.leave:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.leave(),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    if (Matrix.of(context).shareContent != null) {
      return ListTile(
        leading: CircleAvatar(
          radius: Avatar.defaultSize / 2,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          child: const Icon(Icons.camera_alt_outlined),
        ),
        title: Text(L10n.of(context)!.addToStory),
        onTap: () => _addToStoryAction(context),
      );
    }
    final ownStoryRoom = client.storiesRooms
        .firstWhereOrNull((r) => r.creatorId == client.userID);
    final stories = [
      if (ownStoryRoom != null) ownStoryRoom,
      ...client.storiesRooms..remove(ownStoryRoom),
    ];
    return SizedBox(
      height: 96,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, i) {
          final room = stories[i];
          final creator = room
              .unsafeGetUserFromMemoryOrFallback(room.creatorId ?? 'Unknown');
          final userId = room.creatorId;
          final displayname = creator.calcDisplayname();
          final avatarUrl = creator.avatarUrl;
          if (!displayname.toLowerCase().contains(filter.toLowerCase())) {
            return Container();
          }
          return _StoryButton(
            profile: Profile(
              displayName: displayname,
              avatarUrl: avatarUrl,
              userId: userId ?? 'Unknown',
            ),
            heroTag: 'stories_${room.id}',
            hasPosts: room.hasPosts || room == ownStoryRoom,
            showEditFab: userId == client.userID,
            unread: room.membership == Membership.invite ||
                (room.hasNewMessages && room.hasPosts),
            onPressed: () => _goToStoryAction(context, room.id),
            onLongPressed: () => _contextualActions(context, room),
          );
        },
      ),
    );
  }
}

extension on Room {
  bool get hasPosts {
    if (membership == Membership.invite) return true;
    final lastEvent = this.lastEvent;
    if (lastEvent == null) return false;
    if (lastEvent.type != EventTypes.Message) return false;
    if (DateTime.now().difference(lastEvent.originServerTs).inHours >
        ClientStoriesExtension.lifeTimeInHours) {
      return false;
    }
    return true;
  }
}

class _StoryButton extends StatelessWidget {
  final Profile profile;
  final bool showEditFab;
  final bool unread;
  final bool hasPosts;
  final void Function() onPressed;
  final void Function()? onLongPressed;
  final String heroTag;

  const _StoryButton({
    required this.profile,
    required this.onPressed,
    required this.heroTag,
    this.showEditFab = false,
    this.hasPosts = true,
    this.unread = false,
    this.onLongPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: onPressed,
        onLongPress: onLongPressed,
        child: Opacity(
          opacity: hasPosts ? 1 : 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Material(
                  borderRadius: BorderRadius.circular(Avatar.defaultSize),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      gradient: unread
                          ? const LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.purple,
                                Colors.orange,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: unread
                          ? null
                          : Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(Avatar.defaultSize),
                    ),
                    child: Stack(
                      children: [
                        Material(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius:
                              BorderRadius.circular(Avatar.defaultSize),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              foregroundColor:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              child: Hero(
                                tag: heroTag,
                                child: Avatar(
                                  mxContent: profile.avatarUrl,
                                  name: profile.displayName,
                                  size: 100,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (showEditFab)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: FloatingActionButton.small(
                                heroTag: null,
                                onPressed: () =>
                                    VRouter.of(context).to('/stories/create'),
                                child: const Icon(
                                  Icons.add_outlined,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    profile.displayName ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: unread ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on Room {
  String? get creatorId => getState(EventTypes.RoomCreate)?.senderId;
}
