import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/pages/pangea_invitation_selection_view.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/join_rule_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum InvitationFilter {
  participants,
  space,
  contacts,
  knocking,
  invited,
  public;

  static InvitationFilter? fromString(String value) {
    switch (value) {
      case 'space':
        return InvitationFilter.space;
      case 'contacts':
        return InvitationFilter.contacts;
      case 'invited':
        return InvitationFilter.invited;
      case 'knocking':
        return InvitationFilter.knocking;
      case 'public':
        return InvitationFilter.public;
      case 'participants':
        return InvitationFilter.participants;
      default:
        return null;
    }
  }

  String get string {
    switch (this) {
      case InvitationFilter.space:
        return 'space';
      case InvitationFilter.contacts:
        return 'contacts';
      case InvitationFilter.invited:
        return 'invited';
      case InvitationFilter.knocking:
        return 'knocking';
      case InvitationFilter.public:
        return 'public';
      case InvitationFilter.participants:
        return 'participants';
    }
  }
}

class PangeaInvitationSelection extends StatefulWidget {
  final String roomId;
  final InvitationFilter? initialFilter;
  const PangeaInvitationSelection({
    super.key,
    required this.roomId,
    this.initialFilter,
  });

  @override
  PangeaInvitationSelectionController createState() =>
      PangeaInvitationSelectionController();
}

class PangeaInvitationSelectionController
    extends State<PangeaInvitationSelection> {
  TextEditingController controller = TextEditingController();

  bool loading = false;

  List<Profile> foundProfiles = [];
  Timer? coolDown;

  InvitationFilter filter = InvitationFilter.knocking;

  @override
  void initState() {
    super.initState();

    _room?.requestParticipants(
      [Membership.join, Membership.invite, Membership.knock],
      false,
      true,
    ).then((_) {
      if (mounted) setState(() {});
    });

    if (widget.initialFilter != null &&
        availableFilters.contains(widget.initialFilter)) {
      filter = widget.initialFilter!;
    } else if (spaceParent != null) {
      filter = InvitationFilter.space;
    } else if (_room?.getParticipants([Membership.knock]).isEmpty ?? true) {
      filter = InvitationFilter.contacts;
    }

    if (filter == InvitationFilter.public) {
      searchUser(context, controller.text);
    }

    controller.addListener(() {
      setState(() {});
    });

    _addJoinCode();
  }

  String filterLabel(InvitationFilter filter) {
    final l10n = L10n.of(context);
    switch (filter) {
      case InvitationFilter.space:
        return l10n.inThisSpace;
      case InvitationFilter.contacts:
        return l10n.myContacts;
      case InvitationFilter.invited:
        return l10n.numInvited(_room?.summary.mInvitedMemberCount ?? 0);
      case InvitationFilter.knocking:
        return l10n.numKnocking(
          participants?.where((u) => u.membership == Membership.knock).length ??
              0,
        );
      case InvitationFilter.public:
        return l10n.public;
      case InvitationFilter.participants:
        return l10n.participants;
    }
  }

  Room? get _room => Matrix.of(context).client.getRoomById(widget.roomId);

  Room? get spaceParent {
    final parents = _room?.pangeaSpaceParents;
    if (parents == null || parents.isEmpty) return null;
    return parents.first;
  }

  List<InvitationFilter> get availableFilters => InvitationFilter.values
      .where(
        (f) => switch (f) {
          InvitationFilter.space => spaceParent != null,
          InvitationFilter.contacts => true,
          InvitationFilter.invited => participants?.any(
                (u) => u.membership == Membership.invite,
              ) ??
              false,
          InvitationFilter.knocking => participants?.any(
                (u) => u.membership == Membership.knock,
              ) ??
              false,
          InvitationFilter.public => true,
          InvitationFilter.participants => true,
        },
      )
      .toList();

  List<User>? get participants {
    return _room?.getParticipants();
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

  void setFilter(InvitationFilter newFilter) {
    if (filter == newFilter) return;
    if (newFilter == InvitationFilter.public) {
      searchUser(context, controller.text);
    }
    setState(() => filter = newFilter);
  }

  List<User> filteredContacts() {
    List<User> contacts = [];
    switch (filter) {
      case InvitationFilter.space:
        contacts = spaceParent?.getParticipants() ?? [];
      case InvitationFilter.contacts:
        contacts = getContacts(context);
      case InvitationFilter.invited:
        contacts = participants
                ?.where(
                  (u) => u.membership == Membership.invite,
                )
                .toList() ??
            [];
      case InvitationFilter.knocking:
        contacts = participants
                ?.where(
                  (u) => u.membership == Membership.knock,
                )
                .toList() ??
            [];
      default:
        contacts = participants ?? [];
    }

    final search = controller.text.toLowerCase();
    contacts = contacts
        .where(
          (u) =>
              u.calcDisplayname().toLowerCase().contains(search) ||
              u.id.toLowerCase().contains(search),
        )
        .toList();

    contacts.removeWhere((u) => u.id == BotName.byEnvironment);
    contacts.sort(_sortUsers);
    return contacts;
  }

  List<User> getContacts(BuildContext context) {
    final client = Matrix.of(context).client;
    participants!.removeWhere(
      (u) => ![Membership.join, Membership.invite].contains(u.membership),
    );
    final contacts = client.rooms
        .where((r) => r.isDirectChat)
        .map((r) => r.unsafeGetUserFromMemoryOrFallback(r.directChatMatrixID!))
        .toList();
    contacts.sort(
      (a, b) => a.calcDisplayname().toLowerCase().compareTo(
            b.calcDisplayname().toLowerCase(),
          ),
    );
    return contacts;
  }

  void searchUserWithCoolDown(String text) async {
    if (filter != InvitationFilter.public) return;
    coolDown?.cancel();
    coolDown = Timer(
      const Duration(milliseconds: 500),
      () => searchUser(context, text),
    );
  }

  Future<void> _addJoinCode() async {
    if (_room == null || _room!.classCode != null) return;
    if (!_room!.canChangeStateEvent(EventTypes.RoomJoinRules)) return;

    try {
      await _room!.addJoinCode();
      if (mounted) setState(() {});
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {'roomId': _room!.id},
      );
    }
  }

  Future<void> searchUser(BuildContext context, String text) async {
    coolDown?.cancel();
    if (text.isEmpty) {
      setState(() => foundProfiles = []);
    }

    String pangeaSearchText = text;
    if (!pangeaSearchText.startsWith("@")) {
      pangeaSearchText = "@$pangeaSearchText";
    }
    if (!pangeaSearchText.contains(":")) {
      pangeaSearchText = "$pangeaSearchText:${Environment.homeServer}";
    }

    setState(() => loading = true);
    final matrix = Matrix.of(context);
    SearchUserDirectoryResponse response;
    try {
      response =
          await matrix.client.searchUserDirectory(pangeaSearchText, limit: 100);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((e).toLocalizedString(context))),
      );
      return;
    } finally {
      setState(() => loading = false);
    }

    final results = response.results;
    results.removeWhere((profile) => profile.userId == BotName.byEnvironment);

    setState(() {
      foundProfiles = List<Profile>.from(results);
      if (text.isValidMatrixId &&
          foundProfiles.indexWhere((profile) => text == profile.userId) == -1) {
        setState(
          () => foundProfiles = [
            Profile.fromJson({'user_id': text}),
          ],
        );
      }

      final participants = this
          .participants
          ?.where(
            (user) =>
                [Membership.join, Membership.invite].contains(user.membership),
          )
          .toList();

      foundProfiles.removeWhere(
        (profile) =>
            participants?.indexWhere((u) => u.id == profile.userId) != -1 ||
            BotName.byEnvironment == profile.userId,
      );
    });
  }

  void inviteAction(String userID) async {
    final room = Matrix.of(context).client.getRoomById(widget.roomId)!;

    final success = await showFutureLoadingDialog(
      context: context,
      future: () async {
        await room.invite(userID);
        if (room.courseParent != null && room.courseParent!.canInvite) {
          await room.courseParent!.requestParticipants(
            [Membership.join, Membership.invite],
            false,
            true,
          );

          final existingParticipant = room.courseParent!
              .getParticipants()
              .firstWhereOrNull((u) => u.id == userID);

          if (existingParticipant == null ||
              ![
                Membership.invite,
                Membership.join,
              ].contains(existingParticipant.membership)) {
            await room.courseParent!.invite(userID);
          }
        }
      },
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).contactHasBeenInvitedToTheChat),
        ),
      );
    }
  }

  Future<void> inviteAllInSpace() async {
    if (_room == null) return;
    final spaceParticipants = spaceParent?.getParticipants() ?? [];

    if (spaceParticipants.isEmpty) return;

    final List<Future> futures = [];
    for (final user in spaceParticipants) {
      if (participants?.any((u) => u.id == user.id) ?? false) {
        // User is already in the room
        continue;
      }

      if (user.id == Matrix.of(context).client.userID) continue;
      futures.add(_room!.invite(user.id));
    }

    await showFutureLoadingDialog(
      context: context,
      future: () async {
        await Future.wait(futures);
        return null; // No error
      },
    ).then((result) {
      if (result.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              L10n.of(context).spaceParticipantsHaveBeenInvitedToTheChat,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error.toString())),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => PangeaInvitationSelectionView(this);
}
