import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/login/pages/pangea_login_view.dart';
import 'package:fluffychat/pangea/login/widgets/p_sso_button.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/platform_infos.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginController createState() => LoginController();
}

class LoginController extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? usernameText;
  String? passwordText;

  String? usernameError;
  String? passwordError;

  bool loadingSignIn = false;
  bool loadingAppleSSO = false;
  bool loadingGoogleSSO = false;
  String? appleSSOError;
  String? googleSSOError;

  bool showPassword = false;

  // #Pangea
  final PangeaController pangeaController = MatrixState.pangeaController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get enabledSignIn =>
      !loadingSignIn &&
      usernameText != null &&
      usernameText!.isNotEmpty &&
      passwordText != null &&
      passwordText!.isNotEmpty;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadingSignIn = true;
    pangeaController.checkHomeServerAction().then((value) {
      setState(() {
        loadingSignIn = false;
      });
    }).catchError((e) {
      final String err = e.toString();
      setState(() {
        loadingSignIn = false;
        passwordError = err.toLocalizedString(context);
      });
    });

    usernameController.addListener(() {
      _setStateOnTextChange(usernameText, usernameController.text);
      usernameText = usernameController.text;
    });

    passwordController.addListener(() {
      _setStateOnTextChange(passwordText, passwordController.text);
      passwordText = passwordController.text;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    loadingSignIn = false;
    usernameError = null;
    passwordError = null;
    super.dispose();
  }

  void setSSOError(String? error, SSOProvider provider) {
    if (provider == SSOProvider.apple) {
      appleSSOError = error;
      googleSSOError = null;
    } else if (provider == SSOProvider.google) {
      googleSSOError = error;
      appleSSOError = null;
    }
    if (mounted) setState(() {});
  }

  void setLoadingSSO(bool loading, SSOProvider provider) {
    if (provider == SSOProvider.apple) {
      loadingAppleSSO = loading;
      loadingGoogleSSO = false;
    } else if (provider == SSOProvider.google) {
      loadingGoogleSSO = loading;
      loadingAppleSSO = false;
    }
    if (mounted) setState(() {});
  }

  void _setStateOnTextChange(String? oldText, String newText) {
    if ((oldText == null || oldText.isEmpty) && (newText.isNotEmpty)) {
      setState(() {});
    }
    if ((oldText != null && oldText.isNotEmpty) && (newText.isEmpty)) {
      setState(() {});
    }
  }
  // Pangea#

  void toggleShowPassword() =>
      setState(() => showPassword = !loadingSignIn && !showPassword);

  void login() async {
    // #Pangea
    final valid = formKey.currentState!.validate();
    if (!valid) return;
    // Pangea#

    final matrix = Matrix.of(context);
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = L10n.of(context).pleaseEnterYourUsername);
    } else {
      setState(() => usernameError = null);
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = L10n.of(context).pleaseEnterYourPassword);
    } else {
      setState(() => passwordError = null);
    }

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    setState(() => loadingSignIn = true);

    _coolDown?.cancel();

    try {
      // #Pangea
      String username = usernameController.text.trim();
      if (RegExp(r'^@(\w+):').hasMatch(username)) {
        username =
            RegExp(r'^@(\w+):').allMatches(username).elementAt(0).group(1)!;
      }
      // Pangea#
      AuthenticationIdentifier identifier;
      if (username.isEmail) {
        identifier = AuthenticationThirdPartyIdentifier(
          medium: 'email',
          address: username,
        );
      } else if (username.isPhoneNumber) {
        identifier = AuthenticationThirdPartyIdentifier(
          medium: 'msisdn',
          address: username,
        );
      } else {
        identifier = AuthenticationUserIdentifier(user: username);
      }
      // #Pangea
      // await matrix.getLoginClient().login(
      final loginRes = await matrix.getLoginClient().login(
        // Pangea#
        LoginType.mLoginPassword,
        identifier: identifier,
        // To stay compatible with older server versions
        // ignore: deprecated_member_use
        user: identifier.type == AuthenticationIdentifierTypes.userId
            ? username
            : null,
        // #Pangea
        // password: passwordController.text,
        password: passwordController.text.trim(),
        // Pangea#
        initialDeviceDisplayName: PlatformInfos.clientName,
        // #Pangea
        onInitStateChanged: (state) {
          if (state == InitState.settingUpEncryption) {
            context.go("/rooms");
          }
        },
        // Pangea#
      );
      MatrixState.pangeaController.pStoreService
          .save(PLocalKey.loginType, 'password');
      // #Pangea
      GoogleAnalytics.login("pangea", loginRes.userId);
      // Pangea#
    } on MatrixException catch (exception) {
      // #Pangea
      // setState(() => passwordError = exception.errorMessage);
      setState(() {
        passwordError = exception.errorMessage;
        usernameError = exception.errorMessage;
      });
      // Pangea#
      return setState(() => loadingSignIn = false);
    } catch (exception) {
      // #Pangea
      // setState(() => passwordError = exception.toString());
      setState(() {
        passwordError = exception.toString();
        usernameError = exception.toString();
      });
      // Pangea#
      return setState(() => loadingSignIn = false);
    }

    // #Pangea
    // if (mounted) setState(() => loading = false);
    // Pangea#
  }

  Timer? _coolDown;

  void checkWellKnownWithCoolDown(String userId) async {
    _coolDown?.cancel();
    _coolDown = Timer(
      const Duration(seconds: 1),
      () => _checkWellKnown(userId),
    );
  }

  void _checkWellKnown(String userId) async {
    if (mounted) setState(() => usernameError = null);
    if (!userId.isValidMatrixId) return;
    final oldHomeserver = Matrix.of(context).getLoginClient().homeserver;
    try {
      var newDomain = Uri.https(userId.domain!, '');
      Matrix.of(context).getLoginClient().homeserver = newDomain;
      DiscoveryInformation? wellKnownInformation;
      try {
        wellKnownInformation =
            await Matrix.of(context).getLoginClient().getWellknown();
        if (wellKnownInformation.mHomeserver.baseUrl.toString().isNotEmpty) {
          newDomain = wellKnownInformation.mHomeserver.baseUrl;
        }
      } catch (_) {
        // do nothing, newDomain is already set to a reasonable fallback
      }
      if (newDomain != oldHomeserver) {
        await Matrix.of(context).getLoginClient().checkHomeserver(newDomain);

        if (Matrix.of(context).getLoginClient().homeserver == null) {
          Matrix.of(context).getLoginClient().homeserver = oldHomeserver;
          // okay, the server we checked does not appear to be a matrix server
          Logs().v(
            '$newDomain is not running a homeserver, asking to use $oldHomeserver',
          );
          final dialogResult = await showOkCancelAlertDialog(
            context: context,
            useRootNavigator: false,
            title: L10n.of(context)
                .noMatrixServer(newDomain.toString(), oldHomeserver.toString()),
            okLabel: L10n.of(context).ok,
            cancelLabel: L10n.of(context).cancel,
          );
          if (dialogResult == OkCancelResult.ok) {
            if (mounted) setState(() => usernameError = null);
          } else {
            Navigator.of(context, rootNavigator: false).pop();
            return;
          }
        }
        usernameError = null;
        if (mounted) setState(() {});
      } else {
        Matrix.of(context).getLoginClient().homeserver = oldHomeserver;
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      Matrix.of(context).getLoginClient().homeserver = oldHomeserver;
      usernameError = e.toLocalizedString(context);
      if (mounted) setState(() {});
    }
  }

  void passwordForgotten() async {
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context).passwordForgotten,
      message: L10n.of(context).enterAnEmailAddress,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      initialText:
          usernameController.text.isEmail ? usernameController.text : '',
      hintText: L10n.of(context).enterAnEmailAddress,
      keyboardType: TextInputType.emailAddress,
    );
    if (input == null) return;
    final clientSecret = DateTime.now().millisecondsSinceEpoch.toString();
    final response = await showFutureLoadingDialog(
      context: context,
      future: () =>
          Matrix.of(context).getLoginClient().requestTokenToResetPasswordEmail(
                clientSecret,
                input,
                sendAttempt++,
              ),
    );
    if (response.error != null) return;
    final password = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context).passwordForgotten,
      message: L10n.of(context).chooseAStrongPassword,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      hintText: '******',
      obscureText: true,
      minLines: 1,
      maxLines: 1,
    );
    if (password == null) return;
    final ok = await showOkAlertDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context).weSentYouAnEmail,
      // #Pangea
      // message: L10n.of(context).pleaseClickOnLink,
      message: L10n.of(context).clickOnEmailLink,
      // Pangea#
      okLabel: L10n.of(context).iHaveClickedOnLink,
    );
    if (ok != OkCancelResult.ok) return;
    final data = <String, dynamic>{
      'new_password': password,
      'logout_devices': false,
      "auth": AuthenticationThreePidCreds(
        type: AuthenticationTypes.emailIdentity,
        threepidCreds: ThreepidCreds(
          sid: response.result!.sid,
          clientSecret: clientSecret,
        ),
      ).toJson(),
    };
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).getLoginClient().request(
            RequestType.POST,
            '/client/v3/account/password',
            data: data,
          ),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).passwordHasBeenChanged)),
      );
      usernameController.text = input;
      passwordController.text = password;
      login();
    }
  }

  static int sendAttempt = 0;

  @override
  // #Pangea
  // Widget build(BuildContext context) => LoginView(this);
  Widget build(BuildContext context) => PangeaLoginView(this);
  // Pangea#
}

extension on String {
  static final RegExp _phoneRegex =
      RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  static final RegExp _emailRegex = RegExp(r'(.+)@(.+)\.(.+)');

  bool get isEmail => _emailRegex.hasMatch(this);

  bool get isPhoneNumber => _phoneRegex.hasMatch(this);
}
