import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

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
    _createProfile();
  }

  String? _spaceId;
  String? _courseLangCode;

  Future<String?> get _cachedLangCode => LangCodeRepo.get();

  Future<String?> get _langCode async =>
      _courseLangCode ?? (await _cachedLangCode);

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

  Future<void> _updateTargetLanguage() async {
    final langCode = await _langCode;
    await MatrixState.pangeaController.userController.updateProfile(
      (profile) {
        profile.userSettings.targetLanguage = langCode;
        return profile;
      },
      waitForDataInSync: true,
    );
  }

  Future<void> _createUserInPangea() async {
    final l2Set = await MatrixState.pangeaController.userController.isUserL2Set;
    if (l2Set) {
      await _updateTargetLanguage();
      _onProfileCreated();
      return;
    }

    try {
      final langCode = await _langCode;
      final updateFuture = [
        _setAvatar(),
        MatrixState.pangeaController.userController.updateProfile(
          (profile) {
            final systemLang = MatrixState
                .pangeaController.languageController.systemLanguage?.langCode;

            if (systemLang != null) {
              profile.userSettings.sourceLanguage = systemLang;
            }

            profile.userSettings.targetLanguage = langCode;
            profile.userSettings.createdAt = DateTime.now();
            return profile;
          },
          waitForDataInSync: true,
        ),
        if (langCode != null)
          MatrixState.pangeaController.userController.updateAnalyticsProfile(
            targetLanguage: PLanguageStore.byLangCode(langCode),
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
