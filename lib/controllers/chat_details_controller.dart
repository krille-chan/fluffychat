import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';

import 'package:famedlysdk/famedlysdk.dart';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/views/chat_details.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';

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

  void setCanonicalAliasAction(context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).setInvitationLink,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      useRootNavigator: false,
      textFields: [
        DialogTextField(
          hintText: '#localpart:domain',
          initialText: L10n.of(context).alias.toLowerCase(),
        )
      ],
    );
    if (input == null) return;
    final room = Matrix.of(context).client.getRoomById(widget.roomId);
    final domain = room.client.userID.domain;
    final canonicalAlias = '%23' + input.single + '%3A' + domain;
    final aliasEvent = room.getState('m.room.aliases', domain);
    final aliases =
        aliasEvent != null ? aliasEvent.content['aliases'] ?? [] : [];
    if (aliases.indexWhere((s) => s == canonicalAlias) == -1) {
      final newAliases = List<String>.from(aliases);
      newAliases.add(canonicalAlias);
      final response = await showFutureLoadingDialog(
        context: context,
        future: () => room.client.requestRoomAliasInformation(canonicalAlias),
      );
      if (response.error != null) {
        final success = await showFutureLoadingDialog(
          context: context,
          future: () => room.client.createRoomAlias(canonicalAlias, room.id),
        );
        if (success.error != null) return;
      }
    }
    await showFutureLoadingDialog(
      context: context,
      future: () => room.client.sendState(room.id, 'm.room.canonical_alias', {
        'alias': input.single,
      }),
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
