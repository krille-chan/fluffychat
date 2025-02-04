import 'dart:async';

import 'package:collection/collection.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:matrix/matrix.dart' as matrix;

import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/controllers/base_controller.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import '../models/user_model.dart';

/// Controller that manages saving and reading of user/profile information
class UserController extends BaseController {
  late PangeaController _pangeaController;
  UserController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  /// Convenience function that returns the user ID currently stored in the client.
  String? get userId => _pangeaController.matrixState.client.userID;

  /// Cached version of the user profile, so it doesn't have
  /// to be read in from client's account data each time it is accessed.
  Profile? _cachedProfile;

  /// Listens for account updates and updates the cached profile
  StreamSubscription? _profileListener;

  /// Listen for updates to account data in syncs and update the cached profile
  void addProfileListener() {
    _profileListener ??= _pangeaController.matrixState.client.onSync.stream
        .where((sync) => sync.accountData != null)
        .listen((sync) {
      final profileData = _pangeaController
          .matrixState.client.accountData[ModelKey.userProfile]?.content;
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
    if (_pangeaController.matrixState.client.accountData.isEmpty) {
      return Profile.emptyProfile;
    }

    /// try to get the account data in the up-to-date format
    final Profile? fromAccountData = Profile.fromAccountData(
      _pangeaController
          .matrixState.client.accountData[ModelKey.userProfile]?.content,
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
    final prevTargetLang = profile.userSettings.targetLanguage;

    final Profile updatedProfile = update(profile);
    await updatedProfile.saveProfileData(waitForDataInSync: waitForDataInSync);

    if (prevTargetLang != updatedProfile.userSettings.targetLanguage) {
      setState({'prev_target_lang': prevTargetLang});
    }
  }

  /// Creates a new profile for the user with the given date of birth.
  Future<void> createProfile({DateTime? dob}) async {
    final userSettings = UserSettings(
      dateOfBirth: dob,
      createdAt: DateTime.now(),
    );
    final newProfile = Profile(userSettings: userSettings);
    await newProfile.saveProfileData(waitForDataInSync: true);
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
      _profileCompleter!.complete();
    }

    return _profileCompleter!.future;
  }

  /// Initializes the user's profile by waiting for account data to load, reading in account
  /// data to profile, and migrating from the pangea profile if the account data is not present.
  Future<void> _initialize() async {
    // wait for account data to load
    // as long as it's not null, then this we've already migrated the profile
    if (_pangeaController.matrixState.client.prevBatch == null) {
      await _pangeaController.matrixState.client.onSync.stream.first;
    }
  }

  /// Reinitializes the user's profile
  /// This method should be called whenever the user's login status changes
  Future<void> reinitialize() async {
    _profileCompleter = null;
    _cachedProfile = null;
    await initialize();
  }

  /// Returns a boolean value indicating whether a new JWT (JSON Web Token) is needed.
  bool needNewJWT(String token) => Jwt.isExpired(token);

  /// Retrieves matrix access token.
  String get accessToken {
    final token = _pangeaController.matrixState.client.accessToken;
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
    return profile.userSettings.publicProfile;
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
        await _pangeaController.matrixState.client.getAccount3PIDs();
    final matrix.ThirdPartyIdentifier? email = identifiers?.firstWhereOrNull(
      (identifier) =>
          identifier.medium == matrix.ThirdPartyIdentifierMedium.email,
    );
    return email?.address;
  }
}
