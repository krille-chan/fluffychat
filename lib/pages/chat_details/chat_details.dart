import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart' as matrix;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_details/chat_details_view.dart';
import 'package:fluffychat/pages/settings/settings.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/app_lock.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum AliasActions { copy, delete, setCanonical }

class ChatDetails extends StatefulWidget {
  final String roomId;

  const ChatDetails({
    super.key,
    required this.roomId,
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
        ),
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
          .then(
            (response) => List<String>.from(response['aliases'] as Iterable),
          ),
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
      context: context,
      title: L10n.of(context)!.editRoomAliases,
      actions: [
        if (adminMode)
          AlertDialogAction(label: L10n.of(context)!.create, key: 'new'),
        ...aliases.result!
            .map((alias) => AlertDialogAction(key: alias, label: alias)),
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
        ),
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
      context: context,
      title: L10n.of(context)!.setChatDescription,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.noChatDescriptionYet,
          initialText: room.topic,
          minLines: 4,
          maxLines: 8,
        ),
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
          content: Text(L10n.of(context)!.chatDescriptionHasBeenChanged),
        ),
      );
    }
  }

  void setGuestAccess() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final currentGuestAccess = room.guestAccess;
    final newGuestAccess = await showConfirmationDialog<GuestAccess>(
      context: context,
      title: L10n.of(context)!.areGuestsAllowedToJoin,
      actions: GuestAccess.values
          .map(
            (guestAccess) => AlertDialogAction(
              key: guestAccess,
              label: guestAccess
                  .getLocalizedString(MatrixLocals(L10n.of(context)!)),
              isDefaultAction: guestAccess == currentGuestAccess,
            ),
          )
          .toList(),
    );
    if (newGuestAccess == null || newGuestAccess == currentGuestAccess) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => room.setGuestAccess(newGuestAccess),
    );
  }

  void setHistoryVisibility() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final currentHistoryVisibility = room.historyVisibility;
    final newHistoryVisibility =
        await showConfirmationDialog<HistoryVisibility>(
      context: context,
      title: L10n.of(context)!.visibilityOfTheChatHistory,
      actions: HistoryVisibility.values
          .map(
            (visibility) => AlertDialogAction(
              key: visibility,
              label: visibility
                  .getLocalizedString(MatrixLocals(L10n.of(context)!)),
              isDefaultAction: visibility == currentHistoryVisibility,
            ),
          )
          .toList(),
    );
    if (newHistoryVisibility == null ||
        newHistoryVisibility == currentHistoryVisibility) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => room.setHistoryVisibility(newHistoryVisibility),
    );
  }

  void setJoinRules() async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final currentJoinRule = room.joinRules;
    final newJoinRule = await showConfirmationDialog<JoinRules>(
      context: context,
      title: L10n.of(context)!.whoIsAllowedToJoinThisGroup,
      actions: JoinRules.values
          .map(
            (joinRule) => AlertDialogAction(
              key: joinRule,
              label:
                  joinRule.getLocalizedString(MatrixLocals(L10n.of(context)!)),
              isDefaultAction: joinRule == currentJoinRule,
            ),
          )
          .toList(),
    );
    if (newJoinRule == null || newJoinRule == currentJoinRule) return;
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        await room.setJoinRules(newJoinRule);
        room.client.setRoomVisibilityOnDirectory(
          roomId!,
          visibility: {
            JoinRules.public,
            JoinRules.knock,
          }.contains(newJoinRule)
              ? matrix.Visibility.public
              : matrix.Visibility.private,
        );
      },
    );
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
  Widget build(BuildContext context) => ChatDetailsView(this);
}
