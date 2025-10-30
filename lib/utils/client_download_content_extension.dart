import 'dart:typed_data';

import 'package:image/image.dart';
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
      final image = decodeImage(imageData);
      if (image != null) {
        imageData = encodePng(copyCropCircle(image));
      }
    }

    await database.storeFile(cacheKey, imageData, 0);

    return imageData;
  }
}
