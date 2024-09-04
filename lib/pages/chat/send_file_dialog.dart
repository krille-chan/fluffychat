import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/size_string.dart';
import '../../utils/resize_image.dart';

class SendFileDialog extends StatefulWidget {
  final Room room;
  final List<MatrixFile> files;

  const SendFileDialog({
    required this.room,
    required this.files,
    super.key,
  });

  @override
  SendFileDialogState createState() => SendFileDialogState();
}

class SendFileDialogState extends State<SendFileDialog> {
  bool origImage = false;

  /// Images smaller than 20kb don't need compression.
  static const int minSizeToCompress = 20 * 1024;

  Future<void> _send() async {
    for (var file in widget.files) {
      MatrixImageFile? thumbnail;
      if (file is MatrixVideoFile && file.bytes.length > minSizeToCompress) {
        await showFutureLoadingDialog(
          context: context,
          future: () async {
            file = origImage ? file : await file.resizeVideo();
            thumbnail = await file.getVideoThumbnail();
          },
        );
      }
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      widget.room
          .sendFileEvent(
        file,
        thumbnail: thumbnail,
        shrinkImageMaxDimension: origImage ? null : 1600,
      )
          .catchError((e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text((e as Object).toLocalizedString(context))),
        );
        return null;
      });
    }
    Navigator.of(context, rootNavigator: false).pop();

    return;
  }

  @override
  Widget build(BuildContext context) {
    var sendStr = L10n.of(context)!.sendFile;
    final allFilesAreImages =
        widget.files.every((file) => file is MatrixImageFile);
    final sizeString = widget.files
        .fold<double>(0, (p, file) => p + file.bytes.length)
        .sizeString;
    final fileName = widget.files.length == 1
        ? widget.files.single.name
        : L10n.of(context)!.countFiles(widget.files.length.toString());

    if (allFilesAreImages) {
      sendStr = L10n.of(context)!.sendImage;
    } else if (widget.files.every((file) => file is MatrixAudioFile)) {
      sendStr = L10n.of(context)!.sendAudio;
    } else if (widget.files.every((file) => file is MatrixVideoFile)) {
      sendStr = L10n.of(context)!.sendVideo;
    }
    Widget contentWidget;
    if (allFilesAreImages) {
      contentWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Material(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              elevation:
                  Theme.of(context).appBarTheme.scrolledUnderElevation ?? 4,
              shadowColor: Theme.of(context).appBarTheme.shadowColor,
              clipBehavior: Clip.hardEdge,
              child: Image.memory(
                widget.files.first.bytes,
                fit: BoxFit.contain,
                height: 256,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Workaround for SwitchListTile.adaptive crashes in CupertinoDialog
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoSwitch(
                value: origImage,
                onChanged: (v) => setState(() => origImage = v),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10n.of(context)!.sendOriginal,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(sizeString),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else if (widget.files.every((file) => file is MatrixVideoFile)) {
      contentWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(fileName),
          const SizedBox(height: 16),
          // Workaround for SwitchListTile.adaptive crashes in CupertinoDialog
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoSwitch(
                value: origImage,
                onChanged: (v) => setState(() => origImage = v),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10n.of(context)!.sendOriginal,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(sizeString),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      contentWidget = Text('$fileName ($sizeString)');
    }
    return AlertDialog.adaptive(
      title: Text(sendStr),
      content: contentWidget,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // just close the dialog
            Navigator.of(context, rootNavigator: false).pop();
          },
          child: Text(L10n.of(context)!.cancel),
        ),
        TextButton(
          onPressed: _send,
          child: Text(L10n.of(context)!.send),
        ),
      ],
    );
  }
}
