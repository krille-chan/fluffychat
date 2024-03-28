import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:one_of/one_of.dart';
import 'package:tawkie/pages/login/change_username_page.dart';
import 'package:tawkie/pages/register/register_view.dart';
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
  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://staging.tawkie.fr/panel/api/.ory'));
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

  bool _validateEmail(String email) {
    // Define regex to validate email format
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Check if the email matches the regex
    if (!emailRegex.hasMatch(email)) {
      setState(() => emailError = L10n.of(context)?.register_emailError);
      return false;
    }

    // Reset email error if valid
    setState(() => emailError = null);
    return true;
  }

  bool _validatePassword(String password) {
    // Define regex to validate password format
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{3,16}$');

    // Check that the password matches the regex
    if (!passwordRegex.hasMatch(password)) {
      setState(
          () => passwordError = L10n.of(context)?.register_passwordErrorOne);
      return false;
    }

    // Check if the password contains one of the following keywords
    final List<String> keywords = ['password', '123456', 'qwerty'];
    for (final keyword in keywords) {
      if (password.contains(keyword)) {
        setState(
            () => passwordError = L10n.of(context)?.register_passwordErrorTwo);
        return false;
      }
    }

    // Reset password error if valid
    setState(() => passwordError = null);
    return true;
  }

  Future<void> register() async {
    setState(() => confirmPasswordError = null);

    if (emailController.text.isEmpty) {
      setState(() => emailError = L10n.of(context)!.register_requiredField);
      return;
    } else {
      setState(() => emailError = null);
    }

    if (!_validateEmail(emailController.text)) {
      return;
    }

    if (passwordController.text.isEmpty) {
      setState(() => passwordError = L10n.of(context)!.register_requiredField);
      return;
    } else {
      setState(() => passwordError = null);
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(() =>
          confirmPasswordError = L10n.of(context)!.register_requiredField);
      return;
    } else {
      setState(() => confirmPasswordError = null);
    }

    if (!_validatePassword(passwordController.text)) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() =>
          confirmPasswordError = L10n.of(context)!.register_notSamePassword);
      return;
    }

    setState(() => loading = true);

    try {
      final OryKratosClient kratosClient = OryKratosClient(dio: dio);

      // Fetch register flow
      final frontendApi = kratosClient.getFrontendApi();
      final response = await frontendApi.createNativeRegistrationFlow();
      final actionUrl = response.data?.ui.action;
      if (actionUrl == null) {
        throw Exception('Action URL not found in registration flow response');
      }

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
      final registerResponse = await frontendApi.updateRegistrationFlow(
        flow: response.data!.id,
        updateRegistrationFlowBody: updateRegisterFlowBody,
      );

      // Process registration response
      final sessionToken = registerResponse.data?.sessionToken;

      // Fetch user queue status
      final queueStatusResponse = await dio.get(
        'https://staging.tawkie.fr/panel/api/mobile-matrix-auth/getQueueStatus',
        options: Options(headers: {'X-Session-Token': sessionToken}),
      );
      final queueStatus = queueStatusResponse.data;

      if (queueStatus != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeUsernamePage(
              queueStatus: queueStatus,
              dio: dio,
              sessionToken: sessionToken!,
            ),
          ),
        );
      }

      if (kDebugMode) {
        print('Registration successful');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos log: $e\n");
      }
      Logs().v("Error Kratos login : ${e.response?.data}");

      // Display Kratos error messages to the user
      if (e.response!.data['ui']['messages'][0]['text'] != null) {
        final errorMessage = e.response!.data['ui']['messages'][0]['text'];
        setState(() => confirmPasswordError = errorMessage);
      } else {
        setState(() => confirmPasswordError = "Dio error with Kratos");
      }
      return setState(() => loading = false);
    } catch (exception) {
      setState(() => confirmPasswordError = exception.toString());
      return setState(() => loading = false);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => RegisterView(this);
}
