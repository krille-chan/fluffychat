import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:matrix/matrix.dart';

extension ShortcutMemoryIcon on Uint8List {
  Future<String?> toShortcutMemoryIcon(
    String roomId,
    DatabaseApi? database,
  ) async {
    final cacheKey = Uri.parse('im.fluffychat://shortcuts/$roomId');
    final cachedFile = await database?.getFile(cacheKey);
    if (cachedFile != null) return base64Encode(cachedFile);

    final image = decodeImage(this);
    if (image == null) return null;

    final size = image.width < image.height ? image.width : image.height;
    final x = (image.width - size) ~/ 2;
    final y = (image.height - size) ~/ 2;

    final croppedImage = copyCrop(
      image,
      x: x,
      y: y,
      width: size,
      height: size,
    );

    final bytes = croppedImage.toUint8List();
    await database?.storeFile(cacheKey, bytes, 0);

    return base64Encode(croppedImage.toUint8List());
  }
}
