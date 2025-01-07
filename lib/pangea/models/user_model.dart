import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/instructions_enum.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'language_model.dart';

/// The user's settings learning settings.
class UserSettings {
  DateTime? dateOfBirth;
  DateTime? createdAt;
  bool autoPlayMessages;
  // bool itAutoPlay;
  bool activatedFreeTrial;
  bool publicProfile;
  String? targetLanguage;
  String? sourceLanguage;
  String? country;
  bool? hasJoinedHelpSpace;

  UserSettings({
    this.dateOfBirth,
    this.createdAt,
    this.autoPlayMessages = false,
    // this.itAutoPlay = true,
    this.activatedFreeTrial = false,
    this.publicProfile = false,
    this.targetLanguage,
    this.sourceLanguage,
    this.country,
    this.hasJoinedHelpSpace,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        dateOfBirth: json[ModelKey.userDateOfBirth] != null
            ? DateTime.parse(json[ModelKey.userDateOfBirth])
            : null,
        createdAt: json[ModelKey.userCreatedAt] != null
            ? DateTime.parse(json[ModelKey.userCreatedAt])
            : null,
        autoPlayMessages: json[ModelKey.autoPlayMessages] ?? false,
        // itAutoPlay: json[ModelKey.itAutoPlay] ?? true,
        activatedFreeTrial: json[ModelKey.activatedTrialKey] ?? false,
        publicProfile: json[ModelKey.publicProfile] ?? false,
        targetLanguage: json[ModelKey.l2LanguageKey],
        sourceLanguage: json[ModelKey.l1LanguageKey],
        country: json[ModelKey.userCountry],
        hasJoinedHelpSpace: json[ModelKey.hasJoinedHelpSpace],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ModelKey.userDateOfBirth] = dateOfBirth?.toIso8601String();
    data[ModelKey.userCreatedAt] = createdAt?.toIso8601String();
    data[ModelKey.autoPlayMessages] = autoPlayMessages;
    // data[ModelKey.itAutoPlay] = itAutoPlay;
    data[ModelKey.activatedTrialKey] = activatedFreeTrial;
    data[ModelKey.publicProfile] = publicProfile;
    data[ModelKey.l2LanguageKey] = targetLanguage;
    data[ModelKey.l1LanguageKey] = sourceLanguage;
    data[ModelKey.userCountry] = country;
    data[ModelKey.hasJoinedHelpSpace] = hasJoinedHelpSpace;
    return data;
  }

  static UserSettings? migrateFromAccountData() {
    final accountData =
        MatrixState.pangeaController.matrixState.client.accountData;

    if (!accountData.containsKey(ModelKey.userDateOfBirth)) return null;
    final dobContent = accountData[ModelKey.userDateOfBirth]!
        .content[ModelKey.userDateOfBirth];

    String? dobString;
    if (dobContent != null) {
      dobString = dobContent as String;
    }

    DateTime dob;
    try {
      dob = DateTime.parse(dobString!);
    } catch (_) {
      return null;
    }

    final createdAtContent =
        accountData[ModelKey.userCreatedAt]?.content[ModelKey.userCreatedAt];
    DateTime? createdAt;
    if (createdAtContent != null) {
      try {
        createdAt = DateTime.parse(createdAtContent as String);
      } catch (_) {
        createdAt = null;
      }
    }

    return UserSettings(
      dateOfBirth: dob,
      createdAt: createdAt,
      autoPlayMessages: (accountData[ModelKey.autoPlayMessages]
              ?.content[ModelKey.autoPlayMessages] as bool?) ??
          false,
      // itAutoPlay: (accountData[ModelKey.itAutoPlay]
      //         ?.content[ModelKey.itAutoPlay] as bool?) ??
      //     true,
      activatedFreeTrial: (accountData[ModelKey.activatedTrialKey]
              ?.content[ModelKey.activatedTrialKey] as bool?) ??
          false,
      publicProfile: (accountData[ModelKey.publicProfile]
              ?.content[ModelKey.publicProfile] as bool?) ??
          false,
      targetLanguage: accountData[ModelKey.l2LanguageKey]
          ?.content[ModelKey.l2LanguageKey] as String?,
      sourceLanguage: accountData[ModelKey.l1LanguageKey]
          ?.content[ModelKey.l1LanguageKey] as String?,
      country: accountData[ModelKey.userCountry]?.content[ModelKey.userCountry]
          as String?,
    );
  }
}

/// The user's language tool settings.
class UserToolSettings {
  bool interactiveTranslator;
  bool interactiveGrammar;
  bool immersionMode;
  bool definitions;
  bool autoIGC;
  bool enableTTS;

  UserToolSettings({
    this.interactiveTranslator = true,
    this.interactiveGrammar = true,
    this.immersionMode = false,
    this.definitions = true,
    this.autoIGC = true,
    this.enableTTS = true,
  });

  factory UserToolSettings.fromJson(Map<String, dynamic> json) =>
      UserToolSettings(
        interactiveTranslator:
            json[ToolSetting.interactiveTranslator.toString()] ?? true,
        interactiveGrammar:
            json[ToolSetting.interactiveGrammar.toString()] ?? true,
        immersionMode: false,
        definitions: json[ToolSetting.definitions.toString()] ?? true,
        autoIGC: json[ToolSetting.autoIGC.toString()] ?? true,
        enableTTS: json[ToolSetting.enableTTS.toString()] ?? true,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ToolSetting.interactiveTranslator.toString()] = interactiveTranslator;
    data[ToolSetting.interactiveGrammar.toString()] = interactiveGrammar;
    data[ToolSetting.immersionMode.toString()] = immersionMode;
    data[ToolSetting.definitions.toString()] = definitions;
    data[ToolSetting.autoIGC.toString()] = autoIGC;
    data[ToolSetting.enableTTS.toString()] = enableTTS;
    return data;
  }

  factory UserToolSettings.migrateFromAccountData() {
    final accountData =
        MatrixState.pangeaController.matrixState.client.accountData;
    return UserToolSettings(
      interactiveTranslator:
          (accountData[ToolSetting.interactiveTranslator.toString()]
                      ?.content[ToolSetting.interactiveTranslator.toString()]
                  as bool?) ??
              true,
      interactiveGrammar:
          (accountData[ToolSetting.interactiveGrammar.toString()]
                      ?.content[ToolSetting.interactiveGrammar.toString()]
                  as bool?) ??
              true,
      immersionMode: false,
      definitions: (accountData[ToolSetting.definitions.toString()]
              ?.content[ToolSetting.definitions.toString()] as bool?) ??
          true,
      autoIGC: (accountData[ToolSetting.autoIGC.toString()]
              ?.content[ToolSetting.autoIGC.toString()] as bool?) ??
          true,
    );
  }
}

/// The user's settings for whether or not to show instuction messages.
class UserInstructions {
  bool showedItInstructions;
  bool showedClickMessage;
  bool showedBlurMeansTranslate;
  bool showedTooltipInstructions;
  bool showedMissingVoice;
  bool showedClickBestOption;
  bool showedUnlockedLanguageTools;

  bool showedSpeechToTextTooltip;
  bool showedL1TranslationTooltip;
  bool showedTranslationChoicesTooltip;
  bool showedClickAgainToDeselect;

  UserInstructions({
    this.showedItInstructions = false,
    this.showedClickMessage = false,
    this.showedBlurMeansTranslate = false,
    this.showedTooltipInstructions = false,
    this.showedSpeechToTextTooltip = false,
    this.showedL1TranslationTooltip = false,
    this.showedTranslationChoicesTooltip = false,
    this.showedClickAgainToDeselect = false,
    this.showedMissingVoice = false,
    this.showedClickBestOption = false,
    this.showedUnlockedLanguageTools = false,
  });

  factory UserInstructions.fromJson(Map<String, dynamic> json) =>
      UserInstructions(
        showedItInstructions: json[InstructionsEnum.itInstructions.toString()],
        showedClickMessage:
            json[InstructionsEnum.clickMessage.toString()] ?? false,
        showedBlurMeansTranslate:
            json[InstructionsEnum.blurMeansTranslate.toString()] ?? false,
        showedTooltipInstructions:
            json[InstructionsEnum.tooltipInstructions.toString()] ?? false,
        showedL1TranslationTooltip:
            json[InstructionsEnum.l1Translation.toString()] ?? false,
        showedTranslationChoicesTooltip:
            json[InstructionsEnum.translationChoices.toString()] ?? false,
        showedSpeechToTextTooltip:
            json[InstructionsEnum.speechToText.toString()] ?? false,
        showedClickAgainToDeselect:
            json[InstructionsEnum.clickAgainToDeselect.toString()] ?? false,
        showedMissingVoice:
            json[InstructionsEnum.missingVoice.toString()] ?? false,
        showedClickBestOption:
            json[InstructionsEnum.clickBestOption.toString()] ?? false,
        showedUnlockedLanguageTools:
            json[InstructionsEnum.unlockedLanguageTools.toString()] ?? false,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[InstructionsEnum.itInstructions.toString()] = showedItInstructions;
    data[InstructionsEnum.clickMessage.toString()] = showedClickMessage;
    data[InstructionsEnum.blurMeansTranslate.toString()] =
        showedBlurMeansTranslate;
    data[InstructionsEnum.tooltipInstructions.toString()] =
        showedTooltipInstructions;
    data[InstructionsEnum.l1Translation.toString()] =
        showedL1TranslationTooltip;
    data[InstructionsEnum.translationChoices.toString()] =
        showedTranslationChoicesTooltip;
    data[InstructionsEnum.speechToText.toString()] = showedSpeechToTextTooltip;
    data[InstructionsEnum.clickAgainToDeselect.toString()] =
        showedClickAgainToDeselect;
    data[InstructionsEnum.missingVoice.toString()] = showedMissingVoice;
    data[InstructionsEnum.clickBestOption.toString()] = showedClickBestOption;
    data[InstructionsEnum.unlockedLanguageTools.toString()] =
        showedUnlockedLanguageTools;
    return data;
  }

  factory UserInstructions.migrateFromAccountData() {
    final accountData =
        MatrixState.pangeaController.matrixState.client.accountData;
    return UserInstructions(
      showedItInstructions:
          (accountData[InstructionsEnum.itInstructions.toString()]
                      ?.content[InstructionsEnum.itInstructions.toString()]
                  as bool?) ??
              false,
      showedClickMessage: (accountData[InstructionsEnum.clickMessage.toString()]
              ?.content[InstructionsEnum.clickMessage.toString()] as bool?) ??
          false,
      showedBlurMeansTranslate:
          (accountData[InstructionsEnum.blurMeansTranslate.toString()]
                      ?.content[InstructionsEnum.blurMeansTranslate.toString()]
                  as bool?) ??
              false,
      showedTooltipInstructions:
          (accountData[InstructionsEnum.tooltipInstructions.toString()]
                      ?.content[InstructionsEnum.tooltipInstructions.toString()]
                  as bool?) ??
              false,
      showedL1TranslationTooltip:
          (accountData[InstructionsEnum.l1Translation.toString()]
                      ?.content[InstructionsEnum.l1Translation.toString()]
                  as bool?) ??
              false,
      showedTranslationChoicesTooltip:
          (accountData[InstructionsEnum.translationChoices.toString()]
                      ?.content[InstructionsEnum.translationChoices.toString()]
                  as bool?) ??
              false,
      showedSpeechToTextTooltip:
          (accountData[InstructionsEnum.speechToText.toString()]
                      ?.content[InstructionsEnum.speechToText.toString()]
                  as bool?) ??
              false,
      showedClickAgainToDeselect: (accountData[
                      InstructionsEnum.clickAgainToDeselect.toString()]
                  ?.content[InstructionsEnum.clickAgainToDeselect.toString()]
              as bool?) ??
          false,
    );
  }
}

/// A wrapper around the matrix account data for the user profile.
/// Enables easy access to the profile data and saving new data.
class Profile {
  late UserSettings userSettings;
  late UserToolSettings toolSettings;
  late UserInstructions instructionSettings;

  Profile({
    required this.userSettings,
    UserToolSettings? toolSettings,
    UserInstructions? instructionSettings,
  }) {
    this.toolSettings = toolSettings ?? UserToolSettings();
    this.instructionSettings = instructionSettings ?? UserInstructions();
  }

  /// Load an instance of profile from the client's account data.
  static Profile? fromAccountData() {
    final profileData = MatrixState.pangeaController.matrixState.client
        .accountData[ModelKey.userProfile]?.content;
    if (profileData == null) return null;

    final userSettingsContent = profileData[ModelKey.userSettings];
    if (userSettingsContent == null) return null;

    final toolSettingsContent = profileData[ModelKey.toolSettings];
    final instructionSettingsContent =
        profileData[ModelKey.instructionsSettings];

    return Profile(
      userSettings:
          UserSettings.fromJson(userSettingsContent as Map<String, dynamic>),
      toolSettings: toolSettingsContent != null
          ? UserToolSettings.fromJson(
              toolSettingsContent as Map<String, dynamic>,
            )
          : UserToolSettings(),
      instructionSettings: instructionSettingsContent != null
          ? UserInstructions.fromJson(
              instructionSettingsContent as Map<String, dynamic>,
            )
          : UserInstructions(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      ModelKey.userSettings: userSettings.toJson(),
      ModelKey.toolSettings: toolSettings.toJson(),
      ModelKey.instructionsSettings: instructionSettings.toJson(),
    };
    return json;
  }

  /// Migrate data from the old matrix account data
  /// format to the new matrix account data format.
  static Profile? migrateFromAccountData() {
    final userSettings = UserSettings.migrateFromAccountData();
    if (userSettings == null) return null;

    final toolSettings = UserToolSettings.migrateFromAccountData();
    final instructionSettings = UserInstructions.migrateFromAccountData();
    return Profile(
      userSettings: userSettings,
      toolSettings: toolSettings,
      instructionSettings: instructionSettings,
    );
  }

  /// Saves the current configuration of the profile to the client's account data.
  /// If [waitForDataInSync] is true, the function will wait for the updated account
  /// data to come through in a sync, indicating that it has been set on the matrix server.
  Future<void> saveProfileData({
    waitForDataInSync = false,
  }) async {
    final PangeaController pangeaController = MatrixState.pangeaController;
    final Client client = pangeaController.matrixState.client;
    final List<String> profileKeys = [
      ModelKey.userSettings,
      ModelKey.toolSettings,
      ModelKey.instructionsSettings,
    ];

    Future<SyncUpdate>? waitForUpdate;
    if (waitForDataInSync) {
      waitForUpdate = client.onSync.stream.firstWhere(
        (sync) =>
            sync.accountData != null &&
            sync.accountData!.any(
              (event) => event.content.keys.any((k) => profileKeys.contains(k)),
            ),
      );
    }
    await client.setAccountData(
      client.userID!,
      ModelKey.userProfile,
      toJson(),
    );

    if (waitForDataInSync) {
      await waitForUpdate;
    }
  }

  static Profile get emptyProfile {
    return Profile(
      userSettings: UserSettings(),
      toolSettings: UserToolSettings(),
      instructionSettings: UserInstructions(),
    );
  }
}

/// Model of data from pangea chat server. Not used anymore, in favor of matrix account data.
/// This class if used to read in data from the server to be migrated to matrix account data.
class PangeaProfile {
  final String createdAt;
  final String pangeaUserId;
  String? dateOfBirth;
  String? targetLanguage;
  String? sourceLanguage;

  String? country;
  bool publicProfile;

  PangeaProfile({
    required this.createdAt,
    required this.pangeaUserId,
    this.dateOfBirth,
    this.targetLanguage,
    this.sourceLanguage,
    this.country,
    this.publicProfile = false,
  });

  factory PangeaProfile.fromJson(Map<String, dynamic> json) {
    final l2 = LanguageModel.codeFromNameOrCode(
      json[ModelKey.l2LanguageKey],
    );
    final l1 = LanguageModel.codeFromNameOrCode(
      json[ModelKey.l1LanguageKey],
    );

    return PangeaProfile(
      createdAt: json[ModelKey.userCreatedAt],
      pangeaUserId: json[ModelKey.userPangeaUserId],
      dateOfBirth: json[ModelKey.userDateOfBirth],
      targetLanguage: l2,
      sourceLanguage: l1,
      publicProfile: json[ModelKey.publicProfile] ?? false,
      country: json[ModelKey.userCountry],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ModelKey.userCreatedAt] = createdAt;
    data[ModelKey.userPangeaUserId] = pangeaUserId;
    data[ModelKey.userDateOfBirth] = dateOfBirth;
    data[ModelKey.l2LanguageKey] = targetLanguage;
    data[ModelKey.l1LanguageKey] = sourceLanguage;
    data[ModelKey.publicProfile] = publicProfile;
    data[ModelKey.userCountry] = country;
    return data;
  }
}

class PangeaProfileResponse {
  final PangeaProfile profile;
  final String access;

  PangeaProfileResponse({
    required this.profile,
    required this.access,
  });

  factory PangeaProfileResponse.fromJson(Map<String, dynamic> json) {
    return PangeaProfileResponse(
      profile: PangeaProfile.fromJson(json[ModelKey.userProfile]),
      access: json[ModelKey.userAccess],
    );
  }
}
