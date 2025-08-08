import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Visibility;

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/join_rule_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/utils/client_download_content_extension.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum ActivityLaunchState {
  base,
  editing,
  launching,
}

class ActivityPlannerBuilder extends StatefulWidget {
  final ActivityPlanModel initialActivity;
  final String? initialFilename;
  final Room room;

  final Widget Function(ActivityPlannerBuilderState) builder;

  const ActivityPlannerBuilder({
    super.key,
    required this.initialActivity,
    this.initialFilename,
    required this.room,
    required this.builder,
  });

  @override
  State<ActivityPlannerBuilder> createState() => ActivityPlannerBuilderState();
}

class ActivityPlannerBuilderState extends State<ActivityPlannerBuilder> {
  ActivityLaunchState launchState = ActivityLaunchState.base;
  Uint8List? avatar;
  String? imageURL;
  String? filename;

  int numActivities = 1;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController vocabController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  final TextEditingController learningObjectivesController =
      TextEditingController();

  final List<Vocab> vocab = [];
  late LanguageLevelTypeEnum languageLevel;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    resetActivity();
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

  Room get room => widget.room;

  bool get isEditing => launchState == ActivityLaunchState.editing;
  bool get isLaunching => launchState == ActivityLaunchState.launching;

  ActivityPlanRequest get updatedRequest {
    final int participants = int.tryParse(participantsController.text.trim()) ??
        widget.initialActivity.req.numberOfParticipants;
    final updatedReq = widget.initialActivity.req;
    updatedReq.numberOfParticipants = participants;
    updatedReq.cefrLevel = languageLevel;
    return updatedReq;
  }

  ActivityPlanModel get updatedActivity {
    return ActivityPlanModel(
      req: updatedRequest,
      title: titleController.text,
      learningObjective: learningObjectivesController.text,
      instructions: instructionsController.text,
      vocab: vocab,
      imageURL: imageURL,
      roles: widget.initialActivity.roles,
    );
  }

  Future<void> resetActivity() async {
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

    languageLevel = widget.initialActivity.req.cefrLevel;

    imageURL = widget.initialActivity.imageURL;
    filename = widget.initialFilename;
    if (widget.initialActivity.imageURL != null) {
      await _setAvatarByURL(widget.initialActivity.imageURL!);
    }
    if (mounted) setState(() {});
  }

  Future<void> overrideActivity(ActivityPlanModel override) async {
    avatar = null;
    filename = null;
    imageURL = null;

    titleController.text = override.title;
    learningObjectivesController.text = override.learningObjective;
    instructionsController.text = override.instructions;
    participantsController.text = override.req.numberOfParticipants.toString();
    vocab.clear();
    vocab.addAll(override.vocab);
    languageLevel = override.req.cefrLevel;

    if (override.imageURL != null) {
      await _setAvatarByURL(override.imageURL!);
    }
    if (mounted) setState(() {});
  }

  void startEditing() => setLaunchState(ActivityLaunchState.editing);

  void setLaunchState(ActivityLaunchState state) {
    if (state == ActivityLaunchState.launching) {
      BookmarkedActivitiesRepo.save(updatedActivity);
    }

    launchState = state;
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

  void setLanguageLevel(LanguageLevelTypeEnum level) {
    languageLevel = level;
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
        imageURL = null;
        filename = photo.singleOrNull?.name;
      });
    }
  }

  void setNumActivities(int count) {
    if (mounted) setState(() => numActivities = count);
  }

  Future<void> _setAvatarByURL(String url) async {
    try {
      if (avatar == null) {
        if (url.startsWith("mxc")) {
          final client = Matrix.of(context).client;
          final mxcUri = Uri.parse(url);
          final data = await client.downloadMxcCached(mxcUri);
          avatar = data;
          filename = Uri.encodeComponent(
            mxcUri.pathSegments.last,
          );
        } else {
          final Response response = await http.get(Uri.parse(url));
          avatar = response.bodyBytes;
          filename = Uri.encodeComponent(
            Uri.parse(url).pathSegments.last,
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
    setLaunchState(ActivityLaunchState.base);

    await BookmarkedActivitiesRepo.remove(widget.initialActivity.bookmarkId);
    await BookmarkedActivitiesRepo.save(updatedActivity);
    if (mounted) setState(() {});
  }

  Future<void> clearEdits() async {
    await resetActivity();
    setLaunchState(ActivityLaunchState.base);
  }

  Future<void> launchToSpace() async {
    final List<String> activityRoomIDs = [];
    try {
      await Future.wait(
        List.generate(numActivities, (i) async {
          final id = await _launchActivityRoom(i);
          activityRoomIDs.add(id);
        }),
      );
    } catch (e) {
      _cleanupFailedLaunch(activityRoomIDs);
      rethrow;
    }
  }

  Future<String> _launchActivityRoom(int index) async {
    await updateImageURL();
    final roomID = await Matrix.of(context).client.createGroupChat(
          visibility: Visibility.private,
          groupName: "${updatedActivity.title} ${index + 1}",
          initialState: [
            if (imageURL != null)
              StateEvent(
                type: EventTypes.RoomAvatar,
                content: {'url': imageURL},
              ),
            RoomDefaults.defaultPowerLevels(
              Matrix.of(context).client.userID!,
            ),
            await Matrix.of(context).client.pangeaJoinRules(
              'knock_restricted',
              allow: [
                {
                  "type": "m.room_membership",
                  "room_id": room.id,
                }
              ],
            ),
          ],
          enableEncryption: false,
        );

    Room? activityRoom = room.client.getRoomById(roomID);
    if (activityRoom == null) {
      await room.client.waitForRoomInSync(roomID);
      activityRoom = room.client.getRoomById(roomID);
      if (activityRoom == null) {
        throw Exception("Failed to create activity room");
      }
    }

    await room.addToSpace(activityRoom.id);
    if (activityRoom.pangeaSpaceParents.isEmpty) {
      await room.client.waitForRoomInSync(activityRoom.id);
    }

    await activityRoom.sendActivityPlan(
      updatedActivity,
      avatar: avatar,
      filename: filename,
    );

    return activityRoom.id;
  }

  Future<void> _cleanupFailedLaunch(List<String> roomIds) async {
    final futures = roomIds.map((id) async {
      final room = Matrix.of(context).client.getRoomById(id);
      if (room == null) return;

      try {
        await room.leave();
      } catch (e) {
        debugPrint("Failed to leave room $id: $e");
      }
    });

    await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) => widget.builder(this);
}
