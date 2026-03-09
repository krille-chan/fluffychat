import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/material.dart';

class SettingsProfilePage extends StatelessWidget {
  final TextEditingController? pronounsController;
  final String? timezone;
  final VoidCallback save;
  final bool isLoading;

  const SettingsProfilePage({
    super.key,
    required this.pronounsController,
    required this.save,
    required this.timezone,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !FluffyThemes.isColumnMode(context),
        title: Text(L10n.of(context).profileSettings),
      ),
      body: MaxWidthBody(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 32,
            children: [
              TextField(
                controller: pronounsController,
                readOnly: pronounsController == null,
                decoration: InputDecoration(
                  labelText: L10n.of(context).pronouns,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 8,
        shadowColor: theme.appBarTheme.shadowColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: pronounsController == null || isLoading ? null : save,
            child: isLoading
                ? LinearProgressIndicator()
                : Text(L10n.of(context).saveChanges),
          ),
        ),
      ),
    );
  }
}
