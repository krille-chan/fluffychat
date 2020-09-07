/*
 *   Famedly App
 *   Copyright (C) 2020 Famedly GmbH
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of the
 *   License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:typed_data';
import 'dart:ui';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:native_imaging/native_imaging.dart' as native;

extension RoomSendFileExtension on Room {
  Future<String> sendFileEventWithThumbnail(
    MatrixFile file, {
    String txid,
    Event inReplyTo,
    String editEventId,
    bool waitUntilSent,
  }) async {
    MatrixFile thumbnail;
    try {
      if (file is MatrixImageFile) {
        await native.init();
        var nativeImg = native.Image();
        try {
          await nativeImg.loadEncoded(file.bytes);
          file.width = nativeImg.width();
          file.height = nativeImg.height();
        } on UnsupportedError {
          final dartCodec = await instantiateImageCodec(file.bytes);
          final dartFrame = await dartCodec.getNextFrame();
          file.width = dartFrame.image.width;
          file.height = dartFrame.image.height;
          final rgbaData = await dartFrame.image.toByteData();
          final rgba = Uint8List.view(
              rgbaData.buffer, rgbaData.offsetInBytes, rgbaData.lengthInBytes);
          dartFrame.image.dispose();
          dartCodec.dispose();
          nativeImg.loadRGBA(file.width, file.height, rgba);
        }

        const max = 800;
        if (file.width > max || file.height > max) {
          var w = max, h = max;
          if (file.width > file.height) {
            h = max * file.height ~/ file.width;
          } else {
            w = max * file.width ~/ file.height;
          }

          final scaledImg = nativeImg.resample(w, h, native.Transform.lanczos);
          nativeImg.free();
          nativeImg = scaledImg;
        }
        final jpegBytes = await nativeImg.toJpeg(75);
        file.blurhash = nativeImg.toBlurhash(3, 3);

        thumbnail = MatrixImageFile(
          bytes: jpegBytes,
          name: 'thumbnail.jpg',
          mimeType: 'image/jpeg',
          width: nativeImg.width(),
          height: nativeImg.height(),
        );

        nativeImg.free();

        if (thumbnail.size > file.size ~/ 2) {
          thumbnail = null;
        }
      }
    } catch (e) {
      // send no thumbnail
    }

    return sendFileEvent(
      file,
      txid: txid,
      inReplyTo: inReplyTo,
      editEventId: editEventId,
      waitUntilSent: waitUntilSent ?? false,
      thumbnail: thumbnail,
    );
  }
}
