import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/invitation_selection/invitation_selection.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class InvitationSelectionView extends StatelessWidget {
  final InvitationSelectionController controller;

  const InvitationSelectionView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(controller.roomId!)!;
    final groupName = room.name.isEmpty ? L10n.of(context)!.group : room.name;
    return Scaffold(
      appBar: AppBar(
        leading: VRouter.of(context).path.startsWith('/spaces/')
            ? null
            : IconButton(
                icon: const Icon(Icons.close_outlined),
                onPressed: () => VRouter.of(context)
                    .toSegments(['rooms', controller.roomId!]),
              ),
        titleSpacing: 0,
        title: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: L10n.of(context)!.inviteContactToGroup(groupName),
                suffixIcon: controller.loading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 12,
                        ),
                        child: SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : const Icon(Icons.search_outlined),
              ),
              onChanged: controller.searchUserWithCoolDown,
            ),
          ),
        ),
      ),
      body: MaxWidthBody(
        withScrolling: true,
        child: controller.foundProfiles.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.foundProfiles.length,
                itemBuilder: (BuildContext context, int i) => ListTile(
                  leading: Avatar(
                    mxContent: controller.foundProfiles[i].avatarUrl,
                    name: controller.foundProfiles[i].displayName ??
                        controller.foundProfiles[i].userId,
                  ),
                  title: Text(
                    controller.foundProfiles[i].displayName ??
                        controller.foundProfiles[i].userId.localpart!,
                  ),
                  subtitle: Text(controller.foundProfiles[i].userId),
                  onTap: () => controller.inviteAction(
                    context,
                    controller.foundProfiles[i].userId,
                  ),
                ),
              )
            : FutureBuilder<List<User>>(
                future: controller.getContacts(context),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    );
                  }
                  final contacts = snapshot.data!;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: contacts.length,
                    itemBuilder: (BuildContext context, int i) => ListTile(
                      leading: Avatar(
                        mxContent: contacts[i].avatarUrl,
                        name: contacts[i].calcDisplayname(),
                      ),
                      title: Text(
                        contacts[i].calcDisplayname(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        contacts[i].id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onTap: () =>
                          controller.inviteAction(context, contacts[i].id),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
