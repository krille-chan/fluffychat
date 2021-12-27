//@dart=2.12

import 'package:matrix/matrix.dart';

import 'resize_image.dart';

extension RoomSendFileExtension on Room {
  Future<Uri> sendFileEventWithThumbnail(
    MatrixFile file, {
    String? txid,
    Event? inReplyTo,
    String? editEventId,
    bool? waitUntilSent,
    Map<String, dynamic>? extraContent,
  }) async {
    MatrixImageFile? thumbnail;
    if (file is MatrixImageFile) {
      thumbnail = await file.resizeImage();

      if (thumbnail.size > file.size ~/ 2) {
        thumbnail = null;
      }
    } else if (file is MatrixVideoFile) {
      thumbnail = await file.getVideoThumbnail();
    }

    return sendFileEvent(
      file,
      txid: txid,
      inReplyTo: inReplyTo,
      editEventId: editEventId,
      waitUntilSent: waitUntilSent ?? false,
      thumbnail: thumbnail,
      extraContent: extraContent,
    );
  }
}
