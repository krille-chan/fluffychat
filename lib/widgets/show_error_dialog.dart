import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class DioErrorHandler {
  static void fetchError(BuildContext context, DioException e) {
    if (_hasUiErrorMessage(e)) {
      final errorMessage = e.response!.data['ui']['messages'][0]['text'];
      _showErrorDialog(context, '', errorMessage);
    } else if (e.error is SocketException) {
      showNetworkErrorDialog(context);
    } else {
      _showErrorDialog(
        context,
        L10n.of(context)!.err_,
        L10n.of(context)!.errTryAgain,
      );
    }
  }

  static bool _hasUiErrorMessage(DioException e) {
    return e.response != null &&
        e.response!.data != null &&
        e.response!.data['ui'] != null &&
        e.response!.data['ui']['messages'] != null &&
        e.response!.data['ui']['messages'].isNotEmpty;
  }

  static void _showErrorDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title.isNotEmpty ? Text(title) : null,
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(L10n.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  static void showNetworkErrorDialog(BuildContext context) {
    _showErrorDialog(
      context,
      L10n.of(context)!.noConnectionToTheServer,
      L10n.of(context)!.errorConnectionText,
    );
  }

  static void showGenericErrorDialog(BuildContext context, String message) {
    _showErrorDialog(
      context,
      L10n.of(context)!.err_,
      message,
    );
  }
}
