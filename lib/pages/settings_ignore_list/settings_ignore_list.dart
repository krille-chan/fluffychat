import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import '../../widgets/matrix.dart';
import 'settings_ignore_list_view.dart';

class SettingsIgnoreList extends StatefulWidget {
  final String? initialUserId;

  const SettingsIgnoreList({super.key, this.initialUserId});

  @override
  SettingsIgnoreListController createState() => SettingsIgnoreListController();
}

class SettingsIgnoreListController extends State<SettingsIgnoreList> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialUserId = widget.initialUserId;
    if (initialUserId != null) {
      controller.text = initialUserId;
    }
  }

  String? errorText;

  void ignoreUser(BuildContext context) {
    final userId = controller.text.trim();
    if (userId.isEmpty) return;
    if (!userId.isValidMatrixId || userId.sigil != '@') {
      setState(() {
        errorText = L10n.of(context).invalidInput;
      });
      return;
    }
    setState(() {
      errorText = null;
    });

    final client = Matrix.of(context).client;
    showFutureLoadingDialog(
      context: context,
      future: () async {
        for (final room in client.rooms) {
          final isInviteFromUser = room.membership == Membership.invite &&
              room.getState(EventTypes.RoomMember, client.userID!)?.senderId ==
                  userId;

          if (room.directChatMatrixID == userId || isInviteFromUser) {
            try {
              await room.leave();
            } catch (e, s) {
              Logs().w('Unable to leave room with blocked user $userId', e, s);
            }
          }
        }
        await client.ignoreUser(userId);
      },
    );
    setState(() {});
    controller.clear();
  }

  @override
  Widget build(BuildContext context) => SettingsIgnoreListView(this);
}
