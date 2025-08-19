import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/client_download_content_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

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
  final BorderRadius borderRadius;

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
    this.borderRadius = BorderRadius.zero,
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
    cacheKey == null
        ? _imageDataNoCache = data
        : _imageDataCache[cacheKey] = data;
  }

  Future<void> _load() async {
    if (!mounted) return;
    final client =
        widget.client ?? widget.event?.room.client ?? Matrix.of(context).client;
    final uri = widget.uri;
    final event = widget.event;

    if (uri != null) {
      // Handle direct HTTP/HTTPS URLs
      if (uri.scheme == 'http' || uri.scheme == 'https') {
        try {
          final response = await http.get(uri);
          if (response.statusCode == 200) {
            if (!mounted) return;
            setState(() {
              _imageData = response.bodyBytes;
            });
            return;
          }
        } catch (e) {
          Logs().w('Failed to load HTTP image: $uri', e);
        }
      } else if (uri.scheme == 'mxc') {
        // Handle MXC URLs
        final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
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
        if (!mounted) return;
        setState(() {
          _imageData = remoteData;
        });
      }
    }

    if (event != null) {
      // Check if the event has a direct HTTP URL
      final eventUrl = event.content.tryGet<String>('url');
      if (eventUrl != null) {
        final eventUri = Uri.tryParse(eventUrl);
        if (eventUri != null &&
            (eventUri.scheme == 'http' || eventUri.scheme == 'https')) {
          try {
            final response = await http.get(eventUri);
            if (response.statusCode == 200) {
              if (!mounted) return;
              setState(() {
                _imageData = response.bodyBytes;
              });
              return;
            }
          } catch (e) {
            Logs().w('Failed to load HTTP image from event: $eventUrl', e);
          }
        }
      }

      // Fallback to Matrix attachment handling for MXC URLs
      try {
        final data = await event.downloadAndDecryptAttachment(
          getThumbnail: widget.isThumbnail,
        );
        if (data.detectFileType is MatrixImageFile || widget.isThumbnail) {
          if (!mounted) return;
          setState(() {
            _imageData = data.bytes;
          });
          return;
        }
      } catch (e) {
        Logs().w('Failed to download Matrix attachment', e);
      }
    }
  }

  void _tryLoad() async {
    if (_imageData != null) {
      return;
    }
    try {
      await _load();
    } on IOException catch (_) {
      if (!mounted) return;
      await Future.delayed(widget.retryDuration);
      _tryLoad();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryLoad());
  }

  Widget placeholder(BuildContext context) =>
      widget.placeholder?.call(context) ??
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

    return AnimatedSwitcher(
      duration: FluffyThemes.animationDuration,
      child: hasData
          ? ClipRRect(
              borderRadius: widget.borderRadius,
              child: Image.memory(
                data,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                filterQuality: widget.isThumbnail
                    ? FilterQuality.low
                    : FilterQuality.medium,
                errorBuilder: (context, e, s) {
                  Logs().d('Unable to render mxc image', e, s);
                  return SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: min(widget.height ?? 64, 64),
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                },
              ),
            )
          : placeholder(context),
    );
  }
}
