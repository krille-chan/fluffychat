import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/client_stories_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../config/themes.dart';

enum ContextualRoomAction {
  mute,
  unmute,
  leave,
}

class StoriesHeader extends StatelessWidget {
  final String filter;

  const StoriesHeader({required this.filter, super.key});

  void _addToStoryAction(BuildContext context) =>
      context.go('/rooms/stories/create');

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
    context.go('/rooms/stories/$roomId');
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
      height: 104,
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
            return const SizedBox.shrink();
          }
          return _StoryButton(
            profile: Profile(
              displayName: displayname,
              avatarUrl: avatarUrl,
              userId: userId ?? 'Unknown',
            ),
            lastMessage: room.hasPosts
                ? room.lastEvent?.calcLocalizedBodyFallback(
                    MatrixLocals(
                      L10n.of(context)!,
                    ),
                  )
                : null,
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

class _StoryButton extends StatefulWidget {
  final Profile profile;
  final bool showEditFab;
  final bool unread;
  final bool hasPosts;
  final void Function() onPressed;
  final void Function()? onLongPressed;
  final String heroTag;
  final String? lastMessage;

  const _StoryButton({
    required this.profile,
    required this.onPressed,
    required this.heroTag,
    required this.lastMessage,
    this.showEditFab = false,
    this.hasPosts = true,
    this.unread = false,
    this.onLongPressed,
  });

  @override
  State<_StoryButton> createState() => _StoryButtonState();
}

class _StoryButtonState extends State<_StoryButton> {
  bool _hovered = false;

  void _onHover(bool hover) {
    if (hover == _hovered) return;
    setState(() {
      _hovered = hover;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lastMessage = widget.lastMessage;
    final lastMessageBubbleElevation =
        Theme.of(context).appBarTheme.scrolledUnderElevation ?? 4;
    final lastMessageBubbleShadowColor =
        Theme.of(context).appBarTheme.shadowColor;
    final lastMessageBubbleColor = Colors.white.withAlpha(245);
    return SizedBox(
      width: 82,
      child: InkWell(
        onHover: _onHover,
        borderRadius: BorderRadius.circular(7),
        onTap: widget.onPressed,
        onLongPress: widget.onLongPressed,
        child: Opacity(
          opacity: widget.hasPosts ? 1 : 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                const SizedBox(height: 8),
                AnimatedScale(
                  scale: _hovered ? 1.15 : 1.0,
                  duration: FluffyThemes.animationDuration,
                  curve: FluffyThemes.animationCurve,
                  child: Material(
                    borderRadius: BorderRadius.circular(Avatar.defaultSize),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        gradient: widget.unread
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
                        color: widget.unread
                            ? null
                            : Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(Avatar.defaultSize),
                      ),
                      child: Stack(
                        children: [
                          Hero(
                            tag: widget.heroTag,
                            child: Avatar(
                              mxContent: widget.profile.avatarUrl,
                              name: widget.profile.displayName,
                              size: 72,
                              fontSize: 26,
                            ),
                          ),
                          if (widget.showEditFab)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: FloatingActionButton.small(
                                  heroTag: null,
                                  onPressed: () =>
                                      context.go('/rooms/stories/create'),
                                  child: const Icon(
                                    Icons.add_outlined,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          if (lastMessage != null) ...[
                            Positioned(
                              left: 0,
                              top: 0,
                              right: 8,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Material(
                                    elevation: lastMessageBubbleElevation,
                                    shadowColor: lastMessageBubbleShadowColor,
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius / 2,
                                    ),
                                    color: lastMessageBubbleColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        lastMessage,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 26.0,
                                      top: 4.0,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: Material(
                                          elevation: lastMessageBubbleElevation,
                                          shadowColor:
                                              lastMessageBubbleShadowColor,
                                          borderRadius:
                                              BorderRadius.circular(99),
                                          color: lastMessageBubbleColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.profile.displayName ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: widget.unread ? FontWeight.bold : null,
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
