import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:matrix/matrix_api_lite/model/matrix_exception.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:fluffychat/pangea/login/utils/sso_login_action.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

enum SSOProvider { google, apple }

extension on SSOProvider {
  String get id {
    switch (this) {
      case SSOProvider.google:
        return "oidc-google";
      case SSOProvider.apple:
        return "oidc-apple";
    }
  }

  String get asset {
    switch (this) {
      case SSOProvider.google:
        return "assets/pangea/google.svg";
      case SSOProvider.apple:
        return "assets/pangea/apple.svg";
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case SSOProvider.google:
        return L10n.of(context).withGoogle;
      case SSOProvider.apple:
        return L10n.of(context).withApple;
    }
  }
}

class PangeaSsoButton extends StatelessWidget {
  final String? title;
  final SSOProvider provider;

  final Function(bool, SSOProvider) setLoading;
  final bool loading;
  final bool? Function()? validator;

  const PangeaSsoButton({
    required this.provider,
    required this.setLoading,
    this.title,
    this.loading = false,
    this.validator,
    super.key,
  });

  Future<void> _runSSOLogin(BuildContext context) async {
    setLoading(true, provider);
    await showFutureLoadingDialog(
      context: context,
      future: () async => pangeaSSOLoginAction(
        IdentityProvider(
          id: provider.id,
          name: provider.name,
        ),
        context,
      ),
      onError: (e, s) {
        setLoading(false, provider);
        return e is MatrixException
            ? e.errorMessage
            : L10n.of(context).oopsSomethingWentWrong;
      },
      onDismiss: () => setLoading(false, provider),
    );
    setLoading(false, provider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
      ),
      child: Row(
        spacing: 8.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            provider.asset,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onPrimaryContainer,
              BlendMode.srcIn,
            ),
          ),
          Text(title ?? provider.description(context)),
        ],
      ),
      onPressed: () {
        if (validator != null) {
          final valid = validator!.call() ?? false;
          if (!valid) return;
        }
        _runSSOLogin(context);
      },
    );
  }
}
