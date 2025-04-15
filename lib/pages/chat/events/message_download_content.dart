import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/file_description.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/utils/url_launcher.dart';

class MessageDownloadContent extends StatelessWidget {
  final Event event;
  final Color textColor;
  final Color linkColor;

  const MessageDownloadContent(
    this.event, {
    required this.textColor,
    required this.linkColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final filename = event.content.tryGet<String>('filename') ?? event.body;
    final filetype = (filename.contains('.')
        ? filename.split('.').last.toUpperCase()
        : event.content
                .tryGetMap<String, dynamic>('info')
                ?.tryGet<String>('mimetype')
                ?.toUpperCase() ??
            'UNKNOWN');
    final sizeString = event.sizeString;
    final fileDescription = event.fileDescription;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        InkWell(
          onTap: () => event.saveFile(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.file_download_outlined,
                      color: textColor,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        filename,
                        maxLines: 1,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      filetype,
                      style: TextStyle(
                        color: linkColor,
                      ),
                    ),
                    const Spacer(),
                    if (sizeString != null)
                      Text(
                        sizeString,
                        style: TextStyle(
                          color: linkColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (fileDescription != null)
          Linkify(
            text: fileDescription,
            textScaleFactor: MediaQuery.textScalerOf(context).scale(1),
            style: TextStyle(
              color: textColor,
              fontSize: AppConfig.fontSizeFactor * AppConfig.messageFontSize,
            ),
            options: const LinkifyOptions(humanize: false),
            linkStyle: TextStyle(
              color: linkColor,
              fontSize: AppConfig.fontSizeFactor * AppConfig.messageFontSize,
              decoration: TextDecoration.underline,
              decorationColor: linkColor,
            ),
            onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
          ),
      ],
    );
  }
}
