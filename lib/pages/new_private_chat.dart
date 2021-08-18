import 'dart:async';

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
  String currentSearchTerm;
  List<Profile> foundProfiles = [];
  Timer coolDown;
  Profile get foundProfile =>
      foundProfiles.firstWhere((user) => user.userId == '@$currentSearchTerm',
          orElse: () => null);
  bool get correctMxId =>
      foundProfiles
          .indexWhere((user) => user.userId == '@$currentSearchTerm') !=
      -1;

  void submitAction([_]) async {
    controller.text = controller.text.replaceAll('@', '').trim();
    if (controller.text.isEmpty) return;
    if (!formKey.currentState.validate()) return;
    final matrix = Matrix.of(context);

    if ('@' + controller.text == matrix.client.userID) return;

    final user = User(
      '@' + controller.text,
      room: Room(id: '', client: matrix.client),
    );
    final roomID = await showFutureLoadingDialog(
      context: context,
      future: () => user.startDirectChat(),
    );

    if (roomID.error == null) {
      VRouter.of(context).to('/rooms/${roomID.result}');
    }
  }

  void searchUserWithCoolDown([_]) async {
    coolDown?.cancel();
    coolDown = Timer(
      Duration(milliseconds: 500),
      () => searchUser(controller.text),
    );
  }

  void searchUser(String text) async {
    if (text.isEmpty) {
      setState(() {
        foundProfiles = [];
      });
    }
    currentSearchTerm = text;
    if (currentSearchTerm.isEmpty) return;
    if (loading) return;
    setState(() => loading = true);
    final matrix = Matrix.of(context);
    SearchUserDirectoryResponse response;
    try {
      response = await matrix.client.searchUserDirectory(text, limit: 10);
    } catch (_) {}
    setState(() => loading = false);
    if (response?.results?.isEmpty ?? true) return;
    setState(() {
      foundProfiles = List<Profile>.from(response.results);
    });
  }

  String validateForm(String value) {
    if (value.isEmpty) {
      return L10n.of(context).pleaseEnterAMatrixIdentifier;
    }
    final matrix = Matrix.of(context);
    final mxid = '@' + controller.text.trim();
    if (mxid == matrix.client.userID) {
      return L10n.of(context).youCannotInviteYourself;
    }
    if (!mxid.contains('@')) {
      return L10n.of(context).makeSureTheIdentifierIsValid;
    }
    if (!mxid.contains(':')) {
      return L10n.of(context).makeSureTheIdentifierIsValid;
    }
    return null;
  }

  void inviteAction() => FluffyShare.share(
        L10n.of(context).inviteText(Matrix.of(context).client.userID,
            'https://matrix.to/#/${Matrix.of(context).client.userID}'),
        context,
      );

  void pickUser(Profile foundProfile) => setState(
        () => controller.text =
            currentSearchTerm = foundProfile.userId.substring(1),
      );

  @override
  Widget build(BuildContext context) => NewPrivateChatView(this);
}
