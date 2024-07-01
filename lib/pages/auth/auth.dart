import 'dart:async';
import 'dart:convert';
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
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/pages/auth/login_view.dart';
import 'package:tawkie/pages/auth/privacy_policy_text.dart';
import 'package:tawkie/pages/auth/register_view.dart';
import 'package:tawkie/pages/auth/web_login.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'package:tawkie/widgets/show_error_dialog.dart';

import 'change_username_page.dart';

enum AuthType { login, register }

class Auth extends StatefulWidget {
  final AuthType authType;

  const Auth({required this.authType, super.key});

  @override
  AuthController createState() => AuthController();
}

class AuthController extends State<Auth> {
  String? messageError;
  String? messageInfo;
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
    if (widget.authType == AuthType.login) {
      getLoginOry();
      // Check if sessionToken exists and handle it
      getSessionToken().then((sessionToken) {
        if (sessionToken != null) {
          checkUserQueueState(sessionToken);
        }
      });
    } else {
      getRegisterOry();
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(onBackButtonPress);
    super.dispose();
  }

  Future<bool> onBackButtonPress(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    setState(() {
      messageError = null;
      messageInfo = null;
    });
    popFormWidgets();
    return true;
  }

  // How to return to the previous list
  void popFormWidgets() {
    if (hasSubmitted) {
      setState(() => hasSubmitted = false);
      if (widget.authType == AuthType.login) {
        getLoginOry();
      } else {
        getRegisterOry();
      }
    }
  }

  Future<void> storeSessionToken(String? sessionToken) async {
    if (sessionToken != null) {
      await _secureStorage.write(key: 'sessionToken', value: sessionToken);
    }
  }

  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: 'sessionToken');
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

  void checkUserQueueState(String sessionToken) async {
    try {
      final Map<String, dynamic> queueStatus =
          await getQueueStatus(sessionToken);
      final String userState = queueStatus['userState'];

      if (userState == 'CREATED') {
        await redirectUserCreated(queueStatus, sessionToken);
      } else if (userState == 'IN_QUEUE' || userState == 'ACCEPTED') {
        redirectUserInQueueOrAccepted(queueStatus, sessionToken);
      } else {
        redirectUnexpectedUserState(userState);
      }
    } catch (e) {
      // In the event of an error, do nothing, and let the user enter his identifiers normally.
      if (kDebugMode) {
        print("Error fetching queue status: $e");
      }
    }
  }

  Future<void> redirectUserCreated(
      Map<String, dynamic> queueStatus, String sessionToken) async {
    await loginWithSessionToken(sessionToken);
  }

  Future<void> loginWithSessionToken(String sessionToken) async {
    setState(() => loading = true);

    try {
      // Retrieve JWT and server name
      Logs().v('Getting JWT and server name');
      final jwtAndServerName = await getMatrixLoginJwt(sessionToken);
      final String matrixLoginJwt = jwtAndServerName['matrixLoginJwt'];
      final String serverName = jwtAndServerName['serverName'];

      Logs().v('Logging in with JWT into Matrix');
      // Connect with JWT and server name
      await matrixLogin(matrixLoginJwt, serverName);

      // If all goes well, reset passwordError
      //setState(() => passwordError = null);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos log: $e\n");
      }
      Logs().v("Error logging in with jwt : ${e.response?.data}");
      // Explanation to the user
      DioErrorHandler.fetchError(context, e);
      // Set loading to false after handling the error
      setState(() => loading = false);
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
      setState(() => messageError = exception.toString());
      return setState(() => loading = false);
    }
  }

  Future<Map<String, dynamic>> getMatrixLoginJwt(String sessionToken) async {
    final responseMatrix = await dio.get(
      '${baseUrl}panel/api/mobile-matrix-auth/getMatrixToken',
      options: Options(
        headers: {
          'X-Session-Token': sessionToken,
        },
      ),
    );

    final Map<String, dynamic> responseData = responseMatrix.data;

    final String matrixLoginJwt = responseData['matrixLoginJwt'];
    final String serverName = responseData['serverName'];

    if (!matrixLoginJwt.startsWith('ey')) {
      throw Exception('Server did not return a valid JWT');
    }

    if (serverName.isEmpty) {
      throw Exception('Server did not return a valid server name');
    }

    return {'matrixLoginJwt': matrixLoginJwt, 'serverName': serverName};
  }

  Future<void> matrixLogin(String matrixLoginJwt, String serverName) async {
    final matrix = Matrix.of(context);
    final client = matrix.getLoginClient();

    setState(() => loading = true);

    try {
      var homeserver = Uri.parse(serverName);
      if (homeserver.scheme.isEmpty) {
        homeserver = Uri.https(serverName, '');
      }

      final url = '$homeserver/_matrix/client/r0/login';
      final headers = {'Content-Type': 'application/json'};
      final data = {'type': 'org.matrix.login.jwt', 'token': matrixLoginJwt};

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
        await client.init(
          newToken: accessToken,
          newUserID: userId,
          newHomeserver: homeserver,
          newDeviceID: deviceId,
          newDeviceName: PlatformInfos.clientName,
        );
      } else {
        Logs().v('Request failed with status: ${response.statusCode}');
        // Improved error handling
        DioErrorHandler.showGenericErrorDialog(
          context,
          L10n.of(context)!.errTryAgain,
        );
        setState(() => loading = false);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException: $e\n');
      }
      Logs().v('DioException: ${e.response?.data}');
      DioErrorHandler.fetchError(context, e);
      setState(() => loading = false);
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('SocketException: $e\n');
      }
      Logs().v('SocketException: $e');
      DioErrorHandler.showNetworkErrorDialog(context);
      setState(() => loading = false);
    } on MatrixException catch (exception) {
      setState(() => messageError = exception.errorMessage);
      setState(() => loading = false);
    } catch (exception) {
      if (kDebugMode) {
        print('Exception: $exception\n');
      }
      DioErrorHandler.showGenericErrorDialog(
        context,
        L10n.of(context)!.errTryAgain,
      );
      setState(() => loading = false);
    }

    if (mounted) setState(() => loading = false);
  }

  void redirectUserInQueueOrAccepted(
      Map<String, dynamic> queueStatus, String sessionToken) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeUsernamePage(
          queueStatus: queueStatus,
          dio: dio,
          sessionToken: sessionToken,
          onUserCreated: loginWithSessionToken,
        ),
      ),
    );
    if (kDebugMode) {
      print('IN_QUEUE/ACCEPTED');
    }
  }

  void redirectUnexpectedUserState(String userState) {
    if (kDebugMode) {
      print('User is in an unexpected state : $userState');
    }
    // Dialog box with error message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(L10n.of(context)!.err_),
          content: Text(L10n.of(context)!.errTryAgain),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(L10n.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> getQueueStatus(String sessionToken) async {
    final responseQueueStatus = await dio.get(
      '${baseUrl}panel/api/mobile-matrix-auth/getQueueStatus',
      options: Options(
        headers: {
          'X-Session-Token': sessionToken,
        },
      ),
    );

    final Map<String, dynamic> responseDataQueueStatus =
        responseQueueStatus.data;
    final String userId = responseDataQueueStatus['userId'];

    // RevenueCat only works on mobile
    if (PlatformInfos.isMobile) {
      // Identify the user with its Kratos uuid on RevenueCat
      final LogInResult result = await Purchases.logIn(userId);
    }

    return responseDataQueueStatus;
  }

  Future<void> processKratosNodes(
      BuiltList<kratos.UiNode> nodes, String actionUrl) async {
    final List<Widget> formWidgets = [];
    final Map<String, kratos.UiNode> allNodes = {};
    String errorMessage = "";

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

      if (node.messages.isNotEmpty && node.messages[0].text.isNotEmpty) {
        errorMessage = node.messages[0].text;
      }

      formWidgets.add(widget);
      allNodes[attributes.name] = node;
    }

    setState(() {
      authWidgets = formWidgets;
      formNodes = allNodes;
      loading = false;
      if (errorMessage.isNotEmpty) messageError = errorMessage;
    });
  }

  Widget _buildHiddenWidget(kratos.UiNodeInputAttributes attributes) {
    if (attributes.name == "traits.email" || attributes.name == "identifier") {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
            "${L10n.of(context)!.authCodeSentTo} ${attributes.value!}" ?? ""),
      );
    }
    return Container();
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
            if (widget.authType == AuthType.register) const PrivacyPolicyText(),
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
        String value = textControllers[attributes.name]?.text ??
            attributes.value?.toString() ??
            "";

        // Trim the value here
        value = value.trim();

        formData[attributes.name] = value;

        if (attributes.name == 'traits.email' ||
            attributes.name == "identifier") {
          email = value;
          print("email: $email");
        } else if (attributes.name == 'code') {
          code = value;
          print("code: $code");
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
      await oryWithCode(email!, code!, kratosClient);
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
          await refreshFormNodes(); // Refresh the form nodes on error
        }
      } on DioException catch (e) {
        if (kDebugMode) {
          print('Erreur lors de la soumission du formulaire: $e');
          print('Response data: ${e.response?.data}');
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
            final newMessages = loginFlow?.ui.messages;

            if (newMessages != null && newMessages.isNotEmpty) {
              final message = newMessages[0];
              if (message.type == kratos.UiTextTypeEnum.error) {
                setState(() => messageError = message.text);
              } else {
                setState(() => messageInfo = message.text);
              }
            }

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
            await refreshFormNodes(); // Refresh the form nodes on error
          }
        } else {
          setState(() => loading = false);
          DioErrorHandler.showGenericErrorDialog(
              context, e.message ?? "Network error");
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
            '_resendCode: status=${response.statusCode} data=${response.data}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Error resending code: ${e.response?.data}');
      }
      DioErrorHandler.fetchError(context, e);
    } catch (e) {
      if (kDebugMode) {
        print('Non-Dio Exception: $e');
      }
      // Handling non-Dio exceptions
      DioErrorHandler.showGenericErrorDialog(
          context, L10n.of(context)!.errTryAgain);
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

  Future<void> refreshFormNodes() async {
    setState(() {
      loading = true;
    });
    try {
      if (widget.authType == AuthType.login) {
        getLoginOry();
      } else {
        getRegisterOry();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors du rafraîchissement des nœuds : $e");
      }
      setState(() {
        messageError =
            "Erreur lors du rafraîchissement des nœuds. Veuillez réessayer.";
        loading = false;
      });
    }
  }

  Future<void> oryWithCode(
      String email, String code, kratos.OryKratosClient kratosClient) async {
    if (widget.authType == AuthType.register) {
      await oryRegisterWithCode(email, code, kratosClient);
    }
    if (widget.authType == AuthType.login) {
      await oryLoginWithCode(email, code, kratosClient);
    }
  }

  Future<void> oryRegisterWithCode(
      String email, String code, kratos.OryKratosClient kratosClient) async {
    final updateRegistrationFlowWithPasswordMethod =
        kratos.UpdateRegistrationFlowWithCodeMethod(
      (builder) => builder
        ..traits = JsonObject({'email': email})
        ..method = 'code'
        ..code = code
        ..csrfToken = "",
    );

    final updateRegisterFlowBody = kratos.UpdateRegistrationFlowBody(
      (builder) => builder
        ..oneOf =
            OneOf.fromValue1(value: updateRegistrationFlowWithPasswordMethod),
    );

    final frontendApi = kratosClient.getFrontendApi();

    try {
      Logs().v('Completing registration flow');
      final registerResponse = await frontendApi.updateRegistrationFlow(
        flow: flowId!,
        updateRegistrationFlowBody: updateRegisterFlowBody,
      );

      final sessionToken = registerResponse.data?.sessionToken;
      await storeSessionToken(sessionToken);

      Logs().v('Registration successful');
      context.go('/home/login');

      if (kDebugMode) {
        print('Registration successful');
      }
    } on MatrixException catch (exception) {
      setState(() => messageError = exception.errorMessage);
      return setState(() => loading = false);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos registration: $e\n");
        print("Response data: ${e.response?.data}");
      }
      Logs().v("Error Kratos registration : ${e.response?.data}");

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

  Future<void> oryLoginWithCode(
      String email, String code, kratos.OryKratosClient kratosClient) async {
    final updateLoginFlowWithCodeMethod = kratos.UpdateLoginFlowWithCodeMethod(
      (builder) => builder
        ..identifier = email
        ..method = 'code'
        ..code = code
        ..csrfToken = "", // Assuming csrfToken is not required for mobile
    );

    final updateLoginFlowBody = kratos.UpdateLoginFlowBody(
      (builder) => builder
        ..oneOf = OneOf.fromValue1(value: updateLoginFlowWithCodeMethod),
    );

    final frontendApi = kratosClient.getFrontendApi();

    try {
      final loginResponse = await frontendApi.updateLoginFlow(
        flow: flowId!,
        updateLoginFlowBody: updateLoginFlowBody,
      );

      if (kDebugMode) {
        print('Successfully updated login flow with user credentials');
      }

      final sessionToken = loginResponse.data?.sessionToken;
      await storeSessionToken(sessionToken);
      return checkUserQueueState(sessionToken!);
    } on MatrixException catch (exception) {
      setState(() => messageError = exception.errorMessage);
      return setState(() => loading = false);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos login: $e\n");
        print("Response data: ${e.response?.data}");
      }

      final response = e.response?.data;
      print("Response data: $response");

      if (response == null) {
        setState(() => messageError = L10n.of(context)!.errTryAgain);
      } else if (response["error"]?["reason"]?.isNotEmpty ?? false) {
        setState(() => messageError = response["error"]["reason"]);
      } else if (response["ui"]?["messages"]?[0]?["text"]?.isNotEmpty ??
          false) {
        setState(() => messageError = response["ui"]["messages"][0]["text"]);
      } else {
        setState(() => messageError = L10n.of(context)!.errTryAgain);
      }

      return setState(() => loading = false);
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
      setState(() => messageError = exception.toString());
      return setState(() => loading = false);
    }
  }

  void getRegisterOry() async {
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
              () => messageError = L10n.of(context)!.authErrorContactSupport);
        }
      } catch (exception) {
        Logs().v("Error Kratos loginhihi : $exception");
        setState(
            () => messageError = L10n.of(context)!.authErrorContactSupport);
      }
      await refreshFormNodes(); // Refresh the form nodes on error
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

  void getLoginOry() async {
    final kratos.OryKratosClient kratosClient =
        kratos.OryKratosClient(dio: dio);

    try {
      // Initialize API connection flow
      final frontendApi = kratosClient.getFrontendApi();
      final response = await frontendApi.createNativeLoginFlow();

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
        print("Exception when calling Kratos log: $e");
        print(e.response?.data);
      }
      if (e.error is SocketException) {
        DioErrorHandler.showNetworkErrorDialog(context);
      }
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
      DioErrorHandler.showGenericErrorDialog(context, exception.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformInfos.isWeb) {
      return WebLogin(loginController: this);
    } else {
      return widget.authType == AuthType.login
          ? LoginView(this)
          : RegisterView(this);
    }
  }
}
