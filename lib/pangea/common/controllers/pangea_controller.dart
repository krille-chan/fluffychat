import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:get_storage/get_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/get_analytics_controller.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/constants/bot_mode.dart';
import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/choreographer/controllers/contextual_definition_controller.dart';
import 'package:fluffychat/pangea/choreographer/controllers/word_net_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/controllers/message_data_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/guard/p_vguard.dart';
import 'package:fluffychat/pangea/learning_settings/controllers/language_controller.dart';
import 'package:fluffychat/pangea/learning_settings/utils/language_list_util.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/pangea/spaces/controllers/space_controller.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/toolbar/controllers/practice_activity_record_controller.dart';
import 'package:fluffychat/pangea/toolbar/controllers/speech_to_text_controller.dart';
import 'package:fluffychat/pangea/toolbar/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/user/controllers/permissions_controller.dart';
import 'package:fluffychat/pangea/user/controllers/user_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../config/app_config.dart';
import '../../choreographer/controllers/it_feedback_controller.dart';
import '../utils/firebase_analytics.dart';

class PangeaController {
  ///pangeaControllers
  late UserController userController;
  late LanguageController languageController;
  late ClassController classController;
  late PermissionsController permissionsController;
  late GetAnalyticsController getAnalytics;
  late PutAnalyticsController putAnalytics;
  late WordController wordNet;
  late MessageDataController messageData;

  // TODO: make these static so we can remove from here
  late ContextualDefinitionController definitions;
  late ITFeedbackController itFeedback;
  late SubscriptionController subscriptionController;
  late TextToSpeechController textToSpeech;
  late SpeechToTextController speechToText;
  late PracticeActivityRecordController activityRecordController;

  ///store Services
  final pLanguageStore = PangeaLanguage();

  StreamSubscription? _languageStream;

  ///Matrix Variables
  MatrixState matrixState;
  Matrix matrix;

  int? randomint;
  PangeaController({required this.matrix, required this.matrixState}) {
    _setup();
    _subscribeToStreams();
    randomint = Random().nextInt(2000);
  }

  /// Pangea Initialization
  void _setup() {
    _addRefInObjects();
  }

  /// Initializes various controllers and settings.
  /// While many of these functions are asynchronous, they are not awaited here,
  /// because of order of execution does not matter,
  /// and running them at the same times speeds them up.
  void initControllers() {
    putAnalytics.initialize();
    getAnalytics.initialize();
    subscriptionController.initialize();

    startChatWithBotIfNotPresent();
    inviteBotToExistingSpaces();
    setPangeaPushRules();
    // joinSupportSpace();
  }

  /// Initialize controllers
  _addRefInObjects() {
    userController = UserController(this);
    languageController = LanguageController(this);
    classController = ClassController(this);
    permissionsController = PermissionsController(this);
    getAnalytics = GetAnalyticsController(this);
    putAnalytics = PutAnalyticsController(this);
    messageData = MessageDataController(this);
    wordNet = WordController(this);
    definitions = ContextualDefinitionController(this);
    subscriptionController = SubscriptionController(this);
    itFeedback = ITFeedbackController(this);
    textToSpeech = TextToSpeechController(this);
    speechToText = SpeechToTextController(this);
    activityRecordController = PracticeActivityRecordController();
    PAuthGaurd.pController = this;
  }

  _logOutfromPangea() {
    debugPrint("Pangea logout");
    GoogleAnalytics.logout();
    _clearCachedData();
  }

  void _clearCachedData() {
    GetStorage('mode_list_storage').erase();
    GetStorage('activity_plan_storage').erase();
    GetStorage('bookmarked_activities').erase();
    GetStorage('objective_list_storage').erase();
    GetStorage('topic_list_storage').erase();
    GetStorage('lemma_storage').erase();
    GetStorage().erase();
  }

  Future<void> checkHomeServerAction() async {
    if (matrixState.getLoginClient().homeserver != null) {
      await Future.delayed(Duration.zero);
      return;
    }

    final String homeServer =
        AppConfig.defaultHomeserver.trim().toLowerCase().replaceAll(' ', '-');
    var homeserver = Uri.parse(homeServer);
    if (homeserver.scheme.isEmpty) {
      homeserver = Uri.https(homeServer, '');
    }

    try {
      await matrixState.getLoginClient().register();
      matrixState.loginRegistrationSupported = true;
    } on MatrixException catch (e) {
      matrixState.loginRegistrationSupported =
          e.requireAdditionalAuthentication;
    }

    //  setState(() => error = (e).toLocalizedString(context));
  }

  /// check user information if not found then redirect to Date of birth page
  _handleLoginStateChange(LoginState state) {
    switch (state) {
      case LoginState.loggedOut:
      case LoginState.softLoggedOut:
        // Reset cached analytics data
        putAnalytics.dispose();
        getAnalytics.dispose();
        userController.clear();
        _languageStream?.cancel();
        break;
      case LoginState.loggedIn:
        // Initialize analytics data
        putAnalytics.initialize();
        getAnalytics.initialize();
        break;
    }
    if (state != LoginState.loggedIn) {
      _logOutfromPangea();
    }
    Sentry.configureScope(
      (scope) => scope.setUser(
        SentryUser(
          id: matrixState.client.userID,
          name: matrixState.client.userID,
        ),
      ),
    );
    GoogleAnalytics.analyticsUserUpdate(matrixState.client.userID);
  }

  Future<void> resetAnalytics() async {
    putAnalytics.dispose();
    getAnalytics.dispose();
    putAnalytics.initialize();
    await getAnalytics.initialize();
  }

  void startChatWithBotIfNotPresent() {
    Future.delayed(const Duration(milliseconds: 10000), () async {
      // check if user is logged in
      if (!matrixState.client.isLogged() ||
          matrixState.client.userID == null ||
          matrixState.client.userID == BotName.byEnvironment) {
        return;
      }

      final List<Room> botDMs = [];
      for (final room in matrixState.client.rooms) {
        if (await room.isBotDM) {
          botDMs.add(room);
        }
      }

      if (botDMs.isEmpty) {
        try {
          // Copied from client.dart.startDirectChat
          final directChatRoomId =
              matrixState.client.getDirectChatFromUserId(BotName.byEnvironment);
          if (directChatRoomId != null) {
            final room = matrixState.client.getRoomById(directChatRoomId);
            if (room != null) {
              if (room.membership == Membership.join) {
                return null;
              } else if (room.membership == Membership.invite) {
                // we might already have an invite into a DM room. If that is the case, we should try to join. If the room is
                // unjoinable, that will automatically leave the room, so in that case we need to continue creating a new
                // room. (This implicitly also prevents the room from being returned as a DM room by getDirectChatFromUserId,
                // because it only returns joined or invited rooms atm.)
                await room.join();
                if (room.membership != Membership.leave) {
                  if (room.membership != Membership.join) {
                    // Wait for room actually appears in sync with the right membership
                    await matrixState.client
                        .waitForRoomInSync(directChatRoomId, join: true);
                  }
                  return null;
                }
              }
            }
          }
          // enableEncryption ??=
          //     encryptionEnabled && await userOwnsEncryptionKeys(mxid);
          // if (enableEncryption) {
          //   initialState ??= [];
          //   if (!initialState.any((s) => s.type == EventTypes.Encryption)) {
          //     initialState.add(
          //       StateEvent(
          //         content: {
          //           'algorithm': supportedGroupEncryptionAlgorithms.first,
          //         },
          //         type: EventTypes.Encryption,
          //       ),
          //     );
          //   }
          // }

          // Start a new direct chat
          final roomId = await matrixState.client.createRoom(
            invite: [], // intentionally not invite bot yet
            isDirect: true,
            preset: CreateRoomPreset.trustedPrivateChat,
            initialState: [
              BotOptionsModel(mode: BotMode.directChat).toStateEvent,
            ],
          );

          Room? room = matrixState.client.getRoomById(roomId);
          if (room == null || room.membership != Membership.join) {
            // Wait for room actually appears in sync
            await matrixState.client.waitForRoomInSync(roomId, join: true);
            room = matrixState.client.getRoomById(roomId);
            if (room == null) {
              ErrorHandler.logError(
                e: "Bot chat null after waiting for room in sync",
                data: {
                  "roomId": roomId,
                },
              );
              return null;
            }
          }

          final botOptions = room.getState(PangeaEventTypes.botOptions);
          if (botOptions == null) {
            await matrixState.client.setRoomStateWithKey(
              roomId,
              PangeaEventTypes.botOptions,
              "",
              BotOptionsModel(mode: BotMode.directChat).toJson(),
            );
            await matrixState.client
                .getRoomStateWithKey(roomId, PangeaEventTypes.botOptions, "");
          }

          // invite bot to direct chat
          await matrixState.client.setRoomStateWithKey(
              roomId, EventTypes.RoomMember, BotName.byEnvironment, {
            "membership": Membership.invite.name,
            "is_direct": true,
          });
          await room.addToDirectChat(BotName.byEnvironment);

          return null;
        } catch (err, stack) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(
            e: err,
            s: stack,
            data: {
              "directChatRoomId": matrixState.client
                  .getDirectChatFromUserId(BotName.byEnvironment),
            },
          );
        }
      }

      final Room botDMWithLatestActivity = botDMs.reduce((a, b) {
        if (a.timeline == null ||
            b.timeline == null ||
            a.timeline!.events.isEmpty ||
            b.timeline!.events.isEmpty) {
          return a;
        }
        final aLastEvent = a.timeline!.events.last;
        final bLastEvent = b.timeline!.events.last;
        return aLastEvent.originServerTs.isAfter(bLastEvent.originServerTs)
            ? a
            : b;
      });

      for (final room in botDMs) {
        if (room.id != botDMWithLatestActivity.id) {
          await room.leave();
          continue;
        }
      }

      final participants = await botDMWithLatestActivity.requestParticipants();
      final joinedParticipants =
          participants.where((e) => e.membership == Membership.join).toList();
      if (joinedParticipants.length < 2) {
        await botDMWithLatestActivity.invite(BotName.byEnvironment);
      }
    });
  }

  void _subscribeToStreams() {
    matrixState.client.onLoginStateChanged.stream
        .listen(_handleLoginStateChange);

    // Listen for changes to the user's language settings
    _languageStream ??= userController.stateStream.listen((update) {
      if (update is Map<String, dynamic> &&
          update['prev_target_lang'] != null) {
        _clearCachedData();
      }
    });

    // matrixState.client.onSyncStatus.stream
    //     .where((SyncStatusUpdate event) => event.status == SyncStatus.finished)
    //     .listen(_handleSyncStatusFinished);

    //PTODO - listen to incoming invites and autojoin if in class
    // matrixState.client.onSync.stream
    //     .where((event) => event.rooms?.invite?.isNotEmpty ?? false)
    //     .listen((SyncUpdate event) {
    // });

    // matrixState.client.onSync.stream.listen(_handleOnSyncUpdate);
  }

  Future<void> inviteBotToExistingSpaces() async {
    final List<Room> spaces =
        matrixState.client.rooms.where((room) => room.isSpace).toList();
    for (final Room space in spaces) {
      if (space.ownPowerLevel < SpaceConstants.powerLevelOfAdmin ||
          !space.canInvite) {
        continue;
      }
      List<User> participants;
      try {
        participants = await space.requestParticipants();
      } catch (err) {
        ErrorHandler.logError(
          e: "Failed to fetch participants for space ${space.id}",
          data: {
            "spaceID": space.id,
          },
        );
        continue;
      }
      final List<String> userIds = participants.map((user) => user.id).toList();
      if (!userIds.contains(BotName.byEnvironment)) {
        try {
          await space.invite(BotName.byEnvironment);
        } catch (err) {
          ErrorHandler.logError(
            e: "Failed to invite pangea bot to existing space",
            data: {"spaceId": space.id, "error": err},
          );
        }
      }
    }
  }

  Future<void> setPangeaPushRules() async {
    final List<Room> analyticsRooms =
        matrixState.client.rooms.where((room) => room.isAnalyticsRoom).toList();

    for (final Room room in analyticsRooms) {
      final pushRule = room.pushRuleState;
      if (pushRule != PushRuleState.dontNotify) {
        await room.setPushRuleState(PushRuleState.dontNotify);
      }
    }

    if (!(matrixState.client.globalPushRules?.override?.any(
          (element) => element.ruleId == PangeaEventTypes.textToSpeechRule,
        ) ??
        false)) {
      await matrixState.client.setPushRule(
        PushRuleKind.override,
        PangeaEventTypes.textToSpeechRule,
        [PushRuleAction.dontNotify],
        conditions: [
          PushCondition(
            kind: 'event_match',
            key: 'content.msgtype',
            pattern: MessageTypes.Audio,
          ),
          PushCondition(
            kind: 'event_match',
            key: 'content.transcription.lang_code',
            pattern: '*',
          ),
          PushCondition(
            kind: 'event_match',
            key: 'content.transcription.text',
            pattern: '*',
          ),
        ],
      );
    }
  }

  // /// Joins the user to the support space if they are
  // /// not already a member and have not previously left.
  // Future<void> joinSupportSpace() async {
  //   // if the user is already in the space, return
  //   await matrixState.client.roomsLoading;
  //   final isInSupportSpace = matrixState.client.rooms.any(
  //     (room) => room.id == Environment.supportSpaceId,
  //   );
  //   if (isInSupportSpace) return;

  //   // if the user has previously joined the space, return
  //   final bool previouslyJoined =
  //       userController.profile.userSettings.hasJoinedHelpSpace ?? false;
  //   if (previouslyJoined) return;

  //   // join the space
  //   try {
  //     await matrixState.client.joinRoomById(Environment.supportSpaceId);
  //     final room = matrixState.client.getRoomById(Environment.supportSpaceId);
  //     if (room == null) {
  //       await matrixState.client.waitForRoomInSync(
  //         Environment.supportSpaceId,
  //         join: true,
  //       );
  //     }
  //     userController.updateProfile((profile) {
  //       profile.userSettings.hasJoinedHelpSpace = true;
  //       return profile;
  //     });
  //   } catch (err, s) {
  //     ErrorHandler.logError(e: err, s: s);
  //     return;
  //   }
  // }
}
