import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/matrix.dart';
import 'views/chat_list.dart';
import 'views/login.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.white),
  );
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Matrix(
      clientName: "FluffyChat",
      child: MaterialApp(
        title: 'FluffyChat',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF5625BA),
          backgroundColor: Colors.white,
          secondaryHeaderColor: Color(0xFFF2F2F2),
          scaffoldBackgroundColor: Colors.white,
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          popupMenuTheme: PopupMenuThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.white,
            elevation: 1,
            textTheme: TextTheme(
              title: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: Builder(
          builder: (BuildContext context) => StreamBuilder<LoginState>(
            stream: Matrix.of(context).client.onLoginStateChanged.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (Matrix.of(context).client.isLogged()) return ChatListView();
              return LoginPage();
            },
          ),
        ),
      ),
    );
  }
}
