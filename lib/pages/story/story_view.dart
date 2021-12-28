//@dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_link_text/link_text.dart';
import 'package:video_player/video_player.dart';

import 'package:fluffychat/pages/story/story_page.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/avatar.dart';

class StoryView extends StatelessWidget {
  final StoryPageController controller;
  const StoryView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentEvent = controller.currentEvent;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(context).pop,
        ),
        title: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: controller.isHold ? 0 : 1,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              controller.title,
              style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(0, 0),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            subtitle: currentEvent != null
                ? Text(
                    currentEvent.originServerTs.localizedTime(context),
                    style: const TextStyle(
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(0, 0),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  )
                : null,
            leading: Avatar(
              mxContent: controller.avatar,
              name: controller.title,
            ),
          ),
        ),
        actions: [
          if (!controller.isOwnStory)
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: controller.isHold ? 0 : 1,
              child: IconButton(
                icon: Icon(Icons.adaptive.share_outlined),
                onPressed: controller.share,
              ),
            ),
          AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: controller.isHold ? 0 : 1,
              child: PopupMenuButton<PopupStoryAction>(
                onSelected: controller.onPopupStoryAction,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: PopupStoryAction.delete,
                    child: Text(L10n.of(context)!.delete),
                  ),
                  PopupMenuItem(
                    value: PopupStoryAction.report,
                    child: Text(L10n.of(context)!.reportMessage),
                  ),
                ],
              )),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: controller.loadStory,
        builder: (context, snapshot) {
          final error = snapshot.error;
          if (error != null) {
            return Center(child: Text(error.toLocalizedString(context)));
          }
          final events = controller.events;
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: CircularProgressIndicator.adaptive(
              strokeWidth: 2,
            ));
          }
          if (events.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Avatar(
                    mxContent: controller.avatar,
                    name: controller.title,
                    size: 128,
                    fontSize: 64,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    L10n.of(context)!.thisUserHasNotPostedAnythingYet,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
          final event = events[controller.index];
          final backgroundColor = event.content.tryGet<String>('body')?.color ??
              Theme.of(context).primaryColor;
          final backgroundColorDark =
              event.content.tryGet<String>('body')?.darkColor ??
                  Theme.of(context).primaryColorDark;
          if (event.messageType == MessageTypes.Text) {
            controller.loadingModeOff();
          }
          return GestureDetector(
            onTapDown: controller.hold,
            onTapUp: controller.unhold,
            child: Stack(
              children: [
                if (event.messageType == MessageTypes.Video &&
                    PlatformInfos.isMobile)
                  FutureBuilder<VideoPlayerController>(
                    future: controller.loadVideoController(event),
                    builder: (context, snapshot) {
                      final videoPlayerController = snapshot.data;
                      if (videoPlayerController == null) {
                        controller.loadingModeOn();
                        return Container();
                      }
                      controller.loadingModeOff();
                      return Center(child: VideoPlayer(videoPlayerController));
                    },
                  ),
                if (event.messageType == MessageTypes.Image ||
                    (event.messageType == MessageTypes.Video &&
                        !PlatformInfos.isMobile))
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FutureBuilder<MatrixFile>(
                      future: controller.downloadAndDecryptAttachment(
                          event, event.messageType == MessageTypes.Video),
                      builder: (context, snapshot) {
                        final matrixFile = snapshot.data;
                        if (matrixFile == null) {
                          controller.loadingModeOn();
                          final hash = event.infoMap['xyz.amorgan.blurhash'];
                          return hash is String
                              ? BlurHash(
                                  hash: hash,
                                  imageFit: BoxFit.cover,
                                )
                              : Container();
                        }
                        controller.loadingModeOff();
                        return Center(
                          child: Image.memory(
                            matrixFile.bytes,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    gradient: event.messageType == MessageTypes.Text
                        ? LinearGradient(
                            colors: [
                              backgroundColorDark,
                              backgroundColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      LinkText(
                        text: controller.loadingMode
                            ? L10n.of(context)!.loadingPleaseWait
                            : event.content.tryGet<String>('body') ?? '',
                        textAlign: TextAlign.center,
                        onLinkTap: (url) =>
                            UrlLauncher(context, url).launchUrl(),
                        linkStyle: TextStyle(
                          fontSize: 24,
                          color: Colors.blue.shade50,
                          decoration: TextDecoration.underline,
                          backgroundColor:
                              event.messageType == MessageTypes.Text
                                  ? null
                                  : Colors.black,
                        ),
                        textStyle: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          backgroundColor:
                              event.messageType == MessageTypes.Text
                                  ? null
                                  : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  right: 4,
                  child: AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: controller.isHold ? 0 : 1,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < events.length; i++)
                            Expanded(
                              child: i == controller.index
                                  ? LinearProgressIndicator(
                                      color: Colors.white,
                                      minHeight: 2,
                                      backgroundColor: Colors.grey.shade600,
                                      value: controller.loadingMode
                                          ? null
                                          : controller.progress.inMilliseconds /
                                              StoryPageController
                                                  .maxProgress.inMilliseconds,
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(4),
                                      height: 2,
                                      color: i < controller.index
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!controller.isOwnStory && currentEvent != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: controller.isHold ? 0 : 1,
                      child: SafeArea(
                        child: TextField(
                          focusNode: controller.replyFocus,
                          controller: controller.replyController,
                          minLines: 1,
                          maxLines: 7,
                          onSubmitted: controller.replyAction,
                          textInputAction: TextInputAction.newline,
                          readOnly: controller.replyLoading,
                          decoration: InputDecoration(
                            hintText: L10n.of(context)!.reply,
                            prefixIcon: IconButton(
                              onPressed: controller.replyEmojiAction,
                              icon: const Icon(Icons.emoji_emotions_outlined),
                            ),
                            suffixIcon: controller.replyLoading
                                ? const CircularProgressIndicator.adaptive(
                                    strokeWidth: 2)
                                : IconButton(
                                    onPressed: controller.replyAction,
                                    icon: const Icon(Icons.send_outlined),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (controller.isOwnStory &&
                    controller.currentSeenByUsers.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: controller.isHold ? 0 : 1,
                      child: SafeArea(
                        child: Center(
                          child: OutlinedButton.icon(
                            onPressed: controller.displaySeenByUsers,
                            icon: const Icon(
                              Icons.visibility_outlined,
                              color: Colors.white70,
                            ),
                            label: Text(
                              controller.seenByUsersTitle,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
