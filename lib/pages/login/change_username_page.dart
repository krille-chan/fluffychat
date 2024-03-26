import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

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
  final TextEditingController _usernameController = TextEditingController();
  String? _usernameError;

  Future<void> updateUsername(String sessionToken, String newUsername) async {
    try {
      final updateUsernameResponse = await widget.dio.post(
        'https://staging.tawkie.fr/panel/api/mobile-matrix-auth/updateUsername',
        options: Options(headers: {'X-Session-Token': sessionToken}),
        data: jsonEncode({'username': newUsername}),
      );
      final matrixUsername = updateUsernameResponse.data['username'];

      print("la reponse est: $updateUsernameResponse");
      print("matrixUsername: $matrixUsername");
      if (matrixUsername != newUsername) {
        throw Exception('Error during username update');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Exception when calling Kratos log: $e\n");
      }
      Logs().v("Error Kratos login : ${e.response?.data}");

      // Display Kratos error messages to the user
      if (e.response!.data['ui']['messages'][0]['text'] != null) {
        final errorMessage = e.response!.data['ui']['messages'][0]['text'];
        setState(() => _usernameError = errorMessage);
      } else {
        setState(() => _usernameError = "Dio error with Kratos");
      }
    } catch (exception) {
      setState(() => _usernameError = exception.toString());
      throw Exception('Error during username update');
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.queueStatus['username'] != null &&
        widget.queueStatus['username'] != "") {
      _usernameController.text = widget.queueStatus['username'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.username_pageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                        L10n.of(context)!.username_yourPosition,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        widget.queueStatus['queuePosition'].toString(),
                        style: const TextStyle(fontSize: 23),
                      ),
                    ],
                  )
                : Text(
                    L10n.of(context)!.username_itsYourTurn,
                    style: const TextStyle(fontSize: 23),
                  ),
            const SizedBox(height: 10),
            Text(
              L10n.of(context)!.username_changeUsername,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: L10n.of(context)!.username,
                errorText: _usernameError,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return L10n.of(context)!.register_requiredField;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            widget.queueStatus['username'] != null &&
                    widget.queueStatus['username'] != ""
                ? Text(
                    L10n.of(context)!.username_advertisement,
                  )
                : Container(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newUsername = _usernameController.text;

                if (_usernameController.text.isEmpty) {
                  setState(() {
                    _usernameError = L10n.of(context)!.register_requiredField;
                  });
                  return;
                } else {
                  setState(() {
                    _usernameError = null;
                  });

                  // Update user name
                  await updateUsername(widget.sessionToken, newUsername);
                }
              },
              child: Text(L10n.of(context)!.submit),
            ),
          ],
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
