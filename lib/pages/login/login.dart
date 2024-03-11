import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:ory_kratos_client/ory_kratos_client.dart';
import 'package:ory_kratos_client/src/model/login_flow.dart' as kratos;
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'login_view.dart';
import 'package:one_of/one_of.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginController createState() => LoginController();
}

class LoginController extends State<Login> {
  Map<String, dynamic>? _rawLoginTypes;
  HomeserverSummary? loginHomeserverSummary;
  bool _supportsFlow(String flowType) =>
      loginHomeserverSummary?.loginFlows.any((flow) => flow.type == flowType) ??
      false;

  bool get supportsSso => _supportsFlow('m.login.sso');

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? usernameError;
  String? passwordError;
  bool loading = false;
  bool showPassword = false;
  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://staging.tawkie.fr/panel/api/.ory'));

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

  Future<void> storeSessionToken(String? sessionToken) async {
    if (sessionToken != null) {
      await _secureStorage.write(key: 'sessionToken', value: sessionToken);
      // Once the session token has been stored, launch login
      await loginWithSessionToken(sessionToken);
    }
  }

  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: 'sessionToken');
  }

  void login() async {
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = L10n.of(context)!.pleaseEnterYourUsername);
    } else {
      setState(() => usernameError = null);
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = L10n.of(context)!.pleaseEnterYourPassword);
    } else {
      setState(() => passwordError = null);
    }

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    setState(() => loading = true);

    _coolDown?.cancel();

    final OryKratosClient kratosClient = OryKratosClient(dio: dio);

    try {
      // Initialize API connection flow
      final frontendApi = kratosClient.getFrontendApi();
      Response<kratos.LoginFlow> response;
      if (PlatformInfos.isWeb) {
        response = await frontendApi.createBrowserLoginFlow();
      } else {
        response = await frontendApi.createNativeLoginFlow();
      }

      // Retrieve action URL from connection flow
      final actionUrl = response.data?.ui.action;
      if (actionUrl == null) {
        throw Exception('Action URL not found in login flow response');
      }

      // Retrieving TextEditingControllers values
      final String email = usernameController.text;
      final String password = passwordController.text;

      // Creation of an UpdateLoginFlowWithPasswordMethod object with identifiers
      final updateLoginFlowWithPasswordMethod =
          UpdateLoginFlowWithPasswordMethod((builder) => builder
            ..identifier = email
            ..method = 'password'
            ..password = password);

      // Create an UpdateLoginFlowBodyBuilder object and assign it the UpdateLoginFlowWithPasswordMethod object
      final updateLoginFlowBody = UpdateLoginFlowBody(
        (builder) => builder
          ..oneOf = OneOf.fromValue1(value: updateLoginFlowWithPasswordMethod),
      );

      // Sends a POST request with user credentials
      final loginResponse = await frontendApi.updateLoginFlow(
          flow: response.data!.id, updateLoginFlowBody: updateLoginFlowBody);

      // Processing the response to obtain the connection session token
      final sessionToken = loginResponse.data?.sessionToken;

      // Store the session token
      return await storeSessionToken(sessionToken);
    } on MatrixException catch (exception) {
      setState(() => passwordError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      print(exception);
      setState(() => passwordError = L10n.of(context)!.err_usernameOrPassword);
      return setState(() => loading = false);
    }
  }

  Timer? _coolDown;

  Future<void> loginWithSessionToken(String sessionToken) async {
    final matrix = Matrix.of(context);

    setState(() => loading = true);

    try {
      final responseMatrix = await dio.get(
        'https://staging.tawkie.fr/panel/api/mobile-matrix-auth/getMatrixToken',
        options: Options(
          headers: {
            'X-Session-Token': sessionToken,
          },
        ),
      );

      final Map<String, dynamic> responseData = responseMatrix.data;

      final String matrixLoginJwt = responseData['matrixLoginJwt'];
      final String serverName = responseData['serverName'];

      var homeserver = Uri.parse(serverName);
      if (homeserver.scheme.isEmpty) {
        homeserver = Uri.https(serverName, '');
      }

      final client = Matrix.of(context).getLoginClient();
      loginHomeserverSummary = await client.checkHomeserver(homeserver);
      if (supportsSso) {
        _rawLoginTypes = await client.request(
          RequestType.GET,
          '/client/v3/login',
        );
      }

      const url = 'https://matrix.staging.tawkie.fr/_matrix/client/r0/login';
      final headers = {'Content-Type': 'application/json'};
      final data = {'type': 'org.matrix.login.jwt', 'token': matrixLoginJwt};

      try {
        final response = await dio.post(
          url,
          options: Options(headers: headers),
          data: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          final responseData = response.data;
          final userId = responseData['user_id'];
          final accessToken = responseData['access_token'];
          final deviceId = responseData['device_id'];

          // Initialize with recovered data
          try {
            await matrix.getLoginClient().init(
                  newToken: accessToken,
                  newUserID: userId,
                  newHomeserver: homeserver,
                  newDeviceID: deviceId,
                  newDeviceName: PlatformInfos.clientName,
                );
          } catch (e) {
            Logs().v("l'init: $e");
          }
        } else {
          Logs().v('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        Logs().v('Exception during login: $e');
      }
    } on MatrixException catch (exception) {
      setState(() => passwordError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      setState(() => passwordError = exception.toString());
      return setState(() => loading = false);
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => LoginView(this);
}
