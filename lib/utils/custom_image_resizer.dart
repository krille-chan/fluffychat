import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'package:matrix/matrix.dart';
import 'package:native_imaging/native_imaging.dart' as native;

(int, int) _scaleToBox(int width, int height, {required int boxSize}) {
  final fit = applyBoxFit(
    BoxFit.scaleDown,
    Size(width.toDouble(), height.toDouble()),
    Size(boxSize.toDouble(), boxSize.toDouble()),
  ).destination;
  return (fit.width.round(), fit.height.round());
}

Future<MatrixImageFileResizedResponse?> customImageResizer(
  MatrixImageFileResizeArguments arguments,
) async {
  if (kIsWeb) {
    throw UnsupportedError(
      'customImageResizer only supports non-web platforms.',
    );
  }

  await native.init();

  var imageBytes = arguments.bytes;
  String? blurhash;

  var originalWidth = 0;
  var originalHeight = 0;
  var width = 0;
  var height = 0;

  try {
    // for the other platforms
    final dartCodec = await instantiateImageCodec(arguments.bytes);
    final frameCount = dartCodec.frameCount;
    final dartFrame = await dartCodec.getNextFrame();
    final rgbaData = await dartFrame.image.toByteData();
    if (rgbaData == null) {
      return null;
    }
    final rgba = Uint8List.view(
      rgbaData.buffer,
      rgbaData.offsetInBytes,
      rgbaData.lengthInBytes,
    );

    width = originalWidth = dartFrame.image.width;
    height = originalHeight = dartFrame.image.height;

    var nativeImg = native.Image.fromRGBA(width, height, rgba);

    dartFrame.image.dispose();
    dartCodec.dispose();

    if (arguments.calcBlurhash) {
      // scale down image for blurhashing to speed it up
      final (blurW, blurH) = _scaleToBox(width, height, boxSize: 100);
      final blurhashImg = nativeImg.resample(
        blurW, blurH,
        // nearest is unsupported...
        native.Transform.bilinear,
      );

      blurhash = blurhashImg.toBlurhash(3, 3);

      blurhashImg.free();
    }

    if (frameCount > 1) {
      // Don't scale down animated images, since those would lose frames.
      nativeImg.free();
    } else {
      final max = arguments.maxDimension;
      if (width > max || height > max) {
        (width, height) = _scaleToBox(width, height, boxSize: max);

        final scaledImg =
            nativeImg.resample(width, height, native.Transform.lanczos);
        nativeImg.free();
        nativeImg = scaledImg;
      }

      imageBytes = await nativeImg.toJpeg(75);
      nativeImg.free();
    }
  } catch (e, s) {
    Logs().e("Could not generate preview", e, s);
  }

  return MatrixImageFileResizedResponse(
    bytes: imageBytes,
    width: width,
    height: height,
    originalWidth: originalWidth,
    originalHeight: originalHeight,
    blurhash: blurhash,
  );
}
