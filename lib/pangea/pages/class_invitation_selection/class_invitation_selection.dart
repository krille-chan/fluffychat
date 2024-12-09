import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

class ClassInvitationSelection extends StatefulWidget {
  const ClassInvitationSelection({super.key});

  @override
  ClassInvitationSelectionController createState() =>
      ClassInvitationSelectionController();
}

class ClassInvitationSelectionController
    extends State<ClassInvitationSelection> {
  TextEditingController controller = TextEditingController();
  late String currentSearchTerm;
  bool loading = true;
  List<User> allClassParticipants = [];
  List<User> allChatParticipants = [];
  List<User> classParticipantsFilteredByChat = [];

  ///Class participants filtered by chat participants and any search query
  List<User> foundProfiles = [];

  Timer? coolDown;

  String? get roomId => GoRouterState.of(context).pathParameters['roomid'];

  StreamSubscription<SyncUpdate>? _spaceSubscription;

  void inviteAction(BuildContext context, String id) async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    if (OkCancelResult.ok !=
        await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).inviteContactToGroup(room.name),
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
        )) {
      return;
    }
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => room.invite(id),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // #Pangea
          // content: Text(L10n.of(context).contactHasBeenInvitedToTheGroup),
          content: Text(L10n.of(context).contactHasBeenInvitedToTheChat),
          // Pangea#
        ),
      );
    }
  }

  void setDisplayListWithCoolDown(String text) {
    coolDown?.cancel();
    coolDown = Timer(
      const Duration(milliseconds: 0),
      () => _setfoundProfiles(context, text),
    );
  }

  void _setfoundProfiles(BuildContext context, String text) {
    coolDown?.cancel();
    // debugger(when: kDebugMode);
    allClassParticipants = getClassParticipants(context);
    allChatParticipants = getChatParticipants(context);
    classParticipantsFilteredByChat = getClassParticipantsFilteredByChat();

    currentSearchTerm = text;

    foundProfiles = currentSearchTerm.isNotEmpty
        ? classParticipantsFilteredByChat
            .where(
              (user) =>
                  user.displayName?.contains(text) ??
                  false || user.id.contains(text),
            )
            .toList()
        : classParticipantsFilteredByChat;

    setState(() => loading = false);
  }

  Room? _getParentClass(BuildContext context) => Matrix.of(context)
      .client
      .rooms
      .where(
        (r) => r.isSpace,
      )
      .firstWhereOrNull(
        (space) => space.spaceChildren.any(
          (ithroom) => ithroom.roomId == roomId,
        ),
      );

  List<User> getClassParticipants(BuildContext context) {
    final Room? parent = _getParentClass(context);
    if (parent == null) return [];

    final List<User> classParticipants =
        parent.getParticipants([Membership.join]);
    return classParticipants;
  }

  List<User> getChatParticipants(BuildContext context) => Matrix.of(context)
      .client
      .getRoomById(roomId!)!
      .getParticipants([Membership.join, Membership.invite]).toList();

  List<User> getClassParticipantsFilteredByChat() => allClassParticipants
      .where(
        (profile) =>
            allChatParticipants.indexWhere((u) => u.id == profile.id) == -1,
      )
      .toList();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final Room? classParent = _getParentClass(context);
      await classParent
          ?.requestParticipants([Membership.join, Membership.invite]);
      _setfoundProfiles(context, "");
      _spaceSubscription = Matrix.of(context)
          .client
          .onSync
          .stream
          .where(
            (event) =>
                event.rooms?.join?.keys
                    .any((ithRoomId) => ithRoomId == classParent?.id) ??
                false,
          )
          .listen(
        (SyncUpdate syncUpdate) async {
          debugPrint("updating lists");
          await classParent
              ?.requestParticipants([Membership.join, Membership.invite]);
          setState(() {});
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _spaceSubscription?.cancel();
    super.dispose();
  }

  @override
  // Widget build(BuildContext context) => InvitationSelectionView(this);
  Widget build(BuildContext context) => const SizedBox();
}
