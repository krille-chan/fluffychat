import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'matrix_file_extension.dart';
import '../../pages/image_viewer.dart';

extension LocalizedBody on Event {
  void openFile(BuildContext context, {bool downloadOnly = false}) async {
    if (!downloadOnly &&
        [MessageTypes.Image, MessageTypes.Sticker].contains(messageType)) {
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => ImageViewer(this)),
      );
      return;
    }
    final matrixFile = await showFutureLoadingDialog(
      context: context,
      future: () => downloadAndDecryptAttachmentCached(),
    );
    matrixFile.result?.open();
  }

  IconData get statusIcon {
    switch (status) {
      case -1:
        return Icons.error_outline;
      case 0:
        return Icons.timer_outlined;
      case 1:
        return Icons.done_outlined;
      case 2:
        return Icons.done_all_outlined;
      default:
        return Icons.done_outlined;
    }
  }

  bool get isAttachmentSmallEnough =>
      infoMap['size'] is int &&
      infoMap['size'] < room.client.database.maxFileSize;
  bool get isThumbnailSmallEnough =>
      thumbnailInfoMap['size'] is int &&
      thumbnailInfoMap['size'] < room.client.database.maxFileSize;

  bool get showThumbnail =>
      [MessageTypes.Image, MessageTypes.Sticker].contains(messageType) &&
      (kIsWeb ||
          isAttachmentSmallEnough ||
          isThumbnailSmallEnough ||
          (content['url'] is String));

  String get sizeString {
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
    // check if we have it in-memory
    if (_downloadAndDecryptFutures.containsKey(mxcUrl)) {
      return true;
    }
    // check if it is stored
    if (await isAttachmentInLocalStore(getThumbnail: getThumbnail)) {
      return true;
    }
    // check if the url is cached
    final url = Uri.parse(mxcUrl).getDownloadLink(room.client);
    final file = await DefaultCacheManager().getFileFromCache(url.toString());
    return file != null;
  }

  Future<MatrixFile> downloadAndDecryptAttachmentCached(
      {bool getThumbnail = false}) async {
    final mxcUrl = attachmentOrThumbnailMxcUrl(getThumbnail: getThumbnail);
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
