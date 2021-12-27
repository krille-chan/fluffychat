//@dart=2.12

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

import 'package:fluffychat/pages/chat/events/image_bubble.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/event_extension.dart';
import 'package:fluffychat/utils/sentry_controller.dart';

class EventVideoPlayer extends StatefulWidget {
  final Event event;
  const EventVideoPlayer(this.event, {Key? key}) : super(key: key);

  @override
  _EventVideoPlayerState createState() => _EventVideoPlayerState();
}

class _EventVideoPlayerState extends State<EventVideoPlayer> {
  FlickManager? _flickManager;
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
        final tmpDir = await getTemporaryDirectory();
        final file = File(tmpDir.path + videoFile.name);
        if (await file.exists() == false) {
          await file.writeAsBytes(videoFile.bytes);
        }
        _tmpFile = file;
      }
    } on MatrixConnectionException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toLocalizedString(context)),
      ));
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toLocalizedString(context)),
      ));
      SentryController.captureException(e, s);
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  void dispose() {
    _flickManager?.dispose();
    super.dispose();
  }

  static const String fallbackBlurHash = 'L5H2EC=PM+yV0g-mq.wG9c010J}I';

  @override
  Widget build(BuildContext context) {
    final hasThumbnail = widget.event.hasThumbnail;
    final blurHash = (widget.event.infoMap as Map<String, dynamic>)
            .tryGet<String>('xyz.amorgan.blurhash') ??
        fallbackBlurHash;
    final videoFile = _tmpFile;
    final networkUri = _networkUri;
    if (kIsWeb && networkUri != null && _flickManager == null) {
      _flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(networkUri),
      );
    } else if (!kIsWeb && videoFile != null && _flickManager == null) {
      _flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.file(videoFile),
        autoPlay: true,
      );
    }

    final flickManager = _flickManager;
    return SizedBox(
      width: 400,
      height: 300,
      child: Stack(
        children: [
          if (flickManager == null) ...[
            if (hasThumbnail)
              ImageBubble(widget.event)
            else
              BlurHash(hash: blurHash),
            Center(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
                icon: _isDownloading
                    ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
                    : const Icon(Icons.download_outlined),
                label: Text(
                  L10n.of(context)!
                      .videoWithSize(widget.event.sizeString ?? '?MB'),
                ),
                onPressed: _isDownloading ? null : _downloadAction,
              ),
            ),
          ] else
            FlickVideoPlayer(flickManager: flickManager),
        ],
      ),
    );
  }
}
