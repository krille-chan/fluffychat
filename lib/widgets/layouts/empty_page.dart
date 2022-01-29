import 'dart:math';

import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final bool loading;
  static const double _width = 200;
  const EmptyPage({this.loading = false, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = min(MediaQuery.of(context).size.width, EmptyPage._width);
    return Scaffold(
      // Add invisible appbar to make status bar on Android tablets bright.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: 'info-logo',
              child: Image.asset(
                'assets/info-logo.png',
                width: _width,
                height: _width,
              ),
            ),
          ),
          if (loading)
            Center(
              child: SizedBox(
                width: _width,
                child: const LinearProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
