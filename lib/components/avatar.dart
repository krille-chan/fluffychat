import 'package:cached_network_image/cached_network_image.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'matrix.dart';

class Avatar extends StatelessWidget {
  final MxContent mxContent;
  final double size;

  const Avatar(this.mxContent, {this.size = 40, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String src = mxContent.getThumbnail(
      Matrix.of(context).client,
      width: size * MediaQuery.of(context).devicePixelRatio,
      height: size * MediaQuery.of(context).devicePixelRatio,
      method: ThumbnailMethod.scale,
    );
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: mxContent.mxc?.isNotEmpty ?? false
          ? kIsWeb
              ? NetworkImage(
                  src,
                )
              : CachedNetworkImageProvider(
                  src,
                )
          : null,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      child: mxContent.mxc.isEmpty
          ? Text("@", style: TextStyle(color: Colors.blueGrey))
          : null,
    );
  }
}
