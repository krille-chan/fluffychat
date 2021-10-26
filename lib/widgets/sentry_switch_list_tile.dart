import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/utils/sentry_controller.dart';

class SentrySwitchListTile extends StatefulWidget {
  final String label;

  const SentrySwitchListTile({Key key, this.label}) : super(key: key);

  @override
  _SentrySwitchListTileState createState() => _SentrySwitchListTileState();
}

class _SentrySwitchListTileState extends State<SentrySwitchListTile> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: SentryController.getSentryStatus(),
        builder: (context, snapshot) {
          _enabled = snapshot.data ?? false;
          return SwitchListTile(
            title: Text(widget.label ?? L10n.of(context).sendBugReports),
            value: _enabled,
            onChanged: (b) =>
                SentryController.toggleSentryAction(context, b).then(
              (_) => setState(() => null),
            ),
          );
        });
  }
}
