import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/sign_up/signup_view.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/localized_exception_extension.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  SignupPageController createState() => SignupPageController();
}

class SignupPageController extends State<SignupPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? error;
  bool loading = false;
  bool showPassword = true;

  void toggleShowPassword() => setState(() => showPassword = !showPassword);

  String? get domain => VRouter.of(context).queryParameters['domain'];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? password1TextFieldValidator(String? value) {
    const minLength = 8;
    if (value!.isEmpty) {
      return L10n.of(context)!.chooseAStrongPassword;
    }
    if (value.length < minLength) {
      return L10n.of(context)!.pleaseChooseAtLeastChars(minLength.toString());
    }
    return null;
  }

  String? emailTextFieldValidator(String? value) {
    if (value!.isEmpty) {
      return L10n.of(context)!.addEmail;
    }
    if (value.isNotEmpty && !value.contains('@')) {
      return L10n.of(context)!.pleaseEnterValidEmail;
    }
    return null;
  }

  void signup([_]) async {
    setState(() {
      error = null;
    });
    if (!formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {
      final client = Matrix.of(context).getLoginClient();
      final email = emailController.text;
      Matrix.of(context).currentClientSecret =
          DateTime.now().millisecondsSinceEpoch.toString();
      Matrix.of(context).currentThreepidCreds =
          await client.requestTokenToRegisterEmail(
        Matrix.of(context).currentClientSecret,
        email,
        0,
      );

      await client.uiaRequestBackground(
        (auth) => client.register(
          username: Matrix.of(context).loginUsername!,
          password: passwordController.text,
          initialDeviceDisplayName: PlatformInfos.clientName,
          auth: auth,
        ),
      );
    } catch (e) {
      error = (e).toLocalizedString(context);
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => SignupPageView(this);
}
