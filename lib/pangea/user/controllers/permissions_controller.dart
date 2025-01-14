import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/controllers/base_controller.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/spaces/models/space_model.dart';

class PermissionsController extends BaseController {
  late PangeaController _pangeaController;

  PermissionsController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  /// Returns false if user is null
  bool isUser18() {
    final DateTime? dob =
        _pangeaController.userController.profile.userSettings.dateOfBirth;
    if (dob == null) return false;
    final today = DateTime.now();
    final age = today.year - dob.year;

    // Check if the birthday has occurred yet this year
    final hasHadBirthdayThisYear = (today.month > dob.month) ||
        (today.month == dob.month && today.day >= dob.day);

    // Return true if they are 18 or older
    return age > 18 || (age == 18 && hasHadBirthdayThisYear);
  }

  bool canShareVideo(String? roomID) => isUser18();

  bool canSharePhoto(String? roomID) => true;

  bool canShareFile(String? roomID) => true;

  bool canShareLocation(String? roomID) => isUser18();

  bool userToolSetting(ToolSetting setting) {
    switch (setting) {
      case ToolSetting.interactiveTranslator:
        return _pangeaController
            .userController.profile.toolSettings.interactiveTranslator;
      case ToolSetting.interactiveGrammar:
        return _pangeaController
            .userController.profile.toolSettings.interactiveGrammar;
      case ToolSetting.immersionMode:
        return _pangeaController
            .userController.profile.toolSettings.immersionMode;
      case ToolSetting.definitions:
        return _pangeaController
            .userController.profile.toolSettings.definitions;
      case ToolSetting.autoIGC:
        return _pangeaController.userController.profile.toolSettings.autoIGC;
      default:
        return false;
    }
  }

  bool isToolEnabled(ToolSetting setting, Room? room) {
    // Rules can't be edited; default to true
    return userToolSetting(setting);
    // if (room?.isSpaceAdmin ?? false) {
    //   return userToolSetting(setting);
    // }
    // final int? classPermission =
    //     room != null ? classLanguageToolPermission(room, setting) : 1;
    // if (classPermission == 0) return false;
    // if (classPermission == 2) return true;
    // return userToolSetting(setting);
  }

  bool isWritingAssistanceEnabled(Room? room) {
    // Rules can't be edited; default to true
    return true;
    // return isToolEnabled(ToolSetting.interactiveTranslator, room) &&
    //     isToolEnabled(ToolSetting.interactiveGrammar, room);
  }
}
