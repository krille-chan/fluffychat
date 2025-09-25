import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/course_creation/course_plan_filter_widget.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PublicTripPage extends StatefulWidget {
  final String langCode;
  const PublicTripPage({
    super.key,
    required this.langCode,
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

    _loadCourses();
  }

  void setLanguageLevelFilter(LanguageLevelTypeEnum? level) {
    languageLevelFilter = level;
    _loadCourses();
  }

  void setInstructionLanguageFilter(LanguageModel? language) {
    instructionLanguageFilter = language;
    _loadCourses();
  }

  void setTargetLanguageFilter(LanguageModel? language) {
    targetLanguageFilter = language;
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    // TODO: add searching of public spaces

    try {
      setState(() {
        loading = true;
        error = null;
      });
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      error = e;
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            items: MatrixState
                                .pangeaController.pLanguageStore.targetOptions,
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: error != null
                        ? Center(
                            child: ErrorIndicator(
                              message: L10n.of(context).failedToLoadCourses,
                            ),
                          )
                        : loading
                            ? const CircularProgressIndicator.adaptive()
                            : Text(L10n.of(context).noCoursesFound),
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
