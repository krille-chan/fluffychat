// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';
import 'package:native_imaging/native_imaging.dart' as native;
import 'package:path_provider/path_provider.dart';

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
  var imageBytes = arguments.bytes;
  if (PlatformInfos.isMobile) {
    final mimeType = lookupMimeType(arguments.fileName);
    if (mimeType == 'image/heic') {
      Logs().d('Convert heic file to jpeg before sending...');
      final tmpDir = await getTemporaryDirectory();
      final file = XFile.fromData(arguments.bytes, name: arguments.fileName);
      await file.saveTo('${tmpDir.path}/${arguments.fileName}');
      final outputPath = await HeifConverter.convert(
        '${tmpDir.path}/${arguments.fileName}.jpg',
        format: 'jpg',
      );
      if (outputPath != null) {
        imageBytes = await XFile(outputPath).readAsBytes();
      }
    }
  }

  await native.init();

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
        blurW,
        blurH,
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

        final scaledImg = nativeImg.resample(
          width,
          height,
          native.Transform.lanczos,
        );
        nativeImg.free();
        nativeImg = scaledImg;
      }

      imageBytes = await nativeImg.toJpeg(75);
      nativeImg.free();
    }
  } catch (e, s) {
    Logs().e('Could not generate preview', e, s);
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
