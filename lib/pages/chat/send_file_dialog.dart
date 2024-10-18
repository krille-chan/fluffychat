import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/size_string.dart';
import 'package:fluffychat/widgets/adaptive_dialog_action.dart';
import '../../utils/resize_video.dart';

class SendFileDialog extends StatefulWidget {
  final Room room;
  final List<XFile> files;
  final BuildContext outerContext;

  const SendFileDialog({
    required this.room,
    required this.files,
    required this.outerContext,
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
    final scaffoldMessenger = ScaffoldMessenger.of(widget.outerContext);
    final l10n = L10n.of(context);

    try {
      scaffoldMessenger.showLoadingSnackBar(l10n.prepareSendingAttachment);
      Navigator.of(context, rootNavigator: false).pop();
      final clientConfig = await widget.room.client.getConfig();
      final maxUploadSize = clientConfig.mUploadSize ?? 100 * 1024 * 1024;

      for (final xfile in widget.files) {
        final MatrixFile file;
        MatrixImageFile? thumbnail;
        final length = await xfile.length();
        final mimeType = xfile.mimeType ?? lookupMimeType(xfile.path);

        // If file is a video, shrink it!
        if (PlatformInfos.isMobile &&
            mimeType != null &&
            mimeType.startsWith('video') &&
            length > minSizeToCompress &&
            !origImage) {
          scaffoldMessenger.showLoadingSnackBar(l10n.compressVideo);
          file = await xfile.resizeVideo();
          scaffoldMessenger.showLoadingSnackBar(l10n.generatingVideoThumbnail);
          thumbnail = await xfile.getVideoThumbnail();
        } else {
          // Else we just create a MatrixFile
          file = MatrixFile(
            bytes: await xfile.readAsBytes(),
            name: xfile.name,
            mimeType: xfile.mimeType,
          ).detectFileType;
        }

        if (file.bytes.length > maxUploadSize) {
          throw FileTooBigMatrixException(length, maxUploadSize);
        }

        if (widget.files.length > 1) {
          scaffoldMessenger.showLoadingSnackBar(
            l10n.sendingAttachmentCountOfCount(
              widget.files.indexOf(xfile) + 1,
              widget.files.length,
            ),
          );
        } else {
          scaffoldMessenger.clearSnackBars();
        }

        try {
          await widget.room.sendFileEvent(
            file,
            thumbnail: thumbnail,
            shrinkImageMaxDimension: origImage ? null : 1600,
          );
        } on MatrixException catch (e) {
          final retryAfterMs = e.retryAfterMs;
          if (e.error != MatrixError.M_LIMIT_EXCEEDED || retryAfterMs == null) {
            rethrow;
          }
          final retryAfterDuration =
              Duration(milliseconds: retryAfterMs + 1000);

          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                l10n.serverLimitReached(retryAfterDuration.inSeconds),
              ),
            ),
          );
          await Future.delayed(retryAfterDuration);

          scaffoldMessenger.showLoadingSnackBar(l10n.sendingAttachment);

          await widget.room.sendFileEvent(
            file,
            thumbnail: thumbnail,
            shrinkImageMaxDimension: origImage ? null : 1600,
          );
        }
      }
      scaffoldMessenger.clearSnackBars();
    } catch (e) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(e.toLocalizedString(widget.outerContext)),
          duration: const Duration(seconds: 30),
          showCloseIcon: true,
        ),
      );
      rethrow;
    }

    return;
  }

  Future<String> _calcCombinedFileSize() async {
    final lengths =
        await Future.wait(widget.files.map((file) => file.length()));
    return lengths.fold<double>(0, (p, length) => p + length).sizeString;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var sendStr = L10n.of(context).sendFile;
    final uniqueMimeType = widget.files
        .map((file) => file.mimeType ?? lookupMimeType(file.path))
        .toSet()
        .singleOrNull;

    final fileName = widget.files.length == 1
        ? widget.files.single.name
        : L10n.of(context).countFiles(widget.files.length.toString());

    if (uniqueMimeType?.startsWith('image') ?? false) {
      sendStr = L10n.of(context).sendImage;
    } else if (uniqueMimeType?.startsWith('audio') ?? false) {
      sendStr = L10n.of(context).sendAudio;
    } else if (uniqueMimeType?.startsWith('video') ?? false) {
      sendStr = L10n.of(context).sendVideo;
    }

    return FutureBuilder<String>(
      future: _calcCombinedFileSize(),
      builder: (context, snapshot) {
        final sizeString =
            snapshot.data ?? L10n.of(context).calculatingFileSize;

        Widget contentWidget;
        if (uniqueMimeType?.startsWith('image') ?? false) {
          contentWidget = Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Material(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  elevation: theme.appBarTheme.scrolledUnderElevation ?? 4,
                  shadowColor: theme.appBarTheme.shadowColor,
                  clipBehavior: Clip.hardEdge,
                  child: kIsWeb
                      ? Image.network(
                          widget.files.first.path,
                          fit: BoxFit.contain,
                          height: 256,
                        )
                      : Image.file(
                          File(widget.files.first.path),
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
                          L10n.of(context).sendOriginal,
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
          final fileNameParts = fileName.split('.');
          contentWidget = SizedBox(
            width: 256,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      uniqueMimeType == null
                          ? Icons.description_outlined
                          : uniqueMimeType.startsWith('video')
                              ? Icons.video_file_outlined
                              : uniqueMimeType.startsWith('audio')
                                  ? Icons.audio_file_outlined
                                  : Icons.description_outlined,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileNameParts.first,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (fileNameParts.length > 1)
                      Text('.${fileNameParts.last}'),
                    Text(' ($sizeString)'),
                  ],
                ),
                // Workaround for SwitchListTile.adaptive crashes in CupertinoDialog
                if (uniqueMimeType != null &&
                    uniqueMimeType.startsWith('video') &&
                    PlatformInfos.isMobile)
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
                              L10n.of(context).sendOriginal,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(sizeString),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }
        return AlertDialog.adaptive(
          title: Text(sendStr),
          content: contentWidget,
          actions: <Widget>[
            AdaptiveDialogAction(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: false).pop(),
              child: Text(L10n.of(context).cancel),
            ),
            AdaptiveDialogAction(
              onPressed: _send,
              child: Text(L10n.of(context).send),
            ),
          ],
        );
      },
    );
  }
}

extension on ScaffoldMessengerState {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoadingSnackBar(
    String title,
  ) {
    clearSnackBars();
    return showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        dismissDirection: DismissDirection.none,
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 16),
            Text(title),
          ],
        ),
      ),
    );
  }
}
