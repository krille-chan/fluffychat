import 'package:cached_network_image/cached_network_image.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageViewer extends StatelessWidget {
  final MxContent mxContent;

  const ImageViewer(this.mxContent);

  static show(BuildContext context, MxContent content) {
    Navigator.of(context).push(
      AppRoute(
        ImageViewer(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String url = mxContent.getDownloadLink(Matrix.of(context).client);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () => launch(url),
          ),
        ],
      ),
      body: PhotoView(
        loadingBuilder: (c, i) => Center(child: CircularProgressIndicator()),
        imageProvider: NetworkImage(
          url,
        ),
      ),
    );
  }
}
