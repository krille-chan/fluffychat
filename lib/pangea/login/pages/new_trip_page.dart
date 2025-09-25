import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_plan_filter_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_search_provider.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewTripPage extends StatefulWidget {
  final String langCode;
  const NewTripPage({
    super.key,
    required this.langCode,
  });

  @override
  State<NewTripPage> createState() => NewTripPageState();
}

class NewTripPageState extends State<NewTripPage> with CourseSearchProvider {
  @override
  void initState() {
    super.initState();

    final target = PLanguageStore.byLangCode(widget.langCode);
    if (target != null) {
      setTargetLanguageFilter(target);
    }

    final base = MatrixState.pangeaController.languageController.systemLanguage;
    if (base != null) {
      setInstructionLanguageFilter(base);
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
            Text(L10n.of(context).startOwnTripTitle),
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
                const SizedBox(height: 20.0),
                loading || error != null || courses.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: error != null
                              ? Center(
                                  child: ErrorIndicator(
                                    message:
                                        L10n.of(context).failedToLoadCourses,
                                  ),
                                )
                              : loading
                                  ? const CircularProgressIndicator.adaptive()
                                  : Text(L10n.of(context).noCoursesFound),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: InkWell(
                                onTap: () => context.go(
                                  '/course/${widget.langCode}/own/${course.uuid}',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                color: theme.colorScheme
                                                    .surfaceContainer,
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
