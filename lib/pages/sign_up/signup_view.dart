import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'signup.dart';

class SignupPageView extends StatelessWidget {
  final SignupPageController controller;
  const SignupPageView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).signUp),
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
                  controller: controller.usernameController,
                  autofillHints:
                      controller.loading ? null : [AutofillHints.username],
                  validator: controller.usernameTextFieldValidator,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle_outlined),
                      hintText: L10n.of(context).username,
                      labelText: L10n.of(context).username,
                      prefixText: '@',
                      prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
                      suffixStyle: const TextStyle(fontWeight: FontWeight.w200),
                      suffixText: ':${controller.domain}'),
                ),
              ),
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
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key_outlined),
                    hintText: '****',
                    suffixIcon: IconButton(
                      tooltip: L10n.of(context).showPassword,
                      icon: Icon(controller.showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: controller.toggleShowPassword,
                    ),
                    labelText: L10n.of(context).password,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  readOnly: controller.loading,
                  autocorrect: false,
                  autofillHints:
                      controller.loading ? null : [AutofillHints.password],
                  controller: controller.passwordController2,
                  obscureText: true,
                  validator: controller.password2TextFieldValidator,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.repeat_outlined),
                    hintText: '****',
                    labelText: L10n.of(context).repeatPassword,
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
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail_outlined),
                    labelText: L10n.of(context).addEmail,
                    hintText: 'email@example.abc',
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 12),
              if (controller.error != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    controller.error,
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
                    child: controller.loading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context).signUp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
