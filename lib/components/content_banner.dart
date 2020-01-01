import 'package:cached_network_image/cached_network_image.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'matrix.dart';

class ContentBanner extends StatelessWidget {
  final MxContent mxContent;
  final double height;
  final IconData defaultIcon;
  final bool loading;

  const ContentBanner(this.mxContent,
      {this.height = 400,
      this.defaultIcon = Icons.people_outline,
      this.loading = false,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final int bannerSize =
        (mediaQuery.size.width * mediaQuery.devicePixelRatio).toInt();
    final String src = mxContent.getThumbnail(
      Matrix.of(context).client,
      width: bannerSize,
      height: bannerSize,
      method: ThumbnailMethod.scale,
    );
    return Container(
      height: 200,
      color: Color(0xFFF8F8F8),
      child: !loading
          ? mxContent.mxc?.isNotEmpty ?? false
              ? kIsWeb
                  ? Image.network(
                      src,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: src,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (c, s) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (c, s, o) => Icon(Icons.error, size: 200),
                    )
              : Icon(defaultIcon, size: 200)
          : Icon(defaultIcon, size: 200),
    );
  }
}
