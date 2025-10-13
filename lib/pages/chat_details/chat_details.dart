import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/settings/settings.dart';
import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/chat_settings/pages/pangea_room_details.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/activity_summaries_provider.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/download/download_room_extension.dart';
import 'package:fluffychat/pangea/download/download_type_enum.dart';
import 'package:fluffychat/pangea/extensions/join_rule_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum AliasActions { copy, delete, setCanonical }

class ChatDetails extends StatefulWidget {
  final String roomId;
  final Widget? embeddedCloseButton;
  // #Pangea
  final String? activeTab;
  // Pangea#

  const ChatDetails({
    super.key,
    required this.roomId,
    this.embeddedCloseButton,
    // #Pangea
    this.activeTab,
    // Pangea#
  });

  @override
  ChatDetailsController createState() => ChatDetailsController();
}

// #Pangea
// class ChatDetailsController extends State<ChatDetails> {
class ChatDetailsController extends State<ChatDetails>
    with ActivitySummariesProvider, CoursePlanProvider {
  bool loadingActivities = true;

  @override
  void initState() {
    super.initState();
    _loadSummaries();
    _loadCourseInfo();
  }

  @override
  void didUpdateWidget(covariant ChatDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomId != widget.roomId) {
      _loadCourseInfo();
    }
  }

  // Pangea#
  bool displaySettings = false;

  void toggleDisplaySettings() =>
      setState(() => displaySettings = !displaySettings);

  String? get roomId => widget.roomId;

  void setDisplaynameAction() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final input = await showTextInputDialog(
      context: context,
      // #Pangea
      // title: L10n.of(context).changeTheNameOfTheGroup,
      title: room.isSpace
          ? L10n.of(context).changeTheNameOfTheClass
          : L10n.of(context).changeTheNameOfTheChat,
      // Pangea#
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      initialText: room.getLocalizedDisplayname(
        MatrixLocals(
          L10n.of(context),
        ),
      ),
    );
    if (input == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.setName(input),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).displaynameHasBeenChanged)),
      );
    }
  }

  void setTopicAction() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).setChatDescription,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      hintText: L10n.of(context).noChatDescriptionYet,
      initialText: room.topic,
      minLines: 4,
      maxLines: 8,
    );
    if (input == null) return;
    // #Pangea
    await showFutureLoadingDialog(
      context: context,
      future: () => room.setDescription(input),
    );
    // final success = await showFutureLoadingDialog(
    //   context: context,
    //   future: () => room.setDescription(input.single),
    // );
    // if (success.error == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(L10n.of(context).chatDescriptionHasBeenChanged),
    //     ),
    //   );
    // }
    // Pangea#
  }

  void goToEmoteSettings() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    // okay, we need to test if there are any emote state events other than the default one
    // if so, we need to be directed to a selection screen for which pack we want to look at
    // otherwise, we just open the normal one.
    if ((room.states['im.ponies.room_emotes'] ?? <String, Event>{})
        .keys
        .any((String s) => s.isNotEmpty)) {
      context.push('/rooms/${room.id}/details/multiple_emotes');
    } else {
      context.push('/rooms/${room.id}/details/emotes');
    }
  }

  void setAvatarAction() async {
    final room = Matrix.of(context).client.getRoomById(roomId!);
    final actions = [
      if (PlatformInfos.isMobile)
        AdaptiveModalAction(
          value: AvatarAction.camera,
          label: L10n.of(context).openCamera,
          isDefaultAction: true,
          icon: const Icon(Icons.camera_alt_outlined),
        ),
      AdaptiveModalAction(
        value: AvatarAction.file,
        label: L10n.of(context).openGallery,
        icon: const Icon(Icons.photo_outlined),
      ),
      if (room?.avatar != null)
        AdaptiveModalAction(
          value: AvatarAction.remove,
          label: L10n.of(context).delete,
          isDestructive: true,
          icon: const Icon(Icons.delete_outlined),
        ),
    ];
    final action = actions.length == 1
        ? actions.single.value
        : await showModalActionPopup<AvatarAction>(
            context: context,
            title: L10n.of(context).editRoomAvatar,
            cancelLabel: L10n.of(context).cancel,
            actions: actions,
          );
    if (action == null) return;
    if (action == AvatarAction.remove) {
      await showFutureLoadingDialog(
        context: context,
        future: () => room!.setAvatar(null),
      );
      return;
    }
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().pickImage(
        source: action == AvatarAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 50,
      );
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final picked = await selectFiles(
        context,
        allowMultiple: false,
        type: FileSelectorType.images,
      );
      final pickedFile = picked.firstOrNull;
      if (pickedFile == null) return;
      file = MatrixFile(
        bytes: await pickedFile.readAsBytes(),
        name: pickedFile.name,
      );
    }
    await showFutureLoadingDialog(
      context: context,
      future: () => room!.setAvatar(file),
    );
  }

  // #Pangea
  void downloadChatAction() async {
    if (roomId == null) return;
    final Room? room = Matrix.of(context).client.getRoomById(roomId!);
    if (room == null) return;

    final type = await showModalActionPopup(
      context: context,
      title: L10n.of(context).downloadGroupText,
      actions: [
        AdaptiveModalAction(
          value: DownloadType.csv,
          label: L10n.of(context).downloadCSVFile,
        ),
        AdaptiveModalAction(
          value: DownloadType.txt,
          label: L10n.of(context).downloadTxtFile,
        ),
        AdaptiveModalAction(
          value: DownloadType.xlsx,
          label: L10n.of(context).downloadXLSXFile,
        ),
      ],
    );
    if (type == null) return;

    try {
      await room.download(type, context);
    } on EmptyChatException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            L10n.of(context).emptyChatDownloadWarning,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${L10n.of(context).oopsSomethingWentWrong} ${L10n.of(context).errorPleaseRefresh}",
          ),
        ),
      );
    }
  }

  Future<void> setRoomCapacity() async {
    if (roomId == null) return;
    final Room? room = Matrix.of(context).client.getRoomById(roomId!);
    if (room == null) return;

    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).chatCapacity,
      message: L10n.of(context).chatCapacityExplanation,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      initialText: ((room.capacity != null) ? '${room.capacity}' : ''),
      keyboardType: TextInputType.number,
      maxLength: 3,
      validator: (value) {
        if (value.isEmpty ||
            int.tryParse(value) == null ||
            int.parse(value) < 0) {
          return L10n.of(context).enterNumber;
        }
        if (int.parse(value) < (room.summary.mJoinedMemberCount ?? 1)) {
          return L10n.of(context)
              .chatCapacitySetTooLow(room.summary.mJoinedMemberCount ?? 1);
        }
        return null;
      },
    );
    if (input == null || input.isEmpty || int.tryParse(input) == null) {
      return;
    }

    final newCapacity = int.parse(input);
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.updateRoomCapacity(newCapacity),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).chatCapacityHasBeenChanged),
        ),
      );
      setState(() {});
    }
  }

  Future<void> addGroupChat() async {
    final activeSpace = Matrix.of(context).client.getRoomById(roomId!);
    if (activeSpace == null || !activeSpace.isSpace) return;

    final names = await showTextInputDialog(
      context: context,
      title: L10n.of(context).createGroup,
      hintText: L10n.of(context).groupName,
      minLines: 1,
      maxLines: 1,
      maxLength: 64,
      validator: (text) {
        if (text.isEmpty) {
          return L10n.of(context).pleaseChoose;
        }
        return null;
      },
      okLabel: L10n.of(context).create,
      cancelLabel: L10n.of(context).cancel,
    );
    if (names == null) return;

    final resp = await showFutureLoadingDialog<String>(
      context: context,
      future: () async {
        final newRoomId = await Matrix.of(context).client.createGroupChat(
              visibility: sdk.Visibility.private,
              groupName: names,
              initialState: [
                RoomDefaults.defaultPowerLevels(
                  Matrix.of(context).client.userID!,
                ),
                await Matrix.of(context).client.pangeaJoinRules(
                      'knock_restricted',
                      allow: roomId != null
                          ? [
                              {
                                "type": "m.room_membership",
                                "room_id": roomId,
                              }
                            ]
                          : null,
                    ),
              ],
              enableEncryption: false,
            );
        final client = Matrix.of(context).client;
        Room? room = client.getRoomById(newRoomId);
        if (room == null) {
          await client.waitForRoomInSync(newRoomId);
          room = client.getRoomById(newRoomId);
        }
        if (room == null) newRoomId;
        await activeSpace.addToSpace(room!.id);
        if (room.spaceParents.isEmpty) {
          await client.waitForRoomInSync(newRoomId);
        }
        return newRoomId;
      },
    );

    if (resp.isError || resp.result == null || !mounted) return;
    context.go('/rooms/${resp.result}/invite');
  }

  Future<void> _loadCourseInfo() async {
    final room = Matrix.of(context).client.getRoomById(roomId!);
    if (room == null || !room.isSpace || room.coursePlan == null) {
      setState(() {
        course = null;
        loadingCourse = false;
        loadingTopics = false;
        loadingActivities = false;
      });
      return;
    }

    setState(() => loadingActivities = true);
    await loadCourse(room.coursePlan!.uuid);
    if (course != null) {
      await loadTopics();
      await loadAllActivities();
    }
    if (mounted) setState(() => loadingActivities = false);
  }

  Future<void> _loadSummaries() async {
    try {
      final room = Matrix.of(context).client.getRoomById(roomId!);
      if (room == null || !room.isSpace) return;
      await loadRoomSummaries(
        room.spaceChildren.map((c) => c.roomId).whereType<String>().toList(),
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "message": "Failed to load activity summaries",
          "roomId": roomId,
        },
      );
    }
  }
  // Pangea#

  static const fixedWidth = 360.0;

  @override
  // #Pangea
  Widget build(BuildContext context) => PangeaRoomDetailsView(this);
  // Widget build(BuildContext context) => ChatDetailsView(this);
  // Pangea#
}
