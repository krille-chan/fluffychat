import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_language_filter.dart';
import 'package:fluffychat/pangea/course_creation/course_search_provider.dart';
import 'package:fluffychat/pangea/login/pages/add_course_page.dart';
import 'package:fluffychat/widgets/avatar.dart';
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

class NewCoursePageState extends State<NewCoursePage>
    with CourseSearchProvider {
  @override
  void initState() {
    super.initState();

    final target = MatrixState.pangeaController.languageController.userL2;
    if (target != null) {
      setTargetLanguageFilter(target, reload: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spaceId = widget.spaceId;
    final courseEntries = courses.entries.toList();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.network(
              "${AppConfig.assetsBaseURL}/${AddCoursePage.mapStartFileName}",
              width: 24.0,
              height: 24.0,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            Text(
              spaceId != null
                  ? L10n.of(context).addCoursePlan
                  : L10n.of(context).startOwn,
            ),
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
                loading || error != null || courses.isEmpty
                    ? Center(
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
                      )
                    : Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10.0),
                          itemCount: courseEntries.length,
                          itemBuilder: (context, index) {
                            final course = courseEntries[index].value;
                            final courseId = courseEntries[index].key;
                            return InkWell(
                              onTap: () => context.go(
                                spaceId != null
                                    ? '/rooms/spaces/$spaceId/addcourse/$courseId'
                                    : '/${widget.route}/course/own/$courseId',
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
                                          imageUrl: course.imageUrl,
                                          width: 58.0,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
