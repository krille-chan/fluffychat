import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:tawkie/config/subscription.dart';
import 'package:tawkie/pages/login/login.dart';
import 'package:tawkie/utils/platform_infos.dart';

class ChangeUsernamePage extends StatefulWidget {
  final Map<String, dynamic> queueStatus;
  final Dio dio;
  final String sessionToken;

  const ChangeUsernamePage(
      {super.key,
      required this.queueStatus,
      required this.dio,
      required this.sessionToken});

  @override
  State<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  String baseUrl =
      kDebugMode ? 'https://staging.tawkie.fr/' : 'https://tawkie.fr/';

  final TextEditingController _usernameController = TextEditingController();
  String? _usernameError;

  bool isUsernameSet() {
    return widget.queueStatus['username'] != null &&
        widget.queueStatus['username'] != "";
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

      final updateUsernameResponse = await widget.dio.post(
        '${baseUrl}panel/api/mobile-matrix-auth/updateUsername',
        options: Options(headers: {'X-Session-Token': sessionToken}),
        data: jsonEncode({'username': newUsername}),
      );
      final matrixUsername = updateUsernameResponse.data['username'];

      Logs().v("New matrixUsername: $matrixUsername");
      if (matrixUsername != newUsername) {
        throw Exception('Error during username update');
      }

      setState(() {
        widget.queueStatus['username'] = newUsername;
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
      setState(() => _usernameError = e.response?.data['message']);
    } catch (exception) {
      setState(() => _usernameError = exception.toString());
      throw Exception('Error during username update');
    }
  }

  @override
  void initState() {
    super.initState();

    if (isUsernameSet()) {
      _usernameController.text = widget.queueStatus['username'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.usernamePageTitle),
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
                L10n.of(context)!.usernameChangeUsername,
                style: const TextStyle(fontSize: 18),
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
                onPressed: _onSubmitButtonPressed,
                child: Text(L10n.of(context)!.submit),
              ),
              const SizedBox(height: 50),
              isUsernameSet()
                  ? ElevatedButton(
                      onPressed: () async {
                        if (PlatformInfos.shouldInitializePurchase()) {
                          final hasSubscription = await SubscriptionManager
                              .checkSubscriptionStatus();

                          if (!hasSubscription) {
                            final paywallResult =
                                await RevenueCatUI.presentPaywall();
                          } else if (widget.queueStatus['userState'] ==
                              'ACCEPTED') {
                            await LoginController()
                                .loginWithSessionToken(widget.sessionToken);
                          }
                        } else {
                          // Todo: make purchases for Web, Windows and Linux
                        }
                      },
                      child: Text(L10n.of(context)!.next),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
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
