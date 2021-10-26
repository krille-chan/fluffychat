import 'dart:typed_data';
import 'dart:ui';

import 'package:matrix/matrix.dart';
import 'package:native_imaging/native_imaging.dart' as native;

import 'run_in_background.dart';

const int defaultMax = 800;

Future<MatrixImageFile> resizeImage(MatrixImageFile file,
    {int max = defaultMax}) async {
  // we want to resize the image in a separate isolate, because otherwise that can
  // freeze up the UI a bit

  // we can't do width / height fetching in a separate isolate, as that may use the UI stuff

  // somehow doing native.init twice fixes it for linux desktop?
  // TODO: once native imaging is on sound null safety the errors are consistent and
  // then we can properly handle this instead
  // https://gitlab.com/famedly/company/frontend/libraries/native_imaging/-/issues/5
  try {
    await native.init();
  } catch (_) {
    await native.init();
  }

  _IsolateArgs args;
  try {
    final nativeImg = native.Image();
    await nativeImg.loadEncoded(file.bytes);
    file.width = nativeImg.width;
    file.height = nativeImg.height;
    args = _IsolateArgs(
        width: file.width, height: file.height, bytes: file.bytes, max: max);
    nativeImg.free();
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
    args = _IsolateArgs(
        width: file.width, height: file.height, bytes: rgba, max: max);
  }

  final res = await runInBackground(_isolateFunction, args);
  file.blurhash = res.blurhash;
  final thumbnail = MatrixImageFile(
    bytes: res.jpegBytes,
    name: file.name != null
        ? 'scaled_' + file.name.split('.').first + '.jpg'
        : 'thumbnail.jpg',
    mimeType: 'image/jpeg',
    width: res.width,
    height: res.height,
    blurhash: res.blurhash,
  );
  // only return the thumbnail if the size actually decreased
  return thumbnail.size >= file.size ||
          thumbnail.width >= file.width ||
          thumbnail.height >= file.height
      ? file
      : thumbnail;
}

class _IsolateArgs {
  final int width;
  final int height;
  final Uint8List bytes;
  final int max;
  final String name;
  _IsolateArgs({this.width, this.height, this.bytes, this.max, this.name});
}

class _IsolateResponse {
  final String blurhash;
  final Uint8List jpegBytes;
  final int width;
  final int height;
  _IsolateResponse({this.blurhash, this.jpegBytes, this.width, this.height});
}

Future<_IsolateResponse> _isolateFunction(_IsolateArgs args) async {
  // Hack for desktop, see above why
  try {
    await native.init();
  } catch (_) {
    await native.init();
  }
  var nativeImg = native.Image();

  try {
    await nativeImg.loadEncoded(args.bytes);
  } on UnsupportedError {
    nativeImg.loadRGBA(args.width, args.height, args.bytes);
  }
  if (args.width > args.max || args.height > args.max) {
    var w = args.max, h = args.max;
    if (args.width > args.height) {
      h = args.max * args.height ~/ args.width;
    } else {
      w = args.max * args.width ~/ args.height;
    }

    final scaledImg = nativeImg.resample(w, h, native.Transform.lanczos);
    nativeImg.free();
    nativeImg = scaledImg;
  }
  final jpegBytes = await nativeImg.toJpeg(75);
  final blurhash = nativeImg.toBlurhash(3, 3);

  final ret = _IsolateResponse(
      blurhash: blurhash,
      jpegBytes: jpegBytes,
      width: nativeImg.width,
      height: nativeImg.height);

  nativeImg.free();

  return ret;
}
