import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/constants/age_limits.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/utils/p_extension.dart';

class PermissionsController extends BaseController {
  late PangeaController _pangeaController;

  PermissionsController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  Room? _getRoomById(String? roomId) => roomId == null
      ? null
      : _pangeaController.matrixState.client.getRoomById(roomId);

  Room? firstRoomWithState({required String? roomID, required String type}) {
    final Room? room = _getRoomById(roomID);

    return room?.pangeaRoomRules != null
        ? room
        : room?.firstParentWithState(type);
  }

  /// Returns false if user is null
  bool isUser18() {
    final DateTime? dob =
        _pangeaController.userController.profile.userSettings.dateOfBirth;
    return dob?.isAtLeastYearsOld(AgeLimits.toAccessFeatures) ?? false;
  }

  /// A user can private chat if they are 18+
  bool canUserPrivateChat({String? roomID}) {
    return isUser18();
    // Rules can't be edited; default to true
    // final Room? classContext =
    //     firstRoomWithState(roomID: roomID, type: PangeaEventTypes.rules);
    // return classContext?.pangeaRoomRules == null
    //     ? isUser18()
    //     : classContext!.pangeaRoomRules!.oneToOneChatClass ||
    //         classContext.isRoomAdmin;
  }

  bool canUserGroupChat({String? roomID}) {
    return isUser18();
    // Rules can't be edited; default to true
    // final Room? classContext =
    //     firstRoomWithState(roomID: roomID, type: PangeaEventTypes.rules);

    // return classContext?.pangeaRoomRules == null
    //     ? isUser18()
    //     : classContext!.pangeaRoomRules!.isCreateRooms ||
    //         classContext.isRoomAdmin;
  }

  bool showChatInputAddButton(String roomId) {
    // Rules can't be edited; default to true
    // final PangeaRoomRules? perms = _getRoomRules(roomId);
    // if (perms == null) return isUser18();
    // return perms.isShareFiles ||
    //     perms.isShareLocation ||
    //     perms.isSharePhoto ||
    //     perms.isShareVideo;
    return isUser18();
  }

  /// works for both roomID of chat and class
  bool canShareVideo(String? roomID) => isUser18();
  // Rules can't be edited; default to true
  // _getRoomRules(roomID)?.isShareVideo ?? isUser18();

  /// works for both roomID of chat and class
  bool canSharePhoto(String? roomID) => true;
  // Rules can't be edited; default to true
  // _getRoomRules(roomID)?.isSharePhoto ?? isUser18();

  /// works for both roomID of chat and class
  bool canShareFile(String? roomID) => true;
  // Rules can't be edited; default to true
  // _getRoomRules(roomID)?.isShareFiles ?? isUser18();

  /// works for both roomID of chat and class
  bool canShareLocation(String? roomID) => isUser18();
  // Rules can't be edited; default to true
  // _getRoomRules(roomID)?.isShareLocation ?? isUser18();

  int? classLanguageToolPermission(Room room, ToolSetting setting) => 1;
  // Rules can't be edited; default to student choice
  // room.firstRules?.getToolSettings(setting);

  // what happens if a room isn't in a class?
  bool isToolDisabledByClass(ToolSetting setting, Room? room) {
    return false;
    // Rules can't be edited; default to false
    // if (room?.isSpaceAdmin ?? false) return false;
    // final int? classPermission =
    //     room != null ? classLanguageToolPermission(room, setting) : 1;
    // return classPermission == 0;
  }

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
