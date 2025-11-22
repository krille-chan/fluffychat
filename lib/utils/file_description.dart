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
    final formattedBody = content.tryGet<String>('formatted_body');
    if (formattedBody != null && formattedBody.isNotEmpty) return formattedBody;

    final filename = content.tryGet<String>('filename');
    final body = content.tryGet<String>('body');
    if (filename != body &&
        body != null &&
        filename != null &&
        body.isNotEmpty) {
      return body;
    }
    return null;
  }
}
