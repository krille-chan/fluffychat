import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatListController controller;

  const ChatListHeader({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectMode = controller.selectMode;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: selectMode == SelectMode.normal
          ? null
          : IconButton(
              tooltip: L10n.of(context)!.cancel,
              icon: const Icon(Icons.close_outlined),
              onPressed: controller.cancelAction,
              color: Theme.of(context).colorScheme.primary,
            ),
      title: selectMode == SelectMode.share
          ? Text(
              L10n.of(context)!.share,
              key: const ValueKey(SelectMode.share),
            )
          : selectMode == SelectMode.select
              ? Text(
                  controller.selectedRoomIds.length.toString(),
                  key: const ValueKey(SelectMode.select),
                )
              : TextField(
                  controller: controller.searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: controller.onSearchEnter,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: controller.activeSpacesEntry.getName(context),
                    prefixIcon: controller.isSearchMode
                        ? IconButton(
                            tooltip: L10n.of(context)!.cancel,
                            icon: const Icon(Icons.close_outlined),
                            onPressed: controller.cancelSearch,
                            color: Theme.of(context).colorScheme.onBackground,
                          )
                        : IconButton(
                            onPressed: Scaffold.of(context).openDrawer,
                            icon: Icon(
                              Icons.menu,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: controller.isSearchMode
                          ? [
                              if (controller.isSearching)
                                const CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                ),
                              TextButton(
                                onPressed: controller.setServer,
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: Text(
                                  controller.searchServer ??
                                      Matrix.of(context)
                                          .client
                                          .homeserver!
                                          .host,
                                  maxLines: 2,
                                ),
                              ),
                            ]
                          : [
                              IconButton(
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                tooltip: L10n.of(context)!.addToStory,
                                onPressed: () =>
                                    VRouter.of(context).to('/stories/create'),
                              ),
                              ClientChooserButton(controller),
                              const SizedBox(width: 12),
                            ],
                    ),
                  ),
                ),
      actions: selectMode == SelectMode.share
          ? null
          : selectMode == SelectMode.select
              ? [
                  if (controller.spaces.isNotEmpty)
                    IconButton(
                      tooltip: L10n.of(context)!.addToSpace,
                      icon: const Icon(Icons.group_work_outlined),
                      onPressed: controller.addOrRemoveToSpace,
                    ),
                  IconButton(
                    tooltip: L10n.of(context)!.toggleUnread,
                    icon: Icon(controller.anySelectedRoomNotMarkedUnread
                        ? Icons.mark_chat_read_outlined
                        : Icons.mark_chat_unread_outlined),
                    onPressed: controller.toggleUnread,
                  ),
                  IconButton(
                    tooltip: L10n.of(context)!.toggleFavorite,
                    icon: Icon(controller.anySelectedRoomNotFavorite
                        ? Icons.push_pin_outlined
                        : Icons.push_pin),
                    onPressed: controller.toggleFavouriteRoom,
                  ),
                  IconButton(
                    icon: Icon(controller.anySelectedRoomNotMuted
                        ? Icons.notifications_off_outlined
                        : Icons.notifications_outlined),
                    tooltip: L10n.of(context)!.toggleMuted,
                    onPressed: controller.toggleMuted,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outlined),
                    tooltip: L10n.of(context)!.archive,
                    onPressed: controller.archiveAction,
                  ),
                ]
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
