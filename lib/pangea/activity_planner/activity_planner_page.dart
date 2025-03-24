import 'dart:math';

import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_list_view.dart';
import 'package:fluffychat/pangea/activity_planner/activity_mode_list_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/learning_objective_list_repo.dart';
import 'package:fluffychat/pangea/activity_planner/list_request_schema.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_planner/suggestion_form_field.dart';
import 'package:fluffychat/pangea/activity_planner/topic_list_repo.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/language_level_dropdown.dart';
import 'package:fluffychat/pangea/common/widgets/dropdown_text_button.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_language_dropdown.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum _PageMode {
  settings,
  generatedActivities,
  savedActivities,
}

class ActivityPlannerPage extends StatefulWidget {
  final String roomID;
  const ActivityPlannerPage({super.key, required this.roomID});

  @override
  ActivityPlannerPageState createState() => ActivityPlannerPageState();
}

class ActivityPlannerPageState extends State<ActivityPlannerPage> {
  final _formKey = GlobalKey<FormState>();

  /// Index of the content to display
  _PageMode _pageMode = _PageMode.settings;

  MediaEnum _selectedMedia = MediaEnum.nan;
  String? _selectedLanguageOfInstructions;
  String? _selectedTargetLanguage;
  LanguageLevelTypeEnum? _selectedCefrLevel;
  int? _selectedNumberOfParticipants;

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
      _selectedLanguageOfInstructions =
          MatrixState.pangeaController.languageController.userL1?.langCode;
      _selectedTargetLanguage =
          MatrixState.pangeaController.languageController.userL2?.langCode;
      _selectedCefrLevel = LanguageLevelTypeEnum.a1;
      _selectedNumberOfParticipants =
          max(room?.getParticipants().length ?? 1, 1);
    } else {
      _selectedMedia = _initialActivity!.req.media;
      _selectedLanguageOfInstructions =
          _initialActivity!.req.languageOfInstructions;
      _selectedTargetLanguage = _initialActivity!.req.targetLanguage;
      _selectedCefrLevel = _initialActivity!.req.cefrLevel;
      _selectedNumberOfParticipants =
          _initialActivity!.req.numberOfParticipants;
      _topicController.text = _initialActivity!.req.topic;
      _objectiveController.text = _initialActivity!.req.objective;
      _modeController.text = _initialActivity!.req.mode;
    }
  }

  final _topicController = TextEditingController();
  final _objectiveController = TextEditingController();
  final _modeController = TextEditingController();

  @override
  void dispose() {
    _topicController.dispose();
    _objectiveController.dispose();
    _modeController.dispose();
    super.dispose();
  }

  ActivitySettingRequestSchema get req => ActivitySettingRequestSchema(
        langCode:
            MatrixState.pangeaController.languageController.userL2?.langCode ??
                LanguageKeys.defaultLanguage,
      );

  Future<List<ActivitySettingResponseSchema>> get _topicItems =>
      TopicListRepo.get(req);

  Future<List<ActivitySettingResponseSchema>> get modeItems =>
      ActivityModeListRepo.get(req);

  Future<List<ActivitySettingResponseSchema>> get _objectiveItems =>
      LearningObjectiveListRepo.get(req);

  Future<void> _generateActivities() async {
    _pageMode = _PageMode.generatedActivities;
    setState(() {});
  }

  Future<String> _randomTopic() async {
    final topics = await _topicItems;
    return (topics..shuffle()).first.name;
  }

  Future<String> _randomObjective() async {
    final objectives = await _objectiveItems;
    return (objectives..shuffle()).first.name;
  }

  Future<String> _randomMode() async {
    final modes = await modeItems;
    return (modes..shuffle()).first.name;
  }

  void _randomizeSelections() async {
    final selectedTopic = await _randomTopic();
    final selectedObjective = await _randomObjective();
    final selectedMode = await _randomMode();

    setState(() {
      _topicController.text = selectedTopic;
      _objectiveController.text = selectedObjective;
      _modeController.text = selectedMode;
    });
  }

  // Add validation logic
  String? _validateNotNull(String? value) {
    if (value == null || value.isEmpty) {
      return L10n.of(context).interactiveTranslatorRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: _pageMode == _PageMode.settings
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              )
            : IconButton(
                onPressed: () => setState(() => _pageMode = _PageMode.settings),
                icon: const Icon(Icons.arrow_back),
              ),
        title: _pageMode == _PageMode.savedActivities
            ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bookmarks),
                    const SizedBox(width: 8),
                    Text(l10n.myBookmarkedActivities),
                  ],
                ),
              )
            : Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event_note_outlined),
                    const SizedBox(width: 8),
                    Text(l10n.activityPlannerTitle),
                  ],
                ),
              ),
        actions: [
          Tooltip(
            message: l10n.myBookmarkedActivities,
            child: IconButton(
              onPressed: () =>
                  setState(() => _pageMode = _PageMode.savedActivities),
              icon: const Icon(Icons.bookmarks),
            ),
          ),
        ],
      ),
      body: _pageMode != _PageMode.settings
          ? ActivityListView(
              room: room,
              activityPlanRequest: _PageMode.savedActivities == _pageMode
                  ? null
                  : ActivityPlanRequest(
                      topic: _topicController.text,
                      mode: _modeController.text,
                      objective: _objectiveController.text,
                      media: _selectedMedia,
                      languageOfInstructions: _selectedLanguageOfInstructions!,
                      targetLanguage: _selectedTargetLanguage!,
                      cefrLevel: _selectedCefrLevel!,
                      numberOfParticipants: _selectedNumberOfParticipants!,
                    ),
              controller: this,
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const InstructionsInlineTooltip(
                        instructionsEnum:
                            InstructionsEnum.activityPlannerOverview,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SuggestionFormField(
                                  suggestions: _topicItems,
                                  validator: _validateNotNull,
                                  label: l10n.topicLabel,
                                  placeholder: l10n.topicPlaceholder,
                                  controller: _topicController,
                                ),
                                const SizedBox(height: 24),
                                SuggestionFormField(
                                  suggestions: _objectiveItems,
                                  validator: _validateNotNull,
                                  label: l10n.learningObjectiveLabel,
                                  placeholder:
                                      l10n.learningObjectivePlaceholder,
                                  controller: _objectiveController,
                                ),
                                const SizedBox(height: 24),
                                SuggestionFormField(
                                  suggestions: modeItems,
                                  validator: _validateNotNull,
                                  label: l10n.modeLabel,
                                  placeholder: l10n.modePlaceholder,
                                  controller: _modeController,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shuffle),
                                onPressed: _randomizeSelections,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField2<MediaEnum>(
                        customButton: CustomDropdownTextButton(
                          text: _selectedMedia.toDisplayCopyUsingL10n(context),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.zero, // Remove default padding
                        ),
                        decoration: InputDecoration(labelText: l10n.mediaLabel),
                        isExpanded: true,
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                          ),
                        ),
                        items: MediaEnum.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: DropdownTextButton(
                                  text: e.toDisplayCopyUsingL10n(context),
                                  isSelected: _selectedMedia == e,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() => _selectedMedia = val ?? MediaEnum.nan);
                        },
                        value: _selectedMedia,
                      ),
                      const SizedBox(height: 24),
                      LanguageLevelDropdown(
                        initialLevel: _selectedCefrLevel,
                        onChanged: (val) =>
                            setState(() => _selectedCefrLevel = val),
                      ),
                      const SizedBox(height: 24),
                      PLanguageDropdown(
                        languages: MatrixState
                            .pangeaController.pLanguageStore.baseOptions,
                        onChange: (val) => setState(
                          () => _selectedLanguageOfInstructions = val.langCode,
                        ),
                        initialLanguage: _selectedLanguageOfInstructions != null
                            ? PLanguageStore.byLangCode(
                                _selectedLanguageOfInstructions!,
                              )
                            : MatrixState
                                .pangeaController.languageController.userL1,
                        isL2List: false,
                        decorationText:
                            L10n.of(context).languageOfInstructionsLabel,
                      ),
                      const SizedBox(height: 24),
                      PLanguageDropdown(
                        languages: MatrixState
                            .pangeaController.pLanguageStore.targetOptions,
                        onChange: (val) => setState(
                          () => _selectedTargetLanguage = val.langCode,
                        ),
                        initialLanguage: _selectedTargetLanguage != null
                            ? PLanguageStore.byLangCode(
                                _selectedTargetLanguage!,
                              )
                            : MatrixState
                                .pangeaController.languageController.userL2,
                        decorationText: L10n.of(context).targetLanguageLabel,
                        isL2List: true,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: l10n.numberOfLearners,
                        ),
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.mustBeInteger;
                          }
                          final n = int.tryParse(value);
                          if (n == null || n <= 0) {
                            return l10n.mustBeInteger;
                          }
                          return null;
                        },
                        onChanged: (val) =>
                            _selectedNumberOfParticipants = int.tryParse(val),
                        initialValue: _selectedNumberOfParticipants?.toString(),
                        onTapOutside: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        onFieldSubmitted: (_) {
                          if (_formKey.currentState?.validate() ?? false) {
                            _generateActivities();
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _generateActivities();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lightbulb_outline),
                            const SizedBox(width: 8),
                            Text(l10n.generateActivitiesButton),
                          ],
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
