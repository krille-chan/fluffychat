import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import '../../widgets/matrix.dart';
import 'settings_ignore_list.dart';

class SettingsIgnoreListView extends StatelessWidget {
  final SettingsIgnoreListController controller;

  const SettingsIgnoreListView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final client = Matrix.of(context).client;
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(L10n.of(context).blockedUsers),
      ),
      body: MaxWidthBody(
        withScrolling: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller.controller,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => controller.ignoreUser(context),
                    decoration: InputDecoration(
                      errorText: controller.errorText,
                      hintText: '@bad_guy:domain.abc',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: L10n.of(context).blockUsername,
                      suffixIcon: IconButton(
                        tooltip: L10n.of(context).block,
                        icon: const Icon(Icons.add),
                        onPressed: () => controller.ignoreUser(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    L10n.of(context).blockListDescription,
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            Divider(
              color: theme.dividerColor,
            ),
            Expanded(
              child: StreamBuilder<Object>(
                stream: client.onSync.stream.where(
                  (syncUpdate) =>
                      syncUpdate.accountData?.any(
                        (accountData) =>
                            accountData.type == 'm.ignored_user_list',
                      ) ??
                      false,
                ),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: client.ignoredUsers.length,
                    itemBuilder: (c, i) => FutureBuilder<Profile>(
                      future:
                          client.getProfileFromUserId(client.ignoredUsers[i]),
                      builder: (c, s) => ListTile(
                        leading: Avatar(
                          mxContent: s.data?.avatarUrl ?? Uri.parse(''),
                          name: s.data?.displayName ?? client.ignoredUsers[i],
                        ),
                        title: Text(
                          s.data?.displayName ?? client.ignoredUsers[i],
                        ),
                        subtitle:
                            Text(s.data?.userId ?? client.ignoredUsers[i]),
                        trailing: IconButton(
                          tooltip: L10n.of(context).delete,
                          icon: const Icon(Icons.delete_outlined),
                          onPressed: () => showFutureLoadingDialog(
                            context: context,
                            future: () =>
                                client.unignoreUser(client.ignoredUsers[i]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
