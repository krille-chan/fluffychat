import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/spaces/widgets/download_space_analytics_dialog.dart';

class DownloadSpaceAnalyticsButton extends StatelessWidget {
  final Room space;

  const DownloadSpaceAnalyticsButton({
    super.key,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Column(
      children: [
        ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => DownloadAnalyticsDialog(space: space),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: iconColor,
            child: const Icon(Icons.download_outlined),
          ),
          title: Text(
            L10n.of(context).downloadSpaceAnalytics,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
