import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/login/pages/user_settings_view.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  UserSettingsState createState() => UserSettingsState();
}

class UserSettingsState extends State<UserSettingsPage> {
  PangeaController get _pangeaController => MatrixState.pangeaController;

  LanguageModel? selectedTargetLanguage;
  LanguageLevelTypeEnum selectedCefrLevel = LanguageLevelTypeEnum.a1;

  String? selectedLanguageError;
  String? profileCreationError;
  String? tncError;

  bool loading = false;

  Uint8List? avatar;
  String? _selectedFilePath;

  List<String> avatarPaths = const [
    "assets/pangea/Avatar_1.png",
    "assets/pangea/Avatar_2.png",
    "assets/pangea/Avatar_3.png",
    "assets/pangea/Avatar_4.png",
    "assets/pangea/Avatar_5.png",
  ];
  String? selectedAvatarPath;

  LanguageModel? get _systemLanguage {
    final systemLangCode =
        _pangeaController.languageController.systemLanguage?.langCode;
    return systemLangCode == null
        ? null
        : PLanguageStore.byLangCode(systemLangCode);
  }

  TextEditingController displayNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedTargetLanguage = _pangeaController.languageController.userL2;
    selectedAvatarPath = avatarPaths.first;
    displayNameController.text = Matrix.of(context).client.userID?.localpart ??
        Matrix.of(context).client.userID ??
        "";
  }

  @override
  void dispose() {
    displayNameController.dispose();
    loading = false;
    selectedLanguageError = null;
    profileCreationError = null;
    tncError = null;
    super.dispose();
  }

  void setSelectedTargetLanguage(LanguageModel? language) {
    setState(() {
      selectedTargetLanguage = language;
      selectedLanguageError = null;
    });
  }

  void setSelectedCefrLevel(LanguageLevelTypeEnum? cefrLevel) {
    setState(() {
      selectedCefrLevel = cefrLevel ?? LanguageLevelTypeEnum.a1;
    });
  }

  void setSelectedAvatarPath(int index) {
    if (index < 0 || index >= avatarPaths.length) return;
    setState(() {
      avatar = null;
      selectedAvatarPath = avatarPaths[index];
    });
  }

  int get selectedAvatarIndex {
    if (selectedAvatarPath == null) return -1;
    return avatarPaths.indexOf(selectedAvatarPath!);
  }

  void uploadAvatar() async {
    final photo = await selectFiles(
      context,
      type: FileSelectorType.images,
      allowMultiple: false,
    );
    final selectedFile = photo.singleOrNull;
    final bytes = await selectedFile?.readAsBytes();
    final path = selectedFile?.path;

    setState(() {
      selectedAvatarPath = null;
      avatar = bytes;
      _selectedFilePath = path;
    });
  }

  Future<void> _setAvatar() async {
    final client = Matrix.of(context).client;
    try {
      MatrixFile? file;
      if (avatar != null && _selectedFilePath != null) {
        file = MatrixFile(
          bytes: avatar!,
          name: _selectedFilePath!,
        );
      } else if (selectedAvatarPath != null) {
        final ByteData byteData = await rootBundle.load(selectedAvatarPath!);
        final Uint8List bytes = byteData.buffer.asUint8List();
        file = MatrixFile(
          bytes: bytes,
          name: selectedAvatarPath!,
        );
      }
      if (file != null) await client.setAvatar(file);
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          "avatar": avatar.toString(),
        },
      );
    }
  }

  Future<void> _setDisplayName() async {
    final displayName = displayNameController.text.trim();
    if (displayName.isEmpty) return;

    final client = Matrix.of(context).client;
    if (client.userID == null) return;
    await client.setDisplayName(client.userID!, displayName);
  }

  Future<void> createUserInPangea() async {
    setState(() {
      profileCreationError = null;
      selectedLanguageError = null;
      tncError = null;
    });

    if (selectedTargetLanguage == null) {
      setState(() {
        selectedLanguageError = L10n.of(context).pleaseSelectALanguage;
      });
      return;
    }

    if (!formKey.currentState!.validate()) return;
    setState(() => loading = true);

    try {
      final updateFuture = [
        _setDisplayName(),
        _setAvatar(),
        _pangeaController.subscriptionController.reinitialize(),
        _pangeaController.userController.updateProfile(
          (profile) {
            if (_systemLanguage != null) {
              profile.userSettings.sourceLanguage = _systemLanguage!.langCode;
            }
            profile.userSettings.targetLanguage =
                selectedTargetLanguage!.langCode;
            profile.userSettings.cefrLevel = selectedCefrLevel;
            profile.userSettings.createdAt = DateTime.now();
            return profile;
          },
          waitForDataInSync: true,
        ),
        _pangeaController.userController.updatePublicProfile(
          targetLanguage: selectedTargetLanguage,
          baseLanguage: _systemLanguage,
          level: 1,
        ),
      ];
      await Future.wait(updateFuture).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(L10n.of(context).oopsSomethingWentWrong);
        },
      );
      context.go(
        _pangeaController.classController.cachedClassCode == null
            ? '/user_age/join_space'
            : '/rooms',
      );
    } catch (err) {
      if (err is MatrixException) {
        profileCreationError = err.errorMessage;
      } else {
        profileCreationError = err.toLocalizedString(context);
      }
      if (mounted) setState(() {});
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  List<LanguageModel> get targetOptions =>
      _pangeaController.pLanguageStore.targetOptions;

  @override
  Widget build(BuildContext context) => UserSettingsView(controller: this);
}
