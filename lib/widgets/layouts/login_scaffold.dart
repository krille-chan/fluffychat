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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: appBar?.automaticallyImplyLeading ?? true,
        centerTitle: appBar?.centerTitle,
        title: appBar?.title,
        leading: appBar?.leading,
        actions: appBar?.actions,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/login_wallpaper.png'),
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
