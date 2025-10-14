import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_language_filter.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plans_repo.dart';
import 'package:fluffychat/pangea/course_plans/courses/get_localized_courses_request.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/spaces/utils/public_course_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PublicTripPage extends StatefulWidget {
  final String route;
  final bool showFilters;
  const PublicTripPage({
    super.key,
    required this.route,
    this.showFilters = true,
  });

  @override
  State<PublicTripPage> createState() => PublicTripPageState();
}

class PublicTripPageState extends State<PublicTripPage> {
  bool loading = true;
  Object? error;

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

    _loadCourses();
  }

  void setTargetLanguageFilter(LanguageModel? language, {bool reload = true}) {
    if (targetLanguageFilter?.langCodeShort == language?.langCodeShort) return;
    setState(() => targetLanguageFilter = language);
    if (reload) _loadCourses();
  }

  List<PublicCoursesChunk> get filteredCourses {
    List<PublicCoursesChunk> filtered = discoveredCourses
        .where(
          (c) =>
              !Matrix.of(context).client.rooms.any(
                    (r) =>
                        r.id == c.room.roomId &&
                        r.membership == Membership.join,
                  ) &&
              coursePlans.containsKey(c.courseId),
        )
        .toList();

    if (targetLanguageFilter != null) {
      filtered = filtered.where(
        (chunk) {
          final course = coursePlans[chunk.courseId];
          if (course == null) return false;
          return course.targetLanguage.split('-').first ==
              targetLanguageFilter!.langCodeShort;
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
    }

    try {
      final resp = await CoursePlansRepo.search(
        GetLocalizedCoursesRequest(
          coursePlanIds:
              discoveredCourses.map((c) => c.courseId).toSet().toList(),
          l1: MatrixState.pangeaController.languageController.activeL1Code()!,
        ),
      );
      final searchResult = resp.coursePlans;

      coursePlans.clear();
      for (final entry in searchResult.entries) {
        coursePlans[entry.key] = entry.value;
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
        setState(() => loading = false);
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
                            CourseLanguageFilter(
                              value: targetLanguageFilter,
                              onChanged: setTargetLanguageFilter,
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
                              '/${widget.route}/course/own',
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
                        final courseId = filteredCourses[index].courseId;
                        final course = coursePlans[courseId];

                        final displayname = roomChunk.name ??
                            roomChunk.canonicalAlias ??
                            L10n.of(context).emptyChat;

                        return InkWell(
                          onTap: () => context.go(
                            '/${widget.route}/course/public/$courseId',
                            extra: roomChunk,
                          ),
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
                                    courseId,
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
