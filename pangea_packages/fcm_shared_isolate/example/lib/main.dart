import 'package:flutter/material.dart';

import 'package:fcm_shared_isolate/fcm_shared_isolate.dart';

void main() {
  FcmSharedIsolate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Hello World\n'),
        ),
      ),
    );
  }
}
