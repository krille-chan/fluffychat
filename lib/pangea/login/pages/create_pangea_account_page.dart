import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plans_repo.dart';
import 'package:fluffychat/pangea/course_plans/courses/get_localized_courses_request.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/login/utils/lang_code_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CreatePangeaAccountPage extends StatefulWidget {
  const CreatePangeaAccountPage({
    super.key,
  });

  @override
  CreatePangeaAccountPageState createState() => CreatePangeaAccountPageState();
}

class CreatePangeaAccountPageState extends State<CreatePangeaAccountPage> {
  bool _loading = true;

  Object? _profileError;
  Object? _courseError;

  @override
  void initState() {
    super.initState();
    _createProfile();
  }

  String? _spaceId;
  String? _courseLangCode;

  String avatarPath(int num) => "avatar_$num.png";

  Future<LanguageSettings?> get _cachedLangCode => LangCodeRepo.get();

  Future<String?> get _targetLangCode async =>
      _courseLangCode ?? (await _cachedLangCode)?.targetLangCode;

  Future<String?> get _baseLangCode async =>
      (await _cachedLangCode)?.baseLangCode ??
      MatrixState.pangeaController.languageController.systemLanguage?.langCode;

  String? get _cachedSpaceCode =>
      MatrixState.pangeaController.spaceCodeController.cachedSpaceCode;

  Future<void> _createProfile() async {
    setState(() {
      _loading = true;
      _profileError = null;
      _courseError = null;
    });

    await _joinCachedCourse();
    if (mounted) {
      await _createUserInPangea();
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _joinCachedCourse() async {
    await MatrixState.pangeaController.spaceCodeController.initCompleter.future;
    if (_cachedSpaceCode == null) return;

    try {
      final spaceId = await MatrixState.pangeaController.spaceCodeController
          .joinCachedSpaceCode(context);

      if (spaceId == null) {
        throw Exception('Failed to join space with code $_cachedSpaceCode');
      }

      final client = Matrix.of(context).client;
      Room? room = client.getRoomById(spaceId);
      if (room == null || room.membership != Membership.join) {
        await client.waitForRoomInSync(spaceId, join: true);
        room = client.getRoomById(spaceId);
        if (room == null || room.membership != Membership.join) {
          throw Exception('Failed to join space with code $_cachedSpaceCode');
        }
      }

      final courseId = room.coursePlan?.uuid;
      if (courseId == null) {
        throw Exception('No course plan associated with space $spaceId');
      }

      final course = await CoursePlansRepo.get(
        GetLocalizedCoursesRequest(
          coursePlanIds: [courseId],
          l1: MatrixState.pangeaController.languageController.activeL1Code()!,
        ),
      );

      _spaceId = spaceId;
      _courseLangCode = course.targetLanguage;
    } catch (err) {
      _courseError = err;
    }
  }

  Future<void> _setAvatar() async {
    final client = Matrix.of(context).client;
    try {
      final random = Random();
      final selectedAvatarPath = avatarPath(random.nextInt(4) + 1);
      final avatarUrl =
          Uri.parse("${AppConfig.assetsBaseURL}/$selectedAvatarPath");
      await client.setAvatarUrl(client.userID!, avatarUrl);
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
    }
  }

  Future<void> _updateLanguageSettings() async {
    final targetLangCode = await _targetLangCode;
    final baseLangCode = await _baseLangCode;
    await MatrixState.pangeaController.userController.updateProfile(
      (profile) {
        profile.userSettings.targetLanguage = targetLangCode;
        if (baseLangCode != null) {
          profile.userSettings.sourceLanguage = baseLangCode;
        }
        return profile;
      },
      waitForDataInSync: true,
    );
  }

  Future<void> _createUserInPangea() async {
    final l2Set = await MatrixState.pangeaController.userController.isUserL2Set;
    if (l2Set) {
      await _updateLanguageSettings();
      _onProfileCreated();
      return;
    }

    try {
      final baseLangCode = await _baseLangCode;
      final targetLangCode = await _targetLangCode;

      // User's L2 is not set and they niether have a target language in their
      // local storage nor can they get it from a course they plan to join.
      // Redirect back to language selection.
      // This can happen if a user creates a new account via login => SSO
      if (targetLangCode == null) {
        context.go('/registration');
      }

      final updateFuture = [
        _setAvatar(),
        MatrixState.pangeaController.userController.updateProfile(
          (profile) {
            profile.userSettings.targetLanguage = targetLangCode;
            if (baseLangCode != null) {
              profile.userSettings.sourceLanguage = baseLangCode;
            }
            profile.userSettings.createdAt = DateTime.now();
            return profile;
          },
          waitForDataInSync: true,
        ),
        if (targetLangCode != null)
          MatrixState.pangeaController.userController.updateAnalyticsProfile(
            targetLanguage: PLanguageStore.byLangCode(targetLangCode),
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
      await _onProfileCreated();
    } catch (err) {
      if (err is MatrixException) {
        _profileError = err.errorMessage;
      } else {
        _profileError = err;
      }
    }
  }

  Future<void> _onProfileCreated() async {
    await LangCodeRepo.remove();
    context.go(
      _spaceId != null
          ? '/rooms/spaces/$_spaceId/details'
          : '/registration/course',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _loading
              ? const CircularProgressIndicator.adaptive()
              : _profileError != null || _courseError != null
                  ? Column(
                      spacing: 8.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ErrorIndicator(
                          message: L10n.of(context).oopsSomethingWentWrong,
                        ),
                        Row(
                          spacing: 8.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: _createUserInPangea,
                              child: Text(L10n.of(context).tryAgain),
                            ),
                            TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: Text(L10n.of(context).cancel),
                            ),
                          ],
                        ),
                      ],
                    )
                  : null,
        ),
      ),
    );
  }
}
