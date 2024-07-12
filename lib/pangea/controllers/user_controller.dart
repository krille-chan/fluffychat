import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:matrix/matrix.dart' as matrix;

import '../constants/local.key.dart';
import '../models/user_model.dart';
import '../repo/user_repo.dart';

/// Controller that manages saving and reading of user/profile information
class UserController extends BaseController {
  late PangeaController _pangeaController;
  UserController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  /// Convenience function that returns the user ID currently stored in the client.
  String? get userId => _pangeaController.matrixState.client.userID;

  /// Convenience function that returns the accessToken currently stored in the client.
  String? get _matrixAccessToken =>
      _pangeaController.matrixState.client.accessToken;

  Profile? _cachedProfile;

  /// Listen for updates to account data in syncs and update the cached profile
  void addProfileListener() {
    _pangeaController.matrixState.client.onSync.stream
        .where((sync) => sync.accountData != null)
        .listen((sync) {
      final Profile? fromAccountData = Profile.fromAccountData();
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
    final Profile? fromAccountData = Profile.fromAccountData();
    if (fromAccountData != null) {
      _cachedProfile = fromAccountData;
      return fromAccountData;
    }

    _cachedProfile = Profile.migrateFromAccountData();
    _cachedProfile?.saveProfileData();
    return _cachedProfile ?? Profile.emptyProfile;
  }

  void updateProfile(Profile Function(Profile) update) {
    final Profile updatedProfile = update(profile);
    updatedProfile.saveProfileData();
  }

  Future<void> createProfile({required DateTime dob}) async {
    final userSettings = UserSettings(
      dateOfBirth: dob,
      createdAt: DateTime.now(),
    );
    final newProfile = Profile(userSettings: userSettings);
    await newProfile.saveProfileData(waitForDataInSync: true);
  }

  /// A completer for the profile model of a user.
  Completer<void>? _profileCompleter;

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
      ErrorHandler.logError(e: err, s: s);
    } finally {
      _profileCompleter!.complete();
    }

    return _profileCompleter!.future;
  }

  Future<void> _initialize() async {
    await waitForAccountData();
    if (profile.userSettings.dateOfBirth != null) {
      return;
    }
    final PangeaProfileResponse? resp = await PUserRepo.fetchPangeaUserInfo(
      userID: userId!,
      matrixAccessToken: _matrixAccessToken!,
    );
    if (resp?.profile == null) {
      return;
    }
    final userSetting = UserSettings.fromJson(resp!.profile.toJson());
    final newProfile = Profile(userSettings: userSetting);
    await newProfile.saveProfileData(waitForDataInSync: true);
  }

  /// Reinitializes the user's profile
  /// This method should be called whenever the user's login status changes
  Future<void> reinitialize() async {
    _profileCompleter = null;
    _cachedProfile = null;
    await initialize();
  }

  /// Account data comes through in the first sync, so wait for that
  Future<void> waitForAccountData() async {
    final client = _pangeaController.matrixState.client;
    if (client.prevBatch == null) {
      await client.onSync.stream.first;
    }
  }

  /// Returns a boolean value indicating whether a new JWT (JSON Web Token) is needed.
  bool needNewJWT(String token) => Jwt.isExpired(token);

  /// Retrieves the access token for the user. Looks for it locally,
  /// and if it's not found or expired, fetches it from the server.
  Future<String> get accessToken async {
    final localAccessToken =
        _pangeaController.pStoreService.read(PLocalKey.access);

    if (localAccessToken == null || needNewJWT(localAccessToken)) {
      final PangeaProfileResponse? userModel =
          await PUserRepo.fetchPangeaUserInfo(
        userID: userId!,
        matrixAccessToken: _matrixAccessToken!,
      );
      if (userModel?.access == null) {
        throw ("Trying to get accessToken with null userModel");
      }
      _pangeaController.pStoreService.save(
        PLocalKey.access,
        userModel!.access,
      );
      return userModel.access;
    }

    return localAccessToken;
  }

  /// Returns the full name of the user.
  /// If the [userId] is null, an error will be logged and null will be returned.
  /// The full name is obtained by extracting the substring before the first occurrence of ":" in the [userId]
  /// and then replacing all occurrences of "@" with an empty string.
  String? get fullname {
    if (userId == null) {
      ErrorHandler.logError(
        e: "calling fullname with userId == null",
      );
      return null;
    }
    return userId!.substring(0, userId!.indexOf(":")).replaceAll("@", "");
  }

  /// Checks if user data is available and the date of birth is set.
  /// Returns a [Future] that completes with a [bool] value indicating
  /// whether the user data is available and the date of birth is set.
  Future<bool> get isUserDataAvailableAndDateOfBirthSet async {
    try {
      // the function fetchUserModel() uses a completer, so it shouldn't
      // re-call the endpoint if it has already been called
      await initialize();
      return profile.userSettings.dateOfBirth != null;
    } catch (err, s) {
      ErrorHandler.logError(e: err, s: s);
      return false;
    }
  }

  /// Returns a boolean value indicating whether the user is currently in the trial window.
  bool get inTrialWindow {
    final DateTime? createdAt = profile.userSettings.createdAt;
    if (createdAt == null) {
      return false;
    }
    return createdAt.isAfter(
      DateTime.now().subtract(const Duration(days: 7)),
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
      ErrorHandler.logError(e: err, s: s);
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
