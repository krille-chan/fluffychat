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

    final token = dotenv.env['REGISTER_TOKEN'] ?? '';

    String? clientSecret;
    String? emailSid;

    clientSecret = const Uuid().v4();
    emailSid = await _sendEmailVerification(
      client: client,
      email: email,
      clientSecret: clientSecret,
    );

    if (emailSid == null) {
      return;
    }

    _waitForUser(context);

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
      setState(() => emailError = 'Por favor, adicione um e-mail');
      return false;
    }

    if (!RegExp(r'^[\w\.-]+@([\w-]+\.)+[A-Za-z]{2,}$').hasMatch(email)) {
      setState(() => emailError = 'E-mail em formato inválido');
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
        return sid;
      }

      _showGenericError();
      return null;
    } on MatrixException catch (e) {
      if (e.error == MatrixError.M_THREEPID_IN_USE) {
        emailError = "Esse e-mail já está sendo usado";
      } else {
        _showGenericError();
      }
      return null;
    } catch (_) {
      _showGenericError();
      return null;
    }
  }

  _showGenericError() {
    genericError = "Ops... algo deu errado!";
  }

  Future<void> _waitForUser(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Verifique seu e-mail'),
        content: const Text('Clique no link de verificação que foi enviado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok, já cliquei'),
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
    AuthenticationData? auth,
  }) async {
    try {
      await client.register(
        username: username,
        password: password,
        initialDeviceDisplayName: device,
        auth: auth,
      );

      try {
        await client.add3PID(clientSecret, emailSid);
      } on MatrixException catch (e) {
        final session = e.session;
        if (session == null) {
          rethrow;
        }

        await client.request(
          RequestType.POST,
          '/client/v3/account/3pid',
          data: {
            'three_pid_creds': {
              'sid': emailSid,
              'client_secret': clientSecret,
            },
            'auth': {
              'type': 'm.login.password',
              'session': session,
              'user': username,
              'password': password,
            },
          },
        );
      }

      await client.joinRoom('#geral:radiohemp.com');

      return;
    } on MatrixException catch (e) {
      final session = e.session;
      if (session == null) {
        rethrow;
      }

      final flows = e.authenticationFlows ?? [];
      final completed = e.completedAuthenticationFlows;
      final missing = flows
          .expand((f) => f.stages)
          .toSet()
          .difference(completed.toSet())
          .toList();

      if (missing.isEmpty) rethrow;

      final next = missing.first;
      late AuthenticationData nextAuth;

      switch (next) {
        case 'm.login.registration_token':
          nextAuth = RegistrationTokenAuth(
            session: session,
            token: token,
          );
          break;

        case 'm.login.dummy':
          nextAuth = AuthenticationData(
            type: 'm.login.dummy',
            session: session,
          );
          break;

        case 'm.login.email.identity':
          nextAuth = SidAuth(
            session: session,
            sid: emailSid!,
            clientSecret: clientSecret!,
          );
          break;

        default:
          rethrow;
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
        auth: nextAuth,
      );
    }
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
    json['sid'] = sid;
    json['clientSecret'] = clientSecret;

    return json;
  }
}
