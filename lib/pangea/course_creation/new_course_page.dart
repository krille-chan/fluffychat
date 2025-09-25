import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/course_creation/course_plan_filter_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_plan_tile_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_search_provider.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewCourse extends StatefulWidget {
  final String? spaceId;
  const NewCourse({
    super.key,
    this.spaceId,
  });

  @override
  State<NewCourse> createState() => NewCourseController();
}

class NewCourseController extends State<NewCourse> with CourseSearchProvider {
  @override
  Widget build(BuildContext context) {
    const double titleFontSize = 16.0;
    const double descFontSize = 12.0;

    const double iconSize = 12.0;
    final spaceId = widget.spaceId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          spaceId != null
              ? L10n.of(context).addCoursePlan
              : L10n.of(context).newCourse,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: MaxWidthBody(
          showBorder: false,
          withScrolling: false,
          maxWidth: 500.0,
          child: Column(
            spacing: 12.0,
            children: [
              Text(
                L10n.of(context).newCourseSubtitle,
                style: const TextStyle(
                  fontSize: titleFontSize,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.symmetric(
                  vertical: 4.0,
                ),
                child: Row(
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
                            shortName: L10n.of(context).instructionsLanguage,
                          ),
                          CoursePlanFilter<LanguageModel>(
                            value: targetLanguageFilter,
                            onChanged: setTargetLanguageFilter,
                            items: MatrixState
                                .pangeaController.pLanguageStore.targetOptions,
                            displayname: (v) =>
                                v.getDisplayName(context) ?? v.displayName,
                            enableSearch: true,
                            defaultName: L10n.of(context).targetLanguageLabel,
                          ),
                          CoursePlanFilter<LanguageLevelTypeEnum>(
                            value: languageLevelFilter,
                            onChanged: setLanguageLevelFilter,
                            items: LanguageLevelTypeEnum.values,
                            displayname: (v) => v.string,
                            defaultName: L10n.of(context).cefrLevelLabel,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (error != null) {
                    return Center(
                      child: ErrorIndicator(
                        message: L10n.of(context).failedToLoadCourses,
                      ),
                    );
                  }

                  if (loading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (courses.isEmpty) {
                    return Center(
                      child: Text(L10n.of(context).noCoursesFound),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsetsGeometry.fromLTRB(
                          4.0,
                          4.0,
                          4.0,
                          16.0,
                        ),
                        child: CoursePlanTile(
                          course: courses[index],
                          onTap: () => context.go(
                            spaceId != null
                                ? "/rooms/spaces/$spaceId/addcourse/${courses[index].uuid}"
                                : "/rooms/communities/newcourse/${courses[index].uuid}",
                          ),
                          titleFontSize: titleFontSize,
                          chipFontSize: descFontSize,
                          chipIconSize: iconSize,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
