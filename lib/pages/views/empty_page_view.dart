import 'dart:math';

import 'package:fluffychat/widgets/background_gradient_box.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final bool loading;
  static const double _width = 200;
  const EmptyPage({this.loading = false, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _width = min(MediaQuery.of(context).size.width, EmptyPage._width);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundGradientBox(),
          Column(
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
                    child: LinearProgressIndicator(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
