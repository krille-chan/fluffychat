import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat_details/chat_details_view.dart';
import 'package:fluffychat/pages/settings/settings.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum AliasActions { copy, delete, setCanonical }

class ChatDetails extends StatefulWidget {
  const ChatDetails({Key? key}) : super(key: key);

  @override
  ChatDetailsController createState() => ChatDetailsController();
}

class ChatDetailsController extends State<ChatDetails> {
  List<User>? members;
  bool displaySettings = false;

  void toggleDisplaySettings() =>
      setState(() => displaySettings = !displaySettings);

  String? get roomId => VRouter.of(context).pathParameters['roomid'];

  void setDisplaynameAction() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.changeTheNameOfTheGroup,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          initialText: room.getLocalizedDisplayname(
            MatrixLocals(
              L10n.of(context)!,
            ),
          ),
        )
      ],
    );
    if (input == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.setName(input.single),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context)!.displaynameHasBeenChanged)),
      );
    }
  }

  void editAliases() async {
    final room = Matrix.of(context).client.getRoomById(roomId!);

    // The current endpoint doesnt seem to be implemented in Synapse. This may
    // change in the future and then we just need to switch to this api call:
    //
    // final aliases = await showFutureLoadingDialog(
    //   context: context,
    //   future: () => room.client.requestRoomAliases(room.id),
    // );
    //
    // While this is not working we use the unstable api:
    final aliases = await showFutureLoadingDialog(
      context: context,
      future: () => room!.client
          .request(
            RequestType.GET,
            '/client/unstable/org.matrix.msc2432/rooms/${Uri.encodeComponent(room.id)}/aliases',
          )
          .then((response) => List<String>.from(response['aliases'])),
    );
    // Switch to the stable api once it is implemented.

    if (aliases.error != null) return;
    final adminMode = room!.canSendEvent('m.room.canonical_alias');
    if (aliases.result!.isEmpty && (room.canonicalAlias.isNotEmpty)) {
      aliases.result!.add(room.canonicalAlias);
    }
    if (aliases.result!.isEmpty && adminMode) {
      return setAliasAction();
    }
    final select = await showConfirmationDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.editRoomAliases,
      actions: [
        if (adminMode)
          AlertDialogAction(label: L10n.of(context)!.create, key: 'new'),
        ...aliases.result!
            .map((alias) => AlertDialogAction(key: alias, label: alias))
            .toList(),
      ],
    );
    if (select == null) return;
    if (select == 'new') {
      return setAliasAction();
    }
    final option = await showConfirmationDialog<AliasActions>(
      context: context,
      title: select,
      actions: [
        AlertDialogAction(
          label: L10n.of(context)!.copyToClipboard,
          key: AliasActions.copy,
          isDefaultAction: true,
        ),
        if (adminMode) ...{
          AlertDialogAction(
            label: L10n.of(context)!.setAsCanonicalAlias,
            key: AliasActions.setCanonical,
            isDestructiveAction: true,
          ),
          AlertDialogAction(
            label: L10n.of(context)!.delete,
            key: AliasActions.delete,
            isDestructiveAction: true,
          ),
        },
      ],
    );
    if (option == null) return;
    switch (option) {
      case AliasActions.copy:
        await Clipboard.setData(ClipboardData(text: select));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context)!.copiedToClipboard)),
        );
        break;
      case AliasActions.delete:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.client.deleteRoomAlias(select),
        );
        break;
      case AliasActions.setCanonical:
        await showFutureLoadingDialog(
          context: context,
          future: () => room.client.setRoomStateWithKey(
            room.id,
            EventTypes.RoomCanonicalAlias,
            '',
            {
              'alias': select,
            },
          ),
        );
        break;
    }
  }

  void setAliasAction() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final domain = room.client.userID!.domain;

    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.setInvitationLink,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          prefixText: '#',
          suffixText: domain,
          hintText: L10n.of(context)!.alias,
          initialText: room.canonicalAlias.localpart,
        )
      ],
    );
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () =>
          room.client.setRoomAlias('#${input.single}:${domain!}', room.id),
    );
  }

  void setTopicAction() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.setGroupDescription,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.setGroupDescription,
          initialText: room.topic,
          minLines: 1,
          maxLines: 4,
        )
      ],
    );
    if (input == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.setDescription(input.single),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context)!.groupDescriptionHasBeenChanged),
        ),
      );
    }
  }

  void setGuestAccessAction(GuestAccess guestAccess) => showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context)
            .client
            .getRoomById(roomId!)!
            .setGuestAccess(guestAccess),
      );

  void setHistoryVisibilityAction(HistoryVisibility historyVisibility) =>
      showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context)
            .client
            .getRoomById(roomId!)!
            .setHistoryVisibility(historyVisibility),
      );

  void setJoinRulesAction(JoinRules joinRule) => showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context)
            .client
            .getRoomById(roomId!)!
            .setJoinRules(joinRule),
      );

  void goToEmoteSettings() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    // okay, we need to test if there are any emote state events other than the default one
    // if so, we need to be directed to a selection screen for which pack we want to look at
    // otherwise, we just open the normal one.
    if ((room.states['im.ponies.room_emotes'] ?? <String, Event>{})
        .keys
        .any((String s) => s.isNotEmpty)) {
      VRouter.of(context).to('multiple_emotes');
    } else {
      VRouter.of(context).to('emotes');
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
      final result =
          await FilePickerCross.importFromStorage(type: FileTypeCross.image);
      if (result.fileName == null) return;
      file = MatrixFile(
        bytes: result.toUint8List(),
        name: result.fileName!,
      );
    }
    await showFutureLoadingDialog(
      context: context,
      future: () => room!.setAvatar(file),
    );
  }

  void requestMoreMembersAction() async {
    final room = Matrix.of(context).client.getRoomById(roomId!);
    final participants = await showFutureLoadingDialog(
      context: context,
      future: () => room!.requestParticipants(),
    );
    if (participants.error == null) {
      setState(() => members = participants.result);
    }
  }

  static const fixedWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    members ??=
        Matrix.of(context).client.getRoomById(roomId!)!.getParticipants();
    return SizedBox(
      width: fixedWidth,
      child: ChatDetailsView(this),
    );
  }
}
