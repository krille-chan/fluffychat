import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:fluffychat/utils/client_download_content_extension.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class ActivitySuggestionDialog extends StatefulWidget {
  final ActivityPlanModel initialActivity;
  final String buttonText;
  final Room? room;

  final Function(
    ActivityPlanModel,
    Uint8List?,
    String?,
  )? onLaunch;

  final Future<void> Function(
    String,
    ActivityPlanModel,
    Uint8List?,
    String?,
  )? onEdit;

  const ActivitySuggestionDialog({
    required this.initialActivity,
    required this.buttonText,
    this.onLaunch,
    this.onEdit,
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
  String? _imageURL;
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
    _titleController.text = widget.initialActivity.title;
    _learningObjectivesController.text =
        widget.initialActivity.learningObjective;
    _instructionsController.text = widget.initialActivity.instructions;
    _participantsController.text =
        widget.initialActivity.req.numberOfParticipants.toString();
    _vocab.addAll(widget.initialActivity.vocab);
    _imageURL = widget.initialActivity.imageURL;
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
    if (widget.initialActivity.imageURL == null) return;
    try {
      if (_avatar == null) {
        if (widget.initialActivity.imageURL!.startsWith("mxc")) {
          final client = Matrix.of(context).client;
          final mxcUri = Uri.parse(widget.initialActivity.imageURL!);
          final data = await client.downloadMxcCached(mxcUri);
          _avatar = data;
          _filename = Uri.encodeComponent(
            mxcUri.pathSegments.last,
          );
        } else {
          final Response response =
              await http.get(Uri.parse(widget.initialActivity.imageURL!));
          _avatar = response.bodyBytes;
          _filename = Uri.encodeComponent(
            Uri.parse(widget.initialActivity.imageURL!).pathSegments.last,
          );
        }
      }
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          "imageURL": widget.initialActivity.imageURL,
        },
      );
    }
  }

  void _clearEdits() {
    _avatar = null;
    _filename = null;
    _setAvatarByURL();
    _vocab.clear();
    _vocab.addAll(widget.initialActivity.vocab);
    if (mounted) setState(() {});
  }

  ActivityPlanModel get _updatedActivity => ActivityPlanModel(
        req: widget.initialActivity.req,
        title: _titleController.text,
        learningObjective: _learningObjectivesController.text,
        instructions: _instructionsController.text,
        vocab: _vocab,
        imageURL: _imageURL,
      );

  Future<void> _updateImageURL() async {
    if (_avatar == null) return;
    final url = await Matrix.of(context).client.uploadContent(
          _avatar!,
          filename: _filename,
        );
    if (!mounted) return;
    setState(() {
      _imageURL = url.toString();
    });
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
    await _updateImageURL();

    if (widget.room != null) {
      await widget.room!.sendActivityPlan(
        _updatedActivity,
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
      groupName: _updatedActivity.title,
      initialState: [
        if (_updatedActivity.imageURL != null)
          StateEvent(
            type: EventTypes.RoomAvatar,
            stateKey: '',
            content: {
              "url": _updatedActivity.imageURL,
            },
          ),
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
      _updatedActivity,
      avatar: _avatar,
      filename: _filename,
    );

    context.go("/rooms/$roomId/invite?filter=groups");
  }

  Future<void> _saveEdits() async {
    if (!_formKey.currentState!.validate()) return;
    await _updateImageURL();
    _setEditing(false);
    if (widget.onEdit != null) {
      await widget.onEdit!(
        widget.initialActivity.bookmarkId,
        _updatedActivity,
        _avatar,
        _filename,
      );
    }
  }

  double get width {
    if (FluffyThemes.isColumnMode(context)) {
      return 400.0;
    }
    return MediaQuery.of(context).size.width;
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
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 400.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    width: width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: _avatar != null
                          ? Image.memory(_avatar!, fit: BoxFit.cover)
                          : _updatedActivity.imageURL != null
                              ? _updatedActivity.imageURL!.startsWith("mxc")
                                  ? MxcImage(
                                      uri: Uri.parse(
                                        _updatedActivity.imageURL!,
                                      ),
                                      width: width,
                                      height: 200,
                                      cacheKey: _updatedActivity.bookmarkId,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: _updatedActivity.imageURL!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const SizedBox(),
                                    )
                              : null,
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 8.0,
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
                              _updatedActivity.title,
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
                              _updatedActivity.learningObjective,
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
                              _updatedActivity.instructions,
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
                                _updatedActivity.req.numberOfParticipants,
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
                    if (_isEditing && widget.onEdit != null)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveEdits,
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
                      )
                    else
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            final resp = await showFutureLoadingDialog(
                              context: context,
                              future: () async {
                                if (widget.onLaunch != null) {
                                  await _updateImageURL();

                                  widget.onLaunch!.call(
                                    _updatedActivity,
                                    _avatar,
                                    _filename,
                                  );
                                } else {
                                  await _launchActivity();
                                }
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
      ],
    );

    final content = AnimatedSize(
      duration: FluffyThemes.animationDuration,
      child: ConstrainedBox(
        constraints: FluffyThemes.isColumnMode(context)
            ? BoxConstraints(maxWidth: width)
            : BoxConstraints(
                maxWidth: width,
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
