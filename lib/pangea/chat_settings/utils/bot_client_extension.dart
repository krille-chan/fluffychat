import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/bot/utils/bot_room_extension.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/chat_settings/constants/bot_mode.dart';
import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/widgets/matrix.dart';

extension BotClientExtension on Client {
  bool get hasBotDM => rooms.any((room) {
        if (room.isDirectChat &&
            room.directChatMatrixID == BotName.byEnvironment) {
          return true;
        }
        if (room.botOptions?.mode == BotMode.directChat) {
          return true;
        }
        return false;
      });

  Room? get botDM => rooms.firstWhereOrNull(
        (room) {
          if (room.isDirectChat &&
              room.directChatMatrixID == BotName.byEnvironment) {
            return true;
          }
          if (room.botOptions?.mode == BotMode.directChat) {
            return true;
          }
          return false;
        },
      );

  Future<String> startChatWithBot() => startDirectChat(
        BotName.byEnvironment,
        preset: CreateRoomPreset.trustedPrivateChat,
        initialState: [
          StateEvent(
            content: BotOptionsModel(
              mode: BotMode.directChat,
              targetLanguage: MatrixState
                  .pangeaController.languageController.userL2?.langCode,
              languageLevel: MatrixState.pangeaController.userController.profile
                  .userSettings.cefrLevel,
            ).toJson(),
            type: PangeaEventTypes.botOptions,
          ),
          RoomDefaults.defaultPowerLevels(
            userID!,
          ),
        ],
      );
}
