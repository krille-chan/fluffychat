import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/matrix_sdk_extensions.dart/event_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class MessageDownloadContent extends StatelessWidget {
  final Event event;
  final Color textColor;

  const MessageDownloadContent(this.event, this.textColor, {Key? key})
      : super(key: key);

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
    return InkWell(
      onTap: () => event.saveFile(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.file_download_outlined,
              color: textColor,
            ),
            title: Text(
              filename,
              maxLines: 1,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: PlatformInfos.isAndroid
                ? IconButton(
                    onPressed: () => event.shareFile(context),
                    tooltip: L10n.of(context)!.share,
                    icon: Icon(Icons.adaptive.share_outlined),
                  )
                : null,
          ),
          const Divider(),
          Row(
            children: [
              Text(
                filetype,
                style: TextStyle(
                  color: textColor.withAlpha(150),
                ),
              ),
              const Spacer(),
              if (sizeString != null)
                Text(
                  sizeString,
                  style: TextStyle(
                    color: textColor.withAlpha(150),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
