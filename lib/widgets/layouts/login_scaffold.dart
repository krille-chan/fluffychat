import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;

  const LoginScaffold({
    Key? key,
    required this.body,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/login_wallpaper.png',
            ),
          ),
        ),
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: body,
        ),
      ),
    );
  }
}
