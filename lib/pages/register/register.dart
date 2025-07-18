import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/platform_infos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'register_view.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';
import '../../utils/platform_infos.dart';
import 'package:url_launcher/url_launcher.dart';

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

    await _runRegister(
      context,
      client,
      username: username,
      password: password,
      device: device,
      email: email,
    );

    if (mounted) setState(() => loading = false);
  }

  bool emailIsValid() {
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    final email = emailController.text.trim(); // remove espaços acidentais

    if (email.isEmpty) {
      setState(() => emailError = L10n.of(context).errorMissingEmail);
      return false;
    }

    if (!emailRegex.hasMatch(email)) {
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
    final l10n = L10n.of(context);

    if (password.isEmpty) {
      setState(() => passwordError = l10n.pleaseEnterYourPassword);
      return false;
    }

    final validPasswordRegex = RegExp(
      r'^(?=.*[0-9])(?=.*[!@#\$%^&*()_+{}\[\]:;<>,.?~\\/-])[A-Za-z\d!@#\$%^&*()_+{}\[\]:;<>,.?~\\/-]{6,}$',
    );

    if (!validPasswordRegex.hasMatch(password)) {
      setState(() => passwordError = l10n.pleaseUseAStrongPassword);
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
        title: Text(L10n.of(context).dialogVerifyEmailTitle.toUpperCase()),
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
    required String email,
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

    bool emailConfirmed = await _confirmEmail(
      context,
      client,
      username,
      password,
      device,
      session,
      emailSid,
      clientSecret,
    );

    if (!emailConfirmed) {
      setState(() => loading = false);
      return;
    }

    final token = await _generateRegistrationToken(session);

    try {
      await client.register(
        username: username,
        password: password,
        initialDeviceDisplayName: device,
        auth: RegistrationTokenAuth(session: session, token: token),
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

    await client.joinRoom('#geral:radiohemp.com');
  }

  Future<bool> _confirmEmail(
    BuildContext context,
    Client client,
    String username,
    String password,
    String device,
    String session,
    String emailSid,
    String clientSecret,
  ) async {
    var emailConfirmed = false;
    const timeoutSeconds = 300;
    final timeout = DateTime.now().add(const Duration(seconds: timeoutSeconds));

    while (!emailConfirmed && DateTime.now().isBefore(timeout)) {
      final confirmed = await _waitForUser(context) ?? false;
      if (!confirmed) {
        if (mounted) setState(() => loading = false);
        return false;
      }

      try {
        await client.register(
          username: username,
          password: password,
          initialDeviceDisplayName: device,
          auth: SidAuth(
            session: session,
            sid: emailSid,
            clientSecret: clientSecret,
          ),
        );
        emailConfirmed = true;
        break;
      } on MatrixException catch (e) {
        final completed = (e.completedAuthenticationFlows as List?) ?? [];
        if (completed.contains('m.login.email.identity')) {
          emailConfirmed = true;
          break;
        }

        if (e.error == MatrixError.M_THREEPID_IN_USE) {
          emailError = L10n.of(context).errorEmailInUse;
          return false;
        }
      }
    }

    if (!emailConfirmed) {
      _showGenericError();
    }

    return emailConfirmed;
  }

  Future<String> _generateRegistrationToken(String session) async {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$apiUrl/matrix/registration-token');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'session': session}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final token = body['token'];
      if (token is String && token.isNotEmpty) {
        return token;
      }
      throw Exception('Resposta não contém token válido.');
    }

    throw Exception('Erro ${response.statusCode}: ${response.reasonPhrase}');
  }

  @override
  Widget build(BuildContext context) => RegisterView(
        this,
        client: widget.client,
      );
}

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
