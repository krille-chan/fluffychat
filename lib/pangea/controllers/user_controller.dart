import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
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

  /// An instance of matrix profile. Used to update and access info from the user's matrix profile.
  /// No information needs to be passing in the constructor as the matrix
  /// profile get all of it's internal data the accountData stored in the client.
  MatrixProfile matrixProfile = MatrixProfile();

  /// Returns the [PUserModel] object representing the current user.
  ///
  /// This method retrieves the user data from the local storage using the [PLocalKey.user] key.
  /// If the data exists, it is converted to a [PUserModel] object using the [PUserModel.fromJson] method.
  /// If the data is null, indicating that the user is not logged in (or that
  /// profile fetching has not yet completed, or had an error), null is returned.
  PUserModel? get userModel {
    final data = _pangeaController.pStoreService.read(PLocalKey.user);
    return data != null ? PUserModel.fromJson(data) : null;
  }

  /// Creates a user pangea chat profile, saves the user's profile information
  /// locally, and set the user's DOB in their matrix profile.
  ///
  /// The [dob] parameter is required and represents the date of birth of the user.
  /// This method creates a new [PUserModel] using the [PUserRepo.repoCreatePangeaUser] method,
  /// and saves the user model in local storage.
  /// It also updates the user's matrix profile using the [updateMatrixProfile] method.
  Future<void> createProfile({required String dob}) async {
    if (userId == null || _matrixAccessToken == null) {
      ErrorHandler.logError(
        e: "calling createProfile with userId == null or matrixAccessToken == null",
      );
    }
    final PUserModel newUserModel = await PUserRepo.repoCreatePangeaUser(
      userID: userId!,
      fullName: fullname,
      dob: dob,
      matrixAccessToken: _matrixAccessToken!,
    );
    newUserModel.save(_pangeaController);
    await matrixProfile.saveProfileData(
      {MatrixProfileEnum.dateOfBirth.title: dob},
      waitForDataInSync: true,
    );
  }

  /// A boolean flag indicating whether the profile data is currently being fetched.
  bool _isFetching = false;

  /// A completer for the profile model of a user.
  Completer<PUserModel?> _profileCompleter = Completer<PUserModel?>();

  /// Fetches the user model.
  ///
  /// This method retrieves the user model asynchronously. If the profile completer is already completed,
  /// it returns the future value of the completer. If the user model is currently being fetched,
  /// it waits for the completion of the completer and returns the future value. Otherwise, it sets
  /// the fetching flag, fetches the user model, completes the profile completer with the fetched user model,
  /// and returns the future value of the completer.
  ///
  /// Returns the future value of the user model completer.
  Future<PUserModel?> fetchUserModel() async {
    if (_profileCompleter.isCompleted) return _profileCompleter.future;
    if (_isFetching) {
      await _profileCompleter.future;
      return _profileCompleter.future;
    }

    _isFetching = true;
    PUserModel? fetchedUserModel;

    try {
      fetchedUserModel = await _fetchUserModel();
    } catch (err, s) {
      ErrorHandler.logError(e: err, s: s);
      return null;
    }

    _isFetching = false;
    _profileCompleter.complete(fetchedUserModel);
    return _profileCompleter.future;
  }

  /// Fetches the user model asynchronously.
  ///
  /// This method fetches the user model by calling the [fetchPangeaUserInfo] method
  /// from the [PUserRepo] class. It requires the [_matrixAccessToken] and [userId]
  /// to be non-null. If either of them is null, an error is logged.
  ///
  /// The fetched [newUserModel] is then saved locally.
  /// The [migrateMatrixProfile] method is called, to migrate any information that is
  /// already saved in the user's pangea profile but is not yet saved in the
  /// user's matrix profile. Finally, the [newUserModel] is returned.
  Future<PUserModel?> _fetchUserModel() async {
    if (_matrixAccessToken == null || userId == null) {
      ErrorHandler.logError(
        e: "calling fetchUserModel with userId == null or matrixAccessToken == null",
      );
      return null;
    }
    final PUserModel? newUserModel = await PUserRepo.fetchPangeaUserInfo(
      userID: userId!,
      matrixAccessToken: _matrixAccessToken!,
    );
    newUserModel?.save(_pangeaController);
    await migrateMatrixProfile();
    return newUserModel;
  }

  /// Reinitializes the user's profile
  ///
  /// This method sets up the necessary variables and fetches the user model.
  /// It completes the [_profileCompleter] with the fetched user model.
  /// This method should be called whenever the user's login status changes
  Future<void> reinitialize() async {
    _profileCompleter = Completer<PUserModel?>();
    _isFetching = false;
    await fetchUserModel();
  }

  /// Migrates the user's profile from Pangea to Matrix.
  ///
  /// This method retrieves the user's profile / local settings information from Pangea and checks for corresponding information stored in Matrix.
  /// If any of the profile fields in Pangea have information, but the corresponding fields in Matrix are null, the values are updated in Matrix.
  /// The profile fields that are checked for migration include date of birth, creation date, target language, source language, country, and public profile.
  /// Additionally, several profile settings related to auto play, trial activation, interactive features, and instructional messages are also checked for migration.
  ///
  /// This method calls the [updateMatrixProfile] method to update the user's profile in Matrix with the migrated values.
  ///
  /// Note: This method assumes that the [userModel] and [_pangeaController] instances are properly initialized before calling this method.
  Future<void> migrateMatrixProfile() async {
    // This function relies on the client's account data being loaded.
    // The account data is loaded during
    // the first sync, so wait for that to complete.
    final client = _pangeaController.matrixState.client;
    if (client.prevBatch == null) {
      await client.onSync.stream.first;
    }

    final Map<String, dynamic> profileUpdates = {};
    final Profile? pangeaProfile = userModel?.profile;

    for (final field in MatrixProfile.pangeaProfileFields) {
      final dynamic matrixValue = matrixProfile.getProfileData(field);
      dynamic pangeaValue;
      switch (field) {
        case MatrixProfileEnum.dateOfBirth:
          pangeaValue = pangeaProfile?.dateOfBirth;
          break;
        case MatrixProfileEnum.createdAt:
          pangeaValue = pangeaProfile?.createdAt;
          break;
        case MatrixProfileEnum.targetLanguage:
          pangeaValue = pangeaProfile?.targetLanguage;
          break;
        case MatrixProfileEnum.sourceLanguage:
          pangeaValue = pangeaProfile?.sourceLanguage;
          break;
        case MatrixProfileEnum.country:
          pangeaValue = pangeaProfile?.country;
          break;
        case MatrixProfileEnum.publicProfile:
          pangeaValue = pangeaProfile?.publicProfile;
          break;
        default:
          break;
      }
      if (pangeaValue != null && matrixValue == null) {
        profileUpdates[field.title] = pangeaValue;
      }
    }

    for (final value in MatrixProfileEnum.values) {
      if (profileUpdates.containsKey(value.title)) continue;
      final dynamic localValue =
          _pangeaController.pStoreService.read(value.title);
      final dynamic matrixValue = matrixProfile.getProfileData(value);
      final dynamic unmigratedValue =
          localValue != null && matrixValue == null ? localValue : null;
      if (unmigratedValue != null) {
        profileUpdates[value.title] = unmigratedValue;
      }
    }

    await matrixProfile.saveProfileData(
      profileUpdates,
      waitForDataInSync: true,
    );
  }

  /// Updates the user's profile with the provided information.
  ///
  /// The [dateOfBirth] parameter is the new date of birth for the user.
  /// The [targetLanguage] parameter is the new target language for the user.
  /// The [sourceLanguage] parameter is the new source language for the user.
  /// The [country] parameter is the new country for the user.
  /// The [interests] parameter is a list of new interests for the user.
  /// The [speaks] parameter is a list of new languages the user speaks.
  /// The [publicProfile] parameter indicates whether the user's profile should be public or not.
  ///
  /// Throws an error if [userModel] or [accessToken] is null.
  Future<void> updateUserProfile({
    String? dateOfBirth,
    String? targetLanguage,
    String? sourceLanguage,
    String? country,
    List<String>? interests,
    List<String>? speaks,
    bool? publicProfile,
  }) async {
    final String? accessToken = await this.accessToken;
    if (userModel == null || accessToken == null) {
      ErrorHandler.logError(
        e: "calling updateUserProfile with userModel == null or accessToken == null",
      );
      return;
    }

    final profileJson = userModel!.profile!.toJson();

    if (dateOfBirth != null) {
      profileJson[ModelKey.userDateOfBirth] = dateOfBirth;
    }
    if (targetLanguage != null) {
      profileJson[ModelKey.userTargetLanguage] = targetLanguage;
    }
    if (sourceLanguage != null) {
      profileJson[ModelKey.userSourceLanguage] = sourceLanguage;
    }
    if (interests != null) {
      profileJson[ModelKey.userInterests] = interests.toString();
    }
    if (speaks != null) {
      profileJson[ModelKey.userSpeaks] = speaks.toString();
    }
    if (country != null) {
      profileJson[ModelKey.userCountry] = country;
    }
    if (publicProfile != null) {
      profileJson[ModelKey.publicProfile] = publicProfile;
    }

    final Profile updatedUserProfile = await PUserRepo.updateUserProfile(
      Profile.fromJson(profileJson),
      accessToken,
    );

    PUserModel(
      access: accessToken,
      refresh: userModel!.refresh,
      profile: updatedUserProfile,
    ).save(_pangeaController);

    matrixProfile.saveProfileData({
      MatrixProfileEnum.dateOfBirth.title: dateOfBirth,
      MatrixProfileEnum.targetLanguage.title: targetLanguage,
      MatrixProfileEnum.sourceLanguage.title: sourceLanguage,
      MatrixProfileEnum.country.title: country,
      MatrixProfileEnum.publicProfile.title: publicProfile,
    });
  }

  /// Returns a boolean value indicating whether a new JWT (JSON Web Token) is needed.
  /// It checks if the `userModel` has a non-null `access` token and if the token is expired using the `Jwt.isExpired()` method.
  /// If the `userModel` is null or the `access` token is null, it returns true indicating that a new JWT is needed.
  bool get needNewJWT =>
      userModel?.access != null ? Jwt.isExpired(userModel!.access) : true;

  /// Retrieves the access token for the user.
  ///
  /// If the locally stored user model is null or the access token has
  /// expired, it fetches the user model.
  /// If the user model is still null after fetching, an error is logged.
  ///
  /// Returns the access token as a string, or null if the user model is null.
  Future<String?> get accessToken async {
    final PUserModel? useThisOne =
        needNewJWT ? await fetchUserModel() : userModel;

    if (useThisOne == null) {
      ErrorHandler.logError(
        e: "trying to get accessToken with userModel = null",
      );
    }
    return useThisOne?.access;
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

  /// Checks if the user data is available.
  /// Returns a [Future] that completes with a [bool] value
  /// indicating whether the user data is available or not.
  Future<bool> get isPUserDataAvailable async {
    try {
      final PUserModel? toCheck = userModel ?? (await fetchUserModel());
      return toCheck != null;
    } catch (err, s) {
      ErrorHandler.logError(e: err, s: s);
      return false;
    }
  }

  /// Checks if user data is available and the date of birth is set.
  /// Returns a [Future] that completes with a [bool] value indicating
  /// whether the user data is available and the date of birth is set.
  Future<bool> get isUserDataAvailableAndDateOfBirthSet async {
    try {
      // the function fetchUserModel() uses a completer, so it shouldn't
      // re-call the endpoint if it has already been called
      await fetchUserModel();
      return matrixProfile.dateOfBirth != null;
    } catch (err, s) {
      ErrorHandler.logError(e: err, s: s);
      return false;
    }
  }

  /// Returns a boolean value indicating whether the user is currently in the trial window.
  bool get inTrialWindow {
    final String? createdAt = userModel?.profile?.createdAt;
    if (createdAt == null) {
      return false;
    }
    return DateTime.parse(createdAt).isAfter(
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
      final PUserModel? toCheck = userModel ?? (await fetchUserModel());
      if (toCheck?.profile == null) {
        return false;
      }
      final String? srcLang = toCheck!.profile!.sourceLanguage;
      final String? tgtLang = toCheck.profile!.targetLanguage;
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
  bool get isPublic => userModel?.profile?.publicProfile ?? false;

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
