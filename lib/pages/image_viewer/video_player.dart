import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/blur_hash.dart';
import '../../../utils/error_reporter.dart';
import '../../widgets/mxc_image.dart';

class EventVideoPlayer extends StatefulWidget {
  final Event event;

  const EventVideoPlayer(
    this.event, {
    super.key,
  });

  @override
  EventVideoPlayerState createState() => EventVideoPlayerState();
}

class EventVideoPlayerState extends State<EventVideoPlayer> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;

  // #Pangea
  Object? _error;

  bool get _supportedFormat {
    final infoMap = widget.event.content.tryGetMap<String, Object?>('info');
    final mimetype = infoMap?.tryGet<String>('mimetype');
    return PlatformInfos.isAndroid ? mimetype != "video/quicktime" : true;
  }
  // Pangea#

  // The video_player package only doesn't support Windows and Linux.
  // #Pangea
  // final _supportsVideoPlayer =
  //     !PlatformInfos.isWindows && !PlatformInfos.isLinux;
  bool get _supportsVideoPlayer => !PlatformInfos.isLinux && _supportedFormat;
  // Pangea#

  void _downloadAction() async {
    if (!_supportsVideoPlayer) {
      widget.event.saveFile(context);
      return;
    }

    try {
      // #Pangea
      setState(() => _error = null);
      // Pangea#
      final videoFile = await widget.event.downloadAndDecryptAttachment();

      // Dispose the controllers if we already have them.
      _disposeControllers();
      late VideoPlayerController videoPlayerController;

      // Create the VideoPlayerController from the contents of videoFile.
      if (kIsWeb) {
        final blob = html.Blob([videoFile.bytes]);
        final networkUri = Uri.parse(html.Url.createObjectUrlFromBlob(blob));
        videoPlayerController = VideoPlayerController.networkUrl(networkUri);
      } else {
        final tempDir = await getTemporaryDirectory();
        final fileName = Uri.encodeComponent(
          widget.event.attachmentOrThumbnailMxcUrl()!.pathSegments.last,
        );
        final file = File('${tempDir.path}/${fileName}_${videoFile.name}');
        if (await file.exists() == false) {
          await file.writeAsBytes(videoFile.bytes);
        }
        videoPlayerController = VideoPlayerController.file(file);
      }
      _videoPlayerController = videoPlayerController;

      await videoPlayerController.initialize();

      final infoMap = widget.event.content.tryGetMap<String, Object?>('info');
      final videoWidth = infoMap?.tryGet<int>('w') ?? 400;
      final videoHeight = infoMap?.tryGet<int>('h') ?? 300;

      // Create a ChewieController on top.
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          showControlsOnInitialize: false,
          autoPlay: true,
          autoInitialize: true,
          looping: true,
          aspectRatio: videoHeight == 0 ? null : videoWidth / videoHeight,
        );
      });
    } on IOException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toLocalizedString(context)),
        ),
      );
      // #Pangea
      setState(() => _error = e);
      // Pangea#
    } catch (e, s) {
      ErrorReporter(context, 'Unable to play video').onErrorCallback(e, s);
      // #Pangea
      setState(() => _error = e);
      // Pangea#
    }
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController = null;
    _videoPlayerController = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _downloadAction();
    });
  }

  static const String fallbackBlurHash = 'L5H2EC=PM+yV0g-mq.wG9c010J}I';

  @override
  Widget build(BuildContext context) {
    final hasThumbnail = widget.event.hasThumbnail;
    final blurHash = (widget.event.infoMap as Map<String, dynamic>)
            .tryGet<String>('xyz.amorgan.blurhash') ??
        fallbackBlurHash;
    final infoMap = widget.event.content.tryGetMap<String, Object?>('info');
    final videoWidth = infoMap?.tryGet<int>('w') ?? 400;
    final videoHeight = infoMap?.tryGet<int>('h') ?? 300;
    final height = MediaQuery.of(context).size.height - 52;
    final width = videoWidth * (height / videoHeight);

    final chewieController = _chewieController;
    return chewieController != null
        ? Center(
            child: SizedBox(
              width: width,
              height: height,
              child: Chewie(controller: chewieController),
            ),
          )
        : Stack(
            children: [
              Center(
                child: Hero(
                  tag: widget.event.eventId,
                  child: hasThumbnail
                      ? MxcImage(
                          event: widget.event,
                          isThumbnail: true,
                          width: width,
                          height: height,
                          fit: BoxFit.cover,
                          placeholder: (context) => BlurHash(
                            blurhash: blurHash,
                            width: width,
                            height: height,
                            fit: BoxFit.cover,
                          ),
                        )
                      : BlurHash(
                          blurhash: blurHash,
                          width: width,
                          height: height,
                        ),
                ),
              ),
              // #Pangea
              // const Center(child: CircularProgressIndicator.adaptive()),
              _error != null
                  ? Center(
                      child: Column(
                        spacing: 8.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            spacing: 8.0,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              Text(L10n.of(context).failedToPlayVideo),
                            ],
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withAlpha(200),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.download_outlined),
                            onPressed: () => widget.event.saveFile(context),
                            color: Colors.white,
                            tooltip: L10n.of(context).downloadFile,
                          ),
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator.adaptive()),
              // Pangea#
            ],
          );
  }
}
