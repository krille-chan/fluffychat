import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matrix/matrix_api_lite/model/matrix_exception.dart';

import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:fluffychat/pangea/login/utils/sso_login_action.dart';
import 'package:fluffychat/pangea/login/widgets/full_width_button.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

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

  String get name {
    switch (this) {
      case SSOProvider.google:
        return "Google";
      case SSOProvider.apple:
        return "Apple";
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
}

class PangeaSsoButton extends StatelessWidget {
  final String title;
  final SSOProvider provider;

  final Function(bool, SSOProvider) setLoading;
  final bool loading;

  const PangeaSsoButton({
    required this.title,
    required this.provider,
    required this.setLoading,
    this.loading = false,
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
        Matrix.of(context).getLoginClient(),
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
    return FullWidthButton(
      depressed: loading,
      loading: loading,
      title: title,
      icon: SvgPicture.asset(
        provider.asset,
        height: 20,
        width: 20,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onPrimary,
          BlendMode.srcIn,
        ),
      ),
      onPressed: () => _runSSOLogin(context),
    );
  }
}
