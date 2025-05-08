import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/image_bubble.dart';
import 'package:fluffychat/utils/file_description.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/blur_hash.dart';
import '../../../utils/error_reporter.dart';

class EventVideoPlayer extends StatefulWidget {
  final Event event;
  final Color? textColor;
  final Color? linkColor;
  // #Pangea
  final ChatController? chatController;
  // Pangea#
  const EventVideoPlayer(
    this.event, {
    this.textColor,
    this.linkColor,
    // #Pangea
    this.chatController,
    // Pangea#
    super.key,
  });

  @override
  EventVideoPlayerState createState() => EventVideoPlayerState();
}

class EventVideoPlayerState extends State<EventVideoPlayer> {
  ChewieController? _chewieManager;
  bool _isDownloading = false;
  String? _networkUri;
  File? _tmpFile;

  // #Pangea
  StreamSubscription? _stopVideoSubscription;

  @override
  initState() {
    _stopVideoSubscription = widget.chatController?.stopMediaStream.stream
        .listen((_) => _chewieManager?.pause());
    super.initState();
  }
  // Pangea#

  void _downloadAction() async {
    if (PlatformInfos.isDesktop) {
      widget.event.saveFile(context);
      return;
    }
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
          videoPlayerController:
              VideoPlayerController.networkUrl(Uri.parse(networkUri)),
          autoPlay: true,
          autoInitialize: true,
        );
      } else if (!kIsWeb && tmpFile != null && _chewieManager == null) {
        _chewieManager ??= ChewieController(
          useRootNavigator: false,
          videoPlayerController: VideoPlayerController.file(tmpFile),
          autoPlay: true,
          autoInitialize: true,
        );
      }
    } on IOException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toLocalizedString(context)),
        ),
      );
    } catch (e, s) {
      ErrorReporter(context, 'Unable to play video').onErrorCallback(e, s);
    } finally {
      // Workaround for Chewie needs time to get the aspectRatio
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() => _isDownloading = false);
    }
  }

  @override
  void dispose() {
    _chewieManager?.dispose();
    // #Pangea
    _stopVideoSubscription?.cancel();
    // Pangea#
    super.dispose();
  }

  static const String fallbackBlurHash = 'L5H2EC=PM+yV0g-mq.wG9c010J}I';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasThumbnail = widget.event.hasThumbnail;
    final blurHash = (widget.event.infoMap as Map<String, dynamic>)
            .tryGet<String>('xyz.amorgan.blurhash') ??
        fallbackBlurHash;
    final fileDescription = widget.event.fileDescription;
    final textColor = widget.textColor;
    final linkColor = widget.linkColor;

    const width = 300.0;

    final chewieManager = _chewieManager;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Material(
          color: Colors.black,
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          child: SizedBox(
            height: width,
            child: chewieManager != null
                ? Center(child: Chewie(controller: chewieManager))
                : Stack(
                    children: [
                      if (hasThumbnail)
                        Center(
                          child: ImageBubble(
                            widget.event,
                            tapToView: false,
                            textColor: widget.textColor,
                          ),
                        )
                      else
                        BlurHash(
                          blurhash: blurHash,
                          width: width,
                          height: width,
                        ),
                      Center(
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                          ),
                          icon: _isDownloading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.play_circle_outlined),
                          tooltip: _isDownloading
                              ? L10n.of(context).loadingPleaseWait
                              : L10n.of(context).videoWithSize(
                                  widget.event.sizeString ?? '?MB',
                                ),
                          onPressed: _isDownloading ? null : _downloadAction,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (fileDescription != null && textColor != null && linkColor != null)
          SizedBox(
            width: width,
            child: Linkify(
              text: fileDescription,
              style: TextStyle(
                color: textColor,
                fontSize: AppConfig.fontSizeFactor * AppConfig.messageFontSize,
              ),
              options: const LinkifyOptions(humanize: false),
              linkStyle: TextStyle(
                color: linkColor,
                fontSize: AppConfig.fontSizeFactor * AppConfig.messageFontSize,
                decoration: TextDecoration.underline,
                decorationColor: linkColor,
              ),
              onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
            ),
          ),
      ],
    );
  }
}
