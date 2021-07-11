import 'dart:typed_data';

import 'package:matrix/matrix.dart';
import 'package:fluffychat/pages/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../utils/matrix_sdk_extensions.dart/event_extension.dart';
import '../matrix.dart';

class ImageBubble extends StatefulWidget {
  final Event event;
  final bool tapToView;
  final BoxFit fit;
  final bool maxSize;
  final Color backgroundColor;
  final double radius;
  final bool thumbnailOnly;
  final void Function() onLoaded;

  const ImageBubble(
    this.event, {
    this.tapToView = true,
    this.maxSize = true,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.radius = 10.0,
    this.thumbnailOnly = true,
    this.onLoaded,
    Key key,
  }) : super(key: key);

  @override
  _ImageBubbleState createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  String thumbnailUrl;
  String attachmentUrl;
  MatrixFile _file;
  MatrixFile _thumbnail;
  bool _requestedThumbnailOnFailure = false;

  // overrides for certain mimetypes if they need different images to render
  // memory are for in-memory renderers (e2ee rooms), network for network url renderers.
  // The map values themself are set in initState() as they need to be able to access
  // `this`.
  final _contentRenderers = <String, _ImageBubbleContentRenderer>{};

  String getMimetype([bool thumbnail = false]) => thumbnail
      ? widget.event.thumbnailMimetype
      : widget.event.attachmentMimetype;

  MatrixFile get _displayFile => _file ?? _thumbnail;
  String get displayUrl => widget.thumbnailOnly ? thumbnailUrl : attachmentUrl;

  dynamic _error;

  Future<void> _requestFile({bool getThumbnail = false}) async {
    try {
      final res = await widget.event
          .downloadAndDecryptAttachmentCached(getThumbnail: getThumbnail);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (getThumbnail) {
          if (mounted) {
            setState(() => _thumbnail = res);
          }
        } else {
          if (widget.onLoaded != null) {
            widget.onLoaded();
          }
          if (mounted) {
            setState(() => _file = res);
          }
        }
      });
    } catch (err) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _error = err);
        }
      });
    }
  }

  @override
  void initState() {
    _contentRenderers['image/svg+xml'] = _ImageBubbleContentRenderer(
      memory: (Uint8List bytes, String key) => SvgPicture.memory(
        bytes,
        key: ValueKey(key),
        fit: widget.fit,
      ),
      network: (String url) => SvgPicture.network(
        url,
        key: ValueKey(url),
        placeholderBuilder: (context) => getPlaceholderWidget(),
        fit: widget.fit,
      ),
    );
    _contentRenderers['image/lottie+json'] = _ImageBubbleContentRenderer(
      memory: (Uint8List bytes, String key) => Lottie.memory(
        bytes,
        key: ValueKey(key),
        fit: widget.fit,
      ),
      network: (String url) => Lottie.network(
        url,
        key: ValueKey(url),
        fit: widget.fit,
      ),
    );

    thumbnailUrl = widget.event
        .getAttachmentUrl(getThumbnail: true, animated: true)
        ?.toString();
    attachmentUrl = widget.event.getAttachmentUrl(animated: true)?.toString();
    if (thumbnailUrl == null) {
      _requestFile(getThumbnail: true);
    }
    if (!widget.thumbnailOnly && attachmentUrl == null) {
      _requestFile();
    } else {
      // if the full attachment is cached, we might as well fetch it anyways.
      // no need to stick with thumbnail only, since we don't do any networking
      widget.event.isAttachmentCached().then((cached) {
        if (cached) {
          _requestFile();
        }
      });
    }
    super.initState();
  }

  Widget getErrorWidget() {
    return Center(
      child: Text(
        _error.toString(),
      ),
    );
  }

  Widget getPlaceholderWidget() {
    Widget blurhash;
    if (widget.event.infoMap['xyz.amorgan.blurhash'] is String) {
      final ratio =
          widget.event.infoMap['w'] is int && widget.event.infoMap['h'] is int
              ? widget.event.infoMap['w'] / widget.event.infoMap['h']
              : 1.0;
      var width = 32;
      var height = 32;
      if (ratio > 1.0) {
        height = (width / ratio).round();
      } else {
        width = (height * ratio).round();
      }
      blurhash = BlurHash(
        hash: widget.event.infoMap['xyz.amorgan.blurhash'],
        decodingWidth: width,
        decodingHeight: height,
        imageFit: widget.fit,
      );
    }
    return Stack(
      children: <Widget>[
        if (blurhash != null) blurhash,
        Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ],
    );
  }

  Widget getMemoryWidget() {
    final isOriginal = _file != null ||
        widget.event.attachmentOrThumbnailMxcUrl(getThumbnail: true) ==
            widget.event.attachmentMxcUrl;
    final key = isOriginal
        ? widget.event.attachmentMxcUrl
        : widget.event.thumbnailMxcUrl;
    final mimetype = getMimetype(!isOriginal);
    if (_contentRenderers.containsKey(mimetype)) {
      return _contentRenderers[mimetype].memory(_displayFile.bytes, key);
    } else {
      return Image.memory(
        _displayFile.bytes,
        key: ValueKey(key),
        fit: widget.fit,
      );
    }
  }

  Widget getNetworkWidget() {
    final mimetype = getMimetype(!_requestedThumbnailOnFailure);
    if (displayUrl == attachmentUrl &&
        _contentRenderers.containsKey(mimetype)) {
      return _contentRenderers[mimetype].network(displayUrl);
    } else {
      return CachedNetworkImage(
        // as we change the url on-error we need a key so that the widget actually updates
        key: ValueKey(displayUrl),
        imageUrl: displayUrl,
        placeholder: (context, url) {
          if (!widget.thumbnailOnly &&
              displayUrl != thumbnailUrl &&
              displayUrl == attachmentUrl) {
            // we have to display the thumbnail while loading
            return CachedNetworkImage(
              key: ValueKey(thumbnailUrl),
              imageUrl: thumbnailUrl,
              placeholder: (c, u) => getPlaceholderWidget(),
              fit: widget.fit,
            );
          }
          return getPlaceholderWidget();
        },
        errorWidget: (context, url, error) {
          // we can re-request the thumbnail
          if (!_requestedThumbnailOnFailure) {
            _requestedThumbnailOnFailure = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                thumbnailUrl = widget.event
                    .getAttachmentUrl(
                        getThumbnail: true,
                        useThumbnailMxcUrl: true,
                        animated: true)
                    ?.toString();
                attachmentUrl = widget.event
                    .getAttachmentUrl(useThumbnailMxcUrl: true, animated: true)
                    ?.toString();
              });
            });
          }
          return getPlaceholderWidget();
        },
        fit: widget.fit,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    String key;
    if (_error != null) {
      content = getErrorWidget();
      key = 'error';
    } else if (_displayFile != null) {
      content = getMemoryWidget();
      key = 'memory-' + (content.key as ValueKey).value;
    } else if (displayUrl != null) {
      content = getNetworkWidget();
      key = 'network-' + (content.key as ValueKey).value;
    } else {
      content = getPlaceholderWidget();
      key = 'placeholder';
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: InkWell(
        onTap: () {
          if (!widget.tapToView) return;
          showDialog(
            context: Matrix.of(context).navigatorContext,
            useRootNavigator: false,
            builder: (_) => ImageViewer(widget.event, onLoaded: () {
              // If the original file didn't load yet, we want to do that now.
              // This is so that the original file displays after going on the image viewer,
              // waiting for it to load, and then hitting back. This ensures that we always
              // display the best image available, with requiring as little network as possible
              if (_file == null) {
                widget.event.isAttachmentCached().then((cached) {
                  if (cached) {
                    _requestFile();
                  }
                });
              }
            }),
          );
        },
        child: Hero(
          tag: widget.event.eventId,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 1000),
            child: Container(
              key: ValueKey(key),
              height: widget.maxSize ? 300 : null,
              width: widget.maxSize ? 400 : null,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageBubbleContentRenderer {
  final Widget Function(Uint8List, String) memory;
  final Widget Function(String) network;

  _ImageBubbleContentRenderer({this.memory, this.network});
}
