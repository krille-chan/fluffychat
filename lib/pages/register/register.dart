import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tawkie/pages/register/register_view.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterController createState() => RegisterController();
}

class RegisterController extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? emailError;
  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;
  bool loading = false;
  bool showPassword = false;
  final Dio dio = Dio(BaseOptions(baseUrl: 'BASE_URL_HERE'));
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

  Future<void> register() async {
    if (emailController.text.isEmpty) {
      setState(
          () => emailError = L10n.of(context)!.register_pleaseEnterYourEmail);
    } else {
      setState(() => emailError = null);
    }

    if (usernameController.text.isEmpty) {
      setState(() => emailError = L10n.of(context)!.pleaseEnterYourUsername);
    } else {
      setState(() => emailError = null);
    }

    if (passwordController.text.isEmpty) {
      setState(() => passwordError = L10n.of(context)!.pleaseEnterYourPassword);
    } else {
      setState(() => passwordError = null);
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(() => confirmPasswordError =
          L10n.of(context)!.register_pleaseConfirmYourPassword);
    } else {
      setState(() => confirmPasswordError = null);
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(
          () => confirmPasswordError = L10n.of(context)!.passwordsDoNotMatch);
      return;
    }

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return;
    }

    setState(() => loading = true);

    // Perform registration logic here

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => RegisterView(this);
}
