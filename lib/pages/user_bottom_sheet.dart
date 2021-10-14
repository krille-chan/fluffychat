import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:matrix/matrix.dart';
import 'package:fluffychat/pages/permission_slider_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:vrouter/vrouter.dart';

import 'views/user_bottom_sheet_view.dart';

class UserBottomSheet extends StatefulWidget {
  final User user;
  final Function onMention;
  final BuildContext outerContext;

  const UserBottomSheet({
    Key key,
    @required this.user,
    @required this.outerContext,
    this.onMention,
  }) : super(key: key);

  @override
  UserBottomSheetController createState() => UserBottomSheetController();
}

class UserBottomSheetController extends State<UserBottomSheet> {
  void participantAction(String action) async {
    // ignore: prefer_function_declarations_over_variables
    final Function _askConfirmation =
        () async => (await showOkCancelAlertDialog(
              useRootNavigator: false,
              context: context,
              title: L10n.of(context).areYouSure,
              okLabel: L10n.of(context).yes,
              cancelLabel: L10n.of(context).no,
            ) ==
            OkCancelResult.ok);
    switch (action) {
      case 'mention':
        Navigator.of(context, rootNavigator: false).pop();
        widget.onMention();
        break;
      case 'ban':
        if (await _askConfirmation()) {
          await showFutureLoadingDialog(
            context: context,
            future: () => widget.user.ban(),
          );
          Navigator.of(context, rootNavigator: false).pop();
        }
        break;
      case 'unban':
        if (await _askConfirmation()) {
          await showFutureLoadingDialog(
            context: context,
            future: () => widget.user.unban(),
          );
          Navigator.of(context, rootNavigator: false).pop();
        }
        break;
      case 'kick':
        if (await _askConfirmation()) {
          await showFutureLoadingDialog(
            context: context,
            future: () => widget.user.kick(),
          );
          Navigator.of(context, rootNavigator: false).pop();
        }
        break;
      case 'permission':
        final newPermission = await PermissionSliderDialog(
                initialPermission: widget.user.powerLevel)
            .show(context);
        if (newPermission != null) {
          if (newPermission == 100 && await _askConfirmation() == false) break;
          await showFutureLoadingDialog(
            context: context,
            future: () => widget.user.setPower(newPermission),
          );
          Navigator.of(context, rootNavigator: false).pop();
        }
        break;
      case 'message':
        final roomIdResult = await showFutureLoadingDialog(
          context: context,
          future: () => widget.user.startDirectChat(),
        );
        if (roomIdResult.error != null) return;
        VRouter.of(widget.outerContext)
            .toSegments(['rooms', roomIdResult.result]);
        Navigator.of(context, rootNavigator: false).pop();
        break;
    }
  }

  @override
  Widget build(BuildContext context) => UserBottomSheetView(this);
}
