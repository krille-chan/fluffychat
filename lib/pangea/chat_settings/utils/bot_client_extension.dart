import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/chat_settings/constants/bot_mode.dart';
import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';

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

  Future<String> startChatWithBot() => startDirectChat(
        BotName.byEnvironment,
        preset: CreateRoomPreset.trustedPrivateChat,
        initialState: [
          BotOptionsModel(mode: BotMode.directChat).toStateEvent,
          RoomDefaults.defaultPowerLevels(
            userID!,
          ),
        ],
      );
}
