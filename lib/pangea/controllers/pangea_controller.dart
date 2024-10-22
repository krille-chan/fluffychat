import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/class_controller.dart';
import 'package:fluffychat/pangea/controllers/contextual_definition_controller.dart';
import 'package:fluffychat/pangea/controllers/get_analytics_controller.dart';
import 'package:fluffychat/pangea/controllers/language_controller.dart';
import 'package:fluffychat/pangea/controllers/language_detection_controller.dart';
import 'package:fluffychat/pangea/controllers/language_list_controller.dart';
import 'package:fluffychat/pangea/controllers/message_data_controller.dart';
import 'package:fluffychat/pangea/controllers/my_analytics_controller.dart';
import 'package:fluffychat/pangea/controllers/permissions_controller.dart';
import 'package:fluffychat/pangea/controllers/practice_activity_generation_controller.dart';
import 'package:fluffychat/pangea/controllers/practice_activity_record_controller.dart';
import 'package:fluffychat/pangea/controllers/speech_to_text_controller.dart';
import 'package:fluffychat/pangea/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/controllers/user_controller.dart';
import 'package:fluffychat/pangea/controllers/word_net_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/guard/p_vguard.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/instructions.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../config/app_config.dart';
import '../utils/firebase_analytics.dart';
import '../utils/p_store.dart';
import 'it_feedback_controller.dart';

class PangeaController {
  ///pangeaControllers
  late UserController userController;
  late LanguageController languageController;
  late ClassController classController;
  late PermissionsController permissionsController;
  // late AnalyticsController analytics;
  late GetAnalyticsController analytics;
  late MyAnalyticsController myAnalytics;
  late WordController wordNet;
  late MessageDataController messageData;
  late ContextualDefinitionController definitions;
  late ITFeedbackController itFeedback;
  late InstructionsController instructions;
  late SubscriptionController subscriptionController;
  late TextToSpeechController textToSpeech;
  late SpeechToTextController speechToText;
  late LanguageDetectionController languageDetection;
  late PracticeActivityRecordController activityRecordController;
  late PracticeGenerationController practiceGenerationController;

  ///store Services
  late PStore pStoreService;
  final pLanguageStore = PangeaLanguage();

  ///Matrix Variables
  MatrixState matrixState;
  Matrix matrix;

  int? randomint;
  PangeaController({required this.matrix, required this.matrixState}) {
    _setup();
    _subscribeToMatrixStreams();
    randomint = Random().nextInt(2000);
  }

  /// Pangea Initialization
  void _setup() {
    _addRefInObjects();
  }

  Future<void> afterSyncAndFirstLoginInitialization(
    BuildContext context,
  ) async {
    await classController.checkForClassCodeAndSubscription(context);
    classController.fixClassPowerLevels();
  }

  /// Initialize controllers
  _addRefInObjects() {
    pStoreService = PStore(pangeaController: this);
    userController = UserController(this);
    languageController = LanguageController(this);
    classController = ClassController(this);
    permissionsController = PermissionsController(this);
    // analytics = AnalyticsController(this);
    analytics = GetAnalyticsController(this);
    myAnalytics = MyAnalyticsController(this);
    messageData = MessageDataController(this);
    wordNet = WordController(this);
    definitions = ContextualDefinitionController(this);
    instructions = InstructionsController(this);
    subscriptionController = SubscriptionController(this);
    itFeedback = ITFeedbackController(this);
    textToSpeech = TextToSpeechController(this);
    speechToText = SpeechToTextController(this);
    languageDetection = LanguageDetectionController(this);
    activityRecordController = PracticeActivityRecordController(this);
    practiceGenerationController = PracticeGenerationController(this);
    PAuthGaurd.pController = this;
  }

  _logOutfromPangea() {
    debugPrint("Pangea logout");
    GoogleAnalytics.logout();
    pStoreService.clearStorage();
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
        MatrixState.pangeaController.myAnalytics.dispose();
        MatrixState.pangeaController.analytics.dispose();
        break;
      case LoginState.loggedIn:
        // Initialize analytics data
        MatrixState.pangeaController.myAnalytics.initialize();
        MatrixState.pangeaController.analytics.initialize();
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

  // void startChatWithBotIfNotPresent() {
  //   Future.delayed(const Duration(milliseconds: 5000), () async {
  //     try {
  //       if (pStoreService.read("started_bot_chat", addClientIdToKey: false) ??
  //           false) {
  //         return;
  //       }
  //       await pStoreService.save("started_bot_chat", true,
  //           addClientIdToKey: false);
  //       final rooms = matrixState.client.rooms;

  //       await matrixState.client.startDirectChat(
  //         BotName.byEnvironment,
  //         enableEncryption: false,
  //       );
  //     } catch (err, stack) {
  //       debugger(when: kDebugMode);
  //       ErrorHandler.logError(e: err, s: stack);
  //     }
  //   });
  // }

  void startChatWithBotIfNotPresent() {
    Future.delayed(const Duration(milliseconds: 10000), () async {
      // check if user is logged in
      if (!matrixState.client.isLogged()) {
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
          await matrixState.client.startDirectChat(
            BotName.byEnvironment,
            enableEncryption: false,
          );
        } catch (err, stack) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(e: err, s: stack);
        }
        return;
      }

      final Room botDMWithLatestActivity = botDMs.reduce((a, b) {
        if (a.timeline == null || b.timeline == null) {
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

  _handleJoinEvent(SyncUpdate syncUpdate) {
    // for (final joinedRoomUpdate in syncUpdate.rooms!.join!.entries) {
    //   debugPrint(
    //       "room update for ${joinedRoomUpdate.key} - ${joinedRoomUpdate.value}");
    // }
  }

  _handleOnSyncUpdate(SyncUpdate syncUpdate) {
    // debugPrint(syncUpdate.toString());
  }

  _handleSyncStatusFinished(SyncStatusUpdate event) {
    //might be useful to do something periodically, probably be overkill
  }

  void _subscribeToMatrixStreams() {
    matrixState.client.onLoginStateChanged.stream
        .listen(_handleLoginStateChange);

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
      if (space.ownPowerLevel < ClassDefaultValues.powerLevelOfAdmin ||
          !space.canInvite) {
        continue;
      }
      List<User> participants;
      try {
        participants = await space.requestParticipants();
      } catch (err) {
        ErrorHandler.logError(
          e: "Failed to fetch participants for space ${space.id}",
        );
        continue;
      }
      final List<String> userIds = participants.map((user) => user.id).toList();
      if (!userIds.contains(BotName.byEnvironment)) {
        try {
          await space.invite(BotName.byEnvironment);
        } catch (err) {
          ErrorHandler.logError(
            e: "Failed to invite pangea bot to space ${space.id}",
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
        'global',
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
}
