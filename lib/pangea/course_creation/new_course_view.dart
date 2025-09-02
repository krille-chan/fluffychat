import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/course_creation/course_plan_filter_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_plan_tile_widget.dart';
import 'package:fluffychat/pangea/course_creation/new_course_page.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewCourseView extends StatelessWidget {
  final NewCourseController controller;

  const NewCourseView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    const double titleFontSize = 16.0;
    const double descFontSize = 12.0;

    const double iconSize = 12.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).newCourse),
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
                        spacing: 4.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.start,
                        children: [
                          CoursePlanFilter<LanguageLevelTypeEnum>(
                            value: controller.languageLevelFilter,
                            onChanged: controller.setLanguageLevelFilter,
                            items: LanguageLevelTypeEnum.values,
                            displayname: (v) => v.string,
                            fontSize: descFontSize,
                            iconSize: iconSize,
                            defaultName: L10n.of(context).cefrLevelLabel,
                          ),
                          CoursePlanFilter<LanguageModel>(
                            value: controller.instructionLanguageFilter,
                            onChanged: controller.setInstructionLanguageFilter,
                            items: MatrixState
                                .pangeaController.pLanguageStore.baseOptions,
                            displayname: (v) =>
                                v.getDisplayName(context) ?? v.displayName,
                            enableSearch: true,
                            fontSize: descFontSize,
                            iconSize: iconSize,
                            defaultName:
                                L10n.of(context).languageOfInstructionsLabel,
                            shortName: L10n.of(context).instructionsLanguage,
                          ),
                          CoursePlanFilter<LanguageModel>(
                            value: controller.targetLanguageFilter,
                            onChanged: controller.setTargetLanguageFilter,
                            items: MatrixState
                                .pangeaController.pLanguageStore.targetOptions,
                            displayname: (v) =>
                                v.getDisplayName(context) ?? v.displayName,
                            enableSearch: true,
                            fontSize: descFontSize,
                            iconSize: iconSize,
                            defaultName: L10n.of(context).targetLanguageLabel,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (controller.error != null) {
                    return Center(
                      child: ErrorIndicator(
                        message: L10n.of(context).failedToLoadCourses,
                      ),
                    );
                  }

                  if (controller.loading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: controller.courses.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsetsGeometry.fromLTRB(
                          4.0,
                          4.0,
                          4.0,
                          16.0,
                        ),
                        child: CoursePlanTile(
                          course: controller.courses[index],
                          onTap: () => context.go(
                            "/rooms/communities/newcourse/${controller.courses[index].uuid}",
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
