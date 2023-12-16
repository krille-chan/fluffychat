import 'package:flutter/material.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/pinned_events.dart';
import 'package:fluffychat/pages/chat/reactions_picker.dart';
import 'package:fluffychat/pages/chat/reply_display.dart';
import 'package:fluffychat/pages/chat/tombstone_display.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'chat_emoji_picker.dart';
import 'chat_input_row.dart';

class ChatViewFrame extends StatelessWidget {
  final ChatController controller;
  final WidgetBuilder contentBuilder;

  const ChatViewFrame(this.controller,
      {super.key, required this.contentBuilder});

  @override
  Widget build(BuildContext context) {
    final bottomSheetPadding = FluffyThemes.isColumnMode(context) ? 16.0 : 8.0;
    final scrollUpBannerEventId = controller.scrollUpBannerEventId;

    return DropTarget(
      onDragDone: controller.onDragDone,
      onDragEntered: controller.onDragEntered,
      onDragExited: controller.onDragExited,
      child: Stack(
        children: <Widget>[
          if (Matrix.of(context).wallpaper != null)
            Image.file(
              Matrix.of(context).wallpaper!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          SafeArea(
            child: Column(
              children: <Widget>[
                TombstoneDisplay(controller),
                if (scrollUpBannerEventId != null)
                  Material(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    shape: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: ListTile(
                      leading: IconButton(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        icon: const Icon(Icons.close),
                        tooltip: L10n.of(context)!.close,
                        onPressed: () {
                          controller.discardScrollUpBannerEventId();
                          controller.setReadMarker();
                        },
                      ),
                      title: Text(
                        L10n.of(context)!.jumpToLastReadMessage,
                      ),
                      contentPadding: const EdgeInsets.only(left: 8),
                      trailing: TextButton(
                        onPressed: () {
                          controller.scrollToEventId(
                            scrollUpBannerEventId,
                          );
                          controller.discardScrollUpBannerEventId();
                        },
                        child: Text(L10n.of(context)!.jump),
                      ),
                    ),
                  ),
                PinnedEvents(controller),
                Expanded(
                  child: GestureDetector(
                    onTap: controller.clearSingleSelectedEvent,
                    child: Builder(
                      builder: contentBuilder.call,
                    ),
                  ),
                ),
                if (controller.room.canSendDefaultMessages &&
                    controller.room.membership == Membership.join)
                  Container(
                    margin: EdgeInsets.only(
                      bottom: bottomSheetPadding,
                      left: bottomSheetPadding,
                      right: bottomSheetPadding,
                    ),
                    constraints: const BoxConstraints(
                      maxWidth: FluffyThemes.columnWidth * 2.5,
                    ),
                    alignment: Alignment.center,
                    child: Material(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppConfig.borderRadius),
                        bottomRight: Radius.circular(AppConfig.borderRadius),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withAlpha(64),
                      clipBehavior: Clip.hardEdge,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                      child: controller.room.isAbandonedDMRoom == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(16),
                                    foregroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                  icon: const Icon(
                                    Icons.archive_outlined,
                                  ),
                                  onPressed: controller.leaveChat,
                                  label: Text(
                                    L10n.of(context)!.leave,
                                  ),
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(16),
                                  ),
                                  icon: const Icon(
                                    Icons.forum_outlined,
                                  ),
                                  onPressed: controller.recreateChat,
                                  label: Text(
                                    L10n.of(context)!.reopenChat,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ConnectionStatusHeader(),
                                ReactionsPicker(controller),
                                ReplyDisplay(controller),
                                ChatInputRow(controller),
                                ChatEmojiPicker(controller),
                              ],
                            ),
                    ),
                  ),
              ],
            ),
          ),
          if (controller.dragging)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              alignment: Alignment.center,
              child: const Icon(
                Icons.upload_outlined,
                size: 100,
              ),
            ),
        ],
      ),
    );
  }
}
