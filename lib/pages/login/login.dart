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
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/pages/login/web_login.dart';
import 'package:tawkie/utils/platform_infos.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'package:tawkie/widgets/show_error_dialog.dart';
import 'change_username_page.dart';
import 'login_view.dart';
import 'package:one_of/one_of.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginController createState() => LoginController();
}

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
  String baseUrl = AppConfig.baseUrl;
  late final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(baseUrl: '${baseUrl}panel/api/.ory'));

    // Check if sessionToken exists and handle it
    getSessionToken().then((sessionToken) {
      if (sessionToken != null) {
        checkUserQueueState(sessionToken);
      }
    });
  }

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

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
          content: Text(L10n.of(context)!.err_tryAgain),
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
      if (kDebugMode) {
        print('Successfully initialized Kratos API');
      }
      Response<kratos.LoginFlow> response;
      response = await frontendApi.createNativeLoginFlow();
      if (kDebugMode) {
        print('Successfully created login flow');
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

      if (kDebugMode) {
        print(
            'Before sending POST request to update login flow with user credentials');
      }

      // Sends a POST request with user credentials
      final loginResponse = await frontendApi.updateLoginFlow(
          flow: response.data!.id, updateLoginFlowBody: updateLoginFlowBody);
      if (kDebugMode) {
        print('Successfully updated login flow with user credentials');
      }

      // Processing the response to obtain the connection session token
      final sessionToken = loginResponse.data?.sessionToken;

      if (kDebugMode) {
        print('Session token: $sessionToken');
      }

      // Store the session token
      await storeSessionToken(sessionToken);
      return checkUserQueueState(sessionToken!);
    } on MatrixException catch (exception) {
      setState(() => passwordError = exception.errorMessage);
      return setState(() => loading = false);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos log: $e\n");
      }
      Logs().v("Error Kratos login : ${e.response?.data}");

      // Display Kratos error messages to the user
      if (e.response?.data != null) {
        final errorMessage = e.response!.data['ui']['messages'][0]['text'];
        setState(() => passwordError = errorMessage);
      } else {
        setState(
          () => passwordError = L10n.of(context)!.err_tryAgain,
        );
      }
      return setState(() => loading = false);
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
      setState(() => passwordError = L10n.of(context)!.err_usernameOrPassword);
      return setState(() => loading = false);
    }
  }

  Timer? _coolDown;

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
      final jwtAndServerName = await getMatrixLoginJwt(sessionToken);
      final String matrixLoginJwt = jwtAndServerName['matrixLoginJwt'];
      final String serverName = jwtAndServerName['serverName'];

      // Connect with JWT and server name
      await matrixLogin(matrixLoginJwt, serverName);

      // If all goes well, reset passwordError
      setState(() => passwordError = null);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos log: $e\n");
      }
      Logs().v("Error Kratos login : ${e.response?.data}");
      // Explanation to the user
      DioErrorHandler.fetchError(context, e);
      throw Exception();
    } finally {
      // Set loading to false after handling the error
      setState(() => loading = false);
    }

    setState(() => loading = false);
  }

  Future<Map<String, dynamic>> getMatrixLoginJwt(String sessionToken) async {
    try {
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
    } catch (e) {
      // Explanation to the user
      DioErrorHandler.fetchError(context, e as DioException);
      throw Exception();
    }
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
