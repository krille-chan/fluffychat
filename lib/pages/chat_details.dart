import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';

import 'package:famedlysdk/famedlysdk.dart';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/pages/views/chat_details_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/services.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';

enum AliasActions { copy, delete, setCanonical }

class ChatDetails extends StatefulWidget {
  final String roomId;

  const ChatDetails(this.roomId);

  @override
  ChatDetailsController createState() => ChatDetailsController();
}

class ChatDetailsController extends State<ChatDetails> {
  List<User> members;

  @override
  void initState() {
    super.initState();
    members ??=
        Matrix.of(context).client.getRoomById(widget.roomId).getParticipants();
  }

  void setDisplaynameAction() async {
    final room = Matrix.of(context).client.getRoomById(widget.roomId);
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).changeTheNameOfTheGroup,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      useRootNavigator: false,
      textFields: [
        DialogTextField(
          initialText: room.getLocalizedDisplayname(
            MatrixLocals(
              L10n.of(context),
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
      AdaptivePageLayout.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).displaynameHasBeenChanged)));
    }
  }

  void editAliases() async {
    final room = Matrix.of(context).client.getRoomById(widget.roomId);

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
      future: () => room.client
          .request(
            RequestType.GET,
            '/client/unstable/org.matrix.msc2432/rooms/${Uri.encodeComponent(room.id)}/aliases',
          )
          .then((response) => List<String>.from(response['aliases'])),
    );
    // Switch to the stable api once it is implemented.

    if (aliases.error != null) return;
    final adminMode = room.canSendEvent('m.room.canonical_alias');
    if (aliases.result.isEmpty && (room.canonicalAlias?.isNotEmpty ?? false)) {
      aliases.result.add(room.canonicalAlias);
    }
    if (aliases.result.isEmpty && adminMode) {
      return setAliasAction();
    }
    final select = await showConfirmationDialog(
      context: context,
      title: L10n.of(context).editRoomAliases,
      actions: [
        if (adminMode)
          AlertDialogAction(label: L10n.of(context).create, key: 'new'),
        ...aliases.result
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
          label: L10n.of(context).copyToClipboard,
          key: AliasActions.copy,
          isDefaultAction: true,
        ),
        if (adminMode) ...{
          AlertDialogAction(
            label: L10n.of(context).setAsCanonicalAlias,
            key: AliasActions.setCanonical,
            isDestructiveAction: true,
          ),
          AlertDialogAction(
            label: L10n.of(context).delete,
            key: AliasActions.delete,
            isDestructiveAction: true,
          ),
        },
      ],
    );
    switch (option) {
      case AliasActions.copy:
        await Clipboard.setData(ClipboardData(text: select));
        AdaptivePageLayout.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).copiedToClipboard)),
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
          future: () => room.client
              .setRoomStateWithKey(room.id, EventTypes.RoomCanonicalAlias, {
            'alias': select,
          }),
        );
        break;
    }
  }

  void setAliasAction() async {
    final room = Matrix.of(context).client.getRoomById(widget.roomId);
    final domain = room.client.userID.domain;

    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).setInvitationLink,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      useRootNavigator: false,
      textFields: [
        DialogTextField(
          prefixText: '#',
          suffixText: domain,
          hintText: L10n.of(context).alias,
          initialText: room.canonicalAlias?.localpart,
        )
      ],
    );
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () =>
          room.client.setRoomAlias('#' + input.single + ':' + domain, room.id),
    );
  }

  void setTopicAction() async {
    final room = Matrix.of(context).client.getRoomById(widget.roomId);
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).setGroupDescription,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      useRootNavigator: false,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).setGroupDescription,
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
      AdaptivePageLayout.of(context).showSnackBar(SnackBar(
          content: Text(L10n.of(context).groupDescriptionHasBeenChanged)));
    }
  }

  void setGuestAccessAction(GuestAccess guestAccess) => showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context)
            .client
            .getRoomById(widget.roomId)
            .setGuestAccess(guestAccess),
      );

  void setHistoryVisibilityAction(HistoryVisibility historyVisibility) =>
      showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context)
            .client
            .getRoomById(widget.roomId)
            .setHistoryVisibility(historyVisibility),
      );

  void setJoinRulesAction(JoinRules joinRule) => showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context)
            .client
            .getRoomById(widget.roomId)
            .setJoinRules(joinRule),
      );

  void goToEmoteSettings() async {
    final room = Matrix.of(context).client.getRoomById(widget.roomId);
    // okay, we need to test if there are any emote state events other than the default one
    // if so, we need to be directed to a selection screen for which pack we want to look at
    // otherwise, we just open the normal one.
    if ((room.states['im.ponies.room_emotes'] ?? <String, Event>{})
        .keys
        .any((String s) => s.isNotEmpty)) {
      await AdaptivePageLayout.of(context)
          .pushNamed('/rooms/${room.id}/emotes');
    } else {
      await AdaptivePageLayout.of(context)
          .pushNamed('/settings/emotes', arguments: {'room': room});
    }
  }

  void setAvatarAction() async {
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 1600,
          maxHeight: 1600);
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final result = await FilePickerCross.importFromStorage(
        type: FileTypeCross.image,
      );
      if (result == null) return;
      file = MatrixFile(
        bytes: result.toUint8List(),
        name: result.fileName,
      );
    }
    final room = Matrix.of(context).client.getRoomById(widget.roomId);

    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.setAvatar(file),
    );
    if (success.error == null) {
      AdaptivePageLayout.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).avatarHasBeenChanged)));
    }
  }

  void requestMoreMembersAction() async {
    final room = Matrix.of(context).client.getRoomById(widget.roomId);
    final participants = await showFutureLoadingDialog(
        context: context, future: () => room.requestParticipants());
    if (participants.error == null) {
      setState(() => members = participants.result);
    }
  }

  @override
  Widget build(BuildContext context) => ChatDetailsView(this);
}
