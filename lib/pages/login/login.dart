import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:one_of/one_of.dart';
import 'package:ory_kratos_client/ory_kratos_client.dart' as kratos;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/pages/login/web_login.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'package:tawkie/widgets/show_error_dialog.dart';

import 'change_username_page.dart';
import 'login_view.dart';

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
  bool loading = true;
  String? messageError;

  String baseUrl = AppConfig.baseUrl;
  late final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  kratos.FrontendApi? api;
  String? flowId;
  List<Widget> authWidgets = [];
  List<TextEditingController> textControllers = [];
  List<kratos.UiNode> formNodes = [];

  // If the submit button has already been pressed
  bool hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);

    dio = Dio(BaseOptions(baseUrl: '${baseUrl}panel/api/.ory'));
    getLoginOry();
    // Check if sessionToken exists and handle it
    getSessionToken().then((sessionToken) {
      if (sessionToken != null) {
        checkUserQueueState(sessionToken);
      }
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  Future<bool> myInterceptor(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    popFormWidgets();
    return true;
  }

  Future<void> storeSessionToken(String? sessionToken) async {
    if (sessionToken != null) {
      await _secureStorage.write(key: 'sessionToken', value: sessionToken);
    }
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

  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: 'sessionToken');
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

      if (attributes.name == "identifier" &&
          attributes.type == kratos.UiNodeInputAttributesTypeEnum.hidden) {
        formWidgets.add(_buildHiddenInput(attributes));
      } else if (node.type == kratos.UiNodeTypeEnum.input) {
        Widget inputWidget =
            _buildInputWidget(attributes, controller, actionUrl, node);
        formWidgets.add(inputWidget);
      }

      allNodes.add(node);
    }

    setState(() {
      authWidgets = formWidgets;
      formNodes = allNodes;
      loading = false;
    });
  }

  Widget _buildHiddenInput(kratos.UiNodeInputAttributes attributes) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
          "${L10n.of(context)!.authCodeSentTo} ${attributes.value!}" ?? ""),
    );
  }

  Widget _buildInputWidget(kratos.UiNodeInputAttributes attributes,
      TextEditingController controller, String actionUrl, kratos.UiNode node) {
    switch (attributes.type) {
      case kratos.UiNodeInputAttributesTypeEnum.text:
        return _buildTextInput(attributes, controller, node);
      case kratos.UiNodeInputAttributesTypeEnum.submit:
        return _buildSubmitButton(attributes, actionUrl, node);
      default:
        return Container(); // Placeholder for unsupported types
    }
  }

  Widget _buildTextInput(kratos.UiNodeInputAttributes attributes,
      TextEditingController controller, kratos.UiNode node) {
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
            // Implement your resend code logic here
          },
          child: Text(node.meta.label!.text),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: () {
            _submitForm(actionUrl);
          },
          child: Text(
            node.meta.label!.text,
            style: TextStyle(color: Colors.green[500]),
          ),
        ),
      );
    }
  }

  // How to return to the previous list
  void popFormWidgets() {
    if (hasSubmitted) {
      setState(() => hasSubmitted = false);
      getLoginOry();
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

    // Create an UpdateLoginFlowBodyBuilder object and assign it the UpdateLoginFlowWithCodeMethod object
    final updateLoginFlowBody = kratos.UpdateLoginFlowBody(
      (builder) => builder
        ..oneOf = OneOf.fromValue1(value: updateLoginFlowWithCodeMethod),
    );

    final frontendApi = kratosClient.getFrontendApi();

    try {
      // Sends a POST request with user credentials
      final loginResponse = await frontendApi.updateLoginFlow(
        flow: flowId!,
        updateLoginFlowBody: updateLoginFlowBody,
      );

      if (kDebugMode) {
        print('Successfully updated login flow with user credentials');
      }

      // Processing the response to obtain the connection session token
      final sessionToken = loginResponse.data?.sessionToken;

      await storeSessionToken(sessionToken);
      return checkUserQueueState(sessionToken!);
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
      await oryLoginWithCode(email, code, kratosClient);
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

  BuiltList<kratos.UiNode> deserializeUiNodes(List<dynamic> json) {
    final kratos.OryKratosClient kratosClient =
        kratos.OryKratosClient(dio: dio);
    final standardSerializers = kratosClient.serializers;

    return BuiltList<kratos.UiNode>.from(json.map((dynamic node) =>
        standardSerializers.deserializeWith(kratos.UiNode.serializer, node)!));
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
    }
    return setState(() => loading = false);
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

    // Function to log user with Kratos id on Revenu Cat
    final LogInResult result = await Purchases.logIn(userId);

    return responseDataQueueStatus;
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
    } finally {
      // Set loading to false after handling the error
      setState(() => loading = false);
    }

    setState(() => loading = false);
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

      loginHomeserverSummary = await client.checkHomeserver(homeserver);
      if (supportsSso) {
        _rawLoginTypes = await client.request(
          RequestType.GET,
          '/client/v3/login',
        );
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
        // TODO improve error handling
        //setState(() => passwordError = L10n.of(context)!.errTryAgain);
      }
    } on MatrixException catch (exception) {
      //setState(() => passwordError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      //setState(() => passwordError = exception.toString());
      return setState(() => loading = false);
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformInfos.isWeb) {
      return WebLogin(
        loginController: this,
      );
    } else {
      return LoginView(this);
    }
  }
}
