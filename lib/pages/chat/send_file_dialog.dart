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
import 'package:fluffychat/utils/other_party_can_receive.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/size_string.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
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
  bool compress = true;

  /// Images smaller than 20kb don't need compression.
  static const int minSizeToCompress = 20 * 1000;

  Future<void> _send() async {
    final scaffoldMessenger = ScaffoldMessenger.of(widget.outerContext);
    final l10n = L10n.of(context);

    try {
      if (!widget.room.otherPartyCanReceiveMessages) {
        throw OtherPartyCanNotReceiveMessages();
      }
      scaffoldMessenger.showLoadingSnackBar(l10n.prepareSendingAttachment);
      Navigator.of(context, rootNavigator: false).pop();
      final clientConfig = await widget.room.client.getConfig();
      final maxUploadSize = clientConfig.mUploadSize ?? 100 * 1000 * 1000;

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
            compress) {
          scaffoldMessenger.showLoadingSnackBar(l10n.compressVideo);
          file = await xfile.resizeVideo();
          scaffoldMessenger.showLoadingSnackBar(l10n.generatingVideoThumbnail);
          thumbnail = await xfile.getVideoThumbnail();
        } else {
          if (length > maxUploadSize) {
            throw FileTooBigMatrixException(length, maxUploadSize);
          }
          // Else we just create a MatrixFile
          file = MatrixFile(
            bytes: await xfile.readAsBytes(),
            name: xfile.name,
            mimeType: mimeType,
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
            shrinkImageMaxDimension: compress ? 1600 : null,
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
            shrinkImageMaxDimension: compress ? null : 1600,
          );
        }
      }
      scaffoldMessenger.clearSnackBars();
    } catch (e) {
      scaffoldMessenger.clearSnackBars();
      final theme = Theme.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: theme.colorScheme.errorContainer,
          closeIconColor: theme.colorScheme.onErrorContainer,
          content: Text(
            e.toLocalizedString(widget.outerContext),
            style: TextStyle(color: theme.colorScheme.onErrorContainer),
          ),
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
    final uniqueFileType = widget.files
        .map((file) => file.mimeType ?? lookupMimeType(file.name))
        .map((mimeType) => mimeType?.split('/').first)
        .toSet()
        .singleOrNull;

    final fileName = widget.files.length == 1
        ? widget.files.single.name
        : L10n.of(context).countFiles(widget.files.length);
    final fileTypes = widget.files
        .map((file) => file.name.split('.').last)
        .toSet()
        .join(', ')
        .toUpperCase();

    if (uniqueFileType == 'image') {
      if (widget.files.length == 1) {
        sendStr = L10n.of(context).sendImage;
      } else {
        sendStr = L10n.of(context).sendImages(widget.files.length);
      }
    } else if (uniqueFileType == 'audio') {
      sendStr = L10n.of(context).sendAudio;
    } else if (uniqueFileType == 'video') {
      sendStr = L10n.of(context).sendVideo;
    }

    return FutureBuilder<String>(
      future: _calcCombinedFileSize(),
      builder: (context, snapshot) {
        final sizeString =
            snapshot.data ?? L10n.of(context).calculatingFileSize;

        return AlertDialog.adaptive(
          title: Text(sendStr),
          content: SizedBox(
            width: 256,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                if (uniqueFileType == 'image')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      height: 256,
                      child: Center(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.files.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(
                                AppConfig.borderRadius / 2,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: kIsWeb
                                  ? Image.network(
                                      widget.files[i].path,
                                      height: 256,
                                    )
                                  : Image.file(
                                      File(widget.files[i].path),
                                      height: 256,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (uniqueFileType != 'image')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          uniqueFileType == null
                              ? Icons.description_outlined
                              : uniqueFileType == 'video'
                                  ? Icons.video_file_outlined
                                  : uniqueFileType == 'audio'
                                      ? Icons.audio_file_outlined
                                      : Icons.description_outlined,
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '$sizeString - $fileTypes',
                                style: theme.textTheme.labelSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                // Workaround for SwitchListTile.adaptive crashes in CupertinoDialog
                if ({'image', 'video'}.contains(uniqueFileType))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if ({TargetPlatform.iOS, TargetPlatform.macOS}
                          .contains(theme.platform))
                        CupertinoSwitch(
                          value: compress,
                          onChanged: uniqueFileType == 'video' &&
                                  !PlatformInfos.isMobile
                              ? null
                              : (v) => setState(() => compress = v),
                        )
                      else
                        Switch.adaptive(
                          value: compress,
                          onChanged: uniqueFileType == 'video' &&
                                  !PlatformInfos.isMobile
                              ? null
                              : (v) => setState(() => compress = v),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  L10n.of(context).compress,
                                  style: theme.textTheme.titleMedium,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            if (!compress)
                              Text(
                                ' ($sizeString)',
                                style: theme.textTheme.labelSmall,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
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
