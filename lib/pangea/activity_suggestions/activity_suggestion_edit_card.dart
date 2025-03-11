import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card_row.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_area.dart';

class ActivitySuggestionEditCard extends StatefulWidget {
  final ActivityPlanModel activity;
  final ActivitySuggestionsAreaState controller;

  const ActivitySuggestionEditCard({
    super.key,
    required this.activity,
    required this.controller,
  });

  @override
  ActivitySuggestionEditCardState createState() =>
      ActivitySuggestionEditCardState();
}

class ActivitySuggestionEditCardState
    extends State<ActivitySuggestionEditCard> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _vocabController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _learningObjectivesController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.activity.title;
    _learningObjectivesController.text = widget.activity.learningObjective;
    _instructionsController.text = widget.activity.instructions;
    _participantsController.text =
        widget.activity.req.numberOfParticipants.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _learningObjectivesController.dispose();
    _instructionsController.dispose();
    _vocabController.dispose();
    _participantsController.dispose();
    super.dispose();
  }

  void _updateActivity() {
    widget.controller.updateActivity((activity) {
      activity.title = _titleController.text;
      activity.learningObjective = _learningObjectivesController.text;
      activity.instructions = _instructionsController.text;
      activity.req.numberOfParticipants =
          int.tryParse(_participantsController.text) ?? 3;
      return activity;
    });
  }

  void _addVocab() {
    widget.controller.updateActivity((activity) {
      activity.vocab.insert(
        0,
        Vocab(
          lemma: _vocabController.text.trim(),
          pos: "",
        ),
      );
      return activity;
    });
    _vocabController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActivitySuggestionCardRow(
            icon: Icons.event_note_outlined,
            child: TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: L10n.of(context).activityTitle,
              ),
              style: theme.textTheme.bodySmall,
              maxLines: 2,
              minLines: 1,
            ),
          ),
          ActivitySuggestionCardRow(
            icon: Symbols.target,
            child: TextFormField(
              style: theme.textTheme.bodySmall,
              controller: _learningObjectivesController,
              decoration: InputDecoration(
                labelText: L10n.of(context).learningObjectiveLabel,
              ),
              maxLines: 4,
              minLines: 1,
            ),
          ),
          ActivitySuggestionCardRow(
            icon: Symbols.target,
            child: TextFormField(
              style: theme.textTheme.bodySmall,
              controller: _instructionsController,
              decoration: InputDecoration(
                labelText: L10n.of(context).instructions,
              ),
              maxLines: 8,
              minLines: 1,
            ),
          ),
          ActivitySuggestionCardRow(
            icon: Icons.group_outlined,
            child: TextFormField(
              controller: _participantsController,
              style: theme.textTheme.bodySmall,
              decoration: InputDecoration(
                labelText: L10n.of(context).classRoster,
              ),
              maxLines: 1,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }

                try {
                  final val = int.parse(value);
                  if (val <= 0) {
                    return L10n.of(context).pleaseEnterInt;
                  }
                } catch (e) {
                  return L10n.of(context).pleaseEnterANumber;
                }
                return null;
              },
            ),
          ),
          ActivitySuggestionCardRow(
            icon: Symbols.dictionary,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 54.0),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: widget.activity.vocab
                      .mapIndexed(
                        (i, vocab) => Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(50),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                widget.controller.updateActivity((activity) {
                                  activity.vocab.removeAt(i);
                                  return activity;
                                });
                              },
                              child: Row(
                                spacing: 4.0,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    vocab.lemma,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const Icon(Icons.close, size: 12.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              spacing: 4.0,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _vocabController,
                    style: theme.textTheme.bodySmall,
                    decoration: InputDecoration(
                      hintText: L10n.of(context).addVocabulary,
                    ),
                    maxLines: 1,
                    onFieldSubmitted: (_) => _addVocab(),
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(0.0),
                  constraints:
                      const BoxConstraints(), // override default min size of 48px
                  iconSize: 16.0,
                  icon: const Icon(Icons.add_outlined),
                  onPressed: _addVocab,
                ),
              ],
            ),
          ),
          Row(
            spacing: 6.0,
            children: [
              GestureDetector(
                child: const Icon(Icons.save_outlined, size: 16.0),
                onTap: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _updateActivity();
                  widget.controller.setEditting(false);
                },
              ),
              GestureDetector(
                child: const Icon(Icons.close_outlined, size: 16.0),
                onTap: () => widget.controller.setEditting(false),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _updateActivity();
                    widget.controller.onLaunch(widget.activity);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: Text(
                    L10n.of(context).inviteAndLaunch,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
