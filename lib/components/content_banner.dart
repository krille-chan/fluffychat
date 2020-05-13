import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

import 'matrix.dart';

class ContentBanner extends StatelessWidget {
  final Uri mxContent;
  final double height;
  final IconData defaultIcon;
  final bool loading;
  final Function onEdit;

  const ContentBanner(this.mxContent,
      {this.height = 400,
      this.defaultIcon = Icons.people_outline,
      this.loading = false,
      this.onEdit,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bannerSize =
        (mediaQuery.size.width * mediaQuery.devicePixelRatio).toInt();
    final src = mxContent?.getThumbnail(
      Matrix.of(context).client,
      width: bannerSize,
      height: bannerSize,
      method: ThumbnailMethod.scale,
    );
    return Container(
      height: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.75,
              child: !loading
                  ? mxContent != null
                      ? Image(
                          height: 300,
                          fit: BoxFit.cover,
                          image: AdvancedNetworkImage(
                            src,
                            useDiskCache: !kIsWeb,
                          ),
                        )
                      : Icon(defaultIcon, size: 300)
                  : Icon(defaultIcon, size: 300),
            ),
          ),
          if (onEdit != null)
            Container(
              margin: EdgeInsets.all(8),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.camera_alt),
                onPressed: onEdit,
              ),
            ),
        ],
      ),
    );
  }
}
