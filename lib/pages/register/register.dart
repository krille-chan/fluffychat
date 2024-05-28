import 'dart:async';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:one_of/one_of.dart';
import 'package:ory_kratos_client/ory_kratos_client.dart' as kratos;
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/pages/register/register_view.dart';
import 'package:tawkie/widgets/show_error_dialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterController createState() => RegisterController();
}

class RegisterController extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  String? messageError;
  bool loading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String baseUrl = AppConfig.baseUrl;
  late final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  kratos.FrontendApi? api;
  String? flowId;
  List<Widget> authWidgets = [];
  List<TextEditingController> textControllers = [];
  List<kratos.UiNode> formNodes = [];

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
      setState(() => messageError = L10n.of(context)?.registerEmailError);
      return false;
    }

    // Reset email error if valid
    setState(() => messageError = null);
    return true;
  }

  // Checks password length
  bool _validatePasswordLength(String password) {
    return password.length >= 8 && password.length <= 64;
  }

  Future<void> processKratosNodes(
      BuiltList<kratos.UiNode> nodes, String actionUrl) async {
    List<Widget> formWidgets = [];
    List<kratos.UiNode> allNodes = [];

    for (kratos.UiNode node in nodes) {
      kratos.UiNodeInputAttributes attributes =
          node.attributes.oneOf.value as kratos.UiNodeInputAttributes;
      var controller =
          TextEditingController(text: attributes.value?.toString() ?? "");

      textControllers.add(controller);

      if (node.type == kratos.UiNodeTypeEnum.input) {
        Widget inputWidget;

        if (attributes.type == kratos.UiNodeInputAttributesTypeEnum.text) {
          inputWidget = Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: controller,
              onChanged: (String data) {},
              decoration: InputDecoration(
                label: Text(node.meta.label!.text),
              ),
              enabled: !attributes.disabled,
            ),
          );
        } else if (attributes.type ==
            kratos.UiNodeInputAttributesTypeEnum.submit) {
          inputWidget = Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                _submitForm(actionUrl);
              },
              child: Text(node.meta.label!.text),
            ),
          );
        } else {
          inputWidget = Container(); // Placeholder for unsupported types
        }

        formWidgets.add(inputWidget);
        allNodes.add(node);
      }

      setState(() => loading = false);
    }

    setState(() {
      authWidgets = formWidgets;
      formNodes = allNodes;
      loading = false;
    });
  }

  Future<void> _submitForm(String actionUrl) async {
    setState(() => loading = true);
    final formData = <String, dynamic>{};
    String? email;
    String? code;

    final kratos.OryKratosClient kratosClient =
        kratos.OryKratosClient(dio: dio);

    // Update node values with controller values
    for (int i = 0; i < formNodes.length; i++) {
      final kratos.UiNode node = formNodes[i];
      if (node.attributes.oneOf.value is kratos.UiNodeInputAttributes) {
        final kratos.UiNodeInputAttributes attributes =
            node.attributes.oneOf.value as kratos.UiNodeInputAttributes;
        final value = textControllers[i].text;

        formData[attributes.name] = value; // Convert JsonObject to String

        if (attributes.name == 'identifier') {
          email = value;
        } else if (attributes.name == 'resend') {
          code = value;
        }
      }
    }

    if (email != null && email.isNotEmpty && code != null && code.isNotEmpty) {
      await oryRegisterWithCode(email, code, kratosClient);
    } else {
      try {
        final response = await dio.post(
          actionUrl,
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          print('Succès: ${response.data}');
        } else {
          print('Erreur: ${response.data}');
        }
      } on DioException catch (e) {
        if (kDebugMode) {
          print('Erreur lors de la soumission du formulaire: $e');
        }
        if (e.response != null) {
          // Unserialize the JSON response in LoginFlow
          final responseData = e.response?.data;
          final loginFlow = kratosClient.serializers
              .deserializeWith(kratos.LoginFlow.serializer, responseData);

          setState(() => flowId = loginFlow?.id);

          // new response to retrieve nodes and action URL
          final newNodes = loginFlow?.ui.nodes;
          final newActionUrl = loginFlow?.ui.action;

          if (newNodes != null && newActionUrl != null) {
            await processKratosNodes(newNodes, newActionUrl);
          }
        }
      }
    }
  }

  Future<void> oryRegisterWithCode(
      String email, String code, kratos.OryKratosClient kratosClient) async {
    //Creation of an UpdateLoginFlowWithPasswordMethod object with identifiers
    final updateRegistrationFlowWithPasswordMethod =
        kratos.UpdateRegistrationFlowWithCodeMethod(
      (builder) => builder
        ..traits = JsonObject({'email': email})
        ..method = 'code'
        ..code = code
        ..csrfToken = "", // Assuming csrfToken is not required for mobile
    );

    // Create an UpdateRegistrationFlowBody object and assign it the UpdateLoginFlowWithPasswordMethod object
    final updateRegisterFlowBody = kratos.UpdateRegistrationFlowBody(
      (builder) => builder
        ..oneOf =
            OneOf.fromValue1(value: updateRegistrationFlowWithPasswordMethod),
    );

    final frontendApi = kratosClient.getFrontendApi();

    try {
      // Send POST request to complete registration
      Logs().v('Completing registration flow');
      final registerResponse = await frontendApi.updateRegistrationFlow(
        flow: flowId!,
        updateRegistrationFlowBody: updateRegisterFlowBody,
      );

      // Process registration response
      final sessionToken = registerResponse.data?.sessionToken;

      // Store kratos session token
      await storeSessionToken(sessionToken);

      Logs().v('Registration successful');
      // redirect to login page, which will handle the matrix login
      // and onboarding
      context.go('/home/login');

      if (kDebugMode) {
        print('Registration successful');
      }
    } on MatrixException catch (exception) {
      setState(() => messageError = exception.errorMessage);
      return setState(() => loading = false);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos log: $e\n");
      }
      Logs().v("Error Kratos login : ${e.response?.data}");

      // Display Kratos error messages to the user
      if (e.response?.data != null) {
        final errorMessage = e.response!.data['ui']['messages'][0]['text'];
        setState(() => messageError = errorMessage);
      } else {
        setState(
          () => messageError = L10n.of(context)!.errTryAgain,
        );
      }
      return setState(() => loading = false);
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
      setState(() => messageError = L10n.of(context)!.errUsernameOrPassword);
      return setState(() => loading = false);
    }
  }

  Future<void> register() async {
    if (emailController.text.isEmpty) {
      setState(() => messageError = L10n.of(context)!.registerRequiredField);
      return;
    } else {
      setState(() => messageError = null);
    }

    if (!_validateEmail(emailController.text)) {
      setState(() => messageError = L10n.of(context)!.registerInvalidEmail);
      return;
    }

    setState(() => loading = true);

    try {
      final kratos.OryKratosClient kratosClient =
          kratos.OryKratosClient(dio: dio);

      Logs().v('Registering user with email: ${emailController.text}');
      // Fetch register flow
      final frontendApi = kratosClient.getFrontendApi();
      final response = await frontendApi.createNativeRegistrationFlow();
      final actionUrl = response.data?.ui.action;
      if (actionUrl == null) {
        throw Exception('Action URL not found in registration flow response');
      }

      Logs().v('Register flow ID: ${response.data!.id}');
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

        final bool hasMessages = messages is List && messages.isNotEmpty;
        final bool hasEmailError =
            nodes.length >= 3 && nodes[1]['messages'].length > 0;
        final bool hasPasswordError =
            nodes.length >= 3 && nodes[2]['messages'].length > 0;

        if (hasMessages) {
          setState(() => messageError = messages[0]['text']);
        } else if (hasEmailError) {
          final errorMessage = nodes[1]['messages'][0]['text'];
          setState(() => messageError = errorMessage);
        } else if (hasPasswordError) {
          final errorMessage = nodes[2]['messages'][0]['text'];
          setState(() => messageError = errorMessage);
        } else {
          setState(
              () => messageError = "Error registering. Please contact support");
        }
      } catch (exception) {
        Logs().v("Error Kratos loginhihi : $exception");
        setState(
            () => messageError = "Error registering. Please contact support.");
      }
      return setState(() => loading = false);
    } catch (exception) {
      if (kDebugMode) {
        print("Non-Dio Exception while registering: $exception\n");
      }
      setState(() => messageError = exception.toString());
      return setState(() => loading = false);
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => RegisterView(this);
}
