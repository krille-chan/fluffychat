// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/l10n.dart';

// Project imports:
import 'package:fluffychat/pangea/utils/password_forgotten.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
      // #Pangea
      // enforceMobileMode: Matrix.of(context).client.isLogged(),
      // Pangea#
      appBar: AppBar(
        leading: controller.loading ? null : const BackButton(),
        automaticallyImplyLeading: !controller.loading,
        centerTitle: true,
        // #Pangea
        // title: Text(
        //   L10n.of(context)!.logInTo(
        //     Matrix.of(context)
        //         .getLoginClient()
        //         .homeserver
        //         .toString()
        //         .replaceFirst('https://', ''),
        //   ),
        // ),
        // Pangea#
      ),
      body: Builder(
        builder: (context) {
          return AutofillGroup(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    readOnly: controller.loading,
                    autocorrect: false,
                    autofocus: true,
                    onChanged: controller.checkWellKnownWithCoolDown,
                    controller: controller.usernameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints:
                        controller.loading ? null : [AutofillHints.username],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_box_outlined),
                      errorText: controller.usernameError,
                      errorStyle: const TextStyle(color: Colors.orange),
                      hintText: L10n.of(context)!.emailOrUsername,
                      // #Pangea
                      fillColor: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.75),
                      // Pangea#
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
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
                      errorStyle: const TextStyle(color: Colors.orange),
                      // #Pangea
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
                            color: Colors.black,
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
                      // #Pangea
                      fillColor: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.75),
                      // Pangea#
                    ),
                  ),
                ),
                Hero(
                  tag: 'signinButton',
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
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
                    //     backgroundColor: Theme.of(context).colorScheme.primary,
                    //     foregroundColor:
                    //         Theme.of(context).colorScheme.onPrimary,
                    //   ),
                    //   onPressed: controller.loading ? null : controller.login,
                    //   icon: const Icon(Icons.login_outlined),
                    //   label: controller.loading
                    //       ? const LinearProgressIndicator()
                    //       : Text(L10n.of(context)!.login),
                    // ),
                    // Pangea$
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          // #Pangea
                          color: Colors.white,
                          // color: Theme.of(context).dividerColor,
                          // Pangea#
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
                          // #Pangea
                          color: Colors.white,
                          // color: Theme.of(context).dividerColor,
                          // Pangea#
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  // #Pangea
                  child: ElevatedButton(
                    onPressed: controller.loading
                        ? () {}
                        : controller.pangeaPasswordForgotten,
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.red),
                    child: Text(L10n.of(context)!.passwordForgotten),
                  ),
                  // child: ElevatedButton.icon(
                  //   onPressed: controller.loading
                  //       ? () {}
                  //       : controller.passwordForgotten,
                  //   style: ElevatedButton.styleFrom(
                  //     foregroundColor: Theme.of(context).colorScheme.error,
                  //     backgroundColor: Theme.of(context).colorScheme.onError,
                  //   ),
                  //   icon: const Icon(Icons.safety_check_outlined),
                  //   label: Text(L10n.of(context)!.passwordForgotten),
                  // ),
                  // Pangea#
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
