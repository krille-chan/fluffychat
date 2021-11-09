import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/matrix_sdk_extensions.dart/event_extension.dart';

class MessageDownloadContent extends StatelessWidget {
  final Event event;
  final Color textColor;

  const MessageDownloadContent(this.event, this.textColor, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String filename = event.content.containsKey('filename')
        ? event.content['filename']
        : event.body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).scaffoldBackgroundColor,
            onPrimary: Theme.of(context).textTheme.bodyText1.color,
          ),
          onPressed: () => event.saveFile(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.download_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  filename,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        if (event.sizeString != null)
          Text(
            event.sizeString,
            style: TextStyle(
              color: textColor,
            ),
          ),
      ],
    );
  }
}
