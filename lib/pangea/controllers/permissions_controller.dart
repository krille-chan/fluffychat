import 'package:fluffychat/pangea/constants/age_limits.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/models/user_model.dart';
import 'package:fluffychat/pangea/utils/p_extension.dart';
import 'package:matrix/matrix.dart';

class PermissionsController extends BaseController {
  late PangeaController _pangeaController;

  PermissionsController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  Room? _getRoomById(String? roomId) => roomId == null
      ? null
      : _pangeaController.matrixState.client.getRoomById(roomId);

  PangeaRoomRules? _getRoomRules(String? roomId) =>
      roomId == null ? null : _getRoomById(roomId)?.firstRules;

  Room? firstRoomWithState({required String? roomID, required String type}) {
    final Room? room = _getRoomById(roomID);

    return room?.pangeaRoomRules != null
        ? room
        : room?.firstParentWithState(type);
  }

  /// Returns false if user is null
  bool isUser18() {
    final dob = _pangeaController.pStoreService.read(
      MatrixProfile.dateOfBirth.title,
    );
    return dob != null
        ? DateTime.parse(dob).isAtLeastYearsOld(AgeLimits.toAccessFeatures)
        : false;
  }

  /// A user can private chat if
  /// 1) they are 18 and outside a class context or
  /// 2) they are in a class context and the class rules permit it
  /// If no class is passed, uses classController.activeClass
  bool canUserPrivateChat({String? roomID}) {
    final Room? classContext =
        firstRoomWithState(roomID: roomID, type: PangeaEventTypes.rules);
    return classContext?.pangeaRoomRules == null
        ? isUser18()
        : classContext!.pangeaRoomRules!.oneToOneChatClass ||
            classContext.isRoomAdmin;
  }

  bool canUserGroupChat({String? roomID}) {
    final Room? classContext =
        firstRoomWithState(roomID: roomID, type: PangeaEventTypes.rules);

    return classContext?.pangeaRoomRules == null
        ? isUser18()
        : classContext!.pangeaRoomRules!.isCreateRooms ||
            classContext.isRoomAdmin;
  }

  bool showChatInputAddButton(String roomId) {
    final PangeaRoomRules? perms = _getRoomRules(roomId);
    if (perms == null) return isUser18();
    return perms.isShareFiles ||
        perms.isShareLocation ||
        perms.isSharePhoto ||
        perms.isShareVideo;
  }

  /// works for both roomID of chat and class
  bool canShareVideo(String? roomID) =>
      _getRoomRules(roomID)?.isShareVideo ?? isUser18();

  /// works for both roomID of chat and class
  bool canSharePhoto(String? roomID) =>
      _getRoomRules(roomID)?.isSharePhoto ?? isUser18();

  /// works for both roomID of chat and class
  bool canShareFile(String? roomID) =>
      _getRoomRules(roomID)?.isShareFiles ?? isUser18();

  /// works for both roomID of chat and class
  bool canShareLocation(String? roomID) =>
      _getRoomRules(roomID)?.isShareLocation ?? isUser18();

  int? classLanguageToolPermission(Room room, ToolSetting setting) =>
      room.firstRules?.getToolSettings(setting);

  //what happens if a room isn't in a class?
  bool isToolDisabledByClass(ToolSetting setting, Room? room) {
    if (room?.isSpaceAdmin ?? false) return false;
    final int? classPermission =
        room != null ? classLanguageToolPermission(room, setting) : 1;
    return classPermission == 0;
  }

  bool userToolSetting(ToolSetting setting) =>
      _pangeaController.localSettings.userLanguageToolSetting(setting);

  bool isToolEnabled(ToolSetting setting, Room? room) {
    if (room?.isSpaceAdmin ?? false) {
      return userToolSetting(setting);
    }
    final int? classPermission =
        room != null ? classLanguageToolPermission(room, setting) : 1;
    if (classPermission == 0) return false;
    if (classPermission == 2) return true;
    return userToolSetting(setting);
  }

  bool isWritingAssistanceEnabled(Room? room) {
    return isToolEnabled(ToolSetting.interactiveTranslator, room) &&
        isToolEnabled(ToolSetting.interactiveGrammar, room);
  }
}
