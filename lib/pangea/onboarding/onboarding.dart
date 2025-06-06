import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/chat_settings/constants/bot_mode.dart';
import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/onboarding/onboarding_steps_enum.dart';
import 'package:fluffychat/pangea/onboarding/onboarding_view.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  OnboardingController createState() => OnboardingController();
}

class OnboardingController extends State<Onboarding> {
  static final GetStorage _onboardingStorage = GetStorage('onboarding_storage');

  static bool get isClosed => _onboardingStorage.read('closed') ?? false;

  static bool get isComplete => OnboardingStepsEnum.values.every(
        (step) => complete(step),
      );

  static bool complete(OnboardingStepsEnum step) {
    switch (step) {
      case OnboardingStepsEnum.chatWithBot:
        return hasBotDM;
      case OnboardingStepsEnum.joinSpace:
        return MatrixState.pangeaController.matrixState.client.rooms.any(
          (r) => r.isSpace,
        );
      case OnboardingStepsEnum.inviteFriends:
        return hasInvitedFriends;
    }
  }

  static bool get hasInvitedFriends =>
      _onboardingStorage.read('invite_friends') ?? false;

  static bool get hasBotDM =>
      MatrixState.pangeaController.matrixState.client.rooms.any((room) {
        if (room.isDirectChat &&
            room.directChatMatrixID == BotName.byEnvironment) {
          return true;
        }
        if (room.botOptions?.mode == BotMode.directChat) {
          return true;
        }
        return false;
      });

  Future<void> closeCompletedMessage() async {
    await _onboardingStorage.write('closed', true);
    if (mounted) setState(() {});
  }

  Future<void> inviteFriends() async {
    FluffyShare.shareInviteLink(context);
    await _onboardingStorage.write('invite_friends', true);
    if (mounted) setState(() {});
  }

  Future<void> startChatWithBot() async {
    final resp = await showFutureLoadingDialog<String>(
      context: context,
      future: () => Matrix.of(context).client.createRoom(
            invite: [BotName.byEnvironment],
            isDirect: true,
            preset: CreateRoomPreset.trustedPrivateChat,
            initialState: [
              BotOptionsModel(mode: BotMode.directChat).toStateEvent,
              RoomDefaults.defaultPowerLevels(
                Matrix.of(context).client.userID!,
              ),
            ],
          ),
    );
    if (resp.isError) return;
    context.go("/rooms/${resp.result}");
  }

  void joinCommunities() {
    context.go('/rooms/communities');
  }

  Future<void> onPressed(OnboardingStepsEnum step) async {
    switch (step) {
      case OnboardingStepsEnum.chatWithBot:
        return startChatWithBot();
      case OnboardingStepsEnum.joinSpace:
        return joinCommunities();
      case OnboardingStepsEnum.inviteFriends:
        return inviteFriends();
    }
  }

  @override
  Widget build(BuildContext context) => OnboardingView(controller: this);
}
