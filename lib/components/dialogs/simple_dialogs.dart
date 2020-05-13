import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:bot_toast/bot_toast.dart';

class SimpleDialogs {
  final BuildContext context;

  const SimpleDialogs(this.context);

  Future<String> enterText({
    String titleText,
    String confirmText,
    String cancelText,
    String hintText,
    String labelText,
    String prefixText,
    String suffixText,
    bool password = false,
    bool multiLine = false,
  }) async {
    final TextEditingController controller = TextEditingController();
    String input;
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(titleText ?? 'Please enter a text'),
        content: TextField(
          controller: controller,
          autofocus: true,
          autocorrect: false,
          onSubmitted: (s) {
            input = s;
            Navigator.of(context).pop();
          },
          minLines: multiLine ? 3 : 1,
          maxLines: multiLine ? 3 : 1,
          obscureText: password,
          textInputAction: multiLine ? TextInputAction.newline : null,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            prefixText: prefixText,
            suffixText: suffixText,
            prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
            suffixStyle: TextStyle(color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
                cancelText?.toUpperCase() ??
                    L10n.of(context).close.toUpperCase(),
                style: TextStyle(color: Colors.blueGrey)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text(
              confirmText?.toUpperCase() ??
                  L10n.of(context).confirm.toUpperCase(),
            ),
            onPressed: () {
              input = controller.text;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    return input;
  }

  Future<bool> askConfirmation({
    String titleText,
    String contentText,
    String confirmText,
    String cancelText,
  }) async {
    bool confirmed = false;
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(titleText ?? L10n.of(context).areYouSure),
        content: contentText != null ? Text(contentText) : null,
        actions: <Widget>[
          FlatButton(
            child: Text(
                cancelText?.toUpperCase() ??
                    L10n.of(context).close.toUpperCase(),
                style: TextStyle(color: Colors.blueGrey)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text(
              confirmText?.toUpperCase() ??
                  L10n.of(context).confirm.toUpperCase(),
            ),
            onPressed: () {
              confirmed = true;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    return confirmed;
  }

  Future<void> inform({
    String titleText,
    String contentText,
    String okText,
  }) async {
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: titleText != null ? Text(titleText) : null,
        content: contentText != null ? Text(contentText) : null,
        actions: <Widget>[
          FlatButton(
            child: Text(
              okText ?? L10n.of(context).ok.toUpperCase(),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> tryRequestWithLoadingDialog(Future<dynamic> request,
      {Function(MatrixException) onAdditionalAuth}) async {
    showLoadingDialog(context);
    final dynamic = await tryRequestWithErrorToast(request,
        onAdditionalAuth: onAdditionalAuth);
    Navigator.of(context)?.pop();
    return dynamic;
  }

  Future<dynamic> tryRequestWithErrorToast(Future<dynamic> request,
      {Function(MatrixException) onAdditionalAuth}) async {
    try {
      return await request;
    } on MatrixException catch (exception) {
      if (exception.requireAdditionalAuthentication &&
          onAdditionalAuth != null) {
        return await tryRequestWithErrorToast(onAdditionalAuth(exception));
      } else {
        BotToast.showText(text: exception.errorMessage);
      }
    } catch (exception) {
      BotToast.showText(text: exception.toString());
      return false;
    }
  }

  showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text(L10n.of(context).loadingPleaseWait),
          ],
        ),
      ),
    );
  }
}
