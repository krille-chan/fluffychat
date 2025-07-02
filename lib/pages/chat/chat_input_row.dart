import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/other_party_can_receive.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../config/themes.dart';
import 'chat.dart';
import 'input_bar.dart';

class ChatInputRow extends StatelessWidget {
  final ChatController controller;

  const ChatInputRow(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const height = 48.0;

    if (!controller.room.otherPartyCanReceiveMessages) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            L10n.of(context).otherPartyNotLoggedIn,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final selectedTextButtonStyle = TextButton.styleFrom(
      foregroundColor: theme.colorScheme.onTertiaryContainer,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: controller.selectMode
          ? <Widget>[
              if (controller.selectedEvents
                  .every((event) => event.status == EventStatus.error))
                SizedBox(
                  height: height,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.orange,
                    ),
                    onPressed: controller.deleteErrorEventsAction,
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.delete),
                        Text(L10n.of(context).delete),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  height: height,
                  child: TextButton(
                    style: selectedTextButtonStyle,
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
                          .getDisplayEvent(controller.timeline!)
                          .status
                          .isSent
                      ? SizedBox(
                          height: height,
                          child: TextButton(
                            style: selectedTextButtonStyle,
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
                          height: height,
                          child: TextButton(
                            style: selectedTextButtonStyle,
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
                  : const SizedBox.shrink(),
            ]
          : <Widget>[
              const SizedBox(width: 4),
              AnimatedContainer(
                duration: FluffyThemes.animationDuration,
                curve: FluffyThemes.animationCurve,
                width: controller.sendController.text.isNotEmpty ? 0 : height,
                height: height,
                alignment: Alignment.center,
                decoration: const BoxDecoration(),
                clipBehavior: Clip.hardEdge,
                child: PopupMenuButton<String>(
                  useRootNavigator: true,
                  icon: const Icon(Icons.add_circle_outline),
                  iconColor: theme.colorScheme.onPrimaryContainer,
                  onSelected: controller.onAddPopupMenuButtonSelected,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    if (PlatformInfos.isMobile)
                      PopupMenuItem<String>(
                        value: 'location',
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.onPrimaryContainer,
                            foregroundColor: theme.colorScheme.primaryContainer,
                            child: const Icon(Icons.gps_fixed_outlined),
                          ),
                          title: Text(L10n.of(context).shareLocation),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                    PopupMenuItem<String>(
                      value: 'image',
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.onPrimaryContainer,
                          foregroundColor: theme.colorScheme.primaryContainer,
                          child: const Icon(Icons.photo_outlined),
                        ),
                        title: Text(L10n.of(context).sendImage),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'video',
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.onPrimaryContainer,
                          foregroundColor: theme.colorScheme.primaryContainer,
                          child: const Icon(Icons.video_camera_back_outlined),
                        ),
                        title: Text(L10n.of(context).sendVideo),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'file',
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.onPrimaryContainer,
                          foregroundColor: theme.colorScheme.primaryContainer,
                          child: const Icon(Icons.attachment_outlined),
                        ),
                        title: Text(L10n.of(context).sendFile),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ],
                ),
              ),
              if (PlatformInfos.isMobile)
                AnimatedContainer(
                  duration: FluffyThemes.animationDuration,
                  curve: FluffyThemes.animationCurve,
                  width: controller.sendController.text.isNotEmpty ? 0 : height,
                  height: height,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(),
                  clipBehavior: Clip.hardEdge,
                  child: PopupMenuButton(
                    useRootNavigator: true,
                    icon: const Icon(Icons.camera_alt_outlined),
                    onSelected: controller.onAddPopupMenuButtonSelected,
                    iconColor: theme.colorScheme.onPrimaryContainer,
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'camera-video',
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.onPrimaryContainer,
                            foregroundColor: theme.colorScheme.primaryContainer,
                            child: const Icon(Icons.videocam_outlined),
                          ),
                          title: Text(L10n.of(context).recordAVideo),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'camera',
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.onPrimaryContainer,
                            foregroundColor: theme.colorScheme.primaryContainer,
                            child: const Icon(Icons.camera_alt_outlined),
                          ),
                          title: Text(L10n.of(context).takeAPhoto),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                height: height,
                width: height,
                alignment: Alignment.center,
                child: IconButton(
                  tooltip: L10n.of(context).emojis,
                  color: theme.colorScheme.onPrimaryContainer,
                  icon: PageTransitionSwitcher(
                    transitionBuilder: (
                      Widget child,
                      Animation<double> primaryAnimation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return SharedAxisTransition(
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.scaled,
                        fillColor: Colors.transparent,
                        child: child,
                      );
                    },
                    child: Icon(
                      controller.showEmojiPicker
                          ? Icons.keyboard
                          : Icons.add_reaction_outlined,
                      key: ValueKey(controller.showEmojiPicker),
                    ),
                  ),
                  onPressed: controller.emojiPickerAction,
                ),
              ),
              if (Matrix.of(context).isMultiAccount &&
                  Matrix.of(context).hasComplexBundles &&
                  Matrix.of(context).currentBundle!.length > 1)
                Container(
                  width: height,
                  height: height,
                  alignment: Alignment.center,
                  child: _ChatAccountPicker(controller),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: InputBar(
                    room: controller.room,
                    minLines: 1,
                    maxLines: 8,
                    autofocus: !PlatformInfos.isMobile,
                    keyboardType: TextInputType.multiline,
                    textInputAction:
                        AppConfig.sendOnEnter == true && PlatformInfos.isMobile
                            ? TextInputAction.send
                            : null,
                    onSubmitted: controller.onInputBarSubmitted,
                    onSubmitImage: controller.sendImageFromClipBoard,
                    focusNode: controller.inputFocus,
                    controller: controller.sendController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 6.0,
                        right: 6.0,
                        bottom: 6.0,
                        top: 3.0,
                      ),
                      counter: const SizedBox.shrink(),
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
              Container(
                height: height,
                width: height,
                alignment: Alignment.center,
                child: PlatformInfos.platformCanRecord &&
                        controller.sendController.text.isEmpty
                    ? FloatingActionButton.small(
                        tooltip: L10n.of(context).voiceMessage,
                        onPressed: controller.voiceMessageAction,
                        elevation: 0,
                        heroTag: null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(height),
                        ),
                        backgroundColor: theme.bubbleColor,
                        foregroundColor: theme.onBubbleColor,
                        child: const Icon(Icons.mic_none_outlined),
                      )
                    : FloatingActionButton.small(
                        tooltip: L10n.of(context).send,
                        onPressed: controller.send,
                        elevation: 0,
                        heroTag: null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(height),
                        ),
                        backgroundColor: theme.bubbleColor,
                        foregroundColor: theme.onBubbleColor,
                        child: const Icon(Icons.send_outlined),
                      ),
              ),
            ],
    );
  }
}

class _ChatAccountPicker extends StatelessWidget {
  final ChatController controller;

  const _ChatAccountPicker(this.controller);

  void _popupMenuButtonSelected(String mxid, BuildContext context) {
    final client = Matrix.of(context)
        .currentBundle!
        .firstWhere((cl) => cl!.userID == mxid, orElse: () => null);
    if (client == null) {
      Logs().w('Attempted to switch to a non-existing client $mxid');
      return;
    }
    controller.setSendingClient(client);
  }

  @override
  Widget build(BuildContext context) {
    final clients = controller.currentRoomBundle;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<Profile>(
        future: controller.sendingClient.fetchOwnProfile(),
        builder: (context, snapshot) => PopupMenuButton<String>(
          useRootNavigator: true,
          onSelected: (mxid) => _popupMenuButtonSelected(mxid, context),
          itemBuilder: (BuildContext context) => clients
              .map(
                (client) => PopupMenuItem<String>(
                  value: client!.userID,
                  child: FutureBuilder<Profile>(
                    future: client.fetchOwnProfile(),
                    builder: (context, snapshot) => ListTile(
                      leading: Avatar(
                        mxContent: snapshot.data?.avatarUrl,
                        name: snapshot.data?.displayName ??
                            client.userID!.localpart,
                        size: 20,
                      ),
                      title: Text(snapshot.data?.displayName ?? client.userID!),
                      contentPadding: const EdgeInsets.all(0),
                    ),
                  ),
                ),
              )
              .toList(),
          child: Avatar(
            mxContent: snapshot.data?.avatarUrl,
            name: snapshot.data?.displayName ??
                Matrix.of(context).client.userID!.localpart,
            size: 20,
          ),
        ),
      ),
    );
  }
}
