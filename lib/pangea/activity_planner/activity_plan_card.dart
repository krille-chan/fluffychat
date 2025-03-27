import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class ActivityPlanCard extends StatefulWidget {
  final ActivityPlanModel activity;
  final Room? room;
  final ValueChanged<ActivityPlanModel> onEdit;
  final double maxWidth;
  final String? avatarURL;
  final String? initialFilename;

  const ActivityPlanCard({
    super.key,
    required this.activity,
    required this.room,
    required this.onEdit,
    this.maxWidth = 400,
    this.avatarURL,
    this.initialFilename,
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
  final FocusNode _vocabFocusNode = FocusNode();

  Uint8List? _avatar;
  String? _filename;

  @override
  void initState() {
    super.initState();
    _tempActivity = widget.activity;
    _titleController = TextEditingController(text: _tempActivity.title);
    _learningObjectiveController =
        TextEditingController(text: _tempActivity.learningObjective);
    _instructionsController =
        TextEditingController(text: _tempActivity.instructions);
    _filename = widget.initialFilename;
  }

  static const double itemPadding = 12;

  @override
  void dispose() {
    _titleController.dispose();
    _learningObjectiveController.dispose();
    _instructionsController.dispose();
    _newVocabController.dispose();
    _vocabFocusNode.dispose();
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
        return activity; // Return the original activity in case of error
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
      _vocabFocusNode.requestFocus();
    });
  }

  void _removeVocab(int index) {
    setState(() {
      _tempActivity.vocab.removeAt(index);
    });
  }

  void selectPhoto() async {
    final resp = await selectFiles(
      context,
      type: FileSelectorType.images,
      allowMultiple: false,
    );

    final photo = resp.singleOrNull;
    if (photo == null) return;
    final bytes = await photo.readAsBytes();

    setState(() {
      _avatar = bytes;
      _filename = photo.name;
    });
  }

  Future<void> _onLaunch() => showFutureLoadingDialog(
        context: context,
        future: () async {
          await widget.room?.sendActivityPlan(
            widget.activity,
            avatar: _avatar,
            avatarURL: widget.avatarURL,
            filename: _filename,
          );

          Navigator.of(context).pop();
        },
      );

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
          child: Column(
            children: [
              AnimatedSize(
                duration: FluffyThemes.animationDuration,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      child: widget.avatarURL != null || _avatar != null
                          ? ClipRRect(
                              child: _avatar == null
                                  ? CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.avatarURL!,
                                      placeholder: (context, url) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return const Padding(
                                          padding: EdgeInsets.all(28.0),
                                        );
                                      },
                                    )
                                  : Image.memory(
                                      _avatar!,
                                      fit: BoxFit.cover,
                                    ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(28.0),
                            ),
                    ),
                    Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: IconButton(
                        icon: const Icon(Icons.upload_outlined),
                        onPressed: selectPhoto,
                        style:
                            IconButton.styleFrom(backgroundColor: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
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
                                    labelText: L10n.of(context).activityTitle,
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
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
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
                                  decoration: InputDecoration(
                                    labelText: l10n.learningObjectiveLabel,
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
                                  decoration: InputDecoration(
                                    labelText: l10n.instructions,
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
                                        label: Text(
                                          _tempActivity.vocab[index].lemma,
                                        ),
                                        onDeleted: () => _removeVocab(index),
                                        backgroundColor: Colors.transparent,
                                        visualDensity: VisualDensity.compact,
                                        shape: const StadiumBorder(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      )
                                    : Chip(
                                        label: Text(
                                          _tempActivity.vocab[index].lemma,
                                        ),
                                        backgroundColor: Colors.transparent,
                                        visualDensity: VisualDensity.compact,
                                        shape: const StadiumBorder(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (_isEditing) ...[
                      const SizedBox(height: itemPadding),
                      Padding(
                        padding: const EdgeInsets.only(top: itemPadding),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _newVocabController,
                                focusNode: _vocabFocusNode,
                                decoration: InputDecoration(
                                  labelText: l10n.addVocabulary,
                                ),
                                onSubmitted: (value) {
                                  _addVocab();
                                },
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
                    const SizedBox(height: itemPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Tooltip(
                              message:
                                  !_isEditing ? l10n.edit : l10n.saveChanges,
                              child: IconButton(
                                icon:
                                    Icon(!_isEditing ? Icons.edit : Icons.save),
                                onPressed: () => !_isEditing
                                    ? setState(() {
                                        _isEditing = true;
                                      })
                                    : _saveEdits(),
                                isSelected: _isEditing,
                              ),
                            ),
                            if (_isEditing)
                              Tooltip(
                                message: l10n.cancel,
                                child: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: !_isEditing ? _onLaunch : null,
                          icon: const Icon(Icons.send),
                          label: Text(l10n.launchActivityButton),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
