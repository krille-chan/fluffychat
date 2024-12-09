import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matrix/matrix.dart';

class ButtonInfo {
  String iconPath;
  String text;

  ButtonInfo(this.iconPath, this.text);
}

class PangeaSsoButton extends StatelessWidget {
  final IdentityProvider identityProvider;
  final void Function()? onPressed;
  const PangeaSsoButton({
    super.key,
    required this.identityProvider,
    this.onPressed,
  });

  ButtonInfo getButtonInfo(BuildContext context) {
    switch (identityProvider.id) {
      case "oidc-google":
        return ButtonInfo(
          "assets/pangea/google.svg",
          "${L10n.of(context).loginOrSignup} Google",
        );
      case "oidc-apple":
        return ButtonInfo(
          "assets/pangea/apple.svg",
          "${L10n.of(context).loginOrSignup} Apple",
        );
      default:
        return ButtonInfo(
          "assets/pangea/pangea.svg",
          "${L10n.of(context).loginOrSignup} Pangea Chat",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonInfo buttonInfo = getButtonInfo(context);
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          identityProvider.icon == null
              ? SvgPicture.asset(
                  buttonInfo.iconPath,
                  height: 20,
                  width: 20,
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppConfig.primaryColor
                      : AppConfig.primaryColorLight,
                )
              : Image.network(
                  Uri.parse(identityProvider.icon!)
                      .getDownloadLink(Matrix.of(context).getLoginClient())
                      .toString(),
                  width: 32,
                  height: 32,
                ),
          // #Pangea
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              identityProvider.name != null
                  ? buttonInfo.text
                  : (identityProvider.brand != null
                      ? L10n.of(context).loginOrSignup
                      : L10n.of(context).loginOrSignup),
            ),
          ),
        ],
      ),
    );
  }
}
