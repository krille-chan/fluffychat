import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/client_download_content_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;

class MxcImage extends StatefulWidget {
  final Uri? uri;
  final Event? event;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isThumbnail;
  final bool animated;
  final Duration retryDuration;
  final Duration animationDuration;
  final Curve animationCurve;
  final ThumbnailMethod thumbnailMethod;
  final Widget Function(BuildContext context)? placeholder;
  final String? cacheKey;
  final Client? client;

  const MxcImage({
    this.uri,
    this.event,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.isThumbnail = true,
    this.animated = false,
    this.animationDuration = FluffyThemes.animationDuration,
    this.retryDuration = const Duration(seconds: 2),
    this.animationCurve = FluffyThemes.animationCurve,
    this.thumbnailMethod = ThumbnailMethod.scale,
    this.cacheKey,
    this.client,
    super.key,
  });

  @override
  State<MxcImage> createState() => _MxcImageState();
}

class _MxcImageState extends State<MxcImage> {
  static final Map<String, Uint8List> _imageDataCache = {};
  Uint8List? _imageDataNoCache;

  Uint8List? get _imageData => widget.cacheKey == null
      ? _imageDataNoCache
      : _imageDataCache[widget.cacheKey];

  set _imageData(Uint8List? data) {
    if (data == null) return;
    final cacheKey = widget.cacheKey;
    if (cacheKey == null) {
      _imageDataNoCache = data;
    } else {
      _imageDataCache[cacheKey] = data;
    }
  }

  Future<Uint8List> _fixExifOrientation(Uint8List data) async {
    try {

      final image = img.decodeImage(data);
      if (image == null) return data;

      // Read EXIF data
      final Map<String, IfdTag> exifData = await readExifFromBytes(data);
      final orientationValue =
          exifData['Image Orientation']?.values?.first?.toInt() ?? 1;

      img.Image fixedImage;

      switch (orientationValue) {
        case 1:
          // No rotation
          fixedImage = image;
          break;
        case 2:
          // Horizontal flip
          fixedImage = img.flipHorizontal(image);
          break;
        case 3:
          // Rotate 180
          fixedImage = img.copyRotate(image, 180);
          break;
        case 4:
          // Vertical flip
          fixedImage = img.flipVertical(image);
          break;
        case 5:
          // Vertical flip + 90 rotate right
          fixedImage = img.copyRotate(img.flipVertical(image), 90);
          break;
        case 6:
          // Rotate 90
          fixedImage = img.copyRotate(image, 90);
          break;
        case 7:
          // Horizontal flip + 90 rotate right
          fixedImage = img.copyRotate(img.flipHorizontal(image), 90);
          break;
        case 8:
          // Rotate 270
          fixedImage = img.copyRotate(image, -90);
          break;
        default:
          // Unknown orientation
          fixedImage = image;
          break;
      }

      // Encode the fixed image back to Uint8List
      return Uint8List.fromList(img.encodeJpg(fixedImage));
    } catch (e) {
      // If there's an error, return the original data
      return data;
    }
  }

  Future<void> _load() async {
    final client =
        widget.client ?? widget.event?.room.client ?? Matrix.of(context).client;
    final uri = widget.uri;
    final event = widget.event;

    if (uri != null) {
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      final width = widget.width;
      final realWidth = width == null ? null : width * devicePixelRatio;
      final height = widget.height;
      final realHeight = height == null ? null : height * devicePixelRatio;

      final remoteData = await client.downloadMxcCached(
        uri,
        width: realWidth,
        height: realHeight,
        thumbnailMethod: widget.thumbnailMethod,
        isThumbnail: widget.isThumbnail,
        animated: widget.animated,
      );

      final adjustedData = await _fixExifOrientation(remoteData);

      if (!mounted) return;
      setState(() {
        _imageData = adjustedData;
      });
    }

    if (event != null) {
      final data = await event.downloadAndDecryptAttachment(
        getThumbnail: widget.isThumbnail,
      );
      if (data.detectFileType is MatrixImageFile) {
        
        final adjustedData = await _fixExifOrientation(data.bytes);

        if (!mounted) return;
        setState(() {
          _imageData = adjustedData;
        });
        return;
      }
    }
  }

  void _tryLoad(_) => tryLoad();

  void tryLoad() async {
    if (_imageData != null) {
      return;
    }
    try {
      await _load();
    } on IOException catch (_) {
      if (!mounted) return;
      await Future.delayed(widget.retryDuration);
      tryLoad();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_tryLoad);
  }

  Widget placeholder(BuildContext context) => widget.placeholder?.call(context) ??
      Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
      );

  @override
  Widget build(BuildContext context) {
    final data = _imageData;
    final hasData = data != null && data.isNotEmpty;

    return AnimatedCrossFade(
      crossFadeState:
          hasData ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 128),
      firstChild: placeholder(context),
      secondChild: hasData
          ? Image.memory(
              data!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              filterQuality:
                  widget.isThumbnail ? FilterQuality.low : FilterQuality.medium,
              errorBuilder: (context, __, ___) {
                _imageData = null;
                WidgetsBinding.instance.addPostFrameCallback(_tryLoad);
                return placeholder(context);
              },
            )
          : SizedBox(
              width: widget.width,
              height: widget.height,
            ),
    );
  }
}
