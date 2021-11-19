import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'chat.dart';
import 'encryption_button.dart';
import 'input_bar.dart';

class ChatInputRow extends StatelessWidget {
  final ChatController controller;
  const ChatInputRow(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.showEmojiPicker) return Container();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: controller.selectMode
          ? <Widget>[
              SizedBox(
                height: 56,
                child: TextButton(
                  onPressed: controller.forwardEventsAction,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.keyboard_arrow_left_outlined),
                      Text(L10n.of(context).forward),
                    ],
                  ),
                ),
              ),
              controller.selectedEvents.length == 1
                  ? controller.selectedEvents.first
                          .getDisplayEvent(controller.timeline)
                          .status
                          .isSent
                      ? SizedBox(
                          height: 56,
                          child: TextButton(
                            onPressed: controller.replyAction,
                            child: Row(
                              children: <Widget>[
                                Text(L10n.of(context).reply),
                                const Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 56,
                          child: TextButton(
                            onPressed: controller.sendAgainAction,
                            child: Row(
                              children: <Widget>[
                                Text(L10n.of(context).tryToSendAgain),
                                const SizedBox(width: 4),
                                const Icon(Icons.send_outlined, size: 16),
                              ],
                            ),
                          ),
                        )
                  : Container(),
            ]
          : <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 56,
                width: controller.inputText.isEmpty ? 56 : 0,
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.add_outlined),
                  onSelected: controller.onAddPopupMenuButtonSelected,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'videocall',
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.video_call_outlined),
                        ),
                        title: Text(L10n.of(context).videoCall),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'file',
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.attachment_outlined),
                        ),
                        title: Text(L10n.of(context).sendFile),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'image',
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.image_outlined),
                        ),
                        title: Text(L10n.of(context).sendImage),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                    if (PlatformInfos.isMobile)
                      PopupMenuItem<String>(
                        value: 'camera',
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.camera_alt_outlined),
                          ),
                          title: Text(L10n.of(context).openCamera),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                    if (controller.room
                        .getImagePacks(ImagePackUsage.sticker)
                        .isNotEmpty)
                      PopupMenuItem<String>(
                        value: 'sticker',
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.emoji_emotions_outlined),
                          ),
                          title: Text(L10n.of(context).sendSticker),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                    if (PlatformInfos.isMobile)
                      PopupMenuItem<String>(
                        value: 'voice',
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.mic_none_outlined),
                          ),
                          title: Text(L10n.of(context).voiceMessage),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                    if (PlatformInfos.isMobile)
                      PopupMenuItem<String>(
                        value: 'location',
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.gps_fixed_outlined),
                          ),
                          title: Text(L10n.of(context).shareLocation),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                height: 56,
                alignment: Alignment.center,
                child: EncryptionButton(controller.room),
              ),
              if (controller.matrix.isMultiAccount &&
                  controller.matrix.hasComplexBundles &&
                  controller.matrix.currentBundle.length > 1)
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: _ChatAccountPicker(controller),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: InputBar(
                    room: controller.room,
                    minLines: 1,
                    maxLines: 8,
                    autofocus: !PlatformInfos.isMobile,
                    keyboardType: TextInputType.multiline,
                    textInputAction:
                        AppConfig.sendOnEnter ? TextInputAction.send : null,
                    onSubmitted: controller.onInputBarSubmitted,
                    focusNode: controller.inputFocus,
                    controller: controller.sendController,
                    decoration: InputDecoration(
                      hintText: L10n.of(context).writeAMessage,
                      hintMaxLines: 1,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      filled: false,
                    ),
                    onChanged: controller.onInputBarChanged,
                  ),
                ),
              ),
              if (PlatformInfos.isMobile && controller.inputText.isEmpty)
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: IconButton(
                    tooltip: L10n.of(context).voiceMessage,
                    icon: const Icon(Icons.mic_none_outlined),
                    onPressed: controller.voiceMessageAction,
                  ),
                ),
              if (!PlatformInfos.isMobile || controller.inputText.isNotEmpty)
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: const Icon(Icons.send_outlined),
                    onPressed: controller.send,
                    tooltip: L10n.of(context).send,
                  ),
                ),
            ],
    );
  }
}

class _ChatAccountPicker extends StatelessWidget {
  final ChatController controller;

  const _ChatAccountPicker(this.controller, {Key key}) : super(key: key);

  void _popupMenuButtonSelected(String mxid) {
    final client = controller.matrix.currentBundle
        .firstWhere((cl) => cl.userID == mxid, orElse: () => null);
    if (client == null) {
      Logs().w('Attempted to switch to a non-existing client $mxid');
      return;
    }
    controller.setSendingClient(client);
  }

  @override
  Widget build(BuildContext context) {
    controller.matrix ??= Matrix.of(context);
    final clients = controller.currentRoomBundle;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Profile>(
        future: controller.sendingClient.ownProfile,
        builder: (context, snapshot) => PopupMenuButton<String>(
          onSelected: _popupMenuButtonSelected,
          itemBuilder: (BuildContext context) => clients
              .map((client) => PopupMenuItem<String>(
                    value: client.userID,
                    child: FutureBuilder<Profile>(
                      future: client.ownProfile,
                      builder: (context, snapshot) => ListTile(
                        leading: Avatar(
                          snapshot.data?.avatarUrl,
                          snapshot.data?.displayName ?? client.userID.localpart,
                          size: 20,
                        ),
                        title:
                            Text(snapshot.data?.displayName ?? client.userID),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ))
              .toList(),
          child: Avatar(
            snapshot.data?.avatarUrl,
            snapshot.data?.displayName ??
                controller.matrix.client.userID.localpart,
            size: 20,
          ),
        ),
      ),
    );
  }
}
