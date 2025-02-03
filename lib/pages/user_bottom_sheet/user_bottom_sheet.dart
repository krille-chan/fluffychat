import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/permission_slider_dialog.dart';
import '../../widgets/matrix.dart';
import 'user_bottom_sheet_view.dart';

enum UserBottomSheetAction {
  // #Pangea
  // report,
  // Pangea#
  mention,
  ban,
  kick,
  unban,
  message,
  ignore,
}

class LoadProfileBottomSheet extends StatelessWidget {
  final String userId;
  final BuildContext outerContext;

  const LoadProfileBottomSheet({
    super.key,
    required this.userId,
    required this.outerContext,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileInformation>(
      future: Matrix.of(outerContext)
          .client
          .getUserProfile(userId)
          .timeout(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done &&
            snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              leading: CloseButton(
                onPressed: Navigator.of(context, rootNavigator: false).pop,
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        return UserBottomSheet(
          outerContext: outerContext,
          profile: Profile(
            userId: userId,
            avatarUrl: snapshot.data?.avatarUrl,
            displayName: snapshot.data?.displayname,
          ),
          profileSearchError: snapshot.error,
        );
      },
    );
  }
}

class UserBottomSheet extends StatefulWidget {
  final User? user;
  final Profile? profile;
  final Function? onMention;
  final BuildContext outerContext;
  final Object? profileSearchError;

  const UserBottomSheet({
    super.key,
    this.user,
    this.profile,
    required this.outerContext,
    this.onMention,
    this.profileSearchError,
  }) : assert(user != null || profile != null);

  @override
  UserBottomSheetController createState() => UserBottomSheetController();
}

class UserBottomSheetController extends State<UserBottomSheet> {
  void participantAction(UserBottomSheetAction action) async {
    final user = widget.user;
    final userId = user?.id ?? widget.profile?.userId;
    if (userId == null) throw ('user or profile must not be null!');

    switch (action) {
      // #Pangea
      // case UserBottomSheetAction.report:
      //   if (user == null) throw ('User must not be null for this action!');

      //   final score = await showModalActionPopup<int>(
      //     context: context,
      //     title: L10n.of(context).reportUser,
      //     message: L10n.of(context).howOffensiveIsThisContent,
      //     cancelLabel: L10n.of(context).cancel,
      //     actions: [
      //       AdaptiveModalAction(
      //         value: -100,
      //         label: L10n.of(context).extremeOffensive,
      //       ),
      //       AdaptiveModalAction(
      //         value: -50,
      //         label: L10n.of(context).offensive,
      //       ),
      //       AdaptiveModalAction(
      //         value: 0,
      //         label: L10n.of(context).inoffensive,
      //       ),
      //     ],
      //   );
      //   if (score == null) return;
      //   final reason = await showTextInputDialog(
      //     useRootNavigator: false,
      //     context: context,
      //     title: L10n.of(context).whyDoYouWantToReportThis,
      //     okLabel: L10n.of(context).ok,
      //     cancelLabel: L10n.of(context).cancel,
      //     hintText: L10n.of(context).reason,
      //   );
      //   if (reason == null || reason.isEmpty) return;

      //   final result = await showFutureLoadingDialog(
      //     context: context,
      //     future: () => Matrix.of(widget.outerContext).client.reportEvent(
      //           user.room.id,
      //           user.id,
      //           reason: reason,
      //           score: score,
      //         ),
      //   );
      //   if (result.error != null) return;
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(L10n.of(context).contentHasBeenReported)),
      //   );
      //   break;
      // Pangea#
      case UserBottomSheetAction.mention:
        if (user == null) throw ('User must not be null for this action!');
        Navigator.of(context).pop();
        widget.onMention!();
        break;
      case UserBottomSheetAction.ban:
        if (user == null) throw ('User must not be null for this action!');
        if (await showOkCancelAlertDialog(
              useRootNavigator: false,
              context: context,
              title: L10n.of(context).areYouSure,
              okLabel: L10n.of(context).yes,
              cancelLabel: L10n.of(context).no,
              message: L10n.of(context).banUserDescription,
            ) ==
            OkCancelResult.ok) {
          await showFutureLoadingDialog(
            context: context,
            future: () => user.ban(),
          );
          Navigator.of(context).pop();
        }
        break;
      case UserBottomSheetAction.unban:
        if (user == null) throw ('User must not be null for this action!');
        if (await showOkCancelAlertDialog(
              useRootNavigator: false,
              context: context,
              title: L10n.of(context).areYouSure,
              okLabel: L10n.of(context).yes,
              cancelLabel: L10n.of(context).no,
              message: L10n.of(context).unbanUserDescription,
            ) ==
            OkCancelResult.ok) {
          await showFutureLoadingDialog(
            context: context,
            future: () => user.unban(),
          );
          Navigator.of(context).pop();
        }
        break;
      case UserBottomSheetAction.kick:
        if (user == null) throw ('User must not be null for this action!');
        if (await showOkCancelAlertDialog(
              useRootNavigator: false,
              context: context,
              title: L10n.of(context).areYouSure,
              okLabel: L10n.of(context).yes,
              cancelLabel: L10n.of(context).no,
              // #Pangea
              // message: L10n.of(context).kickUserDescription,
              message: user.id == BotName.byEnvironment &&
                      !user.room.isSpace &&
                      !user.room.isDirectChat
                  ? L10n.of(context).kickBotWarning
                  : L10n.of(context).kickUserDescription,
              // Pangea#
            ) ==
            OkCancelResult.ok) {
          await showFutureLoadingDialog(
            context: context,
            future: () => user.kick(),
          );
          Navigator.of(context).pop();
        }
        break;
      case UserBottomSheetAction.message:
        Navigator.of(context).pop();
        // Workaround for https://github.com/flutter/flutter/issues/27495
        await Future.delayed(FluffyThemes.animationDuration);

        final roomIdResult = await showFutureLoadingDialog(
          context: widget.outerContext,
          future: () => Matrix.of(widget.outerContext).client.startDirectChat(
                user?.id ?? widget.profile!.userId,
                // #Pangea
                enableEncryption: false,
                // Pangea#
              ),
        );
        final roomId = roomIdResult.result;
        if (roomId == null) return;
        widget.outerContext.go('/rooms/$roomId');
        break;
      case UserBottomSheetAction.ignore:
        Navigator.of(context).pop();
        // Workaround for https://github.com/flutter/flutter/issues/27495
        await Future.delayed(FluffyThemes.animationDuration);
        final userId = user?.id ?? widget.profile?.userId;
        widget.outerContext
            .go('/rooms/settings/security/ignorelist', extra: userId);
    }
  }

  Object? sendError;

  final TextEditingController sendController = TextEditingController();

  void knockAccept() async {
    final user = widget.user!;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => user.room.invite(user.id),
    );
    if (result.error != null) return;
    Navigator.of(context).pop();
  }

  void knockDecline() async {
    final user = widget.user!;
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => user.room.kick(user.id),
    );
    if (result.error != null) return;
    Navigator.of(context).pop();
  }

  void setPowerLevel(int? newLevel) async {
    final user = widget.user;
    if (user == null) throw ('User must not be null for this action!');

    final level = newLevel ??
        await showPermissionChooser(
          context,
          currentLevel: user.powerLevel,
        );
    if (level == null) return;

    if (level == 100) {
      final consent = await showOkCancelAlertDialog(
        useRootNavigator: false,
        context: context,
        title: L10n.of(context).areYouSure,
        okLabel: L10n.of(context).yes,
        cancelLabel: L10n.of(context).no,
        message: L10n.of(context).makeAdminDescription,
      );
      if (consent != OkCancelResult.ok) return;
    }

    await showFutureLoadingDialog(
      context: context,
      future: () => user.setPower(level),
    );
  }

  @override
  Widget build(BuildContext context) => UserBottomSheetView(this);
}
