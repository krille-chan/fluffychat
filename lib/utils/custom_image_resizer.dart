import 'package:matrix/matrix.dart';
import 'package:native_imaging/native_imaging.dart' as native;

Future<MatrixImageFileResizedResponse?> customImageResizer(
    MatrixImageFileResizeArguments arguments) async {
  await native.init();
  var nativeImg = await native.Image.loadEncoded(arguments.bytes);

  final width = nativeImg.width;
  final height = nativeImg.height;
  final max = arguments.maxDimension;
  if (width > max || height > max) {
    var w = max, h = max;
    if (width > height) {
      h = max * height ~/ width;
    } else {
      w = max * width ~/ height;
    }

    final scaledImg = nativeImg.resample(w, h, native.Transform.lanczos);
    nativeImg.free();
    nativeImg = scaledImg;
  }
  final jpegBytes = await nativeImg.toJpeg(75);

  return MatrixImageFileResizedResponse(
    bytes: jpegBytes,
    width: nativeImg.width,
    height: nativeImg.height,
    blurhash: arguments.calcBlurhash ? nativeImg.toBlurhash(3, 3) : null,
  );
}
