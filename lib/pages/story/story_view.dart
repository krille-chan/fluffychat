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

  static const List<Shadow> textShadows = [
    Shadow(
      color: Colors.black,
      offset: Offset(5, 5),
      blurRadius: 20,
    ),
    Shadow(
      color: Colors.black,
      offset: Offset(5, 5),
      blurRadius: 20,
    ),
    Shadow(
      color: Colors.black,
      offset: Offset(-5, -5),
      blurRadius: 20,
    ),
    Shadow(
      color: Colors.black,
      offset: Offset(-5, -5),
      blurRadius: 20,
    ),
  ];

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
        title: ListTile(
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
        actions: currentEvent == null
            ? null
            : [
                if (!controller.isOwnStory)
                  IconButton(
                    icon: Icon(Icons.adaptive.share_outlined),
                    onPressed: controller.share,
                  ),
                PopupMenuButton<PopupStoryAction>(
                  onSelected: controller.onPopupStoryAction,
                  itemBuilder: (context) => [
                    if (controller.currentEvent?.canRedact ?? false)
                      PopupMenuItem(
                        value: PopupStoryAction.delete,
                        child: Text(L10n.of(context)!.delete),
                      ),
                    PopupMenuItem(
                      value: PopupStoryAction.report,
                      child: Text(L10n.of(context)!.reportMessage),
                    ),
                    if (!controller.isOwnStory)
                      PopupMenuItem(
                        value: PopupStoryAction.message,
                        child: Text(L10n.of(context)!.sendAMessage),
                      ),
                  ],
                ),
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
          final backgroundColor = controller.storyThemeData.color1 ??
              event.content.tryGet<String>('body')?.color ??
              Theme.of(context).primaryColor;
          final backgroundColorDark = controller.storyThemeData.color2 ??
              event.content.tryGet<String>('body')?.darkColor ??
              Theme.of(context).primaryColorDark;
          if (event.messageType == MessageTypes.Text) {
            controller.loadingModeOff();
          }
          final hash = event.infoMap['xyz.amorgan.blurhash'];
          return Stack(
            children: [
              if (hash is String)
                BlurHash(
                  hash: hash,
                  imageFit: BoxFit.cover,
                ),
              if ({MessageTypes.Video, MessageTypes.Audio}
                      .contains(event.messageType) &&
                  PlatformInfos.isMobile)
                Positioned(
                  top: 80,
                  bottom: 64,
                  left: 0,
                  right: 0,
                  child: FutureBuilder<VideoPlayerController?>(
                    future: controller.loadVideoControllerFuture ??=
                        controller.loadVideoController(event),
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
                ),
              if (event.messageType == MessageTypes.Image ||
                  (event.messageType == MessageTypes.Video &&
                      !PlatformInfos.isMobile))
                FutureBuilder<MatrixFile>(
                  future: controller.downloadAndDecryptAttachment(
                      event, event.messageType == MessageTypes.Video),
                  builder: (context, snapshot) {
                    final matrixFile = snapshot.data;
                    if (matrixFile == null) {
                      controller.loadingModeOn();
                      return Container();
                    }
                    controller.loadingModeOff();
                    return Container(
                      constraints: const BoxConstraints.expand(),
                      alignment: controller.storyThemeData.fit == BoxFit.cover
                          ? null
                          : Alignment.center,
                      child: Image.memory(
                        matrixFile.bytes,
                        fit: controller.storyThemeData.fit,
                      ),
                    );
                  },
                ),
              GestureDetector(
                onTapDown: controller.hold,
                onTapUp: controller.unhold,
                onTapCancel: controller.unhold,
                onVerticalDragStart: controller.hold,
                onVerticalDragEnd: controller.unhold,
                onHorizontalDragStart: controller.hold,
                onHorizontalDragEnd: controller.unhold,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16.0),
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
                  alignment: Alignment(
                    controller.storyThemeData.alignmentX.toDouble() / 100,
                    controller.storyThemeData.alignmentY.toDouble() / 100,
                  ),
                  child: SafeArea(
                    child: LinkText(
                      text: controller.loadingMode
                          ? L10n.of(context)!.loadingPleaseWait
                          : event.content.tryGet<String>('body') ?? '',
                      textAlign: TextAlign.center,
                      onLinkTap: (url) => UrlLauncher(context, url).launchUrl(),
                      linkStyle: TextStyle(
                        fontSize: 24,
                        color: Colors.blue.shade50,
                        decoration: TextDecoration.underline,
                        shadows: event.messageType == MessageTypes.Text
                            ? null
                            : textShadows,
                      ),
                      textStyle: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        shadows: event.messageType == MessageTypes.Text
                            ? null
                            : textShadows,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                left: 4,
                right: 4,
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
              if (!controller.isOwnStory && currentEvent != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: SafeArea(
                    child: TextField(
                      focusNode: controller.replyFocus,
                      controller: controller.replyController,
                      onSubmitted: controller.replyAction,
                      textInputAction: TextInputAction.send,
                      readOnly: controller.replyLoading,
                      decoration: InputDecoration(
                        hintText: L10n.of(context)!.reply,
                        prefixIcon: IconButton(
                          onPressed: controller.replyEmojiAction,
                          icon: const Icon(Icons.emoji_emotions_outlined),
                        ),
                        suffixIcon: controller.replyLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: Center(
                                  child: CircularProgressIndicator.adaptive(
                                      strokeWidth: 2),
                                ),
                              )
                            : IconButton(
                                onPressed: controller.replyAction,
                                icon: const Icon(Icons.send_outlined),
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
                  child: SafeArea(
                    child: Center(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                        ),
                        onPressed: controller.displaySeenByUsers,
                        icon: const Icon(Icons.visibility_outlined),
                        label: Text(controller.seenByUsersTitle),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
