import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/controllers/base_controller.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:flutter/material.dart';
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

  Future<void> createPangeaUser({required String dob}) async {
    final PUserModel newUserModel = await PUserRepo.repoCreatePangeaUser(
      userID: userId!,
      fullName: fullname,
      dob: dob,
      matrixAccessToken: _matrixAccessToken!,
    );
    newUserModel.save(_pangeaController);
    await updateMatrixProfile(dateOfBirth: dob);
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
      newUserModel?.save(_pangeaController);
      await migrateMatrixProfile();
      _completeCompleter();

      return newUserModel;
    } catch (err) {
      debugPrint(
        "User model not found. Probably first signup and needs Pangea account",
      );
      rethrow;
    }
  }

  dynamic migratedProfileInfo(MatrixProfile key) {
    final dynamic localValue = _pangeaController.pStoreService.read(
      key.title,
      local: true,
    );
    final dynamic matrixValue = _pangeaController.pStoreService.read(
      key.title,
    );
    return localValue != null && matrixValue != localValue ? localValue : null;
  }

  Future<void> migrateMatrixProfile() async {
    final String? pangeaDob = userModel?.profile?.dateOfBirth;
    final String? matrixDob = _pangeaController.pStoreService.read(
      ModelKey.userDateOfBirth,
    );
    final String? dob =
        pangeaDob != null && matrixDob != pangeaDob ? pangeaDob : null;

    final bool? autoPlay = migratedProfileInfo(MatrixProfile.autoPlayMessages);
    final bool? trial = migratedProfileInfo(MatrixProfile.activatedFreeTrial);
    final bool? interactiveTranslator =
        migratedProfileInfo(MatrixProfile.interactiveTranslator);
    final bool? interactiveGrammar =
        migratedProfileInfo(MatrixProfile.interactiveGrammar);
    final bool? immersionMode =
        migratedProfileInfo(MatrixProfile.immersionMode);
    final bool? definitions = migratedProfileInfo(MatrixProfile.definitions);
    final bool? translations = migratedProfileInfo(MatrixProfile.translations);
    final bool? showItInstructions =
        migratedProfileInfo(MatrixProfile.showedItInstructions);
    final bool? showClickMessage =
        migratedProfileInfo(MatrixProfile.showedClickMessage);
    final bool? showBlurMeansTranslate =
        migratedProfileInfo(MatrixProfile.showedBlurMeansTranslate);

    await updateMatrixProfile(
      dateOfBirth: dob,
      autoPlayMessages: autoPlay,
      activatedFreeTrial: trial,
      interactiveTranslator: interactiveTranslator,
      interactiveGrammar: interactiveGrammar,
      immersionMode: immersionMode,
      definitions: definitions,
      translations: translations,
      showedItInstructions: showItInstructions,
      showedClickMessage: showClickMessage,
      showedBlurMeansTranslate: showBlurMeansTranslate,
    );
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

    PUserModel(
      access: await accessToken,
      refresh: userModel!.refresh,
      profile: updatedUserProfile,
    ).save(_pangeaController);
    if (dateOfBirth != null) {
      await updateMatrixProfile(dateOfBirth: dateOfBirth);
    }
  }

  PUserModel? get userModel {
    final data = _pangeaController.pStoreService.read(
      PLocalKey.user,
      local: true,
    );
    return data != null ? PUserModel.fromJson(data) : null;
  }

  Future<void> updateMatrixProfile({
    String? dateOfBirth,
    bool? autoPlayMessages,
    bool? activatedFreeTrial,
    bool? interactiveTranslator,
    bool? interactiveGrammar,
    bool? immersionMode,
    bool? definitions,
    bool? translations,
    bool? showedItInstructions,
    bool? showedClickMessage,
    bool? showedBlurMeansTranslate,
  }) async {
    if (dateOfBirth != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.dateOfBirth.title,
        dateOfBirth,
      );
    }
    if (autoPlayMessages != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.autoPlayMessages.title,
        autoPlayMessages,
      );
    }
    if (activatedFreeTrial != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.activatedFreeTrial.title,
        activatedFreeTrial,
      );
    }
    if (interactiveTranslator != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.interactiveTranslator.title,
        interactiveTranslator,
      );
    }
    if (interactiveGrammar != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.interactiveGrammar.title,
        interactiveGrammar,
      );
    }
    if (immersionMode != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.immersionMode.title,
        immersionMode,
      );
    }
    if (definitions != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.definitions.title,
        definitions,
      );
    }
    if (translations != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.translations.title,
        translations,
      );
    }
    if (showedItInstructions != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.showedItInstructions.title,
        showedItInstructions,
      );
    }
    if (showedClickMessage != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.showedClickMessage.title,
        showedClickMessage,
      );
    }
    if (showedBlurMeansTranslate != null) {
      await _pangeaController.pStoreService.save(
        MatrixProfile.showedBlurMeansTranslate.title,
        showedBlurMeansTranslate,
      );
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
      final client = _pangeaController.matrixState.client;
      if (client.prevBatch == null) {
        await client.onSync.stream.first;
      }
      await fetchUserModel();
      final localAccountData = _pangeaController.pStoreService.read(
        ModelKey.userDateOfBirth,
      );
      return localAccountData != null;
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
