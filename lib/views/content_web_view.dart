import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContentWebView extends StatelessWidget {
  final MxContent content;

  const ContentWebView(this.content);

  @override
  Widget build(BuildContext context) {
    final String url = content.getDownloadLink(Matrix.of(context).client);
    print(url);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Content viewer",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
            ),
            onPressed: () => launch(url),
          ),
        ],
      ),
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
