import 'dart:async';

import 'package:flutter/material.dart';

import 'package:async/async.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_language_filter.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_filter.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_client_extension.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plans_repo.dart';
import 'package:fluffychat/pangea/course_plans/courses/get_localized_courses_response.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewCoursePage extends StatefulWidget {
  final String route;
  final String? spaceId;
  final bool showFilters;

  const NewCoursePage({
    super.key,
    required this.route,
    this.spaceId,
    this.showFilters = true,
  });

  @override
  State<NewCoursePage> createState() => NewCoursePageState();
}

class NewCoursePageState extends State<NewCoursePage> {
  final ValueNotifier<Result<GetLocalizedCoursesResponse>?> _courses =
      ValueNotifier(null);

  final ValueNotifier<LanguageModel?> _targetLanguageFilter =
      ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    _targetLanguageFilter.value =
        MatrixState.pangeaController.languageController.userL2;

    _loadCourses();
  }

  CourseFilter get _filter {
    return CourseFilter(
      targetLanguage: _targetLanguageFilter.value,
    );
  }

  void _setTargetLanguageFilter(LanguageModel? language) {
    if (_targetLanguageFilter.value?.langCodeShort == language?.langCodeShort) {
      return;
    }

    _targetLanguageFilter.value = language;
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      _courses.value = null;
      final resp = await CoursePlansRepo.searchByFilter(filter: _filter);
      _courses.value = Result.value(resp);
      if (resp.coursePlans.isEmpty) {
        ErrorHandler.logError(
          e: "No courses found",
          data: {
            'filter': _filter.toJson(),
          },
        );
      }
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'filter': _filter.toJson(),
        },
      );
      _courses.value = Result.error(e);
    }
  }

  Future<void> _onSelect(CoursePlanModel course) async {
    final existingRoom =
        Matrix.of(context).client.getRoomByCourseId(course.uuid);

    if (existingRoom == null || widget.spaceId != null) {
      context.go(
        widget.spaceId != null
            ? '/rooms/spaces/${widget.spaceId}/addcourse/${course.uuid}'
            : '/${widget.route}/course/own/${course.uuid}',
      );
      return;
    }

    final action = await showAdaptiveDialog<int>(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: Center(
            child: Text(
              course.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
          child: Text(
            L10n.of(context).alreadyInCourseWithID,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          AdaptiveDialogAction(
            onPressed: () => Navigator.of(context).pop(0),
            bigButtons: true,
            child: Text(L10n.of(context).createCourse),
          ),
          AdaptiveDialogAction(
            onPressed: () => Navigator.of(context).pop(1),
            bigButtons: true,
            child: Text(
              L10n.of(context).goToExistingCourse,
            ),
          ),
          AdaptiveDialogAction(
            onPressed: () => Navigator.of(context).pop(null),
            bigButtons: true,
            child: Text(
              L10n.of(context).cancel,
            ),
          ),
        ],
      ),
    );

    if (action == 0) {
      context.go(
        widget.spaceId != null
            ? '/rooms/spaces/${widget.spaceId}/addcourse/${course.uuid}'
            : '/${widget.route}/course/own/${course.uuid}',
      );
    } else if (action == 1) {
      if (existingRoom.isSpace) {
        context.go('/rooms/spaces/${existingRoom.id}');
      } else {
        ErrorHandler.logError(
          e: "Existing course room is not a space",
          data: {
            'roomId': existingRoom.id,
            'courseId': course.uuid,
          },
        );
        context.go('/rooms/${existingRoom.id}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spaceId = widget.spaceId;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          spaceId != null
              ? L10n.of(context).addCoursePlan
              : L10n.of(context).startOwn,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: Column(
              children: [
                if (widget.showFilters) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          alignment: WrapAlignment.start,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _targetLanguageFilter,
                              builder: (context, value, __) {
                                return CourseLanguageFilter(
                                  value: _targetLanguageFilter.value,
                                  onChanged: _setTargetLanguageFilter,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
                ValueListenableBuilder(
                  valueListenable: _courses,
                  builder: (context, value, __) {
                    final loading = value == null;
                    if (loading ||
                        value.isError ||
                        value.result!.coursePlans.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: loading
                              ? const CircularProgressIndicator.adaptive()
                              : Center(
                                  child: Column(
                                    spacing: 12.0,
                                    children: [
                                      const BotFace(
                                        expression: BotExpression.addled,
                                        width: Avatar.defaultSize * 1.5,
                                      ),
                                      Text(
                                        L10n.of(context).noCourseTemplatesFound,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                      ElevatedButton(
                                        onPressed: () => context.go(
                                          '/rooms',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: theme
                                              .colorScheme.primaryContainer,
                                          foregroundColor: theme
                                              .colorScheme.onPrimaryContainer,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              L10n.of(context).continueText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      );
                    }

                    final courseEntries =
                        value.result!.coursePlans.entries.toList();

                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10.0),
                        itemCount: courseEntries.length,
                        itemBuilder: (context, index) {
                          final course = courseEntries[index].value;
                          final courseId = courseEntries[index].key;
                          return Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () => _onSelect(course),
                              borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                child: Column(
                                  spacing: 4.0,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: 8.0,
                                      children: [
                                        ImageByUrl(
                                          imageUrl: course.imageUrl,
                                          width: 58.0,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          replacement: Container(
                                            height: 58.0,
                                            width: 58.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10.0,
                                              ),
                                              color: theme
                                                  .colorScheme.surfaceContainer,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            course.title,
                                            style: theme.textTheme.bodyLarge,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CourseInfoChips(
                                      courseId,
                                      iconSize: 12.0,
                                      fontSize: 12.0,
                                    ),
                                    Text(
                                      course.description,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
