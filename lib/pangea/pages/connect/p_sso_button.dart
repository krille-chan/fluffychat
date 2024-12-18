import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:fluffychat/pangea/pages/sign_up/full_width_button.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/sso_login_action.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matrix/matrix_api_lite/model/matrix_exception.dart';

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

class PangeaSsoButton extends StatefulWidget {
  final String title;
  final SSOProvider provider;
  const PangeaSsoButton({
    required this.title,
    required this.provider,
    super.key,
  });

  @override
  PangeaSsoButtonState createState() => PangeaSsoButtonState();
}

class PangeaSsoButtonState extends State<PangeaSsoButton> {
  bool _loading = false;
  String? _error;

  Future<void> _runSSOLogin() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });
      await pangeaSSOLoginAction(
        IdentityProvider(
          id: widget.provider.id,
          name: widget.provider.name,
        ),
        Matrix.of(context).getLoginClient(),
        context,
      );
    } catch (err, s) {
      ErrorHandler.logError(e: err, s: s);
      if (err is MatrixException) {
        _error = err.errorMessage;
      } else {
        _error = L10n.of(context).oopsSomethingWentWrong;
      }
      _error = err.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullWidthButton(
      depressed: _loading,
      error: _error,
      loading: _loading,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.provider.asset,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onPrimary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 10),
          Text(widget.title),
        ],
      ),
      onPressed: _runSSOLogin,
    );
  }
}
