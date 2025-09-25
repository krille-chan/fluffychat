import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/pangea/login/widgets/app_config_dialog.dart';

class LoginOrSignupView extends StatefulWidget {
  const LoginOrSignupView({super.key});

  @override
  State<LoginOrSignupView> createState() => LoginOrSignupViewState();
}

class LoginOrSignupViewState extends State<LoginOrSignupView> {
  List<AppConfigOverride> _overrides = [];

  @override
  void initState() {
    super.initState();
    _loadOverrides();
  }

  Future<void> _loadOverrides() async {
    final overrides = await Environment.getAppConfigOverrides();
    if (mounted) {
      setState(() => _overrides = overrides);
    }
  }

  Future<void> _setEnvironment() async {
    if (_overrides.isEmpty) return;

    final resp = await showDialog<AppConfigOverride?>(
      context: context,
      builder: (context) => AppConfigDialog(overrides: _overrides),
    );

    await Environment.setAppConfigOverride(resp);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: Environment.isStagingEnvironment && _overrides.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: _setEnvironment,
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: Column(
              spacing: 50.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  spacing: 12.0,
                  children: [
                    PangeaLogoSvg(
                      width: 50.0,
                      forceColor: theme.colorScheme.onSurface,
                    ),
                    Text(
                      AppConfig.applicationName,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  L10n.of(context).appDescription,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  spacing: 16.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go('/home/languages'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          width: 1,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(L10n.of(context).start),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go('/home/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                        side: BorderSide(
                          width: 1,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(L10n.of(context).loginToAccount),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
