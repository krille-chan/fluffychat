import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_plan_filter_widget.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_plans_repo.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/spaces/utils/public_course_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PublicTripPage extends StatefulWidget {
  final bool showFilters;
  const PublicTripPage({
    super.key,
    this.showFilters = true,
  });

  @override
  State<PublicTripPage> createState() => PublicTripPageState();
}

class PublicTripPageState extends State<PublicTripPage> {
  bool loading = true;
  Object? error;

  LanguageLevelTypeEnum? languageLevelFilter;
  LanguageModel? instructionLanguageFilter;
  LanguageModel? targetLanguageFilter;

  List<PublicCoursesChunk> discoveredCourses = [];
  Map<String, CoursePlanModel> coursePlans = {};
  String? nextBatch;

  @override
  void initState() {
    super.initState();

    final target = MatrixState.pangeaController.languageController.userL2;
    if (target != null) {
      setTargetLanguageFilter(target);
    }

    final base = MatrixState.pangeaController.languageController.systemLanguage;
    if (base != null) {
      setInstructionLanguageFilter(base);
    }

    _loadCourses();
  }

  void setLanguageLevelFilter(LanguageLevelTypeEnum? level) {
    setState(() => languageLevelFilter = level);
  }

  void setInstructionLanguageFilter(LanguageModel? language) {
    setState(() => instructionLanguageFilter = language);
  }

  void setTargetLanguageFilter(LanguageModel? language) {
    setState(() => targetLanguageFilter = language);
  }

  List<PublicCoursesChunk> get filteredCourses {
    List<PublicCoursesChunk> filtered = discoveredCourses;

    if (languageLevelFilter != null) {
      filtered = filtered.where(
        (chunk) {
          final course = coursePlans[chunk.courseId];
          if (course == null) return false;
          return course.cefrLevel == languageLevelFilter;
        },
      ).toList();
    }

    if (instructionLanguageFilter != null) {
      filtered = filtered.where(
        (chunk) {
          final course = coursePlans[chunk.courseId];
          if (course == null) return false;
          return course.baseLanguageModel == instructionLanguageFilter;
        },
      ).toList();
    }

    if (targetLanguageFilter != null) {
      filtered = filtered.where(
        (chunk) {
          final course = coursePlans[chunk.courseId];
          if (course == null) return false;
          return course.targetLanguageModel == targetLanguageFilter;
        },
      ).toList();
    }

    return filtered;
  }

  Future<void> _loadCourses() async {
    try {
      setState(() {
        loading = true;
        error = null;
      });

      final resp = await Matrix.of(context).client.requestPublicCourses(
            since: nextBatch,
          );

      for (final room in resp.courses) {
        if (!discoveredCourses.any((e) => e.room.roomId == room.room.roomId)) {
          discoveredCourses.add(room);
        }
      }

      nextBatch = resp.nextBatch;
    } catch (e, s) {
      error = e;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'nextBatch': nextBatch,
        },
      );
    } finally {
      setState(() => loading = false);
    }

    try {
      final searchResult = await CoursePlansRepo.search(
        discoveredCourses.map((c) => c.courseId).toList(),
      );

      coursePlans.clear();
      for (final course in searchResult) {
        coursePlans[course.uuid] = course;
      }
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'discoveredCourses':
              discoveredCourses.map((c) => c.courseId).toList(),
        },
      );
    } finally {
      if (mounted) {
        setState(() {});
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
            Text(L10n.of(context).browsePublicTrips),
          ],
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
                            CoursePlanFilter<LanguageModel>(
                              value: instructionLanguageFilter,
                              onChanged: setInstructionLanguageFilter,
                              items: MatrixState
                                  .pangeaController.pLanguageStore.baseOptions,
                              displayname: (v) =>
                                  v.getDisplayName(context) ?? v.displayName,
                              enableSearch: true,
                              defaultName:
                                  L10n.of(context).languageOfInstructionsLabel,
                              shortName: L10n.of(context).allLanguages,
                            ),
                            CoursePlanFilter<LanguageModel>(
                              value: targetLanguageFilter,
                              onChanged: setTargetLanguageFilter,
                              items: MatrixState.pangeaController.pLanguageStore
                                  .targetOptions,
                              displayname: (v) =>
                                  v.getDisplayName(context) ?? v.displayName,
                              enableSearch: true,
                              defaultName: L10n.of(context).targetLanguageLabel,
                              shortName: L10n.of(context).allLanguages,
                            ),
                            CoursePlanFilter<LanguageLevelTypeEnum>(
                              value: languageLevelFilter,
                              onChanged: setLanguageLevelFilter,
                              items: LanguageLevelTypeEnum.values,
                              displayname: (v) => v.string,
                              defaultName: L10n.of(context).cefrLevelLabel,
                              shortName: L10n.of(context).allCefrLevels,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
                if (error != null ||
                    (!loading && filteredCourses.isEmpty && nextBatch == null))
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        spacing: 12.0,
                        children: [
                          const BotFace(
                            expression: BotExpression.addled,
                            width: Avatar.defaultSize * 1.5,
                          ),
                          Text(
                            L10n.of(context).noPublicCoursesFound,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),
                          ElevatedButton(
                            onPressed: () => context.go(
                              '/registration/course/own',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              foregroundColor:
                                  theme.colorScheme.onPrimaryContainer,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(L10n.of(context).startOwnTrip),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: filteredCourses.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10.0),
                      itemBuilder: (context, index) {
                        if (index == filteredCourses.length) {
                          return Center(
                            child: loading
                                ? const CircularProgressIndicator.adaptive()
                                : nextBatch != null
                                    ? TextButton(
                                        onPressed: _loadCourses,
                                        child: Text(L10n.of(context).loadMore),
                                      )
                                    : const SizedBox(),
                          );
                        }

                        final roomChunk = filteredCourses[index].room;
                        final course =
                            coursePlans[filteredCourses[index].courseId];

                        final displayname = roomChunk.name ??
                            roomChunk.canonicalAlias ??
                            L10n.of(context).emptyChat;

                        return InkWell(
                          onTap: () {},
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
                                      imageUrl: roomChunk.avatarUrl?.toString(),
                                      width: 58.0,
                                      borderRadius: BorderRadius.circular(10.0),
                                      replacement: Container(
                                        height: 58.0,
                                        width: 58.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: theme
                                              .colorScheme.surfaceContainer,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        displayname,
                                        style: theme.textTheme.bodyLarge,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                if (course != null) ...[
                                  CourseInfoChips(
                                    course,
                                    iconSize: 12.0,
                                    fontSize: 12.0,
                                  ),
                                  Text(
                                    course.description,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
