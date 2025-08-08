import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'login.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/menu_login_options.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;
  final bool enforceMobileMode;
  final Client client;

  const LoginView(
    this.controller, {
    super.key,
    this.enforceMobileMode = false,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobileMode =
        enforceMobileMode || !FluffyThemes.isColumnMode(context);

    final screenHeight = MediaQuery.of(context).size.height;

    final mobileAppBarHeight = screenHeight * 0.15;
    final mobileAppBarTitlePaddingTop = mobileAppBarHeight - 18;
    final mobileImagePadding = screenHeight * 0.13;

    const desktopAppBarHeight = 80.0;
    const desktopAppBarTitlePaddingTop = 30.0;
    const desktopImagePadding = 45.0;

    final toolBarHeight =
        isMobileMode ? mobileAppBarHeight : desktopAppBarHeight;
    final toolBarPadding = isMobileMode
        ? mobileAppBarTitlePaddingTop
        : desktopAppBarTitlePaddingTop;
    final imagePadding =
        isMobileMode ? mobileImagePadding : desktopImagePadding;

    return LoginScaffold(
      appBar: AppBar(
        backgroundColor: isMobileMode
            ? theme.colorScheme.surface
            : theme.colorScheme.tertiary,
        toolbarHeight: toolBarHeight,
        title: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            top: toolBarPadding,
          ),
          child: Align(
            alignment: isMobileMode ? Alignment.topLeft : Alignment.centerLeft,
            child: Text(
              L10n.of(context).login,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        actions: [
          MoreLoginMenuButton(
            padding: EdgeInsets.only(right: 16.0, top: toolBarPadding - 15),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: imagePadding),
                      child: FractionallySizedBox(
                        widthFactor: isMobileMode ? 0.6 : 0.5,
                        child: Image.asset(
                          'assets/logo_horizontal_semfundo.png',
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextField(
                        style: TextStyle(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',
                        ),
                        readOnly: controller.loading,
                        autocorrect: false,
                        autofocus: true,
                        onChanged: controller.checkWellKnownWithCoolDown,
                        controller: controller.usernameController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: controller.loading
                            ? null
                            : [AutofillHints.username],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_box_outlined),
                          errorText: controller.usernameError,
                          errorStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          labelText: L10n.of(context).emailOrUsername,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextField(
                        style: TextStyle(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Roboto',
                        ),
                        readOnly: controller.loading,
                        autocorrect: false,
                        autofillHints: controller.loading
                            ? null
                            : [AutofillHints.password],
                        controller: controller.passwordController,
                        textInputAction: TextInputAction.go,
                        obscureText: !controller.showPassword,
                        onSubmitted: (_) => controller.login(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outlined),
                          errorText: controller.passwordError,
                          errorStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          suffixIcon: IconButton(
                            onPressed: controller.toggleShowPassword,
                            icon: Icon(
                              controller.showPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          labelText: L10n.of(context).password,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              controller.loading ? null : controller.login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          child: controller.loading
                              ? const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: LinearProgressIndicator(),
                                )
                              : Text(
                                  L10n.of(context).login,
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${L10n.of(context).newHere} ',
                                style: GoogleFonts.fredoka(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: L10n.of(context).createAnAccountPrompt,
                                style: GoogleFonts.fredoka(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.go('/register', extra: client);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: controller.loading
                              ? null
                              : controller.passwordForgotten,
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          child: Text(
                            L10n.of(context).passwordForgotten,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
