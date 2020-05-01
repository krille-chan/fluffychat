import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

import 'matrix.dart';

class Avatar extends StatelessWidget {
  final Uri mxContent;
  final String name;
  final double size;
  final Function onTap;
  static const double defaultSize = 44;

  const Avatar(
    this.mxContent,
    this.name, {
    this.size = defaultSize,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String src = mxContent?.getThumbnail(
      Matrix.of(context).client,
      width: size * MediaQuery.of(context).devicePixelRatio,
      height: size * MediaQuery.of(context).devicePixelRatio,
      method: ThumbnailMethod.scale,
    );
    String fallbackLetters = "@";
    if ((name?.length ?? 0) >= 2) {
      fallbackLetters = name.substring(0, 2);
    } else if ((name?.length ?? 0) == 1) {
      fallbackLetters = name;
    }
    final noPic = mxContent == null || mxContent.toString().isEmpty;
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: !noPic
            ? AdvancedNetworkImage(
                src,
                useDiskCache: !kIsWeb,
              )
            : null,
        backgroundColor: noPic
            ? name?.color ?? Theme.of(context).secondaryHeaderColor
            : Theme.of(context).secondaryHeaderColor,
        child: noPic
            ? Text(fallbackLetters, style: TextStyle(color: Colors.white))
            : null,
      ),
    );
  }
}
