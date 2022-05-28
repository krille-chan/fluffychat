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
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                readOnly: controller.loading,
                autocorrect: false,
                onChanged: controller.onPasswordType,
                autofillHints:
                    controller.loading ? null : [AutofillHints.newPassword],
                controller: controller.passwordController,
                obscureText: !controller.showPassword,
                validator: controller.password1TextFieldValidator,
                decoration: FluffyThemes.loginTextFieldDecoration(
                  prefixIcon: const Icon(
                    Icons.vpn_key_outlined,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    tooltip: L10n.of(context)!.showPassword,
                    icon: Icon(
                      controller.showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.black,
                    ),
                    onPressed: controller.toggleShowPassword,
                  ),
                  hintText: L10n.of(context)!.chooseAStrongPassword,
                ),
              ),
            ),
            if (controller.displaySecondPasswordField)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  readOnly: controller.loading,
                  autocorrect: false,
                  autofillHints:
                      controller.loading ? null : [AutofillHints.newPassword],
                  controller: controller.password2Controller,
                  obscureText: !controller.showPassword,
                  validator: controller.password2TextFieldValidator,
                  decoration: FluffyThemes.loginTextFieldDecoration(
                    prefixIcon: const Icon(
                      Icons.repeat_outlined,
                      color: Colors.black,
                    ),
                    hintText: L10n.of(context)!.repeatPassword,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                readOnly: controller.loading,
                autocorrect: false,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints:
                    controller.loading ? null : [AutofillHints.username],
                validator: controller.emailTextFieldValidator,
                decoration: FluffyThemes.loginTextFieldDecoration(
                    prefixIcon: const Icon(
                      Icons.mail_outlined,
                      color: Colors.black,
                    ),
                    hintText: L10n.of(context)!.enterAnEmailAddress,
                    errorText: controller.error),
              ),
            ),
            Hero(
              tag: 'loginButton',
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: controller.loading ? () {} : controller.signup,
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
