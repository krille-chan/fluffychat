import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/image_viewer/image_viewer.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import '../../../widgets/blur_hash.dart';

class ImageBubble extends StatefulWidget {
  final Event event;
  final bool tapToView;
  final BoxFit fit;
  final bool maxSize;
  final Color? backgroundColor;
  final bool thumbnailOnly;
  final bool animated;
  final double? width;
  final double? height;
  final void Function()? onTap;
  final BorderRadius? borderRadius;
  final Duration retryDuration;
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
    this.retryDuration = const Duration(seconds: 2),
    super.key,
  });

  @override
  State<ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  Uint8List? _imageData;

  Future<void> _load() async {
    final data = await widget.event.downloadAndDecryptAttachment(
      getThumbnail: widget.thumbnailOnly,
    );
    if (data.detectFileType is MatrixImageFile) {
      if (!mounted) return;
      setState(() {
        _imageData = data.bytes;
      });
      return;
    }
  }

  void _tryLoad([_]) async {
    if (_imageData != null) {
      return;
    }
    try {
      await _load();
    } catch (_) {
      if (!mounted) return;
      await Future.delayed(widget.retryDuration);
      _tryLoad();
    }
  }

  @override
  void initState() {
    super.initState();
    _tryLoad();
  }

  Widget _buildPlaceholder(BuildContext context) {
    final width = widget.width;
    final height = widget.height;
    if (width == null || height == null) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
        ),
      );
    }
    final String blurHashString =
        widget.event.infoMap['xyz.amorgan.blurhash'] is String
            ? widget.event.infoMap['xyz.amorgan.blurhash']
            : 'LEHV6nWB2yk8pyo0adR*.7kCMdnj';

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: BlurHash(
        blurhash: blurHashString,
        width: width,
        height: height,
        fit: widget.fit,
      ),
    );
  }

  void _onTap(BuildContext context) {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    if (!widget.tapToView) return;
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => ImageViewer(widget.event),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        widget.borderRadius ?? BorderRadius.circular(AppConfig.borderRadius);
    final data = _imageData;
    final hasData = data != null;
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: widget.event.messageType == MessageTypes.Sticker
              ? Colors.transparent
              : Theme.of(context).dividerColor,
        ),
      ),
      child: InkWell(
        onTap: () => _onTap(context),
        borderRadius: borderRadius,
        child: Hero(
          tag: widget.event.eventId,
          child: AnimatedCrossFade(
            crossFadeState:
                hasData ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: FluffyThemes.animationDuration,
            firstChild: _buildPlaceholder(context),
            secondChild: hasData
                ? Image.memory(
                    data,
                    width: widget.width,
                    height: widget.height,
                    fit: widget.fit,
                    filterQuality: widget.thumbnailOnly
                        ? FilterQuality.low
                        : FilterQuality.medium,
                    errorBuilder: (context, __, ___) {
                      _imageData = null;
                      WidgetsBinding.instance.addPostFrameCallback(_tryLoad);
                      return _buildPlaceholder(context);
                    },
                  )
                : SizedBox(
                    width: widget.width,
                    height: widget.height,
                  ),
          ),
        ),
      ),
    );
  }
}
