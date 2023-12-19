import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

//Input Form for two Fields
class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function(bool) completerCallback;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.completerCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(L10n.of(context)!.enterYourDetails),
          const SizedBox(height: 5),
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(labelText: L10n.of(context)!.username),
            validator: (value) {
              if (value!.isEmpty) {
                return L10n.of(context)!.pleaseEnterYourUsername;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(labelText: L10n.of(context)!.password),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              if (value!.isEmpty) {
                return L10n.of(context)!.pleaseEnterPassword;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

//Input Form for WhatsApp login
class WhatsAppLoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final Function(bool) completerCallback;

  const WhatsAppLoginForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.completerCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(L10n.of(context)!.enterYourDetails),
          const SizedBox(height: 5),
          IntlPhoneField(
            initialCountryCode:
                Localizations.localeOf(context).languageCode.toUpperCase(),
            onChanged: (PhoneNumber phoneNumberField) {
              controller.text = phoneNumberField.completeNumber;
            },
            // Initial country code via language used in Locale currentLocale
            languageCode: Localizations.localeOf(context).languageCode,
            onCountryChanged: (country) {},
          ),
          const SizedBox(height: 5),
          Text(
            L10n.of(context)!.phoneField_explain,
          ),
          const SizedBox(height: 5),
          Text(
            L10n.of(context)!.phoneField_initialZero,
          ),
        ],
      ),
    );
  }
}
