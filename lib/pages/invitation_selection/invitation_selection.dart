import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/invitation_selection/invitation_selection_view.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/localized_exception_extension.dart';

class InvitationSelection extends StatefulWidget {
  final String roomId;
  const InvitationSelection({
    super.key,
    required this.roomId,
  });

  @override
  InvitationSelectionController createState() =>
      InvitationSelectionController();
}

class InvitationSelectionController extends State<InvitationSelection> {
  TextEditingController controller = TextEditingController();
  late String currentSearchTerm;
  bool loading = false;
  List<Profile> foundProfiles = [];
  Timer? coolDown;

  String? get roomId => widget.roomId;

  // #Pangea
  List<User>? get participants {
    final room = Matrix.of(context).client.getRoomById(roomId!);
    return room?.getParticipants();
  }

  List<Membership> get _membershipOrder => [
        Membership.join,
        Membership.invite,
        Membership.knock,
        Membership.leave,
        Membership.ban,
      ];

  String? membershipCopy(Membership? membership) => switch (membership) {
        Membership.ban => L10n.of(context).banned,
        Membership.invite => L10n.of(context).invited,
        Membership.join => null,
        Membership.knock => L10n.of(context).knocking,
        Membership.leave => L10n.of(context).leftTheChat,
        null => null,
      };

  int _sortUsers(User a, User b) {
    // sort yourself to the top
    final client = Matrix.of(context).client;
    if (a.id == client.userID) return -1;
    if (b.id == client.userID) return 1;

    // sort the bot to the bottom
    if (a.id == BotName.byEnvironment) return 1;
    if (b.id == BotName.byEnvironment) return -1;

    if (participants != null) {
      final participantA = participants!.firstWhereOrNull((u) => u.id == a.id);
      final participantB = participants!.firstWhereOrNull((u) => u.id == b.id);
      // sort all participants first, with admins first, then moderators, then the rest
      if (participantA?.membership == null &&
          participantB?.membership != null) {
        return 1;
      }
      if (participantA?.membership != null &&
          participantB?.membership == null) {
        return -1;
      }
      if (participantA?.membership != null &&
          participantB?.membership != null) {
        final aIndex = _membershipOrder.indexOf(participantA!.membership);
        final bIndex = _membershipOrder.indexOf(participantB!.membership);
        if (aIndex != bIndex) {
          return aIndex.compareTo(bIndex);
        }
      }
    }

    // finally, sort by displayname
    final aName = a.calcDisplayname().toLowerCase();
    final bName = b.calcDisplayname().toLowerCase();
    return aName.compareTo(bName);
  }
  // Pangea#

  Future<List<User>> getContacts(BuildContext context) async {
    final client = Matrix.of(context).client;
    final room = client.getRoomById(roomId!)!;

    final participants = (room.summary.mJoinedMemberCount ?? 0) > 100
        ? room.getParticipants()
        // #Pangea
        // : await room.requestParticipants();
        : await room.requestParticipants(
            [Membership.join, Membership.invite, Membership.knock],
            false,
            true,
          );
    // Pangea#
    participants.removeWhere(
      (u) => ![Membership.join, Membership.invite].contains(u.membership),
    );
    final contacts = client.rooms
        .where((r) => r.isDirectChat)
        // #Pangea
        // .map((r) => r.unsafeGetUserFromMemoryOrFallback(r.directChatMatrixID!))
        .map(
          (r) => r
              .getParticipants()
              .firstWhereOrNull((u) => u.id != client.userID),
        )
        .where((u) => u != null)
        .cast<User>()
        // Pangea#
        .toList();
    // #Pangea
    final mutuals = client.rooms
        .where((r) => r.isSpace)
        .map((r) => r.getParticipants())
        .expand((element) => element)
        .toList();

    for (final user in mutuals) {
      final index = contacts.indexWhere((u) => u.id == user.id);
      if (index == -1) {
        contacts.add(user);
      }
    }

    contacts.sort(_sortUsers);
    return contacts;
    // contacts.sort(
    //   (a, b) => a.calcDisplayname().toLowerCase().compareTo(
    //         b.calcDisplayname().toLowerCase(),
    //       ),
    // );
    // return contacts;
    //Pangea#
  }

  void inviteAction(BuildContext context, String id, String displayname) async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;

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

  void searchUserWithCoolDown(String text) async {
    coolDown?.cancel();
    coolDown = Timer(
      const Duration(milliseconds: 500),
      () => searchUser(context, text),
    );
  }

  void searchUser(BuildContext context, String text) async {
    coolDown?.cancel();
    if (text.isEmpty) {
      setState(() => foundProfiles = []);
    }
    currentSearchTerm = text;
    if (currentSearchTerm.isEmpty) return;
    //#Pangea
    String pangeaSearchText = text;
    if (!pangeaSearchText.startsWith("@")) {
      pangeaSearchText = "@$pangeaSearchText";
    }
    if (!pangeaSearchText.contains(":")) {
      pangeaSearchText = "$pangeaSearchText:${Environment.homeServer}";
    }
    //#Pangea
    if (loading) return;
    setState(() => loading = true);
    final matrix = Matrix.of(context);
    SearchUserDirectoryResponse response;
    try {
      // response = await matrix.client.searchUserDirectory(text, limit: 10);
      //#Pangea
      response =
          await matrix.client.searchUserDirectory(pangeaSearchText, limit: 10);
      //#Pangea
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((e).toLocalizedString(context))),
      );
      return;
    } finally {
      setState(() => loading = false);
    }
    setState(() {
      foundProfiles = List<Profile>.from(response.results);
      if (text.isValidMatrixId &&
          foundProfiles.indexWhere((profile) => text == profile.userId) == -1) {
        setState(
          () => foundProfiles = [
            Profile.fromJson({'user_id': text}),
          ],
        );
      }
      //#Pangea
      final participants = Matrix.of(context)
          .client
          .getRoomById(roomId!)
          ?.getParticipants()
          .where(
            (user) =>
                [Membership.join, Membership.invite].contains(user.membership),
          )
          .toList();
      foundProfiles.removeWhere(
        (profile) =>
            participants?.indexWhere((u) => u.id == profile.userId) != -1 &&
            BotName.byEnvironment != profile.userId,
      );
      //Pangea#
    });
  }

  @override
  Widget build(BuildContext context) => InvitationSelectionView(this);
}
