import 'package:fluffychat/pangea/pages/sign_up/signup_view.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageController createState() => SignupPageController();
}

class SignupPageController extends State<SignupPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? error;
  bool loading = false;
  bool showPassword = false;
  bool noEmailWarningConfirmed = false;
  bool displaySecondPasswordField = false;

  static const int minPassLength = 8;

  void toggleShowPassword() => setState(() => showPassword = !showPassword);

  // String? get domain => VRouter.of(context).queryParameters['domain'];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onPasswordType(String text) {
    if (text.length >= minPassLength && !displaySecondPasswordField) {
      setState(() {
        displaySecondPasswordField = true;
      });
    }
  }

  String? password1TextFieldValidator(String? value) {
    if (value!.isEmpty) {
      return L10n.of(context)!.chooseAStrongPassword;
    }
    if (value.length < minPassLength) {
      return L10n.of(context)!
          .pleaseChooseAtLeastChars(minPassLength.toString());
    }
    return null;
  }

  String? password2TextFieldValidator(String? value) {
    if (value!.isEmpty) {
      return L10n.of(context)!.repeatPassword;
    }
    if (value != passwordController.text) {
      return L10n.of(context)!.passwordsDoNotMatch;
    }
    return null;
  }

  String? emailTextFieldValidator(String? value) {
    if (value!.isEmpty && !noEmailWarningConfirmed) {
      noEmailWarningConfirmed = true;
      return L10n.of(context)!.noEmailWarning;
    }
    if (value.isNotEmpty && !value.contains('@')) {
      return L10n.of(context)!.pleaseEnterValidEmail;
    }
    return null;
  }

  // #Pangea
  bool isTnCChecked = false;
  String? signupError;
  void onTncChange(bool? value) {
    isTnCChecked = value ?? false;
    signupError = null;
    setState(() {});
  }
  // #Pangea

  void signup([_]) async {
    setState(() {
      error = null;
    });
    if (!formKey.currentState!.validate()) return;
    // #Pangea
    if (!isTnCChecked) {
      setState(() {
        signupError = 'Please agree to the Terms and Conditions';
      });
      return;
    }
    // #Pangea
    setState(() {
      loading = true;
    });

    try {
      final client = Matrix.of(context).getLoginClient();
      final email = emailController.text;
      if (email.isNotEmpty) {
        Matrix.of(context).currentClientSecret =
            DateTime.now().millisecondsSinceEpoch.toString();
        Matrix.of(context).currentThreepidCreds =
            await client.requestTokenToRegisterEmail(
          Matrix.of(context).currentClientSecret,
          email,
          0,
        );
      }

      final displayname = Matrix.of(context).loginUsername!;
      final localPart = displayname.toLowerCase().replaceAll(' ', '_');

      final registerRes = await client.uiaRequestBackground(
        (auth) => client.register(
          username: localPart,
          password: passwordController.text,
          initialDeviceDisplayName: PlatformInfos.clientName,
          auth: auth,
        ),
      );

      //@brord is this right??
      //#Pangea
      GoogleAnalytics.login("pangea", registerRes.userId);
      //Pangea#

      // Set displayname
      if (displayname != localPart && client.userID != null) {
        await client.setDisplayName(
          client.userID!,
          displayname,
        );
      }
    } catch (e, s) {
      //#Pangea
      const cancelledString = "Exception: Request has been canceled";
      if (e.toString() != cancelledString) {
        ErrorHandler.logError(e: e, s: s);
        error = (e).toLocalizedString(context);
      }
      // Pangea#
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => SignupPageView(this);
}
