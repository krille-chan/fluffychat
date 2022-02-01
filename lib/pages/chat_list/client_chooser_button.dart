import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'chat_list.dart';

class ClientChooserButton extends StatelessWidget {
  final ChatListController controller;
  const ClientChooserButton(this.controller, {Key? key}) : super(key: key);

  List<PopupMenuEntry<Object>> _bundleMenuItems(BuildContext context) {
    final matrix = Matrix.of(context);
    final bundles = matrix.accountBundles.keys.toList()
      ..sort((a, b) => a!.isValidMatrixId == b!.isValidMatrixId
          ? 0
          : a.isValidMatrixId && !b.isValidMatrixId
              ? -1
              : 1);
    return <PopupMenuEntry<Object>>[
      for (final bundle in bundles) ...[
        if (matrix.accountBundles[bundle]!.length != 1 ||
            matrix.accountBundles[bundle]!.single!.userID != bundle)
          PopupMenuItem(
            value: null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bundle!,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle1!.color,
                    fontSize: 14,
                  ),
                ),
                const Divider(height: 1),
              ],
            ),
          ),
        ...matrix.accountBundles[bundle]!
            .map(
              (client) => PopupMenuItem(
                value: client,
                child: FutureBuilder<Profile>(
                  future: client!.ownProfile,
                  builder: (context, snapshot) => Row(
                    children: [
                      Avatar(
                        mxContent: snapshot.data?.avatarUrl,
                        name: snapshot.data?.displayName ??
                            client.userID!.localpart,
                        size: 28,
                        fontSize: 12,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          snapshot.data?.displayName ??
                              client.userID!.localpart!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => controller.editBundlesForAccount(
                            client.userID, bundle),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);
    return Center(
      child: FutureBuilder<Profile>(
        future: matrix.client.ownProfile,
        builder: (context, snapshot) => PopupMenuButton<Object>(
          child: Avatar(
            mxContent: snapshot.data?.avatarUrl,
            name: snapshot.data?.displayName ?? matrix.client.userID!.localpart,
            size: 28,
            fontSize: 12,
          ),
          onSelected: (Object object) {
            if (object is Client) {
              controller.setActiveClient(object);
            } else if (object is String) {
              controller.setActiveBundle(object);
            }
          },
          itemBuilder: _bundleMenuItems,
        ),
      ),
    );
  }
}
