import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_details/chat_details_view.dart';
import 'package:fluffychat/pages/settings/settings.dart';
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

  void setDisplaynameAction() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).changeTheNameOfTheGroup,
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
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.setDescription(input),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).chatDescriptionHasBeenChanged),
        ),
      );
    }
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

  static const fixedWidth = 360.0;

  @override
  Widget build(BuildContext context) => ChatDetailsView(this);
}
