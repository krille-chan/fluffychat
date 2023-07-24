import 'dart:async';
import 'dart:ui' as ui show Image;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/settings_chat/settings_chat.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'animated_emoji_plain_text.dart';

enum AnimationState { userDefined, forced, disabled }

class MxcImage extends StatefulWidget {
  final Uri? uri;
  final Event? event;
  final double? width;
  final double? height;
  final double? watermarkSize;
  final Color? watermarkColor;
  final bool forceAnimation;
  final bool disableTapHandler;
  final BoxFit? fit;
  final bool isThumbnail;
  final bool animated;
  final Duration retryDuration;
  final Duration animationDuration;
  final Curve animationCurve;
  final ThumbnailMethod thumbnailMethod;
  final Widget Function(BuildContext context)? placeholder;
  final String? cacheKey;

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
    this.watermarkSize,
    this.watermarkColor,
    this.forceAnimation = false,
    this.disableTapHandler = false,
    super.key,
  });

  @override
  State<MxcImage> createState() => _MxcImageState();
}

class _MxcImageState extends State<MxcImage> {
  static final Map<String, ImageFutureResponse> _imageDataCache = {};
  ImageFutureResponse? _imageDataNoCache;

  ImageFutureResponse? get _imageData {
    final cacheKey = widget.cacheKey;
    return cacheKey == null ? _imageDataNoCache : _imageDataCache[cacheKey];
  }

  /// asynchronously
  Future<ImageFutureResponse> removeImageAnimations(Uint8List data) async {
    final provider = MemoryImage(data);

    final codec = await instantiateImageCodecWithSize(
      await ImmutableBuffer.fromUint8List(data),
    );
    if (codec.frameCount > 1) {
      final frame = await codec.getNextFrame();
      return ThumbnailImageResponse(
        thumbnail: frame.image,
        imageProvider: provider,
      );
    } else {
      return ImageProviderFutureResponse(provider);
    }
  }

  Future<ImageFutureResponse> _renderImageFrame(Uint8List data) async {
    if (widget.forceAnimation ||
        (Matrix.of(context).client.autoplayAnimatedContent ?? !kIsWeb)) {
      return ImageProviderFutureResponse(MemoryImage(data));
    } else {
      return await removeImageAnimations(data);
    }
  }

  set _imageData(ImageFutureResponse? data) {
    if (data == null) return;
    final cacheKey = widget.cacheKey;
    cacheKey == null
        ? _imageDataNoCache = data
        : _imageDataCache[cacheKey] = data;
  }

  bool? _isCached;

  Future<void> _load() async {
    final client = Matrix.of(context).client;
    final uri = widget.uri;
    final event = widget.event;

    if (uri != null) {
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      final width = widget.width;
      final realWidth = width == null ? null : width * devicePixelRatio;
      final height = widget.height;
      final realHeight = height == null ? null : height * devicePixelRatio;

      final httpUri = widget.isThumbnail
          ? uri.getThumbnail(
              client,
              width: realWidth,
              height: realHeight,
              animated: widget.animated,
              method: widget.thumbnailMethod,
            )
          : uri.getDownloadLink(client);

      final storeKey = widget.isThumbnail ? httpUri : uri;

      if (_isCached == null) {
        final cachedData = await client.database?.getFile(storeKey);
        if (cachedData != null) {
          _imageData = await _renderImageFrame(cachedData);
          if (!mounted) return;
          setState(() {
            _isCached = true;
          });
          return;
        }
        _isCached = false;
      }

      final response = await http.get(httpUri);
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return;
        }
        throw Exception();
      }
      final remoteData = response.bodyBytes;

      _imageData = await _renderImageFrame(remoteData);
      if (!mounted) return;
      setState(() {});
      await client.database?.storeFile(storeKey, remoteData, 0);
    }

    if (event != null) {
      final data = await event.downloadAndDecryptAttachment(
        getThumbnail: widget.isThumbnail,
      );
      if (data.detectFileType is MatrixImageFile) {
        _imageData = await _renderImageFrame(data.bytes);
        if (!mounted) return;
        setState(() {});
        return;
      }
    }
  }

  void _tryLoad(_) async {
    if (_imageData != null) return;
    try {
      await _load();
    } catch (_) {
      if (!mounted) return;
      await Future.delayed(widget.retryDuration);
      _tryLoad(_);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_tryLoad);
  }

  Widget placeholder(BuildContext context) =>
      widget.placeholder?.call(context) ??
      const Center(
        child: CircularProgressIndicator.adaptive(),
      );

  @override
  Widget build(BuildContext context) {
    final data = _imageData;

    Widget child;
    if (data is ThumbnailImageResponse) {
      child = AnimationEnabledContainerView(
        builder: (bool animate) => animate
            ? _buildImageProvider(data.imageProvider)
            : _buildFrameImage(data.thumbnail),
        disableTapHandler: widget.disableTapHandler,
        iconSize: widget.watermarkSize ?? 0,
        textColor: widget.watermarkColor ?? Colors.transparent,
      );
    } else if (data is ImageProviderFutureResponse) {
      child = _buildImageProvider(data.imageProvider);
    } else {
      child = const SizedBox.shrink();
    }

    return AnimatedCrossFade(
      duration: widget.animationDuration,
      crossFadeState:
          data == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: placeholder(context),
      secondChild: child,
    );
  }

  Widget _buildFrameImage(ui.Image image) {
    return RawImage(
      key: ValueKey(image),
      image: image,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      filterQuality: FilterQuality.medium,
    );
  }

  Widget _buildImageProvider(ImageProvider image) {
    return Image(
      key: ValueKey(image),
      image: image,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, __, ___) {
        _isCached = false;
        _imageData = null;
        WidgetsBinding.instance.addPostFrameCallback(_tryLoad);
        return placeholder(context);
      },
    );
  }
}

abstract class ImageFutureResponse {
  const ImageFutureResponse();
}

class ImageProviderFutureResponse extends ImageFutureResponse {
  final ImageProvider imageProvider;

  const ImageProviderFutureResponse(this.imageProvider);
}

class ThumbnailImageResponse extends ImageProviderFutureResponse {
  final ui.Image thumbnail;

  const ThumbnailImageResponse({
    required this.thumbnail,
    required ImageProvider imageProvider,
  }) : super(imageProvider);
}
