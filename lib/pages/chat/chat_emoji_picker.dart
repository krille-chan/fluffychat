import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/sticker_picker_dialog.dart';
import 'chat.dart';

class ChatEmojiPicker extends StatelessWidget {
  final ChatController controller;
  const ChatEmojiPicker(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnimatedContainer(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      height: controller.showEmojiPicker
          ? MediaQuery.of(context).size.height / 2
          : 0,
      child: controller.showEmojiPicker
          ? DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: L10n.of(context)!.emojis),
                      Tab(text: L10n.of(context)!.stickers),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        EmojiPicker(
                          onEmojiSelected: controller.onEmojiSelected,
                          onBackspacePressed: controller.emojiPickerBackspace,
                          config: Config(
                            backspaceColor: theme.colorScheme.primary,
                            bgColor: theme.brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                            iconColor:
                                theme.colorScheme.primary.withOpacity(0.5),
                            iconColorSelected: theme.colorScheme.primary,
                            indicatorColor: theme.colorScheme.primary,
                            noRecents: const NoRecent(),
                            skinToneDialogBgColor: Color.lerp(
                              theme.colorScheme.background,
                              theme.colorScheme.primaryContainer,
                              0.75,
                            )!,
                            skinToneIndicatorColor:
                                theme.colorScheme.onBackground,
                          ),
                        ),
                        StickerPickerDialog(
                          room: controller.room,
                          onSelected: (sticker) {
                            controller.room.sendEvent(
                              {
                                'body': sticker.body,
                                'info': sticker.info ?? {},
                                'url': sticker.url.toString(),
                              },
                              type: EventTypes.Sticker,
                            );
                            controller.hideEmojiPicker();
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
    return Text(
      L10n.of(context)!.emoteKeyboardNoRecents,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
