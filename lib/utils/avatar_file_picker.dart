// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';

bool _isGif(Uint8List bytes) =>
    bytes.length > 6 &&
    bytes[0] == 0x47 && // G
    bytes[1] == 0x49 && // I
    bytes[2] == 0x46 && // F
    bytes[3] == 0x38; // 8

/// Lets the user pick an avatar image on mobile.
///
/// Gallery images are not re-encoded by the picker (this would turn animated
/// GIFs into still images). Instead, they are scaled down afterwards, while
/// GIFs and other animated images are uploaded unchanged.
Future<MatrixFile?> pickAvatarFileOnMobile({
  required ImageSource source,
  required Client client,
}) async {
  final fromCamera = source == ImageSource.camera;
  final result = await ImagePicker().pickImage(
    source: source,
    imageQuality: fromCamera ? 50 : null,
  );
  if (result == null) return null;
  final bytes = await result.readAsBytes();
  final name = result.name.isNotEmpty ? result.name : result.path;
  if (fromCamera || _isGif(bytes)) {
    return MatrixFile(bytes: bytes, name: name);
  }
  return MatrixImageFile.shrink(
    bytes: bytes,
    name: name,
    maxDimension: 1024,
    customImageResizer: client.customImageResizer,
  );
}
