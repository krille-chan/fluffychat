import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'chat_list.dart';
import 'homeserver_picker.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginState>(
      future: Matrix.of(context).client.onLoginStateChanged.stream.first,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => FlushbarHelper.createError(
                    title: L10n.of(context).oopsSomethingWentWrong,
                    message: snapshot.error.toString(),
                  ).show(context));
          return HomeserverPicker();
        }
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (Matrix.of(context).client.isLogged()) {
          return ChatList();
        }
        return HomeserverPicker();
      },
    );
  }
}
