import 'dart:typed_data';

import 'package:matrix/matrix.dart';
import 'package:fluffychat/pages/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
  final bool animated;
  final double width;
  final double height;
  final void Function() onLoaded;
  final void Function() onTap;

  const ImageBubble(
    this.event, {
    this.tapToView = true,
    this.maxSize = true,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.radius = 10.0,
    this.thumbnailOnly = true,
    this.onLoaded,
    this.width = 400,
    this.height = 300,
    this.animated = false,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  _ImageBubbleState createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  // for plaintext: holds the http URL for the thumbnail
  String thumbnailUrl;
  // for plaintext: holds the http URL of the original
  String attachmentUrl;
  MatrixFile _file;
  MatrixFile _thumbnail;
  bool _requestedThumbnailOnFailure = false;
  // In case we have animated = false, this will hold the first frame so that we make
  // sure that things are never animated
  Widget _firstFrame;

  // the mimetypes that we know how to render, from the flutter Image widget
  final _knownMimetypes = <String>{
    'image/jpg',
    'image/jpeg',
    'image/png',
    'image/apng',
    'image/webp',
    'image/gif',
    'image/bmp',
    'image/x-bmp',
  };

  // overrides for certain mimetypes if they need different images to render
  // memory are for in-memory renderers (e2ee rooms), network for network url renderers.
  // The map values themself are set in initState() as they need to be able to access
  // `this`.
  final _contentRenderers = <String, _ImageBubbleContentRenderer>{};

  String getMimetype([bool thumbnail = false]) => thumbnail
      ? widget.event.thumbnailMimetype.toLowerCase()
      : widget.event.attachmentMimetype.toLowerCase();

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

  Widget frameBuilder(
      BuildContext context, Widget child, int frame, bool sync) {
    // as servers might return animated gifs as thumbnails and we want them to *not* play
    // animated, we'll have to store the first frame in a variable and display that instead
    if (widget.animated) {
      return child;
    }
    if (frame == 0) {
      _firstFrame = child;
    }
    return _firstFrame ?? child;
  }

  @override
  void initState() {
    // add the custom renderers for other mimetypes
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
        errorBuilder: (context, error, stacktrace) =>
            getErrorWidget(context, error),
        animate: widget.animated,
      ),
      network: (String url) => Lottie.network(
        url,
        key: ValueKey(url),
        fit: widget.fit,
        errorBuilder: (context, error, stacktrace) =>
            getErrorWidget(context, error),
        animate: widget.animated,
      ),
    );

    // add all the custom content renderer mimetypes to the known mimetypes set
    for (final key in _contentRenderers.keys) {
      _knownMimetypes.add(key);
    }

    thumbnailUrl = widget.event
        .getAttachmentUrl(getThumbnail: true, animated: widget.animated)
        ?.toString();
    attachmentUrl =
        widget.event.getAttachmentUrl(animated: widget.animated)?.toString();
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

  Widget getErrorWidget(BuildContext context, [dynamic error]) {
    final String filename = widget.event.content.containsKey('filename')
        ? widget.event.content['filename']
        : widget.event.body;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).scaffoldBackgroundColor,
              onPrimary: Theme.of(context).textTheme.bodyText1.color,
            ),
            onPressed: () => widget.event.saveFile(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download_outlined),
                SizedBox(width: 8),
                Text(
                  filename,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          if (widget.event.sizeString != null) Text(widget.event.sizeString),
          SizedBox(height: 8),
          Text((error ?? _error).toString()),
        ],
      ),
    );
  }

  Widget getPlaceholderWidget({Widget child}) {
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
          child: child ?? CircularProgressIndicator(strokeWidth: 2),
        ),
      ],
    );
  }

  // Build a memory file (e2ee)
  Widget getMemoryWidget() {
    final isOriginal = _file != null ||
        widget.event.attachmentOrThumbnailMxcUrl(getThumbnail: true) ==
            widget.event.attachmentMxcUrl;
    final key = isOriginal
        ? widget.event.attachmentMxcUrl
        : widget.event.thumbnailMxcUrl;
    final mimetype = getMimetype(!isOriginal);
    if (_contentRenderers.containsKey(mimetype)) {
      return _contentRenderers[mimetype]
          .memory(_displayFile.bytes, key.toString());
    } else {
      return Image.memory(
        _displayFile.bytes,
        key: ValueKey(key),
        fit: widget.fit,
        errorBuilder: (context, error, stacktrace) {
          if (widget.event.hasThumbnail && !_requestedThumbnailOnFailure) {
            _requestedThumbnailOnFailure = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _file = null;
                _requestFile(getThumbnail: true);
              });
            });
            return getPlaceholderWidget();
          }
          return getErrorWidget(context, error);
        },
        frameBuilder: frameBuilder,
      );
    }
  }

  // build a network file (plaintext)
  Widget getNetworkWidget() {
    // For network files we try to utilize server-side thumbnailing as much as possible.
    // Thus, we do the following logic:
    // - try to display our URL
    // - on failure: Attempt to display the in-event thumbnail instead
    // - on failrue / non-existance: Display button to download or view in-app
    final mimetype = getMimetype(_requestedThumbnailOnFailure);
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
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                frameBuilder: frameBuilder,
                fit: widget.fit,
              ),
            );
          }
          return getPlaceholderWidget();
        },
        imageBuilder: (context, imageProvider) => Image(
          image: imageProvider,
          frameBuilder: frameBuilder,
          fit: widget.fit,
        ),
        errorWidget: (context, url, error) {
          if (widget.event.hasThumbnail && !_requestedThumbnailOnFailure) {
            // the image failed to load but the event has a thumbnail attached....so we can
            // try to load this one!
            _requestedThumbnailOnFailure = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                thumbnailUrl = widget.event
                    .getAttachmentUrl(
                        getThumbnail: true,
                        useThumbnailMxcUrl: true,
                        animated: widget.animated)
                    ?.toString();
                attachmentUrl = widget.event
                    .getAttachmentUrl(
                        useThumbnailMxcUrl: true, animated: widget.animated)
                    ?.toString();
              });
            });
            return getPlaceholderWidget();
          } else if (widget.thumbnailOnly &&
              displayUrl != attachmentUrl &&
              _knownMimetypes.contains(mimetype)) {
            // Okay, the thumbnail failed to load, but we do know how to render the image
            // ourselves. Let's offer the user a button to view it.
            return getPlaceholderWidget(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).scaffoldBackgroundColor,
                    onPrimary: Theme.of(context).textTheme.bodyText1.color,
                  ),
                  onPressed: () => onTap(context),
                  child: Text(
                    L10n.of(context).tapToShowImage,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
                if (widget.event.sizeString != null)
                  Text(widget.event.sizeString),
              ],
            ));
          }
          return getErrorWidget(context, error);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    String key;
    if (_error != null) {
      content = getErrorWidget(context);
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
    if (widget.maxSize) {
      content = AspectRatio(
        aspectRatio: widget.width / widget.height,
        child: content,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: InkWell(
        onTap: () => onTap(context),
        child: Hero(
          tag: widget.event.eventId,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 1000),
            child: Container(
              key: ValueKey(key),
              constraints: widget.maxSize
                  ? BoxConstraints.loose(Size(
                      widget.width,
                      widget.height,
                    ))
                  : null,
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  void onTap(BuildContext context) {
    if (widget.onTap != null) {
      widget.onTap();
      return;
    }
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
  }
}

class _ImageBubbleContentRenderer {
  final Widget Function(Uint8List, String) memory;
  final Widget Function(String) network;

  _ImageBubbleContentRenderer({this.memory, this.network});
}
