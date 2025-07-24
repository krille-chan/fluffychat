import 'dart:math' show min;
import 'dart:typed_data';
import 'dart:ui';

import 'package:matrix/matrix.dart';

extension ClientDownloadContentExtension on Client {
  Future<Uint8List> downloadMxcCached(
    Uri mxc, {
    num? width,
    num? height,
    bool isThumbnail = false,
    bool? animated,
    ThumbnailMethod? thumbnailMethod,
    bool rounded = false,
  }) async {
    // To stay compatible with previous storeKeys:
    final cacheKey = isThumbnail
        // ignore: deprecated_member_use
        ? mxc.getThumbnail(
            this,
            width: width,
            height: height,
            animated: animated,
            method: thumbnailMethod!,
          )
        : mxc;

    final cachedData = await database.getFile(cacheKey);
    if (cachedData != null) return cachedData;

    final httpUri = isThumbnail
        ? await mxc.getThumbnailUri(
            this,
            width: width,
            height: height,
            animated: animated,
            method: thumbnailMethod,
          )
        : await mxc.getDownloadUri(this);

    final response = await httpClient.get(
      httpUri,
      headers:
          accessToken == null ? null : {'authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode != 200) {
      throw Exception();
    }
    var imageData = response.bodyBytes;

    if (rounded) {
      imageData = await _convertToCircularImage(
        imageData,
        min(width ?? 64, height ?? 64).round(),
      );
    }

    await database.storeFile(cacheKey, imageData, 0);

    return imageData;
  }
}

Future<Uint8List> _convertToCircularImage(
  Uint8List imageBytes,
  int size,
) async {
  final codec = await instantiateImageCodec(imageBytes);
  final frame = await codec.getNextFrame();
  final originalImage = frame.image;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);

  final paint = Paint();
  final rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());

  final clipPath = Path()
    ..addOval(
      Rect.fromCircle(center: Offset(size / 2, size / 2), radius: size / 2),
    );

  canvas.clipPath(clipPath);

  canvas.drawImageRect(
    originalImage,
    Rect.fromLTWH(
      0,
      0,
      originalImage.width.toDouble(),
      originalImage.height.toDouble(),
    ),
    rect,
    paint,
  );

  final picture = recorder.endRecording();
  final circularImage = await picture.toImage(size, size);

  final byteData = await circularImage.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
