import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/utils/event_extension.dart';

class MessageDownloadContent extends StatelessWidget {
  final Event event;
  final Color textColor;

  const MessageDownloadContent(this.event, this.textColor, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            color: Colors.blueGrey,
            child: Text(
              L10n.of(context).downloadFile,
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => event.openFile(context),
          ),
          Text(
            '- ' +
                (event.content.containsKey('filename')
                    ? event.content['filename']
                    : event.body),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (event.sizeString != null)
            Text(
              '- ' + event.sizeString,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
