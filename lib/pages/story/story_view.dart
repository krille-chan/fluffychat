//@dart=2.12

import 'package:flutter/material.dart';

import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:video_player/video_player.dart';

import 'package:fluffychat/pages/story/story_page.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/string_color.dart';

class StoryView extends StatelessWidget {
  final StoryPageController controller;
  const StoryView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<List<Event>>(
        future: controller.loadStory,
        builder: (context, snapshot) {
          final error = snapshot.error;
          if (error != null) {
            return Center(child: Text(error.toLocalizedString(context)));
          }
          final events = snapshot.data;
          if (events == null) {
            return const Center(
                child: CircularProgressIndicator.adaptive(
              strokeWidth: 2,
            ));
          }
          if (events.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                L10n.of(context)!.thisUserHasNotPostedAnythingYet,
                textAlign: TextAlign.center,
              )),
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
                        return Image.memory(
                          matrixFile.bytes,
                          fit: BoxFit.cover,
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
                              backgroundColor,
                              backgroundColorDark,
                              backgroundColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    controller.loadingMode
                        ? L10n.of(context)!.loadingPleaseWait
                        : event.content.tryGet<String>('body') ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      backgroundColor: event.messageType == MessageTypes.Text
                          ? null
                          : Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < events.length; i++)
                        Container(
                          margin: const EdgeInsets.all(4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            color: i == controller.index
                                ? Colors.white
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: LinearProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      value: controller.loadingMode
                          ? null
                          : controller.progress.inMilliseconds /
                              StoryPageController.maxProgress.inMilliseconds,
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
