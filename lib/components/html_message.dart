import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter_matrix_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'matrix.dart';

class HtmlMessage extends StatelessWidget {
  final String html;
  final Color textColor;
  final int maxLines;

  const HtmlMessage({this.html, this.textColor, this.maxLines});

  @override
  Widget build(BuildContext context) {
    // there is no need to pre-validate the html, as we validate it while rendering
    
    return Html(
      data: html,
      defaultTextStyle: TextStyle(color: textColor),
      shrinkToFit: true,
      maxLines: maxLines,
      onLinkTap: (String url) {
        if (url == null || url.isEmpty) {
          return;
        }
        launch(url);
      },
      getMxcUrl: (String mxc, double width, double height) {
        final ratio = MediaQuery.of(context).devicePixelRatio;
        return Uri.parse(mxc)?.getThumbnail(
          Matrix.of(context).client,
          width: (width ?? 800) * ratio,
          height: (height ?? 800) * ratio,
          method: ThumbnailMethod.scale,
        );
      },
    );
  }
}
