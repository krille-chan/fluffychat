import 'package:fluffychat/pangea/choreographer/controllers/it_controller.dart';

class MlController {
  final ITController controller;
  MlController(this.controller);

  // sendPayloads(String message, String messageId) async {
  //   final MessageServiceModel serviceModel = MessageServiceModel(
  //     classId: controller.state!.classId,
  //     roomId: controller.state!.roomId,
  //     message: message.toString(),
  //     messageId: messageId.toString(),
  //     payloadIds: controller.state!.payLoadIds,
  //     userId: controller.state!.userId!,
  //     l1Lang: controller.state!.sourceLangCode,
  //     l2Lang: controller.state!.targetLangCode!,
  //   );
  //   try {
  //     await MessageServiceRepo.sendPayloads(serviceModel);
  //   } catch (err) {
  //     debugPrint('$err in sendPayloads');
  //   }
  // }
}
