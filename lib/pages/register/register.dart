import 'dart:async';
import 'dart:convert';

import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:one_of/one_of.dart';
import 'package:tawkie/pages/register/register_view.dart';
import 'package:ory_kratos_client/ory_kratos_client.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterController createState() => RegisterController();
}

class RegisterController extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? emailError;
  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;
  bool loading = false;
  bool showPassword = false;
  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://staging.tawkie.fr/panel/api/.ory'));
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

  Future<void> register() async {
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      // Todo: Display an error
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      // Todo: Display an error
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
      final userId = registerResponse.data?.identity.id;

      // Fetch user queue status
      final queueStatusResponse = await dio.get(
        'https://staging.tawkie.fr/panel/api/mobile-matrix-auth/getQueueStatus',
        options: Options(headers: {'X-Session-Token': sessionToken}),
      );
      final queueStatus = queueStatusResponse.data;
      final queuePosition = queueStatus['queuePosition'];
      final queueState = queueStatus['userState'];

      if (queueState != 'IN_QUEUE') {
        throw Exception('Error during queue status: unexpected state');
      }

      // Update username
      final updateUsernameResponse = await dio.post(
        'https://staging.tawkie.fr/panel/api/mobile-matrix-auth/updateUsername',
        options: Options(headers: {'X-Session-Token': sessionToken}),
        data: jsonEncode({'username': usernameController.text}),
      );
      final matrixUsername = updateUsernameResponse.data['username'];

      if (matrixUsername != usernameController.text) {
        throw Exception('Error during username update');
      }

      // TODO: Accept user
      // TODO: Create matrix user
      // TODO: Output message / send email

      print('Registration successful');
    } on DioException catch (exception) {
      setState(() => confirmPasswordError = exception.response?.data);
      //Todo: Better error message recovery
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
