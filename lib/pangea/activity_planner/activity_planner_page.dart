import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_mode_list_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_page_appbar.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activity_list.dart';
import 'package:fluffychat/pangea/activity_planner/generated_activity_list.dart';
import 'package:fluffychat/pangea/activity_planner/learning_objective_list_repo.dart';
import 'package:fluffychat/pangea/activity_planner/list_request_schema.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_planner/new_activity_form.dart';
import 'package:fluffychat/pangea/activity_planner/topic_list_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_area.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum PageMode {
  settings,
  generatedActivities,
  featuredActivities,
  savedActivities,
}

class ActivityPlannerPage extends StatefulWidget {
  final String roomID;
  const ActivityPlannerPage({super.key, required this.roomID});

  @override
  ActivityPlannerPageState createState() => ActivityPlannerPageState();
}

class ActivityPlannerPageState extends State<ActivityPlannerPage> {
  final formKey = GlobalKey<FormState>();
  PageMode pageMode = PageMode.featuredActivities;

  MediaEnum selectedMedia = MediaEnum.nan;
  String? selectedLanguageOfInstructions;
  String? selectedTargetLanguage;
  LanguageLevelTypeEnum? selectedCefrLevel;
  int? selectedNumberOfParticipants;

  List<String> activities = [];

  Room? get room => Matrix.of(context).client.getRoomById(widget.roomID);

  ActivityPlanModel? get _initialActivity => room?.activityPlan;

  @override
  void initState() {
    super.initState();
    if (room == null) {
      Navigator.of(context).pop();
      return;
    }

    if (_initialActivity == null) {
      selectedLanguageOfInstructions =
          MatrixState.pangeaController.languageController.userL1?.langCode;
      selectedTargetLanguage =
          MatrixState.pangeaController.languageController.userL2?.langCode;
      selectedCefrLevel = LanguageLevelTypeEnum.a1;
      selectedNumberOfParticipants =
          max(room?.getParticipants().length ?? 1, 1);
    } else {
      selectedMedia = _initialActivity!.req.media;
      selectedLanguageOfInstructions =
          _initialActivity!.req.languageOfInstructions;
      selectedTargetLanguage = _initialActivity!.req.targetLanguage;
      selectedCefrLevel = _initialActivity!.req.cefrLevel;
      selectedNumberOfParticipants = _initialActivity!.req.numberOfParticipants;
      topicController.text = _initialActivity!.req.topic;
      objectiveController.text = _initialActivity!.req.objective;
      modeController.text = _initialActivity!.req.mode;
    }
  }

  final topicController = TextEditingController();
  final objectiveController = TextEditingController();
  final modeController = TextEditingController();

  @override
  void dispose() {
    topicController.dispose();
    objectiveController.dispose();
    modeController.dispose();
    super.dispose();
  }

  ActivitySettingRequestSchema get req => ActivitySettingRequestSchema(
        langCode:
            MatrixState.pangeaController.languageController.userL2?.langCode ??
                LanguageKeys.defaultLanguage,
      );

  Future<List<ActivitySettingResponseSchema>> get topicItems =>
      TopicListRepo.get(req);

  Future<List<ActivitySettingResponseSchema>> get modeItems =>
      ActivityModeListRepo.get(req);

  Future<List<ActivitySettingResponseSchema>> get objectiveItems =>
      LearningObjectiveListRepo.get(req);

  void _setPageMode(PageMode? mode) {
    if (mode == null) return;
    setState(() => pageMode = mode);
  }

  void setSelectedNumberOfParticipants(int? value) {
    setState(() => selectedNumberOfParticipants = value);
  }

  void setSelectedTargetLanguage(String? value) {
    setState(() => selectedTargetLanguage = value);
  }

  void setSelectedLanguageOfInstructions(String? value) {
    setState(() => selectedLanguageOfInstructions = value);
  }

  void setSelectedCefrLevel(LanguageLevelTypeEnum? value) {
    setState(() => selectedCefrLevel = value);
  }

  void setSelectedMedia(MediaEnum? value) {
    if (value == null) return;
    setState(() => selectedMedia = value);
  }

  Future<void> generateActivities() async =>
      _setPageMode(PageMode.generatedActivities);

  Future<String> _randomTopic() async {
    final topics = await topicItems;
    return (topics..shuffle()).first.name;
  }

  Future<String> _randomObjective() async {
    final objectives = await objectiveItems;
    return (objectives..shuffle()).first.name;
  }

  Future<String> _randomMode() async {
    final modes = await modeItems;
    return (modes..shuffle()).first.name;
  }

  void randomizeSelections() async {
    final selectedTopic = await _randomTopic();
    final selectedObjective = await _randomObjective();
    final selectedMode = await _randomMode();

    setState(() {
      topicController.text = selectedTopic;
      objectiveController.text = selectedObjective;
      modeController.text = selectedMode;
    });
  }

  // Add validation logic
  String? validateNotNull(String? value) {
    if (value == null || value.isEmpty) {
      return L10n.of(context).interactiveTranslatorRequired;
    }
    return null;
  }

  ActivityPlanRequest get planRequest => ActivityPlanRequest(
        topic: topicController.text,
        mode: modeController.text,
        objective: objectiveController.text,
        media: selectedMedia,
        languageOfInstructions: selectedLanguageOfInstructions!,
        targetLanguage: selectedTargetLanguage!,
        cefrLevel: selectedCefrLevel!,
        numberOfParticipants: selectedNumberOfParticipants!,
      );

  @override
  Widget build(BuildContext context) {
    Widget body = const SizedBox();
    switch (pageMode) {
      case PageMode.settings:
        body = NewActivityForm(this);
        break;
      case PageMode.generatedActivities:
        body = GeneratedActivitiesList(
          controller: this,
        );
        break;
      case PageMode.savedActivities:
        body = BookmarkedActivitiesList(
          room: room,
          controller: this,
        );
        break;
      case PageMode.featuredActivities:
        body = const Expanded(
          child: SingleChildScrollView(
            child: ActivitySuggestionsArea(
              scrollDirection: Axis.vertical,
            ),
          ),
        );
        break;
    }

    return Scaffold(
      appBar: ActivityPlannerPageAppBar(
        pageMode: pageMode,
        setPageMode: _setPageMode,
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800.0),
        child: Column(
          children: [
            if ([PageMode.featuredActivities, PageMode.savedActivities]
                .contains(pageMode))
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SegmentedButton<PageMode>(
                      selected: {pageMode},
                      onSelectionChanged: (modes) => _setPageMode(modes.first),
                      segments: const [
                        ButtonSegment(
                          value: PageMode.featuredActivities,
                          label: Text("Featured activities"),
                        ),
                        ButtonSegment(
                          value: PageMode.savedActivities,
                          label: Text("Your bookmarks"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            body,
          ],
        ),
      ),
    );
  }
}
