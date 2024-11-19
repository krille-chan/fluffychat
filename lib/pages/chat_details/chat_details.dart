import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/pages/settings/settings.dart';
import 'package:fluffychat/pangea/pages/chat_details/pangea_chat_details.dart';
import 'package:fluffychat/pangea/pages/class_settings/p_class_widgets/class_description_button.dart';
import 'package:fluffychat/pangea/utils/set_class_name.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/app_lock.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart' as matrix;
import 'package:matrix/matrix.dart';

enum AliasActions { copy, delete, setCanonical }

class ChatDetails extends StatefulWidget {
  final String roomId;
  final Widget? embeddedCloseButton;

  const ChatDetails({
    super.key,
    required this.roomId,
    this.embeddedCloseButton,
  });

  @override
  ChatDetailsController createState() => ChatDetailsController();
}

class ChatDetailsController extends State<ChatDetails> {
  bool displaySettings = false;

  void toggleDisplaySettings() =>
      setState(() => displaySettings = !displaySettings);

  String? get roomId => widget.roomId;

  // #Pangea
  final GlobalKey<ChatDetailsController> addConversationBotKey =
      GlobalKey<ChatDetailsController>();

  bool displayAddStudentOptions = false;
  void toggleAddStudentOptions() =>
      setState(() => displayAddStudentOptions = !displayAddStudentOptions);
  void setDisplaynameAction() => setClassDisplayname(context, roomId);
  // void setDisplaynameAction() async {
  //   final room = Matrix.of(context).client.getRoomById(roomId!)!;
  //   final input = await showTextInputDialog(
  //     context: context,
  //     title: L10n.of(context)!.changeTheNameOfTheGroup,
  //     okLabel: L10n.of(context)!.ok,
  //     cancelLabel: L10n.of(context)!.cancel,
  //     textFields: [
  //       DialogTextField(
  //         initialText: room.getLocalizedDisplayname(
  //           MatrixLocals(
  //             L10n.of(context)!,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  //   if (input == null) return;
  //   final success = await showFutureLoadingDialog(
  //     context: context,
  //     future: () => room.setName(input.single),
  //   );
  //   if (success.error == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(L10n.of(context)!.displaynameHasBeenChanged)),
  //     );
  //   }
  // }
  // Pangea#

  void setTopicAction() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    // #Pangea
    setClassTopic(room, context);
    // final input = await showTextInputDialog(
    //   context: context,
    //   title: L10n.of(context)!.setChatDescription,
    //   okLabel: L10n.of(context)!.ok,
    //   cancelLabel: L10n.of(context)!.cancel,
    //   textFields: [
    //     DialogTextField(
    //       hintText: L10n.of(context)!.noChatDescriptionYet,
    //       initialText: room.topic,
    //       minLines: 4,
    //       maxLines: 8,
    //     ),
    //   ],
    // );
    // if (input == null) return;
    // final success = await showFutureLoadingDialog(
    //   context: context,
    //   future: () => room.setDescription(input.single),
    // );
    // if (success.error == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(L10n.of(context)!.chatDescriptionHasBeenChanged),
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
        SheetAction(
          key: AvatarAction.camera,
          label: L10n.of(context)!.openCamera,
          isDefaultAction: true,
          icon: Icons.camera_alt_outlined,
        ),
      SheetAction(
        key: AvatarAction.file,
        label: L10n.of(context)!.openGallery,
        icon: Icons.photo_outlined,
      ),
      if (room?.avatar != null)
        SheetAction(
          key: AvatarAction.remove,
          label: L10n.of(context)!.delete,
          isDestructiveAction: true,
          icon: Icons.delete_outlined,
        ),
    ];
    final action = actions.length == 1
        ? actions.single.key
        : await showModalActionSheet<AvatarAction>(
            context: context,
            title: L10n.of(context)!.editRoomAvatar,
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
      final picked = await AppLock.of(context).pauseWhile(
        FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: true,
        ),
      );
      final pickedFile = picked?.files.firstOrNull;
      if (pickedFile == null) return;
      file = MatrixFile(
        bytes: pickedFile.bytes!,
        name: pickedFile.name,
      );
    }
    await showFutureLoadingDialog(
      context: context,
      future: () => room!.setAvatar(file),
    );
  }

  static const fixedWidth = 360.0;

  @override
  // #Pangea
  Widget build(BuildContext context) => PangeaChatDetailsView(this);
  // Widget build(BuildContext context) => ChatDetailsView(this);
  // Pangea#

  // #Pangea
  bool showEditNameIcon = false;
  void hoverEditNameIcon(bool hovering) =>
      setState(() => showEditNameIcon = !showEditNameIcon);

  Future<void> setVisibility(matrix.Visibility visibility) async {
    if (roomId == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        await Matrix.of(context).client.setRoomVisibilityOnDirectory(
              roomId!,
              visibility: visibility,
            );
      },
    );
    if (mounted) setState(() {});
  }

  Future<void> toggleMute() async {
    final client = Matrix.of(context).client;
    final Room? room = client.getRoomById(roomId!);
    if (room == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        await (room.pushRuleState == PushRuleState.notify
            ? room.setPushRuleState(PushRuleState.mentionsOnly)
            : room.setPushRuleState(PushRuleState.notify));
      },
    );

    // wait for push rule update in sync
    await client.onSync.stream.firstWhere(
      (sync) =>
          sync.accountData != null &&
          sync.accountData!.isNotEmpty &&
          sync.accountData!.any((e) => e.type == 'm.push_rules'),
    );
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    MatrixState.pangeaController.classController.addMissingRoomRules(roomId);
  }
  // Pangea#
}
