import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/learning_settings/language_mismatch_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

extension ActivityMenuLogic on ChatController {
  bool get shouldShowActivityInstructions {
    if (InstructionsEnum.showedActivityMenu.isToggledOff ||
        InstructionsEnum.activityStatsMenu.isToggledOff ||
        MatrixState.pAnyState.isOverlayOpen(
          regex: RegExp(r"^word-zoom-card-.*$"),
        ) ||
        timeline == null ||
        GoRouterState.of(context).fullPath?.endsWith(':roomid') != true) {
      return false;
    }

    final userID = Matrix.of(context).client.userID!;
    final activityRoles = room.activityRoles?.roles.values ?? [];
    final finishedRoles = activityRoles.where((r) => r.isFinished);

    if (finishedRoles.isNotEmpty) {
      return !finishedRoles.any((r) => r.userId == userID);
    }

    final count = timeline!.events
        .where(
          (event) =>
              event.senderId == userID &&
              event.type == EventTypes.Message &&
              {
                MessageTypes.Text,
                MessageTypes.Audio,
              }.contains(event.messageType),
        )
        .length;

    return count >= 3;
  }

  bool get shouldShowLanguageMismatchPopupByActivity {
    if (!LanguageMismatchRepo.shouldShowByRoom(roomId)) {
      return false;
    }

    final l1 =
        MatrixState.pangeaController.userController.userL1?.langCodeShort;
    final l2 =
        MatrixState.pangeaController.userController.userL2?.langCodeShort;

    final activityLang = room.activityPlan?.req.targetLanguage.split('-').first;
    return activityLang != null && activityLang != l1 && l2 != activityLang;
  }
}
