import 'package:fluffychat/pages/views/signup_view.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../utils/localized_exception_extension.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  SignupPageController createState() => SignupPageController();
}

class SignupPageController extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String usernameError;
  String passwordError;
  bool loading = false;
  bool showPassword = true;

  void toggleShowPassword() => setState(() => showPassword = !showPassword);

  void signup([_]) async {
    usernameError = passwordError = null;

    if (usernameController.text.isEmpty) {
      return setState(
          () => usernameError = L10n.of(context).pleaseChooseAUsername);
    }
    if (passwordController.text.isEmpty) {
      return setState(
          () => passwordError = L10n.of(context).chooseAStrongPassword);
    }

    setState(() => loading = true);

    try {
      final client = Matrix.of(context).getLoginClient();
      await client.uiaRequestBackground(
        (auth) => client.register(
          username: usernameController.text,
          password: passwordController.text,
          initialDeviceDisplayName: PlatformInfos.clientName,
          auth: auth,
        ),
      );
    } catch (e) {
      passwordError = (e as Object).toLocalizedString(context);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => SignupPageView(this);
}
