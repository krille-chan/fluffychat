// Dart imports:
import 'dart:async';
import 'dart:developer';

// Package imports:
import 'package:collection/collection.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:matrix/matrix.dart' as matrix;

// Project imports:
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
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
      }
      _completeCompleter();

      return newUserModel;
    } catch (err) {
      log("User model not found. Probably first signup and needs Pangea account");
      rethrow;
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
      final PUserModel? toCheck = userModel ?? (await fetchUserModel());
      return toCheck?.profile?.dateOfBirth != null ? true : false;
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

  _savePUserModel(PUserModel? pUserModel) {
    final jsonUser = pUserModel!.toJson();
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
  }

  Future<void> createPangeaUser({required String dob}) async {
    final PUserModel newUserModel = await PUserRepo.repoCreatePangeaUser(
      userID: userId!,
      dateOfBirth: dob,
      fullName: fullname,
      matrixAccessToken: _matrixAccessToken!,
    );
    await _savePUserModel(newUserModel);
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
