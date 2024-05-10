import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/image_viewer/image_viewer.dart';
import 'package:fluffychat/widgets/mxc_image.dart';
import '../../../widgets/blur_hash.dart';

class ImageBubble extends StatelessWidget {
  final Event event;
  final bool tapToView;
  final BoxFit fit;
  final bool maxSize;
  final Color? backgroundColor;
  final bool thumbnailOnly;
  final bool animated;
  final double width;
  final double height;
  final void Function()? onTap;
  final BorderRadius? borderRadius;

  const ImageBubble(
    this.event, {
    this.tapToView = true,
    this.maxSize = true,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.thumbnailOnly = true,
    this.width = 400,
    this.height = 300,
    this.animated = false,
    this.onTap,
    this.borderRadius,
    super.key,
  });

  Widget _buildPlaceholder(BuildContext context) {
    final String blurHashString =
        event.infoMap['xyz.amorgan.blurhash'] is String
            ? event.infoMap['xyz.amorgan.blurhash']
            : 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';
    return SizedBox(
      width: width,
      height: height,
      child: BlurHash(
        blurhash: blurHashString,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }

  void _onTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }
    if (!tapToView) return;
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => ImageViewer(event),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        this.borderRadius ?? BorderRadius.circular(AppConfig.borderRadius);
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: event.messageType == MessageTypes.Sticker
              ? Colors.transparent
              : Theme.of(context).dividerColor,
        ),
      ),
      child: InkWell(
        onTap: () => _onTap(context),
        borderRadius: borderRadius,
        child: Hero(
          tag: event.eventId,
          child: MxcImage(
            event: event,
            width: width,
            height: height,
            fit: fit,
            animated: animated,
            isThumbnail: thumbnailOnly,
            placeholder: event.messageType == MessageTypes.Sticker
                ? null
                : _buildPlaceholder,
          ),
        ),
      ),
    );
  }
}
