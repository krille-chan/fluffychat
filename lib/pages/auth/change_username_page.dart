import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/pages/add_bridge/error_message_dialog.dart';

class ChangeUsernamePage extends StatefulWidget {
  final Map<String, dynamic> queueStatus;
  final Dio dio;
  final String sessionToken;
  final Future<void> Function(String sessionToken) onUserCreated;

  const ChangeUsernamePage(
      {super.key,
      required this.queueStatus,
      required this.dio,
      required this.sessionToken,
      required this.onUserCreated});

  @override
  State<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  String baseUrl = AppConfig.baseUrl;

  final TextEditingController _usernameController = TextEditingController();
  String? _usernameError;
  bool _loadingUpdateUsername = false;
  bool _loadingCreateUser = false;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);

    if (isUsernameSet()) {
      _usernameController.text = widget.queueStatus['username'];
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    _usernameController.dispose();
    super.dispose();
  }

  Future<bool> myInterceptor(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    return true;
  }

  bool isUsernameSet() {
    return widget.queueStatus['username'] != null &&
        widget.queueStatus['username'] != "";
  }

  bool _isAccepted() {
    return widget.queueStatus['userState'] == 'ACCEPTED';
  }

  bool _isCreated() {
    return widget.queueStatus['userState'] == 'CREATED';
  }

  bool _isLoading() {
    return _loadingUpdateUsername || _loadingCreateUser;
  }

  bool _validateUsername(String username) {
    // Define regex to validate username format
    final RegExp usernameRegex = RegExp(r'^[a-z0-9]{3,16}$');

    // Check that the username matches the regex
    if (!usernameRegex.hasMatch(username)) {
      setState(() => _usernameError = L10n.of(context)?.usernameRequirements);
      return false;
    }

    // Reset username error if valid
    setState(() => _usernameError = null);
    return true;
  }

  String _formatUsername(String username) {
    // Remove leading capital letter
    if (username.isNotEmpty && username[0].toUpperCase() == username[0]) {
      username = username.replaceFirst(username[0], username[0].toLowerCase());
    }
    return username;
  }

  Future<void> updateUsername(String sessionToken, String newUsername) async {
    try {
      newUsername = _formatUsername(newUsername);

      // Validate the username
      if (!_validateUsername(newUsername)) {
        return;
      }
      setState(() => _loadingUpdateUsername = true);

      final updateUsernameResponse = await widget.dio.post(
        '${baseUrl}panel/api/mobile-matrix-auth/updateUsername',
        options: Options(headers: {'X-Session-Token': sessionToken}),
        data: jsonEncode({'username': newUsername}),
      );
      final matrixUsername = updateUsernameResponse.data['username'];
      final newState = updateUsernameResponse.data['userState'];

      Logs().v("New matrixUsername: $matrixUsername");
      if (matrixUsername != newUsername) {
        throw Exception('Error during username update');
      }

      setState(() {
        widget.queueStatus['username'] = newUsername;
        widget.queueStatus['userState'] = newState;
        _loadingUpdateUsername = false;
      });

      // Display a SnackBar to indicate a successful name change
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${L10n.of(context)!.usernameSuccess} $newUsername'),
          backgroundColor: Colors.green,
        ),
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos log: $e\n");
      }
      Logs().v("Error Kratos login : ${e.response?.data}");
      setState(() {
        _usernameError = e.response?.data['message'];
        _loadingUpdateUsername = false;
      });
    } catch (exception) {
      setState(() {
        _usernameError = exception.toString();
        _loadingUpdateUsername = false;
      });
      throw Exception('Error during username update');
    }
  }

  Future<void> createUser(String sessionToken) async {
    try {
      Logs().v("Creating matrix user");
      final updateUsernameResponse = await widget.dio.post(
        '${baseUrl}panel/api/mobile-matrix-auth/createUser',
        options: Options(headers: {'X-Session-Token': sessionToken}),
      );
      final newState = updateUsernameResponse.data['userState'];

      if (newState != 'CREATED') {
        throw Exception('Error during user creation');
      }

      setState(() {
        widget.queueStatus['userState'] = newState;
      });
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos creation: $e\n");
      }
      Logs().v("Error response data : ${e.response?.data}");
      setState(() => _usernameError = e.response?.data['message']);
    } catch (exception) {
      Logs().v("Error creating user: $exception");
      setState(() => _usernameError = exception.toString());
      throw Exception('Error during user creation');
    }
  }

  void _onSubmitButtonPressed() async {
    if (widget.queueStatus['username'] != _usernameController.text) {
      final newUsername = _usernameController.text;

      if (_usernameController.text.isEmpty) {
        setState(() {
          _usernameError = L10n.of(context)!.registerRequiredField;
        });
        return;
      } else {
        setState(() {
          _usernameError = null;
        });

        // Update user name
        await updateUsername(widget.sessionToken, newUsername);
      }
    }
  }

  void _onNextButtonPressed() async {
    setState(() => _loadingCreateUser = true);
    if (_isAccepted()) {
      try {
        await createUser(widget.sessionToken);
      } catch (e) {
        Logs().v('Error creating user: $e');
        setState(() => _loadingCreateUser = false);
        showCatchErrorDialog(context, e.toString());
      }
    }
    if (_isCreated()) {
      Navigator.of(context).pop();
      await widget.onUserCreated(widget.sessionToken);
      // don't update state because we popped the page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.usernamePageTitle),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              widget.queueStatus['userState'] == 'IN_QUEUE'
                  ? Column(
                      children: [
                        Text(
                          L10n.of(context)!.usernameYourPosition,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.queueStatus['queuePosition'].toString(),
                          style: const TextStyle(fontSize: 23),
                        ),
                      ],
                    )
                  : Text(
                      L10n.of(context)!.usernameItsYourTurn,
                      style: const TextStyle(fontSize: 23),
                    ),
              const SizedBox(height: 10),
              Text(
                widget.queueStatus['userState'] == 'IN_QUEUE'
                    ? L10n.of(context)!.usernameInQueueChangeUsername
                    : L10n.of(context)!.usernameChangeUsername,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                inputFormatters: [LowerCaseTextFormatter()],
                decoration: InputDecoration(
                  labelText: L10n.of(context)!.username,
                  errorText: _usernameError,
                  errorMaxLines: 3,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return L10n.of(context)!.registerRequiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isUsernameSet()
                  ? Text(
                      L10n.of(context)!.usernameAdvertisement,
                    )
                  : Container(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading() ? null : _onSubmitButtonPressed,
                child: _loadingUpdateUsername
                    ? const LinearProgressIndicator()
                    : Text(L10n.of(context)!.usernameSubmit),
              ),
              const SizedBox(height: 50),
              isUsernameSet()
                  ? Text(
                      _isAccepted()
                          ? L10n.of(context)!.usernameUsernameImmutable
                          : L10n.of(context)!.usernameWaitingForAcceptance,
                    )
                  : Container(),
              isUsernameSet() && _isAccepted()
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppConfig.primaryColor,
                      ),
                      onPressed: _isLoading() ? null : _onNextButtonPressed,
                      child: _loadingCreateUser
                          ? const LinearProgressIndicator()
                          : Text(L10n.of(context)!.next),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom TextInputFormatter to convert to lower case
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
