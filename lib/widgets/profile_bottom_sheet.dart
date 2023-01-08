import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ProfileBottomSheet extends StatelessWidget {
  final String userId;
  final BuildContext outerContext;

  const ProfileBottomSheet({
    required this.userId,
    required this.outerContext,
    Key? key,
  }) : super(key: key);

  void _startDirectChat(BuildContext context) async {
    final client = Matrix.of(context).client;
    final result = await showFutureLoadingDialog<String>(
      context: context,
      future: () => client.startDirectChat(userId),
    );
    if (result.error == null) {
      VRouter.of(context).toSegments(['rooms', result.result!]);
      Navigator.of(context, rootNavigator: false).pop();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Profile>(
        future: Matrix.of(context).client.getProfileFromUserId(userId),
        builder: (context, snapshot) {
          final profile = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              leading: CloseButton(
                onPressed: Navigator.of(context, rootNavigator: false).pop,
              ),
              title: ListTile(
                contentPadding: const EdgeInsets.only(right: 16.0),
                title: Text(
                  profile?.displayName ?? userId.localpart ?? userId,
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  userId,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton.icon(
                    onPressed: () => _startDirectChat(context),
                    icon: Icon(Icons.adaptive.share_outlined),
                    label: Text(L10n.of(context)!.share),
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Avatar(
                      mxContent: profile?.avatarUrl,
                      name: profile?.displayName ?? userId,
                      size: Avatar.defaultSize * 3,
                      fontSize: 36,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: FloatingActionButton.extended(
                    onPressed: () => _startDirectChat(context),
                    label: Text(L10n.of(context)!.newChat),
                    icon: const Icon(Icons.send_outlined),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
