import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CreatePangeaAccountPage extends StatefulWidget {
  final String langCode;
  const CreatePangeaAccountPage({
    super.key,
    required this.langCode,
  });

  @override
  CreatePangeaAccountPageState createState() => CreatePangeaAccountPageState();
}

class CreatePangeaAccountPageState extends State<CreatePangeaAccountPage> {
  bool _loadingProfile = true;
  Object? _profileError;

  final List<String> avatarPaths = const [
    "assets/pangea/Avatar_1.png",
    "assets/pangea/Avatar_2.png",
    "assets/pangea/Avatar_3.png",
    "assets/pangea/Avatar_4.png",
    "assets/pangea/Avatar_5.png",
  ];

  @override
  void initState() {
    super.initState();
    _createUserInPangea();
  }

  Future<void> _setAvatar() async {
    final client = Matrix.of(context).client;
    try {
      final random = Random();
      final selectedAvatarPath =
          avatarPaths[random.nextInt(avatarPaths.length)];

      final ByteData byteData = await rootBundle.load(selectedAvatarPath);
      final Uint8List bytes = byteData.buffer.asUint8List();
      final file = MatrixFile(
        bytes: bytes,
        name: selectedAvatarPath,
      );
      await client.setAvatar(file);
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
    }
  }

  Future<void> _createUserInPangea() async {
    setState(() {
      _loadingProfile = true;
      _profileError = null;
    });

    final l2Set = await MatrixState.pangeaController.userController.isUserL2Set;
    if (l2Set) {
      context.go('/registration/course');
      return;
    }

    try {
      final updateFuture = [
        _setAvatar(),
        MatrixState.pangeaController.userController.updateProfile(
          (profile) {
            final systemLang = MatrixState
                .pangeaController.languageController.systemLanguage?.langCode;

            if (systemLang != null) {
              profile.userSettings.sourceLanguage = systemLang;
            }

            profile.userSettings.targetLanguage = widget.langCode;
            profile.userSettings.createdAt = DateTime.now();
            return profile;
          },
          waitForDataInSync: true,
        ),
        MatrixState.pangeaController.userController.updateAnalyticsProfile(
          targetLanguage: PLanguageStore.byLangCode(widget.langCode),
          baseLanguage:
              MatrixState.pangeaController.languageController.systemLanguage,
          level: 1,
        ),
      ];

      await Future.wait(updateFuture).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(L10n.of(context).oopsSomethingWentWrong);
        },
      );

      await MatrixState.pangeaController.subscriptionController.reinitialize();
      context.go('/registration/course');
    } catch (err) {
      if (err is MatrixException) {
        _profileError = err.errorMessage;
      } else {
        _profileError = err;
      }
    } finally {
      if (mounted) {
        setState(() => _loadingProfile = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingProfile && _profileError != null) {
      context.go('/registration/course');
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _loadingProfile
              ? const CircularProgressIndicator.adaptive()
              : _profileError != null
                  ? Column(
                      spacing: 8.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ErrorIndicator(
                          message: L10n.of(context).oopsSomethingWentWrong,
                        ),
                        TextButton(
                          onPressed: _createUserInPangea,
                          child: Text(L10n.of(context).tryAgain),
                        ),
                      ],
                    )
                  : null,
        ),
      ),
    );
  }
}
