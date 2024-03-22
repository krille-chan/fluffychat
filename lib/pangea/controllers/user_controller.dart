import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:matrix/matrix.dart' as matrix;

import '../constants/local.key.dart';
import '../models/user_model.dart';
import '../repo/user_repo.dart';

class UserController extends BaseController {
  late PangeaController _pangeaController;
  final Completer _completer = Completer();
  UserController(PangeaController pangeaController) : super() {
    _pangeaController = pangeaController;
  }

  Future<PUserModel?> fetchUserModel() async {
    try {
      if (_matrixAccessToken == null) {
        throw Exception(
          "calling fetchUserModel with matrixAccesstoken == null",
        );
      }
      final PUserModel? newUserModel = await PUserRepo.fetchPangeaUserInfo(
        userID: userId!,
        matrixAccessToken: _matrixAccessToken!,
      );

      if (newUserModel != null) {
        _savePUserModel(newUserModel);
        if (newUserModel.profile!.dateOfBirth != null) {
          await setMatrixProfile(newUserModel.profile!.dateOfBirth!);
        }
        final MatrixProfile? matrixProfile = await getMatrixProfile();
        _saveMatrixProfile(matrixProfile);
      }
      _completeCompleter();

      return newUserModel;
    } catch (err) {
      log("User model not found. Probably first signup and needs Pangea account");
      rethrow;
    }
  }

  Future<void> setMatrixProfile(String dob) async {
    await _pangeaController.matrixState.client.setAccountData(
      userId!,
      PangeaEventTypes.userAge,
      {ModelKey.userDateOfBirth: dob},
    );
    final MatrixProfile? matrixProfile = await getMatrixProfile();
    _saveMatrixProfile(matrixProfile);
  }

  Future<MatrixProfile?> getMatrixProfile() async {
    try {
      final Map<String, dynamic> accountData =
          await _pangeaController.matrixState.client.getAccountData(
        userId!,
        PangeaEventTypes.userAge,
      );
      return MatrixProfile.fromJson(accountData);
    } catch (_) {
      return null;
    }
  }

  void _completeCompleter() {
    if (!_completer.isCompleted) {
      _completer.complete(null);
    }
  }

  Future<Completer> get completer async {
    if (await isPUserDataAvailable) {
      _completeCompleter();
    }
    return _completer;
  }

  bool get needNewJWT =>
      userModel?.access != null ? Jwt.isExpired(userModel!.access) : true;

  Future<String> get accessToken async {
    await (await completer).future;
    // if userModel null or access token expired then fetchUserModel
    final PUserModel? useThisOne =
        needNewJWT ? await fetchUserModel() : userModel;

    if (useThisOne == null) {
      //debugger(when: kDebugMode);
      throw Exception("trying to get accessToken with userModel = null");
    }
    return useThisOne.access;
  }

  String? get userId {
    return _pangeaController.matrixState.client.userID;
  }

  String get fullname {
    final String? userID = userId;
    if (userID == null) {
      throw Exception('User ID not found');
    }
    return userID.substring(0, userID.indexOf(":")).replaceAll("@", "");
  }

  PUserModel? get userModel {
    final data = _pangeaController.pStoreService.read(PLocalKey.user);
    return data != null ? PUserModel.fromJson(data) : null;
  }

  MatrixProfile? get matrixProfile {
    final data = _pangeaController.pStoreService.read(PLocalKey.matrixProfile);
    return data != null ? MatrixProfile.fromJson(data) : null;
  }

  Future<bool> get isPUserDataAvailable async {
    try {
      final PUserModel? toCheck = userModel ?? (await fetchUserModel());
      return toCheck != null ? true : false;
    } catch (err) {
      return false;
    }
  }

  Future<bool> get isUserDataAvailableAndDateOfBirthSet async {
    try {
      if (matrixProfile == null) {
        await fetchUserModel();
      }
      return matrixProfile?.dateOfBirth != null ? true : false;
    } catch (err) {
      return false;
    }
  }

  bool get inTrialWindow {
    final String? createdAt = userModel?.profile?.createdAt;
    if (createdAt == null) {
      return false;
    }
    return DateTime.parse(createdAt).isAfter(
      DateTime.now().subtract(const Duration(days: 7)),
    );
  }

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
    } catch (err) {
      return false;
    }
  }

  redirectToUserInfo() {
    // _pangeaController.matrix.router!.currentState!.to(
    //   "/home/connect/user_age",
    //   queryParameters:
    //       _pangeaController.matrix.router!.currentState!.queryParameters,
    // );
    FluffyChatApp.router.go("/rooms/user_age");
  }

  _saveMatrixProfile(MatrixProfile? matrixProfile) {
    if (matrixProfile != null) {
      _pangeaController.pStoreService.save(
        PLocalKey.matrixProfile,
        matrixProfile.toJson(),
      );
      setState(data: matrixProfile);
    }
  }

  _savePUserModel(PUserModel? pUserModel) {
    if (pUserModel == null) {
      ErrorHandler.logError(e: "trying to save null userModel");
      return;
    }
    final jsonUser = pUserModel.toJson();
    _pangeaController.pStoreService.save(PLocalKey.user, jsonUser);

    setState(data: pUserModel);
  }

  Future<void> updateUserProfile({
    String? dateOfBirth,
    String? targetLanguage,
    String? sourceLanguage,
    String? country,
    List<String>? interests,
    List<String>? speaks,
    bool? publicProfile,
  }) async {
    if (userModel == null) throw Exception("Local userModel not defined");
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
      await accessToken,
    );

    await _savePUserModel(
      PUserModel(
        access: await accessToken,
        refresh: userModel!.refresh,
        profile: updatedUserProfile,
      ),
    );

    if (dateOfBirth != null) {
      await setMatrixProfile(dateOfBirth);
    }
  }

  Future<void> createPangeaUser({required String dob}) async {
    final PUserModel newUserModel = await PUserRepo.repoCreatePangeaUser(
      userID: userId!,
      fullName: fullname,
      dob: dob,
      matrixAccessToken: _matrixAccessToken!,
    );
    await _savePUserModel(newUserModel);

    await setMatrixProfile(dob);
  }

  String? get _matrixAccessToken =>
      _pangeaController.matrixState.client.accessToken;

  bool get isPublic =>
      _pangeaController.userController.userModel?.profile?.publicProfile ??
      false;

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
