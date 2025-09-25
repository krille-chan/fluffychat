import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PlanTripPage extends StatefulWidget {
  final String langCode;
  const PlanTripPage({
    super.key,
    required this.langCode,
  });

  @override
  State<PlanTripPage> createState() => PlanTripPageState();
}

class PlanTripPageState extends State<PlanTripPage> {
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
    final l2Set = await MatrixState.pangeaController.userController.isUserL2Set;
    if (l2Set) {
      if (mounted) setState(() => _loadingProfile = false);
      return;
    }

    if (mounted) {
      setState(() {
        _loadingProfile = true;
        _profileError = null;
      });
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
    } catch (err) {
      if (err is MatrixException) {
        _profileError = err.errorMessage;
      } else {
        _profileError = err.toLocalizedString(context);
      }
    } finally {
      if (mounted) {
        setState(() => _loadingProfile = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined),
            Text(L10n.of(context).planTrip),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: _loadingProfile
              ? const CircularProgressIndicator.adaptive()
              : _profileError != null
                  ? const ErrorIndicator(
                      message: "Failed to create profile",
                    )
                  : Container(
                      padding: const EdgeInsets.all(30.0),
                      constraints: const BoxConstraints(
                        maxWidth: 350,
                        maxHeight: 600,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PangeaLogoSvg(
                            width: 100.0,
                            forceColor: theme.colorScheme.onSurface,
                          ),
                          Column(
                            spacing: 16.0,
                            children: [
                              Text(
                                L10n.of(context).howAreYouTraveling,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => context.go(
                                  "/course/${widget.langCode}/private",
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.surface,
                                  foregroundColor: theme.colorScheme.onSurface,
                                  side: BorderSide(
                                    width: 1,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                child: Row(
                                  spacing: 4.0,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.map_outlined),
                                    Text(L10n.of(context).unlockPrivateTrip),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => context.go(
                                  "/course/${widget.langCode}/public",
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.surface,
                                  foregroundColor: theme.colorScheme.onSurface,
                                  side: BorderSide(
                                    width: 1,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                child: Row(
                                  spacing: 4.0,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Symbols.map_search),
                                    Text(L10n.of(context).joinPublicTrip),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => context.go(
                                  "/course/${widget.langCode}/own",
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.surface,
                                  foregroundColor: theme.colorScheme.onSurface,
                                  side: BorderSide(
                                    width: 1,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                child: Row(
                                  spacing: 4.0,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.map_outlined),
                                    Text(L10n.of(context).startOwnTrip),
                                  ],
                                ),
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                leading: const Icon(Icons.school),
                                title: Text(
                                  L10n.of(context).tripPlanDesc,
                                  style: theme.textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
