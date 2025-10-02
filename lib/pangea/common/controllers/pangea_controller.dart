import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/get_analytics_controller.dart';
import 'package:fluffychat/pangea/analytics_misc/put_analytics_controller.dart';
import 'package:fluffychat/pangea/choreographer/controllers/contextual_definition_controller.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/controllers/message_data_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/guard/p_vguard.dart';
import 'package:fluffychat/pangea/learning_settings/controllers/language_controller.dart';
import 'package:fluffychat/pangea/learning_settings/utils/locale_provider.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/spaces/controllers/space_code_controller.dart';
import 'package:fluffychat/pangea/subscription/controllers/subscription_controller.dart';
import 'package:fluffychat/pangea/toolbar/controllers/speech_to_text_controller.dart';
import 'package:fluffychat/pangea/toolbar/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/user/controllers/permissions_controller.dart';
import 'package:fluffychat/pangea/user/controllers/user_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../utils/firebase_analytics.dart';

class PangeaController {
  ///pangeaControllers
  late UserController userController;
  late LanguageController languageController;
  late SpaceCodeController spaceCodeController;
  late PermissionsController permissionsController;
  late GetAnalyticsController getAnalytics;
  late PutAnalyticsController putAnalytics;
  late MessageDataController messageData;

  // TODO: make these static so we can remove from here
  late ContextualDefinitionController definitions;
  late SubscriptionController subscriptionController;
  late TextToSpeechController textToSpeech;
  late SpeechToTextController speechToText;

  ///store Services
  final pLanguageStore = PLanguageStore();

  StreamSubscription? _languageStream;

  ///Matrix Variables
  MatrixState matrixState;
  Matrix matrix;

  int? randomint;
  PangeaController({required this.matrix, required this.matrixState}) {
    _setup();
    _setLanguageSubscription();
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
    _initAnalyticsControllers();
    subscriptionController.initialize();
    setPangeaPushRules();
    TtsController.setAvailableLanguages();
  }

  /// Initialize controllers
  _addRefInObjects() {
    userController = UserController(this);
    languageController = LanguageController(this);
    spaceCodeController = SpaceCodeController(this);
    permissionsController = PermissionsController(this);
    getAnalytics = GetAnalyticsController(this);
    putAnalytics = PutAnalyticsController(this);
    messageData = MessageDataController(this);
    definitions = ContextualDefinitionController(this);
    subscriptionController = SubscriptionController(this);
    textToSpeech = TextToSpeechController(this);
    speechToText = SpeechToTextController(this);
    PAuthGaurd.pController = this;
  }

  _logOutfromPangea(BuildContext context) {
    debugPrint("Pangea logout");
    GoogleAnalytics.logout();
    clearCache();
    Provider.of<LocaleProvider>(context, listen: false).setLocale(null);
  }

  static final List<String> _storageKeys = [
    'mode_list_storage',
    'activity_plan_storage',
    'bookmarked_activities',
    'objective_list_storage',
    'topic_list_storage',
    'activity_plan_search_storage',
    "analytics_storage",
    "version_storage",
    'lemma_storage',
    'svg_cache',
    'morphs_storage',
    'morph_meaning_storage',
    'practice_record_cache',
    'practice_selection_cache',
    'subscription_storage',
    'vocab_storage',
    'onboarding_storage',
    'analytics_request_storage',
    'activity_analytics_storage',
    'course_storage',
    'course_topic_storage',
    'course_media_storage',
    'course_location_storage',
    'course_activity_storage',
    'course_location_media_storage',
  ];

  Future<void> clearCache({List<String> exclude = const []}) async {
    final List<Future<void>> futures = [];
    for (final key in _storageKeys) {
      if (exclude.contains(key)) continue;
      futures.add(GetStorage(key).erase());
    }
    await Future.wait(futures);
  }

  Future<void> checkHomeServerAction() async {
    final client = await matrixState.getLoginClient();
    if (client.homeserver != null) {
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
      await client.register();
      matrixState.loginRegistrationSupported = true;
    } on MatrixException catch (e) {
      matrixState.loginRegistrationSupported =
          e.requireAdditionalAuthentication;
    }

    //  setState(() => error = (e).toLocalizedString(context));
  }

  /// check user information if not found then redirect to Date of birth page
  void handleLoginStateChange(
    LoginState state,
    String? userID,
    BuildContext context,
  ) {
    switch (state) {
      case LoginState.loggedOut:
      case LoginState.softLoggedOut:
        // Reset cached analytics data
        _disposeAnalyticsControllers();
        userController.clear();
        _languageStream?.cancel();
        _languageStream = null;
        _logOutfromPangea(context);
        break;
      case LoginState.loggedIn:
        // Initialize analytics data
        initControllers();
        _setLanguageSubscription();

        userController.reinitialize().then((_) {
          final l1 = userController.profile.userSettings.sourceLanguage;
          Provider.of<LocaleProvider>(context, listen: false).setLocale(l1);
        });
        subscriptionController.reinitialize();
        break;
    }

    Sentry.configureScope(
      (scope) => scope.setUser(
        SentryUser(
          id: userID,
          name: userID,
        ),
      ),
    );
    GoogleAnalytics.analyticsUserUpdate(userID);
  }

  Future<void> _initAnalyticsControllers() async {
    putAnalytics.initialize();
    await getAnalytics.initialize();
  }

  void _disposeAnalyticsControllers() {
    putAnalytics.dispose();
    getAnalytics.dispose();
  }

  Future<void> resetAnalytics() async {
    _disposeAnalyticsControllers();
    await _initAnalyticsControllers();
  }

  void _setLanguageSubscription() {
    _languageStream?.cancel();
    _languageStream = userController.languageStream.stream.listen(
      (_) => clearCache(exclude: ["analytics_storage"]),
    );
  }

  Future<void> setPangeaPushRules() async {
    if (!matrixState.client.isLogged()) return;
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
