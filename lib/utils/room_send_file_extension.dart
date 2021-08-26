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

import 'package:matrix/matrix.dart';

import 'resize_image.dart';

extension RoomSendFileExtension on Room {
  Future<Uri> sendFileEventWithThumbnail(
    MatrixFile file, {
    String txid,
    Event inReplyTo,
    String editEventId,
    bool waitUntilSent,
  }) async {
    MatrixFile thumbnail;
    try {
      if (file is MatrixImageFile) {
        thumbnail = await resizeImage(file);

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
