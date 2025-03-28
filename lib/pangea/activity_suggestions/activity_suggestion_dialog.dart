import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card_row.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivitySuggestionDialog extends StatefulWidget {
  final ActivityPlanModel activity;
  final String buttonText;
  final Room? room;

  final Function(
    ActivityPlanModel,
    Uint8List? avatar,
    String? filename,
  )? launch;

  const ActivitySuggestionDialog({
    required this.activity,
    required this.buttonText,
    this.launch,
    this.room,
    super.key,
  });

  @override
  ActivitySuggestionDialogState createState() =>
      ActivitySuggestionDialogState();
}

class ActivitySuggestionDialogState extends State<ActivitySuggestionDialog> {
  bool _isEditing = false;
  Uint8List? _avatar;
  String? _filename;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _vocabController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _learningObjectivesController =
      TextEditingController();

  // storing this separately so that we can dismiss edits,
  // rather than directly modifying the activity with each change
  final List<Vocab> _vocab = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.activity.title;
    _learningObjectivesController.text = widget.activity.learningObjective;
    _instructionsController.text = widget.activity.instructions;
    _participantsController.text =
        widget.activity.req.numberOfParticipants.toString();
    _vocab.addAll(widget.activity.vocab);
    _setAvatarByURL();
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

  void _setEditing(bool editting) {
    _isEditing = editting;
    if (mounted) setState(() {});
  }

  void _setAvatar() async {
    final photo = await selectFiles(
      context,
      type: FileSelectorType.images,
      allowMultiple: false,
    );
    final bytes = await photo.singleOrNull?.readAsBytes();
    if (mounted) {
      setState(() {
        _avatar = bytes;
        _filename = photo.singleOrNull?.name;
      });
    }
  }

  Future<void> _setAvatarByURL() async {
    if (widget.activity.imageURL == null) return;
    try {
      if (_avatar == null) {
        final Response response =
            await http.get(Uri.parse(widget.activity.imageURL!));
        _avatar = response.bodyBytes;
        _filename = Uri.encodeComponent(
          Uri.parse(widget.activity.imageURL!).pathSegments.last,
        );
      }
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          "imageURL": widget.activity.imageURL,
        },
      );
    }
  }

  void _clearEdits() {
    _avatar = null;
    _filename = null;
    _setAvatarByURL();
    _vocab.clear();
    _vocab.addAll(widget.activity.vocab);
    if (mounted) setState(() {});
  }

  Future<void> _updateTextFields() async {
    widget.activity.title = _titleController.text;
    widget.activity.learningObjective = _learningObjectivesController.text;
    widget.activity.instructions = _instructionsController.text;
    widget.activity.req.numberOfParticipants =
        int.tryParse(_participantsController.text) ?? 3;
    widget.activity.vocab = _vocab;
  }

  void _addVocab() {
    _vocab.insert(
      0,
      Vocab(
        lemma: _vocabController.text.trim(),
        pos: "",
      ),
    );
    _vocabController.clear();
    if (mounted) setState(() {});
  }

  void _removeVocab(int index) {
    _vocab.removeAt(index);
    if (mounted) setState(() {});
  }

  Future<void> _launchActivity() async {
    if (widget.room != null) {
      await widget.room!.sendActivityPlan(
        widget.activity,
        avatar: _avatar,
        filename: _filename,
      );
      context.go("/rooms/${widget.room!.id}/invite");
      return;
    }

    final client = Matrix.of(context).client;
    final roomId = await client.createGroupChat(
      preset: CreateRoomPreset.publicChat,
      visibility: sdk.Visibility.private,
      groupName: widget.activity.title,
      initialState: [
        StateEvent(
          type: EventTypes.RoomPowerLevels,
          stateKey: '',
          content: defaultPowerLevels(client.userID!),
        ),
      ],
      enableEncryption: false,
    );

    Room? room = Matrix.of(context).client.getRoomById(roomId);
    if (room == null) {
      await client.waitForRoomInSync(roomId);
      room = Matrix.of(context).client.getRoomById(roomId);
      if (room == null) return;
    }

    await room.sendActivityPlan(
      widget.activity,
      avatar: _avatar,
      filename: _filename,
    );
    context.go("/rooms/$roomId/invite");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = Stack(
      alignment: Alignment.topCenter,
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: widget.activity.imageURL != null || _avatar != null
                      ? DecorationImage(
                          image: _avatar != null
                              ? MemoryImage(_avatar!)
                              : NetworkImage(widget.activity.imageURL!)
                                  as ImageProvider<Object>,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 8.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isEditing)
                          ActivitySuggestionCardRow(
                            icon: Icons.event_note_outlined,
                            child: TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: L10n.of(context).activityTitle,
                              ),
                              maxLines: 2,
                              minLines: 1,
                            ),
                          )
                        else
                          ActivitySuggestionCardRow(
                            icon: Icons.event_note_outlined,
                            child: Text(
                              widget.activity.title,
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (_isEditing)
                          ActivitySuggestionCardRow(
                            icon: Symbols.target,
                            child: TextFormField(
                              controller: _learningObjectivesController,
                              decoration: InputDecoration(
                                labelText:
                                    L10n.of(context).learningObjectiveLabel,
                              ),
                              maxLines: 4,
                              minLines: 1,
                            ),
                          )
                        else
                          ActivitySuggestionCardRow(
                            icon: Symbols.target,
                            child: Text(
                              widget.activity.learningObjective,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        if (_isEditing)
                          ActivitySuggestionCardRow(
                            icon: Symbols.steps,
                            child: TextFormField(
                              controller: _instructionsController,
                              decoration: InputDecoration(
                                labelText: L10n.of(context).instructions,
                              ),
                              maxLines: 8,
                              minLines: 1,
                            ),
                          )
                        else
                          ActivitySuggestionCardRow(
                            icon: Symbols.steps,
                            child: Text(
                              widget.activity.instructions,
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        if (_isEditing)
                          ActivitySuggestionCardRow(
                            icon: Icons.group_outlined,
                            child: TextFormField(
                              controller: _participantsController,
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
                          )
                        else
                          ActivitySuggestionCardRow(
                            icon: Icons.group_outlined,
                            child: Text(
                              L10n.of(context).countParticipants(
                                widget.activity.req.numberOfParticipants,
                              ),
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        if (_isEditing)
                          ActivitySuggestionCardRow(
                            icon: Symbols.dictionary,
                            child: ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxHeight: 60.0),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 4.0,
                                  runSpacing: 4.0,
                                  children: _vocab
                                      .mapIndexed(
                                        (i, vocab) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 8.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withAlpha(20),
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () => _removeVocab(i),
                                              child: Row(
                                                spacing: 4.0,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(vocab.lemma),
                                                  const Icon(
                                                    Icons.close,
                                                    size: 12.0,
                                                  ),
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
                          )
                        else
                          ActivitySuggestionCardRow(
                            icon: Symbols.dictionary,
                            child: ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxHeight: 60.0),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 4.0,
                                  runSpacing: 4.0,
                                  children: _vocab
                                      .map(
                                        (vocab) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 8.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withAlpha(20),
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: Text(
                                            vocab.lemma,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        if (_isEditing)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              spacing: 4.0,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _vocabController,
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
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  spacing: 6.0,
                  children: [
                    if (_isEditing)
                      GestureDetector(
                        child: const Icon(Icons.close_outlined, size: 16.0),
                        onTap: () {
                          _clearEdits();
                          _setEditing(false);
                        },
                      ),
                    if (_isEditing)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            await _updateTextFields();
                            _setEditing(false);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.all(6.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          child: Text(
                            L10n.of(context).save,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: theme.colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    if (!_isEditing)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            final resp = await showFutureLoadingDialog(
                              context: context,
                              future: () async {
                                if (widget.launch != null) {
                                  return widget.launch?.call(
                                    widget.activity,
                                    _avatar,
                                    _filename,
                                  );
                                }
                                return _launchActivity();
                              },
                            );

                            if (resp.isError) return;
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.all(6.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          child: Text(
                            widget.buttonText,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: theme.colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    if (!_isEditing)
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                        ),
                        padding: const EdgeInsets.all(6.0),
                        constraints:
                            const BoxConstraints(), // override default min size of 48px
                        iconSize: 24.0,
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _setEditing(true),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4.0,
          left: 4.0,
          child: IconButton(
            icon: const Icon(Icons.close_outlined),
            onPressed: Navigator.of(context).pop,
            tooltip: L10n.of(context).close,
          ),
        ),
        if (_isEditing)
          Positioned(
            top: 160.0,
            child: InkWell(
              borderRadius: BorderRadius.circular(90),
              onTap: _setAvatar,
              child: const CircleAvatar(
                radius: 24.0,
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 24.0,
                ),
              ),
            ),
          ),
      ],
    );

    final content = AnimatedSize(
      duration: FluffyThemes.animationDuration,
      child: ConstrainedBox(
        constraints: FluffyThemes.isColumnMode(context)
            ? const BoxConstraints(
                maxWidth: 400.0,
              )
            : BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height,
              ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: body,
        ),
      ),
    );

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: FluffyThemes.isColumnMode(context)
          ? Dialog(child: content)
          : Dialog.fullscreen(child: content),
    );
  }
}
