import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix_api_lite/model/matrix_exception.dart';

import 'package:fluffychat/pangea/pages/sign_up/signup_view.dart';
import 'package:fluffychat/pangea/pages/sign_up/signup_with_email_view.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/firebase_analytics.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SignupPage extends StatefulWidget {
  final bool withEmail;
  const SignupPage({
    this.withEmail = false,
    super.key,
  });

  @override
  SignupPageController createState() => SignupPageController();
}

class SignupPageController extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? usernameText;
  String? passwordText;
  String? emailText;

  String? error;
  bool loading = false;
  bool showPassword = false;
  bool noEmailWarningConfirmed = false;
  bool displaySecondPasswordField = false;

  @override
  void initState() {
    super.initState();

    usernameController.addListener(() {
      _setStateOnTextChange(usernameText, usernameController.text);
      usernameText = usernameController.text;
    });

    passwordController.addListener(() {
      _setStateOnTextChange(passwordText, passwordController.text);
      passwordText = passwordController.text;
    });

    emailController.addListener(() {
      _setStateOnTextChange(emailText, emailController.text);
      emailText = emailController.text;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    loading = false;
    error = null;
    super.dispose();
  }

  bool get enableSignUp =>
      !loading &&
      isTnCChecked &&
      emailController.text.isNotEmpty &&
      usernameController.text.isNotEmpty &&
      passwordController.text.isNotEmpty;

  void _setStateOnTextChange(String? oldText, String newText) {
    if ((oldText == null || oldText.isEmpty) && (newText.isNotEmpty)) {
      setState(() {});
    }
    if ((oldText != null && oldText.isNotEmpty) && (newText.isEmpty)) {
      setState(() {});
    }
  }

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
      return L10n.of(context).chooseAStrongPassword;
    }
    if (value.length < minPassLength) {
      return L10n.of(context)
          .pleaseChooseAtLeastChars(minPassLength.toString());
    }
    return null;
  }

  String? password2TextFieldValidator(String? value) {
    if (value!.isEmpty) {
      return L10n.of(context).repeatPassword;
    }
    if (value != passwordController.text) {
      return L10n.of(context).passwordsDoNotMatch;
    }
    return null;
  }

  String? emailTextFieldValidator(String? value) {
    // #Pangea
    if (value == null || value.isEmpty) {
      // if (value!.isEmpty && !noEmailWarningConfirmed) {
      //   noEmailWarningConfirmed = true;
      // return L10n.of(context).noEmailWarning;
      return L10n.of(context).pleaseEnterEmail;
      // Pangea#
    }
    if (value.isNotEmpty && !value.contains('@')) {
      return L10n.of(context).pleaseEnterValidEmail;
    }
    return null;
  }

  bool isTnCChecked = false;
  String? signupError;
  void onTncChange(bool? value) {
    isTnCChecked = value ?? false;
    signupError = null;
    setState(() {});
  }

  void signup([_]) async {
    setState(() {
      error = null;
    });
    final valid = formKey.currentState!.validate();
    if (!isTnCChecked) {
      setState(() {
        signupError = L10n.of(context).pleaseAgreeToTOS;
      });
    }
    if (!valid || !isTnCChecked) {
      return;
    }

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

      final displayname = usernameController.text;
      final localPart = displayname.toLowerCase().replaceAll(' ', '_');

      final registerRes = await client.uiaRequestBackground(
        (auth) => client.register(
          username: localPart,
          password: passwordController.text,
          initialDeviceDisplayName: PlatformInfos.clientName,
          auth: auth,
        ),
      );

      GoogleAnalytics.login("pangea", registerRes.userId);

      if (displayname != localPart && client.userID != null) {
        await client.setDisplayName(
          client.userID!,
          displayname,
        );
      }
    } on MatrixException catch (e, s) {
      if (e.error != MatrixError.M_THREEPID_IN_USE) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {},
        );
      }
      error = e.errorMessage;
    } catch (e, s) {
      const cancelledString = "Exception: Request has been canceled";
      if (e.toString() != cancelledString) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {},
        );
      }
      error = (e).toLocalizedString(context);
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.withEmail ? SignupWithEmailView(this) : SignupPageView(this);
}
