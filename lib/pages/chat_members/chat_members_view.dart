import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import '../../widgets/layouts/max_width_body.dart';
import '../../widgets/matrix.dart';
import '../chat_details/participant_list_item.dart';
import 'chat_members.dart';

class ChatMembersView extends StatelessWidget {
  final ChatMembersController controller;

  const ChatMembersView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final room =
        Matrix.of(context).client.getRoomById(controller.widget.roomId);
    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }

    final members = controller.filteredMembers;

    final roomCount = (room.summary.mJoinedMemberCount ?? 0) +
        (room.summary.mInvitedMemberCount ?? 0);

    final error = controller.error;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(
          L10n.of(context).countParticipants(roomCount),
        ),
        actions: [
          if (room.canInvite)
            IconButton(
              onPressed: () => context.go('/rooms/${room.id}/invite'),
              icon: const Icon(
                Icons.person_add_outlined,
              ),
            ),
        ],
      ),
      body: MaxWidthBody(
        withScrolling: false,
        innerPadding: const EdgeInsets.symmetric(vertical: 8),
        child: error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline),
                      Text(error.toLocalizedString(context)),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: controller.refreshMembers,
                        icon: const Icon(Icons.refresh_outlined),
                        label: Text(L10n.of(context).tryAgain),
                      ),
                    ],
                  ),
                ),
              )
            : members == null
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: members.length + 1,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        final availableFilters = Membership.values
                            .where(
                              (membership) =>
                                  controller.members?.any(
                                    (member) => member.membership == membership,
                                  ) ??
                                  false,
                            )
                            .toList();
                        availableFilters
                            .sort((a, b) => a == Membership.join ? -1 : 1);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: controller.filterController,
                                onChanged: controller.setFilter,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      theme.colorScheme.secondaryContainer,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  hintStyle: TextStyle(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  prefixIcon: const Icon(Icons.search_outlined),
                                  hintText: L10n.of(context).search,
                                ),
                              ),
                            ),
                            if (availableFilters.length > 1)
                              SizedBox(
                                height: 64,
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 12.0,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: availableFilters.length,
                                  itemBuilder: (context, i) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: FilterChip(
                                      label: Text(
                                        switch (availableFilters[i]) {
                                          Membership.ban =>
                                            L10n.of(context).banned,
                                          Membership.invite =>
                                            L10n.of(context).countInvited(
                                              room.summary
                                                      .mInvitedMemberCount ??
                                                  controller.members
                                                      ?.where(
                                                        (member) =>
                                                            member.membership ==
                                                            Membership.invite,
                                                      )
                                                      .length ??
                                                  0,
                                            ),
                                          Membership.join =>
                                            L10n.of(context).countParticipants(
                                              room.summary.mJoinedMemberCount ??
                                                  controller.members
                                                      ?.where(
                                                        (member) =>
                                                            member.membership ==
                                                            Membership.join,
                                                      )
                                                      .length ??
                                                  0,
                                            ),
                                          Membership.knock =>
                                            L10n.of(context).knocking,
                                          Membership.leave =>
                                            L10n.of(context).leftTheChat,
                                        },
                                      ),
                                      selected: controller.membershipFilter ==
                                          availableFilters[i],
                                      onSelected: (_) =>
                                          controller.setMembershipFilter(
                                        availableFilters[i],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                      i--;
                      return ParticipantListItem(members[i]);
                    },
                  ),
      ),
    );
  }
}
