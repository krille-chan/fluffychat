// Project imports:
import '../config/environment.dart';
import '../network/requests.dart';
import '../network/urls.dart';

class MessageServiceRepo {
  static Future<void> sendPayloads(
      MessageServiceModel serviceModel, String messageId) async {
    final Requests req = Requests(
        baseUrl: PApiUrls.choreoBaseApi,
        choreoApiKey: Environment.choreoApiKey);

    final json = serviceModel.toJson();
    json["msg_id"] = messageId;

    await req.post(url: PApiUrls.messageService, body: json);
  }
}

class MessageServiceModel {
  List<int> payloadIds;
  String? messageId;
  String message;
  String userId;
  String roomId;
  String? classId;
  String? l1Lang;
  String l2Lang;

  MessageServiceModel({
    required this.payloadIds,
    required this.messageId,
    required this.message,
    required this.userId,
    required this.roomId,
    required this.classId,
    required this.l1Lang,
    required this.l2Lang,
  });

  toJson() {
    return {
      'payload_ids': payloadIds,
      'msg_id': messageId,
      'message': message,
      'user_id': userId,
      'room_id': roomId,
      'class_id': classId,
      'l1_lang': l1Lang,
      'l2_lang': l2Lang,
    };
  }
}
