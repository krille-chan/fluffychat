import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/views/ui/sign_up_ui.dart';

import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SignUp extends StatefulWidget {
  @override
  SignUpController createState() => SignUpController();
}

class SignUpController extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  String usernameError;
  bool loading = false;
  MatrixFile avatar;

  void setAvatarAction() async {
    final file =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    if (file != null) {
      setState(
        () => avatar = MatrixFile(
          bytes: file.toUint8List(),
          name: file.fileName,
        ),
      );
    }
  }

  void resetAvatarAction() => setState(() => avatar = null);

  void signUpAction([_]) async {
    final matrix = Matrix.of(context);
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = L10n.of(context).pleaseChooseAUsername);
    } else {
      setState(() => usernameError = null);
    }

    if (usernameController.text.isEmpty) {
      return;
    }
    setState(() => loading = true);

    final preferredUsername =
        usernameController.text.toLowerCase().trim().replaceAll(' ', '-');

    try {
      await matrix.client.usernameAvailable(preferredUsername);
    } on MatrixException catch (exception) {
      setState(() => usernameError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      setState(() => usernameError = exception.toString());
      return setState(() => loading = false);
    }
    setState(() => loading = false);
    await AdaptivePageLayout.of(context).pushNamed(
      '/signup/password/${Uri.encodeComponent(preferredUsername)}/${Uri.encodeComponent(usernameController.text)}',
      arguments: avatar,
    );
  }

  @override
  Widget build(BuildContext context) => SignUpUI(this);
}
