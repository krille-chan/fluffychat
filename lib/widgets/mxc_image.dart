import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/matrix.dart';

class MxcImage extends StatelessWidget {
  final Uri? uri;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isThumbnail;
  final bool animated;
  final ThumbnailMethod thumbnailMethod;
  final Widget Function(BuildContext context)? placeholder;
  final String? cacheKey;

  const MxcImage({
    this.uri,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.isThumbnail = true,
    this.animated = false,
    this.thumbnailMethod = ThumbnailMethod.scale,
    this.cacheKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final uri = this.uri;
    if (uri == null) {
      return placeholder?.call(context) ?? const Placeholder();
    }

    final client = Matrix.of(context).client;

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final width = this.width;
    final realWidth = width == null ? null : width * devicePixelRatio;
    final height = this.height;
    final realHeight = height == null ? null : height * devicePixelRatio;

    final imageUrl = isThumbnail
        ? uri.getThumbnail(
            client,
            width: realWidth,
            height: realHeight,
            animated: animated,
            method: thumbnailMethod,
          )
        : uri.getDownloadLink(client);

    return CachedNetworkImage(
      imageUrl: imageUrl.toString(),
      width: width,
      height: height,
      fit: fit,
      cacheKey: cacheKey,
      filterQuality: isThumbnail ? FilterQuality.low : FilterQuality.medium,
      errorWidget: placeholder == null
          ? null
          : (context, __, ___) => placeholder!.call(context),
    );
  }
}
