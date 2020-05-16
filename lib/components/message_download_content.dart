import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/utils/event_extension.dart';

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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            color: textColor,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              filename,
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () => event.openFile(context),
          ),
          if (event.sizeString != null)
            Text(
              event.sizeString,
              style: TextStyle(
                color: textColor,
              ),
            ),
        ],
      ),
    );
  }
}
