import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageBubble extends StatefulWidget {
  final Event event;
  final bool tapToView;
  final BoxFit fit;
  final bool maxSize;
  final Color backgroundColor;
  final double radius;
  final bool thumbnailOnly;

  const ImageBubble(
    this.event, {
    this.tapToView = true,
    this.maxSize = true,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.radius = 10.0,
    this.thumbnailOnly = true,
    Key key,
  }) : super(key: key);

  @override
  _ImageBubbleState createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  bool get isUnencrypted => widget.event.content['url'] is String;

  static final Map<String, MatrixFile> _matrixFileMap = {};
  MatrixFile get _file => _matrixFileMap[widget.event.eventId];
  set _file(MatrixFile file) {
    if (file != null) {
      _matrixFileMap[widget.event.eventId] = file;
    }
  }

  static final Map<String, MatrixFile> _matrixThumbnailMap = {};
  MatrixFile get _thumbnail => _matrixThumbnailMap[widget.event.eventId];
  set _thumbnail(MatrixFile thumbnail) {
    if (thumbnail != null) {
      _matrixThumbnailMap[widget.event.eventId] = thumbnail;
    }
  }

  dynamic _error;

  bool _requestedFile = false;
  Future<MatrixFile> _getFile() async {
    _requestedFile = true;
    if (widget.thumbnailOnly) return null;
    if (_file != null) return _file;
    return widget.event.downloadAndDecryptAttachment();
  }

  bool _requestedThumbnail = false;
  Future<MatrixFile> _getThumbnail() async {
    _requestedThumbnail = true;
    if (isUnencrypted) return null;
    if (_thumbnail != null) return _thumbnail;
    return widget.event
        .downloadAndDecryptAttachment(getThumbnail: widget.event.hasThumbnail);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: Container(
        height: widget.maxSize ? 300 : null,
        width: widget.maxSize ? 400 : null,
        child: Builder(
          builder: (BuildContext context) {
            if (_error != null) {
              return Center(
                child: Text(
                  _error.toString(),
                ),
              );
            }
            if (_thumbnail == null && !_requestedThumbnail && !isUnencrypted) {
              _getThumbnail().then((MatrixFile thumbnail) {
                if (mounted) {
                  setState(() => _thumbnail = thumbnail);
                }
              }, onError: (error, stacktrace) {
                if (mounted) {
                  setState(() => _error = error);
                }
              });
            }
            if (_file == null && !widget.thumbnailOnly && !_requestedFile) {
              _getFile().then((MatrixFile file) {
                if (mounted) {
                  setState(() => _file = file);
                }
              }, onError: (error, stacktrace) {
                if (mounted) {
                  setState(() => _error = error);
                }
              });
            }
            final display = _file ?? _thumbnail;

            final generatePlaceholderWidget = () => Stack(
                  children: <Widget>[
                    if (widget.event.content['info'] is Map &&
                        widget.event.content['info']['xyz.amorgan.blurhash']
                            is String)
                      BlurHash(
                          hash: widget.event.content['info']
                              ['xyz.amorgan.blurhash']),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );

            Widget renderWidget;
            if (display != null) {
              renderWidget = Image.memory(
                display.bytes,
                fit: widget.fit,
              );
            } else if (isUnencrypted) {
              final src = Uri.parse(widget.event.content['url']).getThumbnail(
                  widget.event.room.client,
                  width: 800,
                  height: 800,
                  method: ThumbnailMethod.scale);
              renderWidget = CachedNetworkImage(
                imageUrl: src,
                placeholder: (context, url) => generatePlaceholderWidget(),
                fit: widget.fit,
              );
            } else {
              renderWidget = generatePlaceholderWidget();
            }
            return InkWell(
              onTap: () {
                if (!widget.tapToView) return;
                Navigator.of(context).push(
                  AppRoute(
                    ImageView(widget.event),
                  ),
                );
              },
              child: Hero(
                tag: widget.event.eventId,
                child: renderWidget,
              ),
            );
          },
        ),
      ),
    );
  }
}
