import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';

import '../utils/matrix_sdk_extensions.dart/event_extension.dart';
import '../utils/platform_infos.dart';
import '../widgets/matrix.dart';
import 'views/video_viewer_view.dart';

class VideoViewer extends StatefulWidget {
  final Event event;

  const VideoViewer(this.event, {Key key}) : super(key: key);

  @override
  VideoViewerController createState() => VideoViewerController();
}

class VideoViewerController extends State<VideoViewer> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  dynamic error;

  @override
  void initState() {
    super.initState();
    (() async {
      try {
        if (widget.event.content['file'] is Map) {
          if (PlatformInfos.isWeb) {
            throw 'Encrypted videos unavailable in web';
          }
          final tempDirectory = (await getTemporaryDirectory()).path;
          final mxcUri = widget.event.content
              .tryGet<Map<String, dynamic>>('file')
              ?.tryGet<String>('url');
          if (mxcUri == null) {
            throw 'No mxc uri found';
          }
          // somehow the video viewer doesn't like the uri-encoded slashes, so we'll just gonna replace them with hyphons
          final file = File(
              '$tempDirectory/videos/${mxcUri.replaceAll(':', '').replaceAll('/', '-')}');
          if (await file.exists() == false) {
            final matrixFile =
                await widget.event.downloadAndDecryptAttachmentCached();
            await file.create(recursive: true);
            await file.writeAsBytes(matrixFile.bytes);
          }
          videoPlayerController = VideoPlayerController.file(file);
        } else if (widget.event.content['url'] is String) {
          videoPlayerController = VideoPlayerController.network(
              widget.event.getAttachmentUrl()?.toString());
        } else {
          throw 'invalid event';
        }
        await videoPlayerController.initialize();

        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          looping: false,
        );
        setState(() => null);
      } catch (e) {
        setState(() => error = e);
      }
    })();
  }

  @override
  void dispose() {
    chewieController?.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  /// Forward this video to another room.
  void forwardAction() {
    Matrix.of(context).shareContent = widget.event.content;
    VRouter.of(context).to('/rooms');
  }

  /// Save this file with a system call.
  void saveFileAction() => widget.event.saveFile(context);

  @override
  Widget build(BuildContext context) => VideoViewerView(this);
}
