import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/login/pages/pangea_login_scaffold.dart';
import 'package:fluffychat/pangea/login/widgets/app_config_dialog.dart';
import 'package:fluffychat/pangea/login/widgets/full_width_button.dart';

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
    return PangeaLoginScaffold(
      actions: Environment.isStagingEnvironment && _overrides.isNotEmpty
          ? [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: _setEnvironment,
              ),
            ]
          : null,
      children: [
        FullWidthButton(
          title: L10n.of(context).createAnAccount,
          onPressed: () => context.go('/home/signup'),
        ),
        FullWidthButton(
          title: L10n.of(context).signIn,
          onPressed: () => context.go('/home/login'),
        ),
      ],
    );
  }
}
