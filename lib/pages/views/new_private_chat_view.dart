import 'package:fluffychat/pages/new_private_chat.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/contacts_list.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:vrouter/vrouter.dart';

class NewPrivateChatView extends StatelessWidget {
  final NewPrivateChatController controller;

  const NewPrivateChatView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).newChat),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => VRouter.of(context).push('/newgroup'),
            child: Text(
              L10n.of(context).createNewGroup,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          )
        ],
      ),
      body: MaxWidthBody(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: controller.formKey,
                child: TextFormField(
                  controller: controller.controller,
                  autocorrect: false,
                  onChanged: controller.searchUserWithCoolDown,
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: controller.submitAction,
                  validator: controller.validateForm,
                  decoration: InputDecoration(
                    labelText: L10n.of(context).enterAUsername,
                    prefixIcon: controller.loading
                        ? Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(),
                          )
                        : controller.correctMxId
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Avatar(
                                  controller.foundProfile.avatarUrl,
                                  controller.foundProfile.displayname ??
                                      controller.foundProfile.userId,
                                  size: 12,
                                ),
                              )
                            : Icon(Icons.account_circle_outlined),
                    prefixText: '@',
                    suffixIcon: IconButton(
                      onPressed: controller.submitAction,
                      icon: Icon(Icons.arrow_forward_outlined),
                    ),
                    hintText: '${L10n.of(context).username.toLowerCase()}',
                  ),
                ),
              ),
            ),
            Divider(height: 1),
            ListTile(
              leading: CircleAvatar(
                radius: Avatar.defaultSize / 2,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                child: Icon(Icons.share_outlined),
              ),
              onTap: controller.inviteAction,
              title: Text('${L10n.of(context).yourOwnUsername}:'),
              subtitle: Text(
                Matrix.of(context).client.userID,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Divider(height: 1),
            if (controller.foundProfiles.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: controller.foundProfiles.length,
                  itemBuilder: (BuildContext context, int i) {
                    final foundProfile = controller.foundProfiles[i];
                    return ListTile(
                      onTap: () => controller.pickUser(foundProfile),
                      leading: Avatar(
                        foundProfile.avatarUrl,
                        foundProfile.displayname ?? foundProfile.userId,
                        //size: 24,
                      ),
                      title: Text(
                        foundProfile.displayname ??
                            foundProfile.userId.localpart,
                        style: TextStyle(),
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        foundProfile.userId,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (controller.foundProfiles.isEmpty)
              Expanded(
                child: ContactsList(searchController: controller.controller),
              ),
          ],
        ),
      ),
    );
  }
}
