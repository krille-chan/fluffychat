import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/settings_password/settings_password_view.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPassword extends StatefulWidget {
  const SettingsPassword({super.key});

  @override
  SettingsPasswordController createState() => SettingsPasswordController();
}

class SettingsPasswordController extends State<SettingsPassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPassword1Controller = TextEditingController();
  final TextEditingController newPassword2Controller = TextEditingController();

  String? oldPasswordError;
  String? newPassword1Error;
  String? newPassword2Error;

  bool loading = false;

  Future<void> changePassword() async {
    final l10n = L10n.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() {
      oldPasswordError = newPassword1Error = newPassword2Error = null;
    });
    if (oldPasswordController.text.isEmpty) {
      setState(() {
        oldPasswordError = L10n.of(context).pleaseEnterYourPassword;
      });
      return;
    }
    if (newPassword1Controller.text.isEmpty ||
        newPassword1Controller.text.length < 6) {
      setState(() {
        newPassword1Error = L10n.of(context).pleaseChooseAStrongPassword;
      });
      return;
    }
    if (newPassword1Controller.text != newPassword2Controller.text) {
      setState(() {
        newPassword2Error = L10n.of(context).passwordsDoNotMatch;
      });
      return;
    }

    setState(() {
      loading = true;
    });
    try {
      await Matrix.of(context).client.changePassword(
        newPassword1Controller.text,
        oldPassword: oldPasswordController.text,
      );
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.passwordHasBeenChanged)),
      );
      if (mounted) context.pop();
    } catch (e) {
      setState(() {
        newPassword2Error = e.toLocalizedString(
          context,
          ExceptionContext.changePassword,
        );
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => SettingsPasswordView(this);
}
