import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'matrix_file_extension.dart';

extension LocalizedBody on Event {
  Future<LoadingDialogResult<MatrixFile?>> _getFile(BuildContext context) =>
      showFutureLoadingDialog(
        context: context,
        future: () => downloadAndDecryptAttachmentCached(),
      );

  void saveFile(BuildContext context) async {
    final matrixFile = await _getFile(context);

    matrixFile.result?.save(context);
  }

  void shareFile(BuildContext context) async {
    final matrixFile = await _getFile(context);

    matrixFile.result?.share(context);
  }

  bool get isAttachmentSmallEnough =>
      infoMap['size'] is int &&
      infoMap['size'] < room.client.database!.maxFileSize;

  bool get isThumbnailSmallEnough =>
      thumbnailInfoMap['size'] is int &&
      thumbnailInfoMap['size'] < room.client.database!.maxFileSize;

  bool get showThumbnail =>
      [MessageTypes.Image, MessageTypes.Sticker, MessageTypes.Video]
          .contains(messageType) &&
      (kIsWeb ||
          isAttachmentSmallEnough ||
          isThumbnailSmallEnough ||
          (content['url'] is String));

  String? get sizeString {
    if (content['info'] is Map<String, dynamic> &&
        content['info'].containsKey('size')) {
      num size = content['info']['size'];
      if (size < 1000000) {
        size = size / 1000;
        size = (size * 10).round() / 10;
        return '${size.toString()} KB';
      } else if (size < 1000000000) {
        size = size / 1000000;
        size = (size * 10).round() / 10;
        return '${size.toString()} MB';
      } else {
        size = size / 1000000000;
        size = (size * 10).round() / 10;
        return '${size.toString()} GB';
      }
    } else {
      return null;
    }
  }

  static final _downloadAndDecryptFutures = <String, Future<MatrixFile>>{};

  Future<bool> isAttachmentCached({bool getThumbnail = false}) async {
    final mxcUrl = attachmentOrThumbnailMxcUrl(getThumbnail: getThumbnail);
    if (mxcUrl == null) return false;
    // check if we have it in-memory
    if (_downloadAndDecryptFutures.containsKey(mxcUrl)) {
      return true;
    }
    // check if it is stored
    if (await isAttachmentInLocalStore(getThumbnail: getThumbnail)) {
      return true;
    }
    // check if the url is cached
    final url = mxcUrl.getDownloadLink(room.client);
    final file = await DefaultCacheManager().getFileFromCache(url.toString());
    return file != null;
  }

  Future<MatrixFile?> downloadAndDecryptAttachmentCached(
      {bool getThumbnail = false}) async {
    final mxcUrl =
        attachmentOrThumbnailMxcUrl(getThumbnail: getThumbnail)?.toString() ??
            eventId;
    _downloadAndDecryptFutures[mxcUrl] ??= downloadAndDecryptAttachment(
      getThumbnail: getThumbnail,
      downloadCallback: (Uri url) async {
        final file = await DefaultCacheManager().getSingleFile(url.toString());
        return await file.readAsBytes();
      },
    );
    final res = await _downloadAndDecryptFutures[mxcUrl];
    return res;
  }
}
