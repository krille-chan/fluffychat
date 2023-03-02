import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

import 'package:fluffychat/pages/chat/events/image_bubble.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';

class EventVideoPlayer extends StatefulWidget {
  final Event event;
  const EventVideoPlayer(this.event, {Key? key}) : super(key: key);

  @override
  EventVideoPlayerState createState() => EventVideoPlayerState();
}

class EventVideoPlayerState extends State<EventVideoPlayer> {
  ChewieController? _chewieManager;
  bool _isDownloading = false;
  String? _networkUri;
  File? _tmpFile;

  void _downloadAction() async {
    setState(() => _isDownloading = true);
    try {
      final videoFile = await widget.event.downloadAndDecryptAttachment();
      if (kIsWeb) {
        final blob = html.Blob([videoFile.bytes]);
        _networkUri = html.Url.createObjectUrlFromBlob(blob);
      } else {
        final tempDir = await getTemporaryDirectory();
        final fileName = Uri.encodeComponent(
          widget.event.attachmentOrThumbnailMxcUrl()!.pathSegments.last,
        );
        final file = File('${tempDir.path}/${fileName}_${videoFile.name}');
        if (await file.exists() == false) {
          await file.writeAsBytes(videoFile.bytes);
        }
        _tmpFile = file;
      }
      final tmpFile = _tmpFile;
      final networkUri = _networkUri;
      if (kIsWeb && networkUri != null && _chewieManager == null) {
        _chewieManager ??= ChewieController(
          videoPlayerController: VideoPlayerController.network(networkUri),
          autoPlay: true,
          autoInitialize: true,
        );
      } else if (!kIsWeb && tmpFile != null && _chewieManager == null) {
        _chewieManager ??= ChewieController(
          videoPlayerController: VideoPlayerController.file(tmpFile),
          autoPlay: true,
          autoInitialize: true,
        );
      }
    } on MatrixConnectionException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toLocalizedString(context)),
        ),
      );
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toLocalizedString(context)),
        ),
      );
      Logs().w('Error while playing video', e, s);
    } finally {
      // Workaround for Chewie needs time to get the aspectRatio
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() => _isDownloading = false);
    }
  }

  @override
  void dispose() {
    _chewieManager?.dispose();
    super.dispose();
  }

  static const String fallbackBlurHash = 'L5H2EC=PM+yV0g-mq.wG9c010J}I';

  @override
  Widget build(BuildContext context) {
    final hasThumbnail = widget.event.hasThumbnail;
    final blurHash = (widget.event.infoMap as Map<String, dynamic>)
            .tryGet<String>('xyz.amorgan.blurhash') ??
        fallbackBlurHash;

    final chewieManager = _chewieManager;
    return Material(
      color: Colors.black,
      child: SizedBox(
        height: 300,
        child: chewieManager != null
            ? Center(child: Chewie(controller: chewieManager))
            : Stack(
                children: [
                  if (hasThumbnail)
                    Center(
                      child: ImageBubble(
                        widget.event,
                        tapToView: false,
                      ),
                    )
                  else
                    BlurHash(hash: blurHash),
                  Center(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                      icon: _isDownloading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.download_outlined),
                      label: Text(
                        _isDownloading
                            ? L10n.of(context)!.loadingPleaseWait
                            : L10n.of(context)!.videoWithSize(
                                widget.event.sizeString ?? '?MB',
                              ),
                      ),
                      onPressed: _isDownloading ? null : _downloadAction,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
