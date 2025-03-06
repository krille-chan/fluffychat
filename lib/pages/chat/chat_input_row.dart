import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/choreographer/widgets/send_button.dart';
import 'package:fluffychat/pangea/choreographer/widgets/start_igc_button.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/reading_assistance_input_bar.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/utils/other_party_can_receive.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import '../../config/themes.dart';
import 'chat.dart';
import 'input_bar.dart';

class ChatInputRow extends StatelessWidget {
  final ChatController controller;
  // #Pangea
  final MessageOverlayController? overlayController;
  // Pangea#

  const ChatInputRow(
    this.controller, {
    // #Pangea
    this.overlayController,
    // Pangea#
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (controller.showEmojiPicker &&
        controller.emojiPickerType == EmojiPickerType.reaction) {
      return const SizedBox.shrink();
    }
    // #Pangea
    // const height = 48.0;
    const height = AppConfig.defaultFooterHeight;
    // Pangea#

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

    // #Pangea
    final activel1 =
        controller.pangeaController.languageController.activeL1Model();
    final activel2 =
        controller.pangeaController.languageController.activeL2Model();

    String hintText() {
      if (controller.choreographer.itController.willOpen) {
        return L10n.of(context).buildTranslation;
      }
      return activel1 != null &&
              activel2 != null &&
              activel1.langCode != LanguageKeys.unknownLanguage &&
              activel2.langCode != LanguageKeys.unknownLanguage
          ? L10n.of(context).writeAMessageLangCodes(
              activel1.langCodeShort.toUpperCase(),
              activel2.langCodeShort.toUpperCase(),
            )
          : L10n.of(context).writeAMessage;
    }

    return Column(
      children: [
        // if (!controller.selectMode) WritingAssistanceInputRow(controller),
        CompositedTransformTarget(
          link: controller.choreographer.inputLayerLinkAndKey.link,
          child: Row(
            key: overlayController != null
                ? null
                : controller.choreographer.inputLayerLinkAndKey.key,
            // crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            // Pangea#
            children: controller.selectMode
                ? <Widget>[
                    if (controller.selectedEvents
                        .every((event) => event.status == EventStatus.error))
                      SizedBox(
                        height: height,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                          ),
                          onPressed: controller.deleteErrorEventsAction,
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.delete),
                              Text(L10n.of(context).delete),
                            ],
                          ),
                        ),
                      ),
                    // #Pangea
                    // else
                    // SizedBox(
                    //   height: height,
                    //   child: TextButton(
                    //     onPressed: controller.forwardEventsAction,
                    //     child: Row(
                    //       children: <Widget>[
                    //         const Icon(Icons.keyboard_arrow_left_outlined),
                    //         Text(L10n.of(context).forward),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // controller.selectedEvents.length == 1
                    //     ? controller.selectedEvents.first
                    //             .getDisplayEvent(controller.timeline!)
                    //             .status
                    //             .isSent
                    //         ? SizedBox(
                    //             height: height,
                    //             child: TextButton(
                    //               onPressed: controller.replyAction,
                    //               child: Row(
                    //                 children: <Widget>[
                    //                   Text(L10n.of(context).reply),
                    //                   const Icon(Icons.keyboard_arrow_right),
                    //                 ],
                    //               ),
                    //             ),
                    //           )
                    //         : SizedBox(
                    //             height: height,
                    //             child: TextButton(
                    //               onPressed: controller.sendAgainAction,
                    //               child: Row(
                    //                 children: <Widget>[
                    //                   Text(L10n.of(context).tryToSendAgain),
                    //                   const SizedBox(width: 4),
                    //                   const Icon(Icons.send_outlined, size: 16),
                    //                 ],
                    //               ),
                    //             ),
                    //           )
                    //     : const SizedBox.shrink(),
                    if (controller.selectedEvents.first
                            .getDisplayEvent(controller.timeline!)
                            .status
                            .isSent &&
                        !controller.selectedEvents.every(
                          (event) => event.status == EventStatus.error,
                        ))
                      overlayController != null
                          ? ReadingAssistanceInputBar(
                              controller,
                              overlayController!,
                            )
                          : const SizedBox(height: height),
                    if (controller.selectedEvents.length == 1 &&
                        !controller.selectedEvents.first
                            .getDisplayEvent(controller.timeline!)
                            .status
                            .isSent)
                      SizedBox(
                        height: height,
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
                      ),
                    // Pangea#
                  ]
                : <Widget>[
                    const SizedBox(width: 4),
                    AnimatedContainer(
                      duration: FluffyThemes.animationDuration,
                      curve: FluffyThemes.animationCurve,
                      height: height,
                      width:
                          controller.sendController.text.isEmpty ? height : 0,
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.add_outlined),
                        onSelected: controller.onAddPopupMenuButtonSelected,
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
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
                          if (PlatformInfos.isMobile)
                            PopupMenuItem<String>(
                              value: 'camera-video',
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  child: Icon(Icons.videocam_outlined),
                                ),
                                title: Text(L10n.of(context).openVideoCamera),
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
                    // #Pangea
                    kIsWeb
                        ?
                        // Pangea#
                        Container(
                            height: height,
                            width: height,
                            alignment: Alignment.center,
                            child: IconButton(
                              tooltip: L10n.of(context).emojis,
                              icon: PageTransitionSwitcher(
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> primaryAnimation,
                                  Animation<double> secondaryAnimation,
                                ) {
                                  return SharedAxisTransition(
                                    animation: primaryAnimation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType:
                                        SharedAxisTransitionType.scaled,
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
                          )
                        // #Pangea
                        : const SizedBox.shrink(),
                    // if (Matrix.of(context).isMultiAccount &&
                    //     Matrix.of(context).hasComplexBundles &&
                    //     Matrix.of(context).currentBundle!.length > 1)
                    //   Container(
                    //     width: height,
                    //     height: height,
                    //     alignment: Alignment.center,
                    //     child: _ChatAccountPicker(controller),
                    //   ),
                    // Pangea#
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: InputBar(
                          room: controller.room,
                          minLines: 1,
                          maxLines: 8,
                          autofocus: !PlatformInfos.isMobile,
                          keyboardType: TextInputType.multiline,
                          // #Pangea
                          // textInputAction: AppConfig.sendOnEnter == true &&
                          textInputAction: AppConfig.sendOnEnter ??
                                  true &&
                                      // Pangea#
                                      PlatformInfos.isMobile
                              ? TextInputAction.send
                              : null,
                          // #Pangea
                          // onSubmitted: controller.onInputBarSubmitted,
                          onSubmitted: (String value) =>
                              controller.onInputBarSubmitted(value, context),
                          // Pangea#
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
                            // #Pangea
                            // hintText: L10n.of(context)!.writeAMessage,
                            hintText: hintText(),
                            disabledBorder: InputBorder.none,
                            // Pangea#
                            hintMaxLines: 1,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            filled: false,
                          ),
                          onChanged: controller.onInputBarChanged,
                        ),
                      ),
                    ),
                    // #Pangea
                    StartIGCButton(
                      controller: controller,
                    ),
                    // Pangea#
                    Container(
                      height: height,
                      width: height,
                      alignment: Alignment.center,
                      child: PlatformInfos.platformCanRecord &&
                              controller.sendController.text.isEmpty
                              // #Pangea
                              &&
                              !controller.choreographer.itController.willOpen
                          // Pangea#
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
                          // #Pangea
                          // : FloatingActionButton.small(
                          //     tooltip: L10n.of(context).send,
                          //     onPressed: controller.send,
                          //     elevation: 0,
                          //     heroTag: null,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(height),
                          //     ),
                          //     backgroundColor:
                          //         theme.colorScheme.onPrimaryContainer,
                          //     foregroundColor: theme.colorScheme.onPrimary,
                          //     child: const Icon(Icons.send_outlined),
                          //   ),
                          : ChoreographerSendButton(controller: controller),
                      // Pangea#
                    ),
                  ],
          ),
        ),
      ],
    );
  }
}

// #Pangea
// class _ChatAccountPicker extends StatelessWidget {
//   final ChatController controller;

//   const _ChatAccountPicker(this.controller);

//   void _popupMenuButtonSelected(String mxid, BuildContext context) {
//     final client = Matrix.of(context)
//         .currentBundle!
//         .firstWhere((cl) => cl!.userID == mxid, orElse: () => null);
//     if (client == null) {
//       Logs().w('Attempted to switch to a non-existing client $mxid');
//       return;
//     }
//     controller.setSendingClient(client);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final clients = controller.currentRoomBundle;
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: FutureBuilder<Profile>(
//         future: controller.sendingClient.fetchOwnProfile(),
//         builder: (context, snapshot) => PopupMenuButton<String>(
//           onSelected: (mxid) => _popupMenuButtonSelected(mxid, context),
//           itemBuilder: (BuildContext context) => clients
//               .map(
//                 (client) => PopupMenuItem<String>(
//                   value: client!.userID,
//                   child: FutureBuilder<Profile>(
//                     future: client.fetchOwnProfile(),
//                     builder: (context, snapshot) => ListTile(
//                       leading: Avatar(
//                         mxContent: snapshot.data?.avatarUrl,
//                         name: snapshot.data?.displayName ??
//                             client.userID!.localpart,
//                         size: 20,
//                       ),
//                       title: Text(snapshot.data?.displayName ?? client.userID!),
//                       contentPadding: const EdgeInsets.all(0),
//                     ),
//                   ),
//                 ),
//               )
//               .toList(),
//           child: Avatar(
//             mxContent: snapshot.data?.avatarUrl,
//             name: snapshot.data?.displayName ??
//                 Matrix.of(context).client.userID!.localpart,
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }
// }
// Pangea#
