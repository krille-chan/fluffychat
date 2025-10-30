import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';

extension BotRoomExtension on Room {
  BotOptionsModel? get botOptions {
    if (isSpace) return null;
    final stateEvent = getState(PangeaEventTypes.botOptions);
    if (stateEvent == null) return null;
    return BotOptionsModel.fromJson(stateEvent.content);
  }

  Future<void> setBotOptions(BotOptionsModel options) =>
      client.setRoomStateWithKey(
        id,
        PangeaEventTypes.botOptions,
        '',
        options.toJson(),
      );
}
