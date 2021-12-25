//@dart=2.12

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/client_stories_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum ContextualRoomAction {
  mute,
  unmute,
  leave,
}

class StoriesHeader extends StatelessWidget {
  const StoriesHeader({Key? key}) : super(key: key);

  void _addToStoryAction(BuildContext context) =>
      VRouter.of(context).to('/stories/create');

  void _goToStoryAction(BuildContext context, String roomId) =>
      VRouter.of(context).toSegments(['stories', roomId]);

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
    return StreamBuilder<Object>(
        stream: client.onSync.stream
            .where((syncUpdate) => syncUpdate.hasRoomUpdate),
        builder: (context, snapshot) {
          if (client.storiesRooms.isEmpty && client.contacts.isEmpty) {
            return Container();
          }
          if (client.storiesRooms.isEmpty ||
              Matrix.of(context).shareContent != null) {
            return ListTile(
              leading: CircleAvatar(
                radius: Avatar.defaultSize / 2,
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).textTheme.bodyText1?.color,
                child: const Icon(Icons.add),
              ),
              title: const Text('Add to story'),
              onTap: () => _addToStoryAction(context),
            );
          }
          return SizedBox(
            height: 98,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              scrollDirection: Axis.horizontal,
              children: [
                _StoryButton(
                  label: L10n.of(context)!.yourStory,
                  onPressed: () => _addToStoryAction(context),
                  child: const Icon(Icons.add),
                ),
                ...client.storiesRooms.map(
                  (room) => Opacity(
                    opacity: room.hasPosts ? 1 : 0.5,
                    child: _StoryButton(
                      label: room.creatorDisplayname,
                      child: Avatar(
                        mxContent: room
                            .getState(EventTypes.RoomCreate)!
                            .sender
                            .avatarUrl,
                        name: room.creatorDisplayname,
                        size: 100,
                      ),
                      unread: room.notificationCount > 0 ||
                          room.membership == Membership.invite,
                      onPressed: () => room.hasPosts
                          ? _goToStoryAction(context, room.id)
                          : _contextualActions(context, room),
                      onLongPressed: () => _contextualActions(context, room),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

extension on Room {
  String get creatorDisplayname =>
      getState(EventTypes.RoomCreate)!.sender.calcDisplayname();

  bool get hasPosts {
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
  final Widget child;
  final String label;
  final void Function() onPressed;
  final void Function()? onLongPressed;
  final bool unread;

  const _StoryButton({
    required this.child,
    required this.label,
    required this.onPressed,
    this.unread = false,
    this.onLongPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        onTap: onPressed,
        onLongPress: onLongPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(2),
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
                  color: unread ? null : Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(Avatar.defaultSize),
                ),
                child: Material(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(Avatar.defaultSize),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor:
                          Theme.of(context).textTheme.bodyText1?.color,
                      child: child,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: unread ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
