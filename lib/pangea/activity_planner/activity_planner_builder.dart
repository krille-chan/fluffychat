import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/client_download_content_extension.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityPlannerBuilder extends StatefulWidget {
  final ActivityPlanModel initialActivity;
  final String? initialFilename;
  final Room? room;

  final Widget Function(ActivityPlannerBuilderState) builder;

  final Future<void> Function(
    String,
    ActivityPlanModel,
    Uint8List?,
    String?,
  )? onEdit;

  const ActivityPlannerBuilder({
    super.key,
    required this.initialActivity,
    this.initialFilename,
    this.room,
    required this.builder,
    this.onEdit,
  });

  @override
  State<ActivityPlannerBuilder> createState() => ActivityPlannerBuilderState();
}

class ActivityPlannerBuilderState extends State<ActivityPlannerBuilder> {
  bool isEditing = false;
  Uint8List? avatar;
  String? imageURL;
  String? filename;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController vocabController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  final TextEditingController learningObjectivesController =
      TextEditingController();

  final List<Vocab> vocab = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _resetActivity();
  }

  @override
  void dispose() {
    titleController.dispose();
    learningObjectivesController.dispose();
    instructionsController.dispose();
    vocabController.dispose();
    participantsController.dispose();
    super.dispose();
  }

  Room? get room => widget.room;

  ActivityPlanModel get updatedActivity {
    final int participants = int.tryParse(participantsController.text.trim()) ??
        widget.initialActivity.req.numberOfParticipants;

    final updatedReq = widget.initialActivity.req;
    updatedReq.numberOfParticipants = participants;

    return ActivityPlanModel(
      req: updatedReq,
      title: titleController.text,
      learningObjective: learningObjectivesController.text,
      instructions: instructionsController.text,
      vocab: vocab,
      imageURL: imageURL,
    );
  }

  Future<void> _resetActivity() async {
    avatar = null;
    filename = null;
    imageURL = null;

    titleController.text = widget.initialActivity.title;
    learningObjectivesController.text =
        widget.initialActivity.learningObjective;
    instructionsController.text = widget.initialActivity.instructions;
    participantsController.text =
        widget.initialActivity.req.numberOfParticipants.toString();

    vocab.clear();
    vocab.addAll(widget.initialActivity.vocab);

    imageURL = widget.initialActivity.imageURL;
    filename = widget.initialFilename;
    await _setAvatarByURL();
    if (mounted) setState(() {});
  }

  void setEditing(bool editting) {
    isEditing = editting;
    if (mounted) setState(() {});
  }

  void addVocab() {
    vocab.insert(
      0,
      Vocab(
        lemma: vocabController.text.trim(),
        pos: "",
      ),
    );
    vocabController.clear();
    if (mounted) setState(() {});
  }

  void removeVocab(int index) {
    vocab.removeAt(index);
    if (mounted) setState(() {});
  }

  void selectAvatar() async {
    final photo = await selectFiles(
      context,
      type: FileSelectorType.images,
      allowMultiple: false,
    );
    final bytes = await photo.singleOrNull?.readAsBytes();
    if (mounted) {
      setState(() {
        avatar = bytes;
        filename = photo.singleOrNull?.name;
      });
    }
  }

  Future<void> _setAvatarByURL() async {
    if (widget.initialActivity.imageURL == null) return;
    try {
      if (avatar == null) {
        if (widget.initialActivity.imageURL!.startsWith("mxc")) {
          final client = Matrix.of(context).client;
          final mxcUri = Uri.parse(widget.initialActivity.imageURL!);
          final data = await client.downloadMxcCached(mxcUri);
          avatar = data;
          filename = Uri.encodeComponent(
            mxcUri.pathSegments.last,
          );
        } else {
          final Response response =
              await http.get(Uri.parse(widget.initialActivity.imageURL!));
          avatar = response.bodyBytes;
          filename = Uri.encodeComponent(
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

  Future<void> updateImageURL() async {
    if (avatar == null) return;
    final url = await Matrix.of(context).client.uploadContent(
          avatar!,
          filename: filename,
        );
    if (!mounted) return;
    setState(() {
      imageURL = url.toString();
    });
  }

  Future<void> saveEdits() async {
    if (!formKey.currentState!.validate()) return;
    await updateImageURL();
    setEditing(false);
    if (widget.onEdit != null) {
      await widget.onEdit!(
        widget.initialActivity.bookmarkId,
        updatedActivity,
        avatar,
        filename,
      );
    }
  }

  Future<void> clearEdits() async {
    _resetActivity();
    if (mounted) {
      setState(() {
        isEditing = false;
      });
    }
  }

  Future<void> launchToRoom() async {
    return widget.room?.sendActivityPlan(
      updatedActivity,
      avatar: avatar,
      filename: filename,
      avatarURL: imageURL,
    );
  }

  @override
  Widget build(BuildContext context) => widget.builder(this);
}
