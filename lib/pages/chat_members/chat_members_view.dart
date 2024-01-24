import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

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
          title: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context)!.youAreNoLongerParticipatingInThisChat),
        ),
      );
    }

    final members = controller.filteredMembers;

    final roomCount = (room.summary.mJoinedMemberCount ?? 0) +
        (room.summary.mInvitedMemberCount ?? 0);

    final error = controller.error;

    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(
          L10n.of(context)!.countParticipants(roomCount),
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
                        label: Text(L10n.of(context)!.tryAgain),
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
                    itemBuilder: (context, i) => i == 0
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: controller.filterController,
                              onChanged: controller.setFilter,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search_outlined),
                                hintText: L10n.of(context)!.search,
                              ),
                            ),
                          )
                        : ParticipantListItem(members[i - 1]),
                  ),
      ),
    );
  }
}
