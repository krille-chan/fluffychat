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

  Future<List<User>> getContacts(BuildContext context) async {
    final client = Matrix.of(context).client;
    final room = client.getRoomById(roomId!)!;

    final participants = (room.summary.mJoinedMemberCount ?? 0) > 100
        ? room.getParticipants()
        : await room.requestParticipants();
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
        // Pangea#
        .toList();
    // #Pangea
    contacts.removeWhere((u) => u == null || u.id != BotName.byEnvironment);
    contacts.sort(
      (a, b) => a!.calcDisplayname().toLowerCase().compareTo(
            b!.calcDisplayname().toLowerCase(),
          ),
    );
    return contacts.cast<User>();
    // contacts.sort(
    //   (a, b) => a.calcDisplayname().toLowerCase().compareTo(
    //         b.calcDisplayname().toLowerCase(),
    //       ),
    // );
    // return contacts;
    //Pangea#
  }

  //#Pangea
  // // add all students (already local) from spaceParents who aren't already in room to eligibleStudents
  // // use room.members to get all users in room
  // bool _initialized = false;
  // Future<List<User>> eligibleStudents(
  //   BuildContext context,
  //   String text,
  // ) async {
  //   if (!_initialized) {
  //     _initialized = true;
  //     await requestParentSpaceParticipants();
  //   }

  //   final eligibleStudents = <User>[];
  //   final spaceParents = room?.pangeaSpaceParents;
  //   if (spaceParents == null) return eligibleStudents;

  //   final userId = Matrix.of(context).client.userID;
  //   for (final Room space in spaceParents) {
  //     eligibleStudents.addAll(
  //       space.getParticipants().where(
  //             (spaceUser) =>
  //                 spaceUser.id != BotName.byEnvironment &&
  //                 spaceUser.id != "@support:staging.pangea.chat" &&
  //                 spaceUser.id != userId &&
  //                 (text.isEmpty ||
  //                     (spaceUser.displayName
  //                             ?.toLowerCase()
  //                             .contains(text.toLowerCase()) ??
  //                         false) ||
  //                     spaceUser.id.toLowerCase().contains(text.toLowerCase())),
  //           ),
  //     );
  //   }
  //   return eligibleStudents;
  // }

  // Future<SearchUserDirectoryResponse>
  //     eligibleStudentsAsSearchUserDirectoryResponse(
  //   BuildContext context,
  //   String text,
  // ) async {
  //   return SearchUserDirectoryResponse(
  //     results: (await eligibleStudents(context, text))
  //         .map(
  //           (e) => Profile(
  //             userId: e.id,
  //             avatarUrl: e.avatarUrl,
  //             displayName: e.displayName,
  //           ),
  //         )
  //         .toList(),
  //     limited: false,
  //   );
  // }

  // List<User?> studentsInRoom(BuildContext context) =>
  //     room
  //         ?.getParticipants()
  //         .where(
  //           (u) => [Membership.join, Membership.invite].contains(u.membership),
  //         )
  //         .toList() ??
  //     <User>[];
  //Pangea#

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
