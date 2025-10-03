import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_plan_filter_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_search_provider.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewTripPage extends StatefulWidget {
  final String route;
  final String? spaceId;
  final bool showFilters;

  const NewTripPage({
    super.key,
    required this.route,
    this.spaceId,
    this.showFilters = true,
  });

  @override
  State<NewTripPage> createState() => NewTripPageState();
}

class NewTripPageState extends State<NewTripPage> with CourseSearchProvider {
  @override
  void initState() {
    super.initState();

    final target = MatrixState.pangeaController.languageController.userL2;
    if (target != null) {
      setTargetLanguageFilter(target, reload: false);
    }

    final base = MatrixState.pangeaController.languageController.systemLanguage;
    if (base != null) {
      setInstructionLanguageFilter(base, reload: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spaceId = widget.spaceId;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 10.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined),
            Text(
              spaceId != null
                  ? L10n.of(context).addCoursePlan
                  : L10n.of(context).startOwnTripTitle,
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
                loading || error != null || courses.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: loading
                              ? const CircularProgressIndicator.adaptive()
                              : Center(
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
                                          L10n.of(context)
                                              .noCourseTemplatesFound,
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
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10.0),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return InkWell(
                              onTap: () => context.go(
                                spaceId != null
                                    ? '/rooms/spaces/$spaceId/addcourse/${courses[index].uuid}'
                                    : '/${widget.route}/course/own/${course.uuid}',
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
                                      course,
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
