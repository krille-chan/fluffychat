import 'package:matrix/matrix.dart';

extension FileDescriptionExtension on Event {
  String? get fileDescription {
    if (!{
      MessageTypes.File,
      MessageTypes.Image,
      MessageTypes.Sticker,
      MessageTypes.Video,
      MessageTypes.Audio,
    }.contains(messageType)) {
      return null;
    }
    final filename = content.tryGet<String>('filename');
    final body = calcUnlocalizedBody(hideReply: true, plaintextBody: true);

    if (filename != body &&
        filename != null &&
        content.tryGet<String>('body')?.isNotEmpty == true) {
      return body;
    }
    return null;
  }
}
