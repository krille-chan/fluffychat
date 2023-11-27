// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'error_handler.dart';

// ignore: curly_braces_in_flow_control_structures
void chatListHandleSpaceTap(
  BuildContext context,
  ChatListController controller,
  Room space,
) {
  void setActiveSpaceAndCloseChat() {
    controller.setActiveSpace(space.id);
    if (controller.activeChat != null &&
        !space.isFirstOrSecondChild(controller.activeChat!)) {
      context.go("/rooms");
    }
  }

  void autoJoin(Room space) {
    showFutureLoadingDialog(
      context: context,
      future: () async {
        await space.join();
        await space.postLoad();
        setActiveSpaceAndCloseChat();
      },
      onError: (exception) {
        ErrorHandler.logError(e: exception);
        return exception.toString();
      },
    );
  }

  //show alert dialog prompting user to accept invite or reject
  //if accepted, setActiveSpaceAndCloseChat()
  //if rejected, leave space
  // use standard alert diolog, not cupertino
  void showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      title: Text(L10n.of(context)!.youreInvited),
      content: Text(
        space.isSpace
            ? L10n.of(context)!
                .invitedToClassOrExchange(space.name, space.creatorId ?? "???")
            : L10n.of(context)!
                .invitedToChat(space.name, space.creatorId ?? "???"),
      ),
      actions: [
        TextButton(
          onPressed: () => showFutureLoadingDialog(
            context: context,
            future: () async {
              await space.leave();
              //show snackbar message that you've left
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(L10n.of(context)!.declinedInvitation),
                  duration: const Duration(seconds: 3),
                ),
              );
              Navigator.of(context).pop();
            },
            onError: (exception) {
              ErrorHandler.logError(e: exception);
              Navigator.of(context).pop();
              return exception.toString();
            },
          ),
          child: Text(L10n.of(context)!.decline),
        ),
        TextButton(
          onPressed: () => showFutureLoadingDialog(
            context: context,
            future: () async {
              await space.join();
              setActiveSpaceAndCloseChat();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(L10n.of(context)!.acceptedInvitation),
                  duration: const Duration(seconds: 3),
                ),
              );
              context.go(
                '/rooms/join_exchange/${controller.activeSpaceId}',
              );
            },
            onError: (exception) {
              ErrorHandler.logError(e: exception);
              Navigator.of(context).pop();
              return exception.toString();
            },
          ),
          child: Text(L10n.of(context)!.accept),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  switch (space.membership) {
    case Membership.join:
      setActiveSpaceAndCloseChat();
      break;
    case Membership.invite:
      //if space is a child of a space you're in, automatically join
      //else confirm you want to join
      //can we tell whether space or chat?
      final rooms = Matrix.of(context).client.rooms.where(
            (element) =>
                element.isSpace && element.membership == Membership.join,
          );
      if (rooms.any((s) => s.spaceChildren.any((c) => c.roomId == space.id))) {
        autoJoin(space);
      } else {
        showAlertDialog(context);
      }
      break;
    default:
      setActiveSpaceAndCloseChat();
      ErrorHandler.logError(
        m: 'should not show space with membership ${space.membership}',
        data: space.toJson(),
      );
      break;
  }
}
