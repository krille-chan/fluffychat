import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:one_of/one_of.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/pages/login/change_username_page.dart';
import 'package:tawkie/pages/register/register_view.dart';
import 'package:tawkie/widgets/show_error_dialog.dart';
import 'package:ory_kratos_client/ory_kratos_client.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterController createState() => RegisterController();
}

class RegisterController extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  bool loading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String baseUrl = AppConfig.baseUrl;
  late final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

  void toggleShowConfirmPassword() =>
      setState(() => showConfirmPassword = !loading && !showConfirmPassword);

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(baseUrl: '${baseUrl}panel/api/.ory'));
  }

  Future<void> storeSessionToken(String? sessionToken) async {
    if (sessionToken != null) {
      await _secureStorage.write(key: 'sessionToken', value: sessionToken);
    }
  }

  bool _validateEmail(String email) {
    // Define regex to validate email format
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Check if the email matches the regex
    if (!emailRegex.hasMatch(email)) {
      setState(() => emailError = L10n.of(context)?.registerEmailError);
      return false;
    }

    // Reset email error if valid
    setState(() => emailError = null);
    return true;
  }

  // Checks password length
  bool _validatePasswordLength(String password) {
    return password.length >= 8 && password.length <= 64;
  }

  bool _validatePassword(String password) {
    // Define regex to validate password format and length

    // Check that the password matches the regex
    if (!_validatePasswordLength(passwordController.text)) {
      setState(() => passwordError = L10n.of(context)?.registerPasswordError);
      return false;
    }

    // Reset password error if valid
    setState(() => passwordError = null);
    return true;
  }

  Future<void> register() async {
    setState(() => confirmPasswordError = null);

    if (emailController.text.isEmpty) {
      setState(() => emailError = L10n.of(context)!.registerRequiredField);
      return;
    } else {
      setState(() => emailError = null);
    }

    if (!_validateEmail(emailController.text)) {
      setState(() => emailError = L10n.of(context)!.registerInvalidEmail);
      return;
    }

    if (passwordController.text.isEmpty) {
      setState(() => passwordError = L10n.of(context)!.registerRequiredField);
      return;
    } else {
      setState(() => passwordError = null);
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(
          () => confirmPasswordError = L10n.of(context)!.registerRequiredField);
      return;
    } else {
      setState(() => confirmPasswordError = null);
    }

    if (!_validatePassword(passwordController.text)) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() =>
          confirmPasswordError = L10n.of(context)!.registerNotSamePassword);
      return;
    }

    setState(() => loading = true);

    try {
      final OryKratosClient kratosClient = OryKratosClient(dio: dio);

      Logs().v('Registering user with email: ${emailController.text}');
      // Fetch register flow
      final frontendApi = kratosClient.getFrontendApi();
      final response = await frontendApi.createNativeRegistrationFlow();
      final actionUrl = response.data?.ui.action;
      if (actionUrl == null) {
        throw Exception('Action URL not found in registration flow response');
      }

      Logs().v('Register flow ID: ${response.data!.id}');

      // Creation of an UpdateLoginFlowWithPasswordMethod object with identifiers
      final updateRegistrationFlowWithPasswordMethod =
          UpdateRegistrationFlowWithPasswordMethod((builder) => builder
            ..traits = JsonObject({'email': emailController.text})
            ..method = 'password'
            ..password = passwordController.text);

      // Create an UpdateRegistrationFlowBody object and assign it the UpdateLoginFlowWithPasswordMethod object
      final updateRegisterFlowBody = UpdateRegistrationFlowBody(
        (builder) => builder
          ..oneOf =
              OneOf.fromValue1(value: updateRegistrationFlowWithPasswordMethod),
      );


      // Send POST request to complete registration
      Logs().v('Completing registration flow');
      final registerResponse = await frontendApi.updateRegistrationFlow(
        flow: response.data!.id,
        updateRegistrationFlowBody: updateRegisterFlowBody,
      );

      // Process registration response
      final sessionToken = registerResponse.data?.sessionToken;
      final userId = registerResponse.data!.identity!.id;

      // Store kratos session token
      await storeSessionToken(sessionToken);
      // Indicate new App User Id to RevenueCat
      await Purchases.logIn(userId);

      Logs().v('Registration successful');
      // redirect to login page, which will handle the matrix login
      // and onboarding
      context.go('/home/login');

      if (kDebugMode) {
        print('Registration successful');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Dio Exception when calling Kratos log: $e\n");
      }
      Logs().v("Error Kratos login : ${e.response?.data}");
      if (e.error is SocketException) {
        // Connection errors
        DioErrorHandler.showNetworkErrorDialog(context);

        return setState(() => loading = false);
      }
      // Display Kratos error messages to the user
      try {
        final nodes = e.response!.data['ui']['nodes'];
        final messages = e.response!.data['ui']['messages'];

        final bool hasMessages = messages is List && messages.length > 0;
        final bool hasEmailError = nodes.length >= 3 && nodes[1]['messages'].length > 0;
        final bool hasPasswordError = nodes.length >= 3 && nodes[2]['messages'].length > 0;

        if (hasMessages) {
          setState(() => confirmPasswordError = messages[0]['text']);
        } else if (hasEmailError) {
          final errorMessage = nodes[1]['messages'][0]['text'];
          setState(() => emailError = errorMessage);
        } else if (hasPasswordError) {
          final errorMessage = nodes[2]['messages'][0]['text'];
          setState(() => confirmPasswordError = errorMessage);
        } else {
          setState(() => confirmPasswordError = "Error registering. Please contact support");
        }
      } catch (exception) {
        Logs().v("Error Kratos loginhihi : $exception");
        setState(() => confirmPasswordError = "Error registering. Please contact support.");
      }
      return setState(() => loading = false);
    } catch (exception) {
      if (kDebugMode) {
        print("Non-Dio Exception while registering: $exception\n");
      }
      setState(() => confirmPasswordError = exception.toString());
      return setState(() => loading = false);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => RegisterView(this);
}
