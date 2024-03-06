import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ory_kratos_client/ory_kratos_client.dart';
import 'login_view.dart';
import 'package:one_of/one_of.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  LoginController createState() => LoginController();
}

class LoginController extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? usernameError;
  String? passwordError;
  bool loading = false;
  bool showPassword = false;
  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://staging.tawkie.fr/panel/api/.ory'));

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> storeSessionToken(String? sessionToken) async {
    if (sessionToken != null) {
      await _secureStorage.write(key: 'sessionToken', value: sessionToken);
    }
  }

  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: 'sessionToken');
  }

  Future<String?> login() async {
    final OryKratosClient kratosClient = OryKratosClient(dio: dio);

    try {
      // Initialize API connection flow
      final frontendApi = kratosClient.getFrontendApi();
      final response = await frontendApi.createNativeLoginFlow();

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

      // Store the session token securely
      await storeSessionToken(sessionToken);

      return sessionToken;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  static int sendAttempt = 0;

  @override
  Widget build(BuildContext context) => LoginView(this);
}
