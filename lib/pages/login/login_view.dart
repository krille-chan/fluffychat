import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // #Pangea
    // final homeserver = Matrix.of(context)
    //     .getLoginClient()
    //     .homeserver
    //     .toString()
    //     .replaceFirst('https://', '');
    // final title = L10n.of(context)!.logInTo(homeserver);
    // final titleParts = title.split(homeserver);

    // final textFieldFillColor = FluffyThemes.isColumnMode(context)
    //     ? theme.colorScheme.surface
    //     // ignore: deprecated_member_use
    //     : theme.colorScheme.surfaceVariant;
    // Pangea#

    return LoginScaffold(
      // #Pangea
      // enforceMobileMode: Matrix.of(context).client.isLogged(),
      // Pangea#
      appBar: AppBar(
        // #Pangea
        // leading: controller.loading ? null : const BackButton(),
        leading: controller.loading
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.surface.withOpacity(0.75),
                    ),
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                      const CircleBorder(),
                    ),
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
        // Pangea#
        automaticallyImplyLeading: !controller.loading,
        titleSpacing: !controller.loading ? 0 : null,
        // #Pangea
        // title: Text.rich(
        //   TextSpan(
        //     children: [
        //       TextSpan(text: titleParts.first),
        //       TextSpan(
        //         text: homeserver,
        //         style: const TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //       TextSpan(text: titleParts.last),
        //     ],
        //   ),
        //   style: const TextStyle(fontSize: 18),
        // ),
        // Pangea#
      ),
      body: Builder(
        builder: (context) {
          return AutofillGroup(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: <Widget>[
                // #Pangea
                const SizedBox(height: 80),
                // Image.asset('assets/banner_transparent.png'),
                // const SizedBox(height: 16),
                // Pangea#
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    readOnly: controller.loading,
                    autocorrect: false,
                    autofocus: true,
                    // #Pangea
                    // onChanged: controller.checkWellKnownWithCoolDown,
                    // Pangea#
                    controller: controller.usernameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints:
                        controller.loading ? null : [AutofillHints.username],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_box_outlined),
                      errorText: controller.usernameError,
                      // #Pangea
                      // errorStyle: const TextStyle(color: Colors.orange),
                      errorStyle: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 14,
                      ),
                      // fillColor: textFieldFillColor,
                      fillColor: theme.colorScheme.surface.withOpacity(0.75),
                      // Pangea#
                      hintText: L10n.of(context)!.emailOrUsername,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    readOnly: controller.loading,
                    autocorrect: false,
                    autofillHints:
                        controller.loading ? null : [AutofillHints.password],
                    controller: controller.passwordController,
                    textInputAction: TextInputAction.go,
                    obscureText: !controller.showPassword,
                    onSubmitted: (_) => controller.login(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outlined),
                      errorText: controller.passwordError,
                      // #Pangea
                      // errorStyle: const TextStyle(color: Colors.orange),
                      errorStyle: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 14,
                      ),
                      // fillColor: textFieldFillColor,
                      fillColor: theme.colorScheme.surface.withOpacity(0.75),
                      // prevent enter key from clicking show password button
                      suffixIcon: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: controller.toggleShowPassword,
                          child: Icon(
                            controller.showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                      // suffixIcon: IconButton(
                      //   onPressed: controller.toggleShowPassword,
                      //   icon: Icon(
                      //     controller.showPassword
                      //         ? Icons.visibility_off_outlined
                      //         : Icons.visibility_outlined,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      // Pangea#
                      hintText: L10n.of(context)!.password,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  // #Pangea
                  child: ElevatedButton(
                    onPressed:
                        controller.loading ? null : () => controller.login(),
                    child: controller.loading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context)!.login),
                  ),
                  // child: ElevatedButton.icon(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: theme.colorScheme.primary,
                  //     foregroundColor: theme.colorScheme.onPrimary,
                  //   ),
                  //   onPressed: controller.loading ? null : controller.login,
                  //   icon: const Icon(Icons.login_outlined),
                  //   label: controller.loading
                  //       ? const LinearProgressIndicator()
                  //       : Text(L10n.of(context)!.login),
                  // ),
                  // Pangea#
                ),
                // #Pangea
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          L10n.of(context)!.or,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Pangea#
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  // #Pangea
                  child: ElevatedButton(
                    onPressed: controller.loading
                        ? () {}
                        : controller.passwordForgotten,
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.red),
                    child: Text(L10n.of(context)!.passwordForgotten),
                  ),
                  // child: TextButton.icon(
                  //   onPressed: controller.loading
                  //       ? () {}
                  //       : controller.passwordForgotten,
                  //   style: TextButton.styleFrom(
                  //     foregroundColor: theme.colorScheme.error,
                  //   ),
                  //   icon: const Icon(Icons.safety_check_outlined),
                  //   label: Text(L10n.of(context)!.passwordForgotten),
                  // ),
                  // Pangea#
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
