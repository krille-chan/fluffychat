import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import 'model/social_network.dart';

//Input Form for two Fields
class LoginForm extends StatefulWidget {
  final SocialNetwork socialNetwork;
  final GlobalKey<FormState> formKey;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final Function(bool) completerCallback;

  const LoginForm({
    super.key,
    required this.socialNetwork,
    required this.formKey,
    required this.identifierController,
    required this.passwordController,
    required this.completerCallback,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;

  void toggleShowPassword() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(L10n.of(context)!.enterYourDetails),
          const SizedBox(height: 5),
          TextFormField(
            controller: widget.identifierController,
            decoration: InputDecoration(
                labelText: widget.socialNetwork.name == 'Instagram'
                    ? L10n.of(context)!.username
                    : L10n.of(context)!.email),
            validator: (value) {
              if (value!.isEmpty) {
                return L10n.of(context)!.pleaseEnterYourUsername;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.passwordController,
            obscureText: _obscureText,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: toggleShowPassword,
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black,
                ),
              ),
              hintText: L10n.of(context)!.password,
            ),
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
            disableLengthCheck: true,
            initialCountryCode:
                Localizations.localeOf(context).languageCode.toUpperCase(),
            onChanged: (PhoneNumber phoneNumberField) {
              String localNumber = phoneNumberField.number;

              // If the local number begins with '0', it is removed
              if (localNumber.startsWith('0')) {
                localNumber = localNumber.substring(1);
              }

              // Reconstruct the complete number with the country code
              controller.text = '${phoneNumberField.countryCode}$localNumber';
            },

            // Initial country code via language used in Locale currentLocale
            languageCode: Localizations.localeOf(context).languageCode,
            onCountryChanged: (country) {},
          ),
          const SizedBox(height: 5),
          Text(
            L10n.of(context)!.phoneFieldExplain,
          ),
          const SizedBox(height: 5),
          Text(
            L10n.of(context)!.phoneFieldInitialZero,
          ),
        ],
      ),
    );
  }
}
