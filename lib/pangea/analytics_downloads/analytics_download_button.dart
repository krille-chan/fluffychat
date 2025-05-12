import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics_downloads/analytics_dowload_dialog.dart';

class DownloadAnalyticsButton extends StatelessWidget {
  const DownloadAnalyticsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: L10n.of(context).download,
      icon: const Icon(Symbols.download),
      onPressed: () => showDialog<AnalyticsDownloadDialog>(
        context: context,
        builder: (context) => const AnalyticsDownloadDialog(),
      ),
    );
  }
}
