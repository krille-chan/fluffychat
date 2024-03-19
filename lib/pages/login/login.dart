import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:ory_kratos_client/ory_kratos_client.dart';
import 'package:ory_kratos_client/src/model/login_flow.dart' as kratos;
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/config/subscription.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'change_username_page.dart';
import 'login_view.dart';
import 'package:one_of/one_of.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginController createState() => LoginController();
}

// TODO every API call should be in a try/catch block with appropriate error handling
// Endpoints will usually return a more specific error message

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
  String baseUrl =
      kDebugMode ? 'https://staging.tawkie.fr/' : 'https://tawkie.fr/';
  late final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(baseUrl: '${baseUrl}panel/api/.ory'));
  }

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

  Future<void> storeSessionToken(String? sessionToken) async {
    if (sessionToken != null) {
      await _secureStorage.write(key: 'sessionToken', value: sessionToken);
      await handleSessionToken(sessionToken);
    }
  }

  Future<void> handleSessionToken(String sessionToken) async {
    final Map<String, dynamic> queueStatus = await getQueueStatus(sessionToken);
    final String userState = queueStatus['userState'];

    if (userState == 'CREATED') {
      await handleUserCreated(queueStatus, sessionToken);
    } else if (userState == 'IN_QUEUE' || userState == 'ACCEPTED') {
      handleUserInQueueOrAccepted(queueStatus);
    } else {
      handleUnexpectedUserState(userState);
    }
  }

  Future<void> handleUserCreated(
      Map<String, dynamic> queueStatus, String sessionToken) async {
    final bool isSubscribed = SubscriptionManager.isSubscribed();

    if (isSubscribed) {
      await loginWithSessionToken(sessionToken);
    } else {
      SubscriptionManager().checkSubscriptionStatusAndRedirect(context);
    }
  }

  void handleUserInQueueOrAccepted(Map<String, dynamic> queueStatus) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeUsernamePage(
          queueStatus: queueStatus,
          controller: this,
        ),
      ),
    );
    print('IN_QUEUE/ACCEPTED');
  }

  void handleUnexpectedUserState(String userState) {
    print('User is in an unexpected state : $userState');
  }

  Future<String> changeUserNameOry(String newUsername) async {
    try {
      String? sessionToken = await _secureStorage.read(key: 'sessionToken');

      // TODO use baseUrl
      final response = await dio.post(
        '${baseUrl}panel/api/mobile-matrix-auth/updateUsername',
        data: {'username': newUsername},
        options: Options(
          headers: {
            'X-Session-Token': sessionToken,
            'content-type': 'application/json',
          },
        ),
      );

      print("Response update name: ${response.data}");
      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'failed';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: 'sessionToken');
  }

  void loginOry() async {
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
      print('Successfully initialized Kratos API');
      Response<kratos.LoginFlow> response;
      if (PlatformInfos.isWeb) {
        response = await frontendApi.createBrowserLoginFlow();
      } else {
        response = await frontendApi.createNativeLoginFlow();
      }
      print('Successfully created login flow');

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

      print(
          'Before sending POST request to update login flow with user credentials');

      // Sends a POST request with user credentials
      final loginResponse = await frontendApi.updateLoginFlow(
          flow: response.data!.id, updateLoginFlowBody: updateLoginFlowBody);
      print('Successfully updated login flow with user credentials');

      // Processing the response to obtain the connection session token
      final sessionToken = loginResponse.data?.sessionToken;

      print('Session token: $sessionToken');

      // Store the session token
      return await storeSessionToken(sessionToken);
    } on MatrixException catch (exception) {
      setState(() => passwordError = exception.errorMessage);
      return setState(() => loading = false);
    } on DioError catch (e) {
      print("Exception when calling Kratos log: $e\n");
      Logs().v("Error Kratos login : ${e.response?.data}");
      //print(e.response?.data.details);
      setState(() => passwordError = "Dio error with Kratos");
      return setState(() => loading = false);
    } catch (exception) {
      print(exception);
      setState(() => passwordError = L10n.of(context)!.err_usernameOrPassword);
      return setState(() => loading = false);
    }
  }

  Timer? _coolDown;

  Future<Map<String, dynamic>> getQueueStatus(String sessionToken) async {
    // TODO use baseUrl
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

    return responseDataQueueStatus;
  }

  Future<void> loginWithSessionToken(String sessionToken) async {
    final matrix = Matrix.of(context);

    setState(() => loading = true);

    try {
      // TODO use baseUrl
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

      // TODO handle errors correctly if not caught and displayed
      if (!matrixLoginJwt.startsWith('ey')) {
        throw Exception('Server did not return a valid JWT');
      }

      if (serverName.isEmpty) {
        throw Exception('Server did not return a valid server name');
      }

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

      // TODO use homeserver variable
      final url = 'https://' + serverName + '/_matrix/client/r0/login';
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
        await matrix.getLoginClient().init(
              newToken: accessToken,
              newUserID: userId,
              newHomeserver: homeserver,
              newDeviceID: deviceId,
              newDeviceName: PlatformInfos.clientName,
            );
      } else {
        Logs().v('Request failed with status: ${response.statusCode}');
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
