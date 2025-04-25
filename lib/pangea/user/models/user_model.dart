import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/instructions/instruction_settings.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/spaces/models/space_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../learning_settings/models/language_model.dart';

/// The user's settings learning settings.
class UserSettings {
  DateTime? dateOfBirth;
  DateTime? createdAt;
  bool? autoPlayMessages;
  bool? publicProfile;
  String? targetLanguage;
  String? sourceLanguage;
  String? country;
  bool? hasJoinedHelpSpace;
  LanguageLevelTypeEnum cefrLevel;

  UserSettings({
    this.dateOfBirth,
    this.createdAt,
    this.autoPlayMessages,
    this.publicProfile,
    this.targetLanguage,
    this.sourceLanguage,
    this.country,
    this.hasJoinedHelpSpace,
    this.cefrLevel = LanguageLevelTypeEnum.a1,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        dateOfBirth: json[ModelKey.userDateOfBirth] != null
            ? DateTime.parse(json[ModelKey.userDateOfBirth])
            : null,
        createdAt: json[ModelKey.userCreatedAt] != null
            ? DateTime.parse(json[ModelKey.userCreatedAt])
            : null,
        autoPlayMessages: json[ModelKey.autoPlayMessages],
        publicProfile: json[ModelKey.publicProfile],
        targetLanguage: json[ModelKey.l2LanguageKey],
        sourceLanguage: json[ModelKey.l1LanguageKey],
        country: json[ModelKey.userCountry],
        hasJoinedHelpSpace: json[ModelKey.hasJoinedHelpSpace],
        cefrLevel: json[ModelKey.cefrLevel] is String
            ? LanguageLevelTypeEnumExtension.fromString(
                json[ModelKey.cefrLevel],
              )
            : LanguageLevelTypeEnum.a1,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ModelKey.userDateOfBirth] = dateOfBirth?.toIso8601String();
    data[ModelKey.userCreatedAt] = createdAt?.toIso8601String();
    data[ModelKey.autoPlayMessages] = autoPlayMessages;
    data[ModelKey.publicProfile] = publicProfile;
    data[ModelKey.l2LanguageKey] = targetLanguage;
    data[ModelKey.l1LanguageKey] = sourceLanguage;
    data[ModelKey.userCountry] = country;
    data[ModelKey.hasJoinedHelpSpace] = hasJoinedHelpSpace;
    data[ModelKey.cefrLevel] = cefrLevel.string;
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

  UserSettings copy() {
    return UserSettings(
      dateOfBirth: dateOfBirth,
      createdAt: createdAt,
      autoPlayMessages: autoPlayMessages,
      publicProfile: publicProfile,
      targetLanguage: targetLanguage,
      sourceLanguage: sourceLanguage,
      country: country,
      hasJoinedHelpSpace: hasJoinedHelpSpace,
      cefrLevel: cefrLevel,
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
  bool enableAutocorrect;

  UserToolSettings({
    this.interactiveTranslator = true,
    this.interactiveGrammar = true,
    this.immersionMode = false,
    this.definitions = true,
    this.autoIGC = true,
    this.enableTTS = true,
    this.enableAutocorrect = false,
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
        enableAutocorrect: json["enableAutocorrect"] ?? false,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ToolSetting.interactiveTranslator.toString()] = interactiveTranslator;
    data[ToolSetting.interactiveGrammar.toString()] = interactiveGrammar;
    data[ToolSetting.immersionMode.toString()] = immersionMode;
    data[ToolSetting.definitions.toString()] = definitions;
    data[ToolSetting.autoIGC.toString()] = autoIGC;
    data[ToolSetting.enableTTS.toString()] = enableTTS;
    data["enableAutocorrect"] = enableAutocorrect;
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

  UserToolSettings copy() {
    return UserToolSettings(
      interactiveTranslator: interactiveTranslator,
      interactiveGrammar: interactiveGrammar,
      immersionMode: immersionMode,
      definitions: definitions,
      autoIGC: autoIGC,
      enableTTS: enableTTS,
      enableAutocorrect: enableAutocorrect,
    );
  }
}

/// A wrapper around the matrix account data for the user profile.
/// Enables easy access to the profile data and saving new data.
class Profile {
  late UserSettings userSettings;
  late UserToolSettings toolSettings;
  late InstructionSettings instructionSettings;

  Profile({
    required this.userSettings,
    UserToolSettings? toolSettings,
    InstructionSettings? instructionSettings,
  }) {
    this.toolSettings = toolSettings ?? UserToolSettings();
    this.instructionSettings = instructionSettings ?? InstructionSettings();
  }

  /// Load an instance of profile from the client's account data.
  static Profile? fromAccountData(Map<String, Object?>? profileData) {
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
          ? InstructionSettings.fromJson(
              instructionSettingsContent as Map<String, dynamic>,
            )
          : InstructionSettings(),
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
    final instructionSettings = InstructionSettings.migrateFromAccountData();
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
      instructionSettings: InstructionSettings(),
    );
  }

  Profile copy() {
    return Profile(
      userSettings: userSettings.copy(),
      toolSettings: toolSettings.copy(),
      instructionSettings: instructionSettings.copy(),
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
  bool? publicProfile;

  PangeaProfile({
    required this.createdAt,
    required this.pangeaUserId,
    this.dateOfBirth,
    this.targetLanguage,
    this.sourceLanguage,
    this.country,
    this.publicProfile,
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
      publicProfile: json[ModelKey.publicProfile],
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
