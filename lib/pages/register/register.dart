import 'dart:async';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/platform_infos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'register_view.dart';

class Register extends StatefulWidget {
  final Client client;
  const Register({required this.client, super.key});

  @override
  RegisterController createState() => RegisterController();
}

class RegisterController extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();

  String? emailError;
  String? usernameError;
  String? passwordError;
  String? genericError;

  bool loading = false;
  bool showPassword = false;

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

  Future<void> register() async {
    final isEmailValid = emailIsValid();
    final isUsernameValid = usernameIsValid();
    final isPasswordValid = passwordIsValid();

    if (!isEmailValid || !isUsernameValid || !isPasswordValid) return;

    setState(() => loading = true);

    final matrix = Matrix.of(context);
    final client = await matrix.getLoginClient();

    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final device = PlatformInfos.clientName;
    genericError = null;

    final token = dotenv.env['REGISTRATION_TOKEN'] ?? '';

    String? clientSecret;
    String? emailSid;

    clientSecret = const Uuid().v4();
    emailSid = await _sendEmailVerification(
      client: client,
      email: email,
      clientSecret: clientSecret,
    );

    if (emailSid == null) {
      setState(() => loading = false);
      return;
    }

    final confirmed = await _waitForUser(context) ?? false;
    if (!confirmed) {
      if (mounted) setState(() => loading = false);
      return;
    }

    await _runRegister(
      context,
      client,
      username: username,
      password: password,
      device: device,
      token: token,
      email: email,
      clientSecret: clientSecret,
      emailSid: emailSid,
    );

    if (mounted) setState(() => loading = false);
  }

  bool emailIsValid() {
    final email = emailController.text;
    if (email.isEmpty) {
      setState(() => emailError = L10n.of(context).errorMissingEmail);
      return false;
    }

    if (!RegExp(r'^[\w\.-]+@([\w-]+\.)+[A-Za-z]{2,}$').hasMatch(email)) {
      setState(() => emailError = L10n.of(context).errorInvalidEmail);
      return false;
    }

    setState(() => emailError = null);
    return true;
  }

  bool usernameIsValid() {
    final username = usernameController.text;
    if (username.isEmpty) {
      setState(() => usernameError = L10n.of(context).pleaseEnterYourUsername);
      return false;
    }
    setState(() => usernameError = null);
    return true;
  }

  bool passwordIsValid() {
    final password = passwordController.text;
    if (password.isEmpty) {
      setState(() => passwordError = L10n.of(context).pleaseEnterYourPassword);
      return false;
    }
    setState(() => passwordError = null);
    return true;
  }

  Future<String?> _sendEmailVerification({
    required Client client,
    required String email,
    required String clientSecret,
  }) async {
    try {
      final response = await client.request(
        RequestType.POST,
        '/client/v3/account/3pid/email/requestToken',
        data: {
          'client_secret': clientSecret,
          'email': email,
          'send_attempt': 1,
        },
      );

      final sid = response['sid'];
      if (sid is String && sid.isNotEmpty) {
        setState(() => emailError = null);
        return sid;
      }

      setState(() => _showGenericError());
      return null;
    } on MatrixException catch (e) {
      if (e.error == MatrixError.M_THREEPID_IN_USE) {
        setState(() => emailError = L10n.of(context).errorEmailInUse);
      } else {
        setState(() => _showGenericError());
      }
      return null;
    } catch (_) {
      setState(() => _showGenericError());
      return null;
    }
  }

  _showGenericError() {
    genericError = L10n.of(context).errorGeneric;
  }

  Future<bool?> _waitForUser(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(L10n.of(context).dialogVerifyEmailTitle),
        content: Text(L10n.of(context).dialogVerifyEmailContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(L10n.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(L10n.of(context).buttonOkClicked),
          ),
        ],
      ),
    );
  }

  Future<void> _runRegister(
    BuildContext context,
    Client client, {
    required String username,
    required String password,
    required String device,
    required String token,
    required String email,
    required String clientSecret,
    required String emailSid,
  }) async {
    String? session;

    try {
      await client.register(
        username: username,
        password: password,
        initialDeviceDisplayName: device,
      );
      return;
    } on MatrixException catch (e) {
      session = e.session;
      if (e.error == MatrixError.M_USER_IN_USE) {
        usernameError = L10n.of(context).errorUsernameInUse;
        return;
      }

      if (e.error == MatrixError.M_INVALID_USERNAME) {
        usernameError = L10n.of(context).errorInvalidUsername;
        return;
      }

      if (session == null) {
        _showGenericError();
        return;
      }
    }

    try {
      await client.register(
        username: username,
        password: password,
        initialDeviceDisplayName: device,
        auth: RegistrationTokenAuth(session: session!, token: token),
      );
    } on MatrixException catch (e) {
      if (e.session != null &&
          e.completedAuthenticationFlows
              .contains('m.login.registration_token')) {
        session = e.session;
      } else {
        _showGenericError();
        return;
      }
    }

    bool emailConfirmed = false;

    while (!emailConfirmed) {
      try {
        await client.register(
          username: username,
          password: password,
          initialDeviceDisplayName: device,
          auth: SidAuth(
            session: session!,
            sid: emailSid,
            clientSecret: clientSecret,
          ),
        );
        emailConfirmed = true;
      } on MatrixException catch (e) {
        if (e.error == MatrixError.M_UNAUTHORIZED ||
            e.error == MatrixError.M_THREEPID_AUTH_FAILED) {
          final confirmed = await _waitForUser(context) ?? false;
          if (!confirmed) return;
          continue;
        }

        if (e.error == MatrixError.M_THREEPID_IN_USE) {
          emailError = L10n.of(context).errorEmailInUse;
          return;
        }

        _showGenericError();
        return;
      }
    }

    await client.joinRoom('#geral:radiohemp.com');
  }

  @override
  Widget build(BuildContext context) => RegisterView(
        this,
        client: widget.client,
      );

  void onMoreAction(MoreLoginActions action) {
    PlatformInfos.showDialog(context);
  }
}

enum MoreLoginActions { importBackup, privacy, about }

class RegistrationTokenAuth extends AuthenticationData {
  final String token;

  RegistrationTokenAuth({
    required String session,
    required this.token,
  }) : super(
          type: 'm.login.registration_token',
          session: session,
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json['token'] = token;
    return json;
  }
}

class SidAuth extends AuthenticationData {
  final String sid;
  final String clientSecret;

  SidAuth(
      {required String session, required this.sid, required this.clientSecret})
      : super(
          type: 'm.login.email.identity',
          session: session,
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json['threepid_creds'] = {
      'sid': sid,
      'client_secret': clientSecret,
    };
    return json;
  }
}
