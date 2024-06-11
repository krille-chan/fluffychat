import 'dart:async';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
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
import 'package:tawkie/pages/register/privacy_polocy_text.dart';
import 'package:tawkie/pages/register/register_view.dart';
import 'package:tawkie/widgets/show_error_dialog.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterController createState() => RegisterController();
}

class RegisterController extends State<Register> {
  String? messageError;
  bool loading = true;
  String baseUrl = AppConfig.baseUrl;
  late final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  kratos.FrontendApi? api;
  String? flowId;
  List<Widget> authWidgets = [];
  Map<String, TextEditingController> textControllers = {};
  Map<String, kratos.UiNode> formNodes = {};

  // If the submit button has already been pressed
  bool hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(onBackButtonPress);

    dio = Dio(BaseOptions(baseUrl: '${baseUrl}panel/api/.ory'));

    register();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(onBackButtonPress);
    super.dispose();
  }

  Future<bool> onBackButtonPress(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    popFormWidgets();
    return true;
  }

  // How to return to the previous list
  void popFormWidgets() {
    if (hasSubmitted) {
      register();
    }
  }

  Future<void> storeSessionToken(String? sessionToken) async {
    if (sessionToken != null) {
      await _secureStorage.write(key: 'sessionToken', value: sessionToken);
    }
  }

  Future<void> processKratosNodes(
      BuiltList<kratos.UiNode> nodes, String actionUrl) async {
    final List<Widget> formWidgets = [];
    final Map<String, kratos.UiNode> allNodes = {};

    for (final kratos.UiNode node in nodes) {
      final attributes =
          node.attributes.oneOf.value as kratos.UiNodeInputAttributes;
      final controller =
          TextEditingController(text: attributes.value?.toString() ?? "");

      // Adding the controller to the map
      textControllers[attributes.name] = controller;

      Widget widget;
      if (attributes.type == kratos.UiNodeInputAttributesTypeEnum.email) {
        widget = _buildEmailInputWidget(attributes, controller, node);
      } else {
        switch (attributes.type) {
          case kratos.UiNodeInputAttributesTypeEnum.hidden:
            widget = _buildHiddenWidget(attributes);
            break;
          case kratos.UiNodeInputAttributesTypeEnum.text:
            widget = _buildTextInputWidget(attributes, controller, node);
            break;
          case kratos.UiNodeInputAttributesTypeEnum.submit:
            widget = _buildSubmitButton(attributes, actionUrl, node);
            break;
          default:
            widget = Container(); // Placeholder for unsupported types
        }
      }

      formWidgets.add(widget);
      allNodes[attributes.name] = node;
    }

    setState(() {
      authWidgets = formWidgets;
      formNodes = allNodes;
      loading = false;
    });
  }

  Widget _buildHiddenWidget(kratos.UiNodeInputAttributes attributes) {
    if (attributes.name == "traits.email") {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
            "${L10n.of(context)!.authCodeSentTo} ${attributes.value!}" ?? ""),
      );
    }
    return Container();
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

  Widget _buildEmailInputWidget(
    kratos.UiNodeInputAttributes attributes,
    TextEditingController controller,
    kratos.UiNode node,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(node.meta.label!.text),
        ),
        keyboardType: TextInputType.emailAddress,
        enabled: !attributes.disabled,
      ),
    );
  }

  Widget _buildTextInputWidget(
    kratos.UiNodeInputAttributes attributes,
    TextEditingController controller,
    kratos.UiNode node,
  ) {
    return Padding(
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
  }

  Widget _buildSubmitButton(kratos.UiNodeInputAttributes attributes,
      String actionUrl, kratos.UiNode node) {
    if (attributes.name == "resend") {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextButton(
          onPressed: () {
            _resendCode(actionUrl);
          },
          child: Text(node.meta.label!.text),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const PrivacyPolicyText(),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppConfig.primaryColor,
              ),
              onPressed: () {
                _submitForm(actionUrl);
              },
              child: Text(
                node.meta.label!.text,
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _submitForm(String actionUrl) async {
    setState(() {
      loading = true;
      hasSubmitted = true;
    });
    final formData = <String, dynamic>{};
    String? email;
    String? code;

    final kratos.OryKratosClient kratosClient =
        kratos.OryKratosClient(dio: dio);

    // Update node values with controller values
    formNodes.forEach((key, node) {
      if (node.attributes.oneOf.value is kratos.UiNodeInputAttributes) {
        final kratos.UiNodeInputAttributes attributes =
            node.attributes.oneOf.value as kratos.UiNodeInputAttributes;
        String value = textControllers[attributes.name]?.text ?? "";

        // Trim the value here
        value = value.trim();

        formData[attributes.name] = value;

        if (attributes.name == 'traits.email') {
          email = value;
        } else if (attributes.name == 'resend') {
          code = value;
        }
      }
    });

    // Validate email
    if (email != null && !_validateEmail(email!)) {
      setState(() => loading = false);
      return;
    }

    if (email != null &&
        email!.isNotEmpty &&
        code != null &&
        code!.isNotEmpty) {
      await oryRegisterWithCode(email!, code!, kratosClient);
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
          try {
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
          } catch (exception) {
            if (kDebugMode) {
              print('Error deserializing login flow: $exception');
            }
            setState(() {
              messageError = L10n.of(context)!.errTryAgain;
              loading = false;
            });
            // TODO refresh ?
          }
        }
      }
    }
  }

  Map<String, dynamic> _buildFormData() {
    final formData = <String, dynamic>{};

    formNodes.forEach((key, node) {
      if (node.attributes.oneOf.value is kratos.UiNodeInputAttributes) {
        final kratos.UiNodeInputAttributes attributes =
            node.attributes.oneOf.value as kratos.UiNodeInputAttributes;
        final value = textControllers[attributes.name]?.text ?? "";

        formData[attributes.name] = value;
      }
    });

    return formData;
  }

  Future<void> _resendCode(String actionUrl) async {
    setState(() {
      loading = true;
    });
    final formData = _buildFormData();

    formData["resend"] = "code";

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

      if (kDebugMode) {
        print(
            'register._resendCode: status=${response.statusCode} data=${response.data}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error resending code: ${e.response?.data}');
      }
      // TODO handle non-Dio exceptions
    } finally {
      setState(() {
        loading = false;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10n.of(context)!.authResendCodeMessage),
        duration: const Duration(seconds: 2),
      ),
    );
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
    try {
      final kratos.OryKratosClient kratosClient =
          kratos.OryKratosClient(dio: dio);

      // Fetch register flow
      final frontendApi = kratosClient.getFrontendApi();
      final response = await frontendApi.createNativeRegistrationFlow();

      // Retrieve action URL from connection flow
      final actionNodes = response.data?.ui.nodes;
      final actionUrl = response.data?.ui.action;

      if (actionNodes == null) {
        throw Exception(
            'URL d\'action non trouvée dans la réponse du flux de connexion');
      }
      await processKratosNodes(actionNodes, actionUrl!);
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
