import 'dart:async';

import 'package:collection/collection.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:matrix/matrix.dart' as matrix;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/user/models/activities_profile_model.dart';
import 'package:fluffychat/pangea/user/models/analytics_profile_model.dart';
import '../models/user_model.dart';

class LanguageUpdate {
  final LanguageModel? prevBaseLang;
  final LanguageModel? prevTargetLang;
  final LanguageModel baseLang;
  final LanguageModel targetLang;

  LanguageUpdate({
    required this.baseLang,
    required this.targetLang,
    this.prevBaseLang,
    this.prevTargetLang,
  });
}

/// Controller that manages saving and reading of user/profile information
class UserController {
  late PangeaController _pangeaController;

  final StreamController<LanguageUpdate> languageStream =
      StreamController.broadcast();
  final StreamController settingsUpdateStream =
      StreamController<Profile>.broadcast();

  UserController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  matrix.Client get client => _pangeaController.matrixState.client;

  /// Convenience function that returns the user ID currently stored in the client.
  String? get userId => client.userID;

  /// Cached version of the user profile, so it doesn't have
  /// to be read in from client's account data each time it is accessed.
  Profile? _cachedProfile;

  AnalyticsProfileModel? analyticsProfile;
  ActivitiesProfileModel? activitiesProfile;

  /// Listens for account updates and updates the cached profile
  StreamSubscription? _profileListener;

  /// Listen for updates to account data in syncs and update the cached profile
  void _addProfileListener() {
    _profileListener ??= client.onSync.stream
        .where((sync) => sync.accountData != null)
        .listen((sync) {
      final profileData = client.accountData[ModelKey.userProfile]?.content;
      final Profile? fromAccountData = Profile.fromAccountData(profileData);
      if (fromAccountData != null) {
        _cachedProfile = fromAccountData;
      }
    });
  }

  /// The user's profile. Will be empty if the client's accountData hasn't
  /// been loaded yet (if the first sync hasn't gone through yet)
  /// or if the user hasn't yer set their date of birth.
  Profile get profile {
    /// if the profile is cached, return it
    if (_cachedProfile != null) return _cachedProfile!;

    /// if account data is empty, return an empty profile
    if (client.accountData.isEmpty) {
      return Profile.emptyProfile;
    }

    /// try to get the account data in the up-to-date format
    final Profile? fromAccountData = Profile.fromAccountData(
      client.accountData[ModelKey.userProfile]?.content,
    );

    if (fromAccountData != null) {
      _cachedProfile = fromAccountData;
      return fromAccountData;
    }

    _cachedProfile = Profile.migrateFromAccountData();
    _cachedProfile?.saveProfileData();
    return _cachedProfile ?? Profile.emptyProfile;
  }

  /// Updates the user's profile with the given [update] function and saves it.
  Future<void> updateProfile(
    Profile Function(Profile) update, {
    waitForDataInSync = false,
  }) async {
    final prevTargetLang = _pangeaController.languageController.userL2;
    final prevBaseLang = _pangeaController.languageController.userL1;
    final prevHash = profile.hashCode;

    final Profile updatedProfile = update(profile);
    if (updatedProfile.hashCode == prevHash) {
      // no changes were made, so don't save
      return;
    }

    await updatedProfile.saveProfileData(waitForDataInSync: waitForDataInSync);

    if ((prevTargetLang != _pangeaController.languageController.userL2) ||
        (prevBaseLang != _pangeaController.languageController.userL1)) {
      languageStream.add(
        LanguageUpdate(
          baseLang: _pangeaController.languageController.userL1!,
          targetLang: _pangeaController.languageController.userL2!,
          prevBaseLang: prevBaseLang,
          prevTargetLang: prevTargetLang,
        ),
      );
    } else {
      settingsUpdateStream.add(updatedProfile);
    }
  }

  /// A completer for the profile model of a user.
  Completer<void> initCompleter = Completer<void>();
  bool _initializing = false;

  /// Initializes the user's profile. Runs a function to wait for account data to load,
  /// read account data into profile, and migrate any missing info from the pangea profile.
  /// Finally, it adds a listen to update the profile data when new account data comes in.
  Future<void> initialize() async {
    if (_initializing || initCompleter.isCompleted) {
      return initCompleter.future;
    }

    _initializing = true;

    try {
      await _initialize();
      _addProfileListener();
      _addAnalyticsRoomIdsToPublicProfile();

      if (profile.userSettings.targetLanguage != null &&
          profile.userSettings.targetLanguage!.isNotEmpty &&
          _pangeaController.languageController.userL2 == null) {
        // update the language list and send an update to refresh analytics summary
        await PLanguageStore.initialize(forceRefresh: true);
      }
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
    } finally {
      if (!initCompleter.isCompleted) {
        initCompleter.complete();
      }
      _initializing = false;
    }

    return initCompleter.future;
  }

  /// Initializes the user's profile by waiting for account data to load, reading in account
  /// data to profile, and migrating from the pangea profile if the account data is not present.
  Future<void> _initialize() async {
    // wait for account data to load
    // as long as it's not null, then this we've already migrated the profile
    if (client.prevBatch == null) {
      await client.onSync.stream.first;
    }

    if (client.userID == null) return;
    try {
      final resp = await client.getUserProfile(client.userID!);
      analyticsProfile =
          AnalyticsProfileModel.fromJson(resp.additionalProperties);
      activitiesProfile =
          ActivitiesProfileModel.fromJson(resp.additionalProperties);
    } catch (e) {
      // getting a 404 error for some users without pre-existing profile
      // still want to set other properties, so catch this error
      analyticsProfile = AnalyticsProfileModel();
      activitiesProfile = ActivitiesProfileModel.empty;
    }

    // Do not await. This function pulls level from analytics,
    // so it waits for analytics to finish initializing. Analytics waits for user controller to
    // finish initializing, so this would cause a deadlock.
    if (analyticsProfile!.isEmpty) {
      _pangeaController.getAnalytics.initCompleter.future
          .timeout(const Duration(seconds: 10))
          .then((_) {
        updateAnalyticsProfile(
          level: _pangeaController.getAnalytics.constructListModel.level,
        );
      }).catchError((e, s) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            "publicProfile": analyticsProfile?.toJson(),
            "userId": client.userID,
          },
          level:
              e is TimeoutException ? SentryLevel.warning : SentryLevel.error,
        );
      });
    }
  }

  void clear() {
    _initializing = false;
    initCompleter = Completer<void>();
    _cachedProfile = null;
    _profileListener?.cancel();
    _profileListener = null;
  }

  /// Reinitializes the user's profile
  /// This method should be called whenever the user's login status changes
  Future<void> reinitialize() async {
    clear();
    await initialize();
  }

  /// Returns a boolean value indicating whether a new JWT (JSON Web Token) is needed.
  bool needNewJWT(String token) => Jwt.isExpired(token);

  /// Retrieves matrix access token.
  String get accessToken {
    final token = client.accessToken;
    if (token == null) {
      throw ("Trying to get accessToken with null token. User is not logged in.");
    }
    return token;
  }

  /// Returns the full name of the user.
  /// If the [userId] is null, an error will be logged and null will be returned.
  /// The full name is obtained by extracting the substring before the first occurrence of ":" in the [userId]
  /// and then replacing all occurrences of "@" with an empty string.
  String? get fullname {
    if (userId == null) {
      ErrorHandler.logError(
        e: "calling fullname with userId == null",
        data: {},
      );
      return null;
    }
    return userId!.substring(0, userId!.indexOf(":")).replaceAll("@", "");
  }

  /// Checks if user data is available and the user's l2 is set.
  Future<bool> get isUserDataAvailableAndL2Set async {
    try {
      // the function fetchUserModel() uses a completer, so it shouldn't
      // re-call the endpoint if it has already been called
      await initialize();
      return profile.userSettings.targetLanguage != null;
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
      return false;
    }
  }

  /// Returns a boolean value indicating whether the user is currently in the trial window.
  bool inTrialWindow({int trialDays = 7}) {
    final DateTime? createdAt = profile.userSettings.createdAt;
    if (createdAt == null) {
      return false;
    }

    return createdAt.isAfter(
      DateTime.now().subtract(Duration(days: trialDays)),
    );
  }

  /// Checks if the user's languages are set.
  /// Returns a [Future] that completes with a [bool] value
  /// indicating whether the user's languages are set.
  ///
  /// A user's languages are considered set if the source and target languages
  /// are not null, not empty, and not equal to the [LanguageKeys.unknownLanguage] constant.
  ///
  /// If an error occurs during the process, it logs the error and returns `false`.
  Future<bool> get areUserLanguagesSet async {
    try {
      final String? srcLang = profile.userSettings.sourceLanguage;
      final String? tgtLang = profile.userSettings.targetLanguage;
      return srcLang != null &&
          tgtLang != null &&
          srcLang.isNotEmpty &&
          tgtLang.isNotEmpty &&
          srcLang != LanguageKeys.unknownLanguage &&
          tgtLang != LanguageKeys.unknownLanguage;
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
      return false;
    }
  }

  /// Returns a boolean value indicating whether the user's profile is public.
  bool get isPublic {
    return profile.userSettings.publicProfile ?? true;
  }

  /// Retrieves the user's email address.
  ///
  /// This method fetches the user's email address by making a request to the
  /// Matrix server. It uses the `_pangeaController` instance to access the
  /// Matrix client and retrieve the account's third-party identifiers. It then
  /// filters the identifiers to find the first one with the medium set to
  /// `ThirdPartyIdentifierMedium.email`. Finally, it returns the email address
  /// associated with the identifier, or `null` if no email address is found.
  ///
  /// Returns:
  ///   - The user's email address as a [String], or `null` if no email address
  ///     is found.
  Future<String?> get userEmail async {
    final List<matrix.ThirdPartyIdentifier>? identifiers =
        await client.getAccount3PIDs();
    final matrix.ThirdPartyIdentifier? email = identifiers?.firstWhereOrNull(
      (identifier) =>
          identifier.medium == matrix.ThirdPartyIdentifierMedium.email,
    );
    return email?.address;
  }

  Future<void> _savePublicProfileUpdate(
    String type,
    Map<String, dynamic> content,
  ) async =>
      client.setUserProfile(
        client.userID!,
        type,
        content,
      );

  Future<void> updateAnalyticsProfile({
    required int level,
    LanguageModel? baseLanguage,
    LanguageModel? targetLanguage,
  }) async {
    targetLanguage ??= _pangeaController.languageController.userL2;
    baseLanguage ??= _pangeaController.languageController.userL1;
    if (targetLanguage == null || analyticsProfile == null) return;

    final analyticsRoom =
        _pangeaController.matrixState.client.analyticsRoomLocal(targetLanguage);

    if (analyticsProfile!.targetLanguage == targetLanguage &&
        analyticsProfile!.baseLanguage == baseLanguage &&
        analyticsProfile!.languageAnalytics?[targetLanguage]?.level == level &&
        analyticsProfile!.analyticsRoomIdByLanguage(targetLanguage) ==
            analyticsRoom?.id) {
      return;
    }

    analyticsProfile!.baseLanguage = baseLanguage;
    analyticsProfile!.targetLanguage = targetLanguage;
    analyticsProfile!.setLanguageInfo(
      targetLanguage,
      level,
      analyticsRoom?.id,
    );
    await _savePublicProfileUpdate(
      PangeaEventTypes.profileAnalytics,
      analyticsProfile!.toJson(),
    );
  }

  Future<void> _addAnalyticsRoomIdsToPublicProfile() async {
    if (analyticsProfile?.languageAnalytics == null) return;
    final analyticsRooms =
        _pangeaController.matrixState.client.allMyAnalyticsRooms;

    if (analyticsRooms.isEmpty) return;
    for (final analyticsRoom in analyticsRooms) {
      final lang = analyticsRoom.madeForLang?.split("-").first;
      if (lang == null || analyticsProfile?.languageAnalytics == null) continue;
      final langKey =
          analyticsProfile!.languageAnalytics!.keys.firstWhereOrNull(
        (l) => l.langCodeShort == lang,
      );

      if (langKey == null) continue;
      if (analyticsProfile!.languageAnalytics![langKey]!.analyticsRoomId ==
          analyticsRoom.id) {
        continue;
      }

      analyticsProfile!.setLanguageInfo(
        langKey,
        analyticsProfile!.languageAnalytics![langKey]!.level,
        analyticsRoom.id,
      );
    }

    await _savePublicProfileUpdate(
      PangeaEventTypes.profileAnalytics,
      analyticsProfile!.toJson(),
    );
  }

  Future<void> addXPOffset(int offset) async {
    final targetLanguage = _pangeaController.languageController.userL2;
    if (targetLanguage == null || analyticsProfile == null) return;

    analyticsProfile!.addXPOffset(
      targetLanguage,
      offset,
      _pangeaController.matrixState.client
          .analyticsRoomLocal(targetLanguage)
          ?.id,
    );
    await _savePublicProfileUpdate(
      PangeaEventTypes.profileAnalytics,
      analyticsProfile!.toJson(),
    );
  }

  Future<void> addBookmarkedActivity({
    required String activityId,
  }) async {
    if (activitiesProfile == null) {
      throw Exception("Activities profile is not initialized");
    }

    activitiesProfile!.addBookmark(activityId);
    await _savePublicProfileUpdate(
      PangeaEventTypes.profileActivities,
      activitiesProfile!.toJson(),
    );
  }

  // Future<List<ActivityPlanModel>> getBookmarkedActivities() async {
  //   if (activitiesProfile == null) {
  //     throw Exception("Activities profile is not initialized");
  //   }

  //   return activitiesProfile!.getBookmarkedActivities();
  // }

  // List<ActivityPlanModel> getBookmarkedActivitiesSync() {
  //   if (activitiesProfile == null) {
  //     throw Exception("Activities profile is not initialized");
  //   }

  //   return activitiesProfile!.getBookmarkedActivitiesSync();
  // }

  Future<void> updateBookmarkedActivity({
    required String activityId,
    required String newActivityId,
  }) async {
    if (activitiesProfile == null) {
      throw Exception("Activities profile is not initialized");
    }

    activitiesProfile!.removeBookmark(activityId);
    activitiesProfile!.addBookmark(newActivityId);
    await _savePublicProfileUpdate(
      PangeaEventTypes.profileActivities,
      activitiesProfile!.toJson(),
    );
  }

  Future<void> removeBookmarkedActivity({
    required String activityId,
  }) async {
    if (activitiesProfile == null) {
      throw Exception("Activities profile is not initialized");
    }

    activitiesProfile!.removeBookmark(activityId);
    await _savePublicProfileUpdate(
      PangeaEventTypes.profileActivities,
      activitiesProfile!.toJson(),
    );
  }

  bool isBookmarked(String id) => activitiesProfile?.isBookmarked(id) ?? false;

  Future<AnalyticsProfileModel> getPublicAnalyticsProfile(
    String userId,
  ) async {
    try {
      if (userId == BotName.byEnvironment) {
        return AnalyticsProfileModel();
      }

      final resp = await client.getUserProfile(userId);
      return AnalyticsProfileModel.fromJson(resp.additionalProperties);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          userId: userId,
        },
      );
      return AnalyticsProfileModel();
    }
  }
}
