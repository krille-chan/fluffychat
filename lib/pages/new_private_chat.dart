import 'package:fluffychat/pages/qr_scanner_modal.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/pages/views/new_private_chat_view.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

class NewPrivateChat extends StatefulWidget {
  @override
  NewPrivateChatController createState() => NewPrivateChatController();
}

class NewPrivateChatController extends State<NewPrivateChat> {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  static const Set<String> supportedSigils = {'@', '!', '#'};

  void submitAction([_]) async {
    controller.text = controller.text.trim();
    if (!formKey.currentState.validate()) return;
    final client = Matrix.of(context).client;

    LoadingDialogResult roomIdResult;

    switch (controller.text.sigil) {
      case '@':
        roomIdResult = await showFutureLoadingDialog(
          context: context,
          future: () => client.startDirectChat(controller.text),
        );
        break;
      case '#':
      case '!':
        roomIdResult = await showFutureLoadingDialog(
          context: context,
          future: () async {
            final roomId = await client.joinRoom(controller.text);
            if (client.getRoomById(roomId) == null) {
              await client.onSync.stream
                  .where((s) => s.rooms.join.containsKey(roomId))
                  .first;
            }
            return roomId;
          },
        );
        break;
    }

    if (roomIdResult.error == null) {
      VRouter.of(context).toSegments(['rooms', roomIdResult.result]);
    }
  }

  String validateForm(String value) {
    if (value.isEmpty) {
      return L10n.of(context).pleaseEnterAMatrixIdentifier;
    }
    if (!controller.text.isValidMatrixId ||
        !supportedSigils.contains(controller.text.sigil)) {
      return L10n.of(context).makeSureTheIdentifierIsValid;
    }
    if (controller.text == Matrix.of(context).client.userID) {
      return L10n.of(context).youCannotInviteYourself;
    }
    return null;
  }

  void inviteAction() => FluffyShare.share(
        'https://matrix.to/#/${Matrix.of(context).client.userID}',
        context,
      );

  void openScannerAction() => showDialog(
        context: context,
        builder: (_) => QrScannerModal(),
      );

  @override
  Widget build(BuildContext context) => NewPrivateChatView(this);
}
