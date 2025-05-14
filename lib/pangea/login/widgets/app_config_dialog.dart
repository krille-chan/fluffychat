import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';

class AppConfigDialog extends StatefulWidget {
  final List<AppConfigOverride> overrides;
  const AppConfigDialog({
    super.key,
    required this.overrides,
  });

  @override
  State<AppConfigDialog> createState() => AppConfigDialogState();
}

class AppConfigDialogState extends State<AppConfigDialog> {
  AppConfigOverride? selectedOverride;

  @override
  void initState() {
    super.initState();
    selectedOverride = Environment.appConfigOverride;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256),
        child: Text(
          L10n.of(context).addEnvironmentOverride,
          textAlign: TextAlign.center,
        ),
      ),
      content: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: const BoxConstraints(
            maxWidth: 256,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...widget.overrides.map((override) {
                  return RadioListTile<AppConfigOverride?>.adaptive(
                    title: Text(
                      override.environment ?? L10n.of(context).unkDisplayName,
                    ),
                    value: override,
                    groupValue: selectedOverride,
                    onChanged: (override) {
                      setState(() {
                        selectedOverride = override;
                      });
                    },
                  );
                }).toList()
                  ..insert(
                    0,
                    RadioListTile<AppConfigOverride?>.adaptive(
                      title: Text(L10n.of(context).defaultOption),
                      value: null,
                      groupValue: selectedOverride,
                      onChanged: (override) {
                        setState(() {
                          selectedOverride = null;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        AdaptiveDialogAction(
          bigButtons: true,
          onPressed: () => Navigator.of(context).pop(selectedOverride),
          child: Text(L10n.of(context).submit),
        ),
        AdaptiveDialogAction(
          bigButtons: true,
          onPressed: Navigator.of(context).pop,
          child: Text(L10n.of(context).close),
        ),
      ],
    );
  }
}
