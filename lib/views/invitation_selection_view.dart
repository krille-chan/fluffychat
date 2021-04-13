import 'package:fluffychat/controllers/invitation_selection_controller.dart';
import 'package:fluffychat/views/widgets/default_app_bar_search_field.dart';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/avatar.dart';
import 'package:fluffychat/views/widgets/max_width_body.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class InvitationSelectionView extends StatelessWidget {
  final InvitationSelectionController controller;

  const InvitationSelectionView(
    this.controller, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room =
        Matrix.of(context).client.getRoomById(controller.widget.roomId);
    final groupName =
        room.name?.isEmpty ?? false ? L10n.of(context).group : room.name;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        titleSpacing: 0,
        title: DefaultAppBarSearchField(
          autofocus: true,
          hintText: L10n.of(context).inviteContactToGroup(groupName),
          onChanged: controller.searchUserWithCoolDown,
        ),
      ),
      body: MaxWidthBody(
        withScrolling: true,
        child: controller.foundProfiles.isNotEmpty
            ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.foundProfiles.length,
                itemBuilder: (BuildContext context, int i) => ListTile(
                  leading: Avatar(
                    controller.foundProfiles[i].avatarUrl,
                    controller.foundProfiles[i].displayname ??
                        controller.foundProfiles[i].userId,
                  ),
                  title: Text(
                    controller.foundProfiles[i].displayname ??
                        controller.foundProfiles[i].userId.localpart,
                  ),
                  subtitle: Text(controller.foundProfiles[i].userId),
                  onTap: () => controller.inviteAction(
                      context, controller.foundProfiles[i].userId),
                ),
              )
            : FutureBuilder<List<User>>(
                future: controller.getContacts(context),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var contacts = snapshot.data;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: contacts.length,
                    itemBuilder: (BuildContext context, int i) => ListTile(
                      leading: Avatar(
                        contacts[i].avatarUrl,
                        contacts[i].calcDisplayname(),
                      ),
                      title: Text(contacts[i].calcDisplayname()),
                      subtitle: Text(contacts[i].id),
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
