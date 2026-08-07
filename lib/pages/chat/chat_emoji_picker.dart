// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/trust_user_key_dialog.dart';
import 'package:fluffychat/pages/chat/sticker_picker_dialog.dart';
import 'package:fluffychat/pages/chat/gif_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';
import 'chat.dart';

class ChatEmojiPicker extends StatefulWidget {
  final ChatController controller;
  const ChatEmojiPicker(this.controller, {super.key});

  @override
  State<ChatEmojiPicker> createState() => _ChatEmojiPickerState();
}

class _ChatEmojiPickerState extends State<ChatEmojiPicker> {
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = widget.controller;

    return AnimatedContainer(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      height: controller.showEmojiPicker
          ? MediaQuery.sizeOf(context).height / 2
          : 0,
      child: controller.showEmojiPicker
          ? DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: L10n.of(context).emojis),
                      Tab(text: L10n.of(context).stickers),
                      Tab(text: L10n.of(context).gifs),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        EmojiPicker(
                          onEmojiSelected: controller.onEmojiSelected,
                          onBackspacePressed: controller.emojiPickerBackspace,
                          config: Config(
                            locale: Localizations.localeOf(context),
                            emojiViewConfig: EmojiViewConfig(
                              noRecents: const NoRecent(),
                              backgroundColor:
                                  theme.colorScheme.onInverseSurface,
                            ),
                            bottomActionBarConfig: const BottomActionBarConfig(
                              enabled: false,
                            ),
                            categoryViewConfig: CategoryViewConfig(
                              backspaceColor: theme.colorScheme.primary,
                              iconColor: theme.colorScheme.primary.withAlpha(
                                128,
                              ),
                              iconColorSelected: theme.colorScheme.primary,
                              indicatorColor: theme.colorScheme.primary,
                              backgroundColor: theme.colorScheme.surface,
                            ),
                            skinToneConfig: SkinToneConfig(
                              dialogBackgroundColor: Color.lerp(
                                theme.colorScheme.surface,
                                theme.colorScheme.primaryContainer,
                                0.75,
                              )!,
                              indicatorColor: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        StickerPickerDialog(
                          room: controller.room,
                          onSelected: (sticker) async {
                            final proceed = await showTrustUserInRoomDialog(
                              context,
                              controller.room,
                            );
                            if (!proceed) return;
                            controller.room.sendEvent(
                              {
                                'body': sticker.body,
                                'info': sticker.info ?? {},
                                'url': sticker.url.toString(),
                              },
                              type: EventTypes.Sticker,
                              threadRootEventId: controller.activeThreadId,
                              threadLastEventId: controller.threadLastEventId,
                            );
                            controller.hideEmojiPicker();
                          },
                        ),
                        GifPickerDialog(
                          isSending: isSending,
                          onSelected: (gif) async {
                            if (isSending) return;

                            if (gif.url.isEmpty ||
                                !gif.url.startsWith('http')) {
                              print("Error: Invalid URL");
                              return;
                            }

                            setState(() => isSending = true);

                            try {
                              await controller.room.sendTextEvent(gif.url);
                            } catch (e) {
                              Logs().w('Failed to send GIF', e);
                            } finally {
                              setState(() => isSending = false);
                              controller.hideEmojiPicker();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class NoRecent extends StatelessWidget {
  const NoRecent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          L10n.of(context).emoteKeyboardNoRecents,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
