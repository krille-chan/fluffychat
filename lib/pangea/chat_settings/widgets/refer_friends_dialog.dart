import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/chat_settings/constants/room_settings_constants.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';

class ReferFriendsDialog extends StatelessWidget {
  final Room room;

  const ReferFriendsDialog({
    required this.room,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final inviteLink =
        "${Environment.frontendURL}/#/join_with_alias?alias=${Uri.encodeComponent(room.id)}";
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(50),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 450,
                child: CachedNetworkImage(
                  imageUrl:
                      "${AppConfig.assetsBaseURL}/${RoomSettingsConstants.referFriendDialogAsset}",
                  errorWidget: (context, url, error) => const SizedBox(),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),
            ),
          ),
          Text(
            L10n.of(context).referFriendDialogTitle,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          Text(
            L10n.of(context).referFriendDialogDesc,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Material(
            color: Colors.transparent, // Keeps the `Container`'s background
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                inviteLink,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.copy_outlined),
              onTap: () async {
                Clipboard.setData(
                  ClipboardData(text: inviteLink),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
