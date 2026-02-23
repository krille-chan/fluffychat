import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';
import 'package:meta/meta.dart';

import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/bot/utils/bot_room_extension.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/chat_settings/constants/bot_mode.dart';
import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/learning_settings/gender_enum.dart';
import 'package:fluffychat/pangea/user/user_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Builds updated [BotOptionsModel] if any bot-relevant user setting differs
/// from [currentOptions]. Returns null when no changes are needed.
@visibleForTesting
BotOptionsModel? buildUpdatedBotOptions({
  required BotOptionsModel? currentOptions,
  required UserSettings userSettings,
  required String? userId,
}) {
  final botOptions = currentOptions ?? const BotOptionsModel();
  final targetLanguage = userSettings.targetLanguage;
  final languageLevel = userSettings.cefrLevel;
  final voice = userSettings.voice;
  final gender = userSettings.gender;

  if (botOptions.targetLanguage == targetLanguage &&
      botOptions.languageLevel == languageLevel &&
      botOptions.targetVoice == voice &&
      botOptions.userGenders[userId] == gender) {
    return null;
  }

  final updatedGenders = Map<String, GenderEnum>.from(botOptions.userGenders);
  if (userId != null && updatedGenders[userId] != gender) {
    updatedGenders[userId] = gender;
  }

  return botOptions.copyWith(
    targetLanguage: targetLanguage,
    languageLevel: languageLevel,
    targetVoice: voice,
    userGenders: updatedGenders,
  );
}

/// Executes async update functions in priority order:
/// 1. [priorityUpdate] runs first — errors propagate to the caller.
/// 2. [remainingUpdates] run sequentially — errors go to [onError].
///
/// This ensures the bot DM (most important room) is updated first and
/// rate-limiting from parallel requests doesn't block it.
@visibleForTesting
Future<void> applyBotOptionUpdatesInOrder({
  required Future<void> Function()? priorityUpdate,
  required List<Future<void> Function()> remainingUpdates,
  void Function(Object error, StackTrace stack)? onError,
}) async {
  if (priorityUpdate != null) {
    await priorityUpdate();
  }

  for (final update in remainingUpdates) {
    try {
      await update();
    } catch (e, s) {
      onError?.call(e, s);
    }
  }
}

extension BotClientExtension on Client {
  bool get hasBotDM => rooms.any((r) => r.isBotDM);
  Room? get botDM => rooms.firstWhereOrNull((r) => r.isBotDM);

  // All 2-member rooms with the bot
  List<Room> get _targetBotChats => rooms.where((r) {
    return
    // bot settings exist
    r.botOptions != null &&
        // there is no activity plan
        !r.showActivityChatUI &&
        // it's just the bot and one other user in the room
        r.summary.mJoinedMemberCount == 2 &&
        r.getParticipants().any((u) => u.id == BotName.byEnvironment);
  }).toList();

  Future<String> startChatWithBot() => startDirectChat(
    BotName.byEnvironment,
    preset: CreateRoomPreset.trustedPrivateChat,
    initialState: [
      StateEvent(
        content: BotOptionsModel(
          mode: BotMode.directChat,
          targetLanguage:
              MatrixState.pangeaController.userController.userL2?.langCode,
          languageLevel: MatrixState
              .pangeaController
              .userController
              .profile
              .userSettings
              .cefrLevel,
        ).toJson(),
        type: PangeaEventTypes.botOptions,
      ),
      RoomDefaults.defaultPowerLevels(userID!),
    ],
  );

  Future<void> updateBotOptions(UserSettings userSettings) async {
    final dm = botDM;
    Future<void> Function()? dmUpdate;

    // Handle the bot DM independently of _targetBotChats.
    // The DM may not pass _targetBotChats filters (e.g., botOptions is null,
    // or a stale activityPlan state event exists), but it's the most important
    // room to keep current.
    if (dm != null) {
      final updated = buildUpdatedBotOptions(
        currentOptions: dm.botOptions,
        userSettings: userSettings,
        userId: userID,
      );
      if (updated != null) {
        dmUpdate = () => dm.setBotOptions(updated);
      }
    }

    // Remaining eligible rooms, excluding the DM (already handled above).
    final otherUpdates = <Future<void> Function()>[];
    for (final room in _targetBotChats) {
      if (room == dm) continue;

      final updated = buildUpdatedBotOptions(
        currentOptions: room.botOptions,
        userSettings: userSettings,
        userId: userID,
      );
      if (updated == null) continue;

      otherUpdates.add(() => room.setBotOptions(updated));
    }

    if (dmUpdate == null && otherUpdates.isEmpty) return;

    await applyBotOptionUpdatesInOrder(
      priorityUpdate: dmUpdate,
      remainingUpdates: otherUpdates,
      onError: (e, s) => ErrorHandler.logError(
        e: e,
        s: s,
        data: {'userSettings': userSettings.toJson()},
      ),
    );
  }
}
