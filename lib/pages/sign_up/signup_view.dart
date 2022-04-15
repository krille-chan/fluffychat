import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'signup.dart';

class SignupPageView extends StatelessWidget {
  final SignupPageController controller;
  const SignupPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !controller.loading,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          L10n.of(context)!.signUp,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                readOnly: controller.loading,
                autocorrect: false,
                autofillHints:
                    controller.loading ? null : [AutofillHints.password],
                controller: controller.passwordController,
                obscureText: !controller.showPassword,
                validator: controller.password1TextFieldValidator,
                decoration: FluffyThemes.loginTextFieldDecoration(
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  suffixIcon: IconButton(
                    tooltip: L10n.of(context)!.showPassword,
                    icon: Icon(controller.showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: controller.toggleShowPassword,
                  ),
                  hintText: L10n.of(context)!.chooseAStrongPassword,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                readOnly: controller.loading,
                autocorrect: false,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints:
                    controller.loading ? null : [AutofillHints.username],
                validator: controller.emailTextFieldValidator,
                decoration: FluffyThemes.loginTextFieldDecoration(
                  prefixIcon: const Icon(Icons.mail_outlined),
                  hintText: L10n.of(context)!.enterAnEmailAddress,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (controller.error != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  controller.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
            ],
            Hero(
              tag: 'loginButton',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  onPressed: controller.loading ? null : controller.signup,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white.withAlpha(200),
                    onPrimary: Colors.black,
                    shadowColor: Colors.white,
                  ),
                  child: controller.loading
                      ? const LinearProgressIndicator()
                      : Text(L10n.of(context)!.signUp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
