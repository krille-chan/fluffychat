import 'dart:async';

import 'package:collection/collection.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:matrix/matrix.dart' as matrix;

import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/controllers/base_controller.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/user/models/profile_model.dart';
import '../models/user_model.dart';

/// Controller that manages saving and reading of user/profile information
class UserController extends BaseController {
  final GetStorage loginBox = GetStorage("login_storage");
  late PangeaController _pangeaController;
  UserController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  matrix.Client get client => _pangeaController.matrixState.client;

  /// Convenience function that returns the user ID currently stored in the client.
  String? get userId => client.userID;

  /// Cached version of the user profile, so it doesn't have
  /// to be read in from client's account data each time it is accessed.
  Profile? _cachedProfile;

  PublicProfileModel? publicProfile;

  /// Listens for account updates and updates the cached profile
  StreamSubscription? _profileListener;

  /// Listen for updates to account data in syncs and update the cached profile
  void addProfileListener() {
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

    final Profile updatedProfile = update(profile);
    await updatedProfile.saveProfileData(waitForDataInSync: waitForDataInSync);

    if (prevTargetLang != _pangeaController.languageController.userL2) {
      setState({'prev_target_lang': prevTargetLang});
    }
  }

  /// A completer for the profile model of a user.
  Completer<void>? _profileCompleter;

  /// Initializes the user's profile. Runs a function to wait for account data to load,
  /// read account data into profile, and migrate any missing info from the pangea profile.
  /// Finally, it adds a listen to update the profile data when new account data comes in.
  Future<void> initialize() async {
    if (_profileCompleter?.isCompleted ?? false) {
      return _profileCompleter!.future;
    }

    if (_profileCompleter != null) {
      await _profileCompleter!.future;
      return _profileCompleter!.future;
    }

    _profileCompleter = Completer<void>();

    try {
      await _initialize();
      addProfileListener();
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
    } finally {
      if (!_profileCompleter!.isCompleted) {
        _profileCompleter!.complete();
      }
    }

    return _profileCompleter!.future;
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
      publicProfile = PublicProfileModel.fromJson(resp.additionalProperties);
    } catch (e) {
      // getting a 404 error for some users without pre-existing profile
      // still want to set other properties, so catch this error
      publicProfile = PublicProfileModel();
    }

    // Do not await. This function pulls level from analytics,
    // so it waits for analytics to finish initializing. Analytics waits for user controller to
    // finish initializing, so this would cause a deadlock.
    if (publicProfile!.isEmpty) {
      _pangeaController.getAnalytics.initCompleter.future
          .timeout(const Duration(seconds: 10))
          .then((_) {
        updatePublicProfile(
          level: _pangeaController.getAnalytics.constructListModel.level,
        );
      });
    }
  }

  /// Reinitializes the user's profile
  /// This method should be called whenever the user's login status changes
  Future<void> reinitialize() async {
    _profileCompleter = null;
    _cachedProfile = null;
    await initialize();
  }

  Future<void> updatePublicProfile({
    LanguageModel? targetLanguage,
    int? level,
  }) async {
    targetLanguage ??= _pangeaController.languageController.userL2;
    if (targetLanguage == null || publicProfile == null) return;

    if (publicProfile!.targetLanguage == targetLanguage &&
        publicProfile!.languageAnalytics?[targetLanguage]?.level == level) {
      return;
    }

    publicProfile!.targetLanguage = targetLanguage;
    if (level != null) {
      publicProfile!.setLevel(targetLanguage, level);
    }

    await _savePublicProfile();
  }

  Future<void> addXPOffset(int offset) async {
    final targetLanguage = _pangeaController.languageController.userL2;
    if (targetLanguage == null || publicProfile == null) return;

    publicProfile!.addXPOffset(targetLanguage, offset);
    await _savePublicProfile();
  }

  Future<void> _savePublicProfile() async => client.setUserProfile(
        client.userID!,
        PangeaEventTypes.profileAnalytics,
        publicProfile!.toJson(),
      );

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

  Future<PublicProfileModel> getPublicProfile(String userId) async {
    try {
      final resp = await client.getUserProfile(userId);
      return PublicProfileModel.fromJson(resp.additionalProperties);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          userId: userId,
        },
      );
      return PublicProfileModel();
    }
  }
}
