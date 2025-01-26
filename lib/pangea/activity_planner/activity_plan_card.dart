import 'dart:developer';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

class ActivityPlanCard extends StatefulWidget {
  final ActivityPlanModel activity;
  final VoidCallback onLaunch;
  final ValueChanged<ActivityPlanModel> onEdit;
  final double maxWidth;

  const ActivityPlanCard({
    super.key,
    required this.activity,
    required this.onLaunch,
    required this.onEdit,
    this.maxWidth = 400,
  });

  @override
  ActivityPlanCardState createState() => ActivityPlanCardState();
}

class ActivityPlanCardState extends State<ActivityPlanCard> {
  bool _isEditing = false;
  late ActivityPlanModel _tempActivity;
  late TextEditingController _titleController;
  late TextEditingController _learningObjectiveController;
  late TextEditingController _instructionsController;
  final TextEditingController _newVocabController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempActivity = widget.activity;
    _titleController = TextEditingController(text: _tempActivity.title);
    _learningObjectiveController =
        TextEditingController(text: _tempActivity.learningObjective);
    _instructionsController =
        TextEditingController(text: _tempActivity.instructions);
  }

  static const double itemPadding = 8;

  @override
  void dispose() {
    _titleController.dispose();
    _learningObjectiveController.dispose();
    _instructionsController.dispose();
    _newVocabController.dispose();
    super.dispose();
  }

  Future<void> _saveEdits() async {
    final updatedActivity = ActivityPlanModel(
      req: _tempActivity.req,
      title: _titleController.text,
      learningObjective: _learningObjectiveController.text,
      instructions: _instructionsController.text,
      vocab: _tempActivity.vocab,
    );

    final activityWithBookmarkId = await _addBookmark(updatedActivity);

    // need to save in the repo as well
    widget.onEdit(activityWithBookmarkId);

    setState(() {
      _isEditing = false;
    });
  }

  Future<ActivityPlanModel> _addBookmark(ActivityPlanModel activity) =>
      BookmarkedActivitiesRepo.save(activity).catchError((e, stack) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(e: e, s: stack, data: activity.toJson());
      }).whenComplete(() {
        setState(() {});
      });

  Future<void> _removeBookmark() =>
      BookmarkedActivitiesRepo.remove(widget.activity.bookmarkId!)
          .catchError((e, stack) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(e: e, s: stack, data: widget.activity.toJson());
      }).whenComplete(() {
        setState(() {});
      });

  void _addVocab() {
    setState(() {
      _tempActivity.vocab.add(Vocab(lemma: _newVocabController.text, pos: ''));
      _newVocabController.clear();
    });
  }

  void _removeVocab(int index) {
    setState(() {
      _tempActivity.vocab.removeAt(index);
    });
  }

  bool get isBookmarked =>
      BookmarkedActivitiesRepo.isBookmarked(widget.activity);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: itemPadding),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.event_note_outlined),
                    const SizedBox(width: itemPadding),
                    Expanded(
                      child: _isEditing
                          ? TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: L10n.of(context).title,
                              ),
                              maxLines: null,
                            )
                          : Text(
                              widget.activity.title,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                    ),
                    if (!_isEditing)
                      IconButton(
                        onPressed: isBookmarked
                            ? () => _removeBookmark()
                            : () => _addBookmark(widget.activity),
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: itemPadding),
                Row(
                  children: [
                    Icon(
                      Symbols.target,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: itemPadding),
                    Expanded(
                      child: _isEditing
                          ? TextField(
                              controller: _learningObjectiveController,
                              decoration: const InputDecoration(
                                labelText: 'Learning Objective',
                              ),
                              maxLines: null,
                            )
                          : Text(
                              widget.activity.learningObjective,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: itemPadding),
                Row(
                  children: [
                    Icon(
                      Symbols.steps_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: itemPadding),
                    Expanded(
                      child: _isEditing
                          ? TextField(
                              controller: _instructionsController,
                              decoration: const InputDecoration(
                                labelText: 'Instructions',
                              ),
                              maxLines: null,
                            )
                          : Text(
                              widget.activity.instructions,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: itemPadding),
                if (widget.activity.vocab.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Symbols.dictionary,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: itemPadding),
                      Expanded(
                        child: Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: List<Widget>.generate(
                              _tempActivity.vocab.length, (int index) {
                            return _isEditing
                                ? Chip(
                                    label:
                                        Text(_tempActivity.vocab[index].lemma),
                                    onDeleted: () => _removeVocab(index),
                                    backgroundColor: Colors.transparent,
                                    visualDensity: VisualDensity.compact,
                                    shape: const StadiumBorder(
                                      side:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  )
                                : Chip(
                                    label:
                                        Text(_tempActivity.vocab[index].lemma),
                                    backgroundColor: Colors.transparent,
                                    visualDensity: VisualDensity.compact,
                                    shape: const StadiumBorder(
                                      side:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  if (_isEditing)
                    Padding(
                      padding: const EdgeInsets.only(top: itemPadding),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _newVocabController,
                              decoration: const InputDecoration(
                                labelText: 'Add Vocabulary',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _addVocab,
                          ),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(!_isEditing ? Icons.edit : Icons.save),
                          onPressed: () => !_isEditing
                              ? setState(() {
                                  _isEditing = true;
                                })
                              : _saveEdits(),
                          isSelected: _isEditing,
                        ),
                        if (_isEditing)
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                            },
                          ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: !_isEditing ? widget.onLaunch : null,
                      icon: const Icon(Icons.send),
                      label: Text(l10n.launchActivityButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
