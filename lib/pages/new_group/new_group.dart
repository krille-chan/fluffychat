import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/new_group/new_group_view.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/utils/client_spaces_extension.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewGroup extends StatefulWidget {
  // #Pangea
  final String? spaceId;
  // Pangea#
  final CreateGroupType createGroupType;
  const NewGroup({
    // #Pangea
    this.spaceId,
    // Pangea#
    this.createGroupType = CreateGroupType.group,
    super.key,
  });

  @override
  NewGroupController createState() => NewGroupController();
}

class NewGroupController extends State<NewGroup> {
  TextEditingController nameController = TextEditingController();

  // #Pangea
  ActivityPlanModel? selectedActivity;
  Uint8List? selectedActivityImage;
  String? selectedActivityImageFilename;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();

  bool requiredCodeToJoin = false;
  // bool publicGroup = false;

  bool get canSubmit => nameController.text.trim().isNotEmpty;
  // Pangea#
  bool groupCanBeFound = false;

  Uint8List? avatar;

  Uri? avatarUrl;

  Object? error;

  bool loading = false;

  CreateGroupType get createGroupType =>
      _createGroupType ?? widget.createGroupType;

  CreateGroupType? _createGroupType;

  void setCreateGroupType(Set<CreateGroupType> b) =>
      setState(() => _createGroupType = b.single);

  // #Pangea
  // void setPublicGroup(bool b) =>
  //     setState(() => publicGroup = groupCanBeFound = b);
  void setRequireCode(bool b) => setState(() => requiredCodeToJoin = b);

  void setSelectedActivity(
    ActivityPlanModel? activity,
    Uint8List? image,
    String? imageFilename,
  ) {
    setState(() {
      selectedActivity = activity;
      selectedActivityImage = image;
      selectedActivityImageFilename = imageFilename;
      if (avatar == null) {
        avatar = image;
        avatarUrl = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  // Pangea#

  void setGroupCanBeFound(bool b) => setState(() => groupCanBeFound = b);

  void selectPhoto() async {
    final photo = await selectFiles(
      context,
      type: FileSelectorType.images,
      allowMultiple: false,
    );
    final bytes = await photo.singleOrNull?.readAsBytes();

    setState(() {
      avatarUrl = null;
      avatar = bytes;
    });
  }

  Future<void> _createGroup() async {
    if (!mounted) return;
    final roomId = await Matrix.of(context).client.createGroupChat(
          // #Pangea
          // visibility:
          //     groupCanBeFound ? sdk.Visibility.public : sdk.Visibility.private,
          // preset: publicGroup
          //     ? sdk.CreateRoomPreset.publicChat
          //     : sdk.CreateRoomPreset.privateChat,
          preset: sdk.CreateRoomPreset.publicChat,
          visibility: sdk.Visibility.private,
          // Pangea#
          groupName:
              nameController.text.isNotEmpty ? nameController.text : null,
          initialState: [
            if (avatar != null)
              sdk.StateEvent(
                type: sdk.EventTypes.RoomAvatar,
                content: {'url': avatarUrl.toString()},
              ),
            // #Pangea
            StateEvent(
              type: EventTypes.RoomPowerLevels,
              stateKey: '',
              content: defaultPowerLevels(Matrix.of(context).client.userID!),
            ),
            // Pangea#
          ],
          // #Pangea
          enableEncryption: false,
          // Pangea#
        );
    if (!mounted) return;
    // #Pangea
    final client = Matrix.of(context).client;
    Room? room = client.getRoomById(roomId);
    if (room == null) {
      await client.waitForRoomInSync(roomId);
      room = client.getRoomById(roomId);
    }
    if (room == null) return;

    if (widget.spaceId != null) {
      try {
        final space = client.getRoomById(widget.spaceId!);
        await space?.pangeaSetSpaceChild(room.id);
      } catch (err) {
        ErrorHandler.logError(
          e: "Failed to add room to space",
          data: {"spaceId": widget.spaceId, "error": err},
        );
      }
    }

    if (selectedActivity != null) {
      try {
        await room.sendActivityPlan(
          selectedActivity!,
          avatar: selectedActivityImage,
          filename: selectedActivityImageFilename,
        );
      } catch (err) {
        ErrorHandler.logError(
          e: "Failed to send activity plan",
          data: {"roomId": roomId, "error": err},
        );
      }
    }
    context.go('/rooms/$roomId/invite?filter=groups');
    // Pangea#
  }

  Future<void> _createSpace() async {
    if (!mounted) return;
    // #Pangea
    // final spaceId = await Matrix.of(context).client.createRoom(
    //       preset: publicGroup
    //           ? sdk.CreateRoomPreset.publicChat
    //           : sdk.CreateRoomPreset.privateChat,
    //       creationContent: {'type': RoomCreationTypes.mSpace},
    //       visibility: publicGroup ? sdk.Visibility.public : null,
    //       roomAliasName: publicGroup
    //           ? nameController.text.trim().toLowerCase().replaceAll(' ', '_')
    //           : null,
    //       name: nameController.text.trim(),
    //       powerLevelContentOverride: {'events_default': 100},
    //       initialState: [
    //         if (avatar != null)
    //           sdk.StateEvent(
    //             type: sdk.EventTypes.RoomAvatar,
    //             content: {'url': avatarUrl.toString()},
    //           ),
    //       ],
    //     );
    // if (!mounted) return;
    // context.pop<String>(spaceId);
    final spaceId = await Matrix.of(context).client.createPangeaSpace(
          name: nameController.text,
          introChatName: L10n.of(context).introductions,
          announcementsChatName: L10n.of(context).announcements,
          visibility:
              groupCanBeFound ? sdk.Visibility.public : sdk.Visibility.private,
          joinRules:
              requiredCodeToJoin ? sdk.JoinRules.knock : sdk.JoinRules.public,
          avatar: avatar,
          avatarUrl: avatarUrl,
        );

    if (!mounted) return;

    final room = Matrix.of(context).client.getRoomById(spaceId);
    if (room == null) return;
    final spaceCode = room.classCode(context);
    if (spaceCode != null) {
      GoogleAnalytics.createClass(room.name, spaceCode);
    }

    context.go("/rooms?spaceId=$spaceId");
    // Pangea#
  }

  void submitAction([_]) async {
    final client = Matrix.of(context).client;

    try {
      // #Pangea
      if (!formKey.currentState!.validate()) {
        focusNode.requestFocus();
        return;
      }

      // if (nameController.text.trim().isEmpty &&
      // createGroupType == CreateGroupType.space) {
      if (!canSubmit) {
        // Pangea#
        setState(() => error = L10n.of(context).pleaseFillOut);
        return;
      }

      setState(() {
        loading = true;
        error = null;
      });

      final avatar = this.avatar;
      avatarUrl ??= avatar == null ? null : await client.uploadContent(avatar);

      if (!mounted) return;

      switch (createGroupType) {
        case CreateGroupType.group:
          await _createGroup();
        case CreateGroupType.space:
          await _createSpace();
      }
    } catch (e, s) {
      sdk.Logs().d('Unable to create group', e, s);
      setState(() {
        error = e;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => NewGroupView(this);
}

enum CreateGroupType { group, space }
