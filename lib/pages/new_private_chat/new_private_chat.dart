import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:fluffychat/pages/new_private_chat/new_private_chat_view.dart';
import 'package:fluffychat/pages/new_private_chat/qr_scanner_modal.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewPrivateChat extends StatefulWidget {
  const NewPrivateChat({Key key}) : super(key: key);

  @override
  NewPrivateChatController createState() => NewPrivateChatController();
}

class NewPrivateChatController extends State<NewPrivateChat> {
  final TextEditingController controller = TextEditingController();
  final FocusNode textFieldFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  bool hideFab = false;

  static const Set<String> supportedSigils = {'@', '!', '#'};

  static const String prefix = 'https://matrix.to/#/';

  void setHideFab() {
    if (textFieldFocus.hasFocus != hideFab) {
      setState(() => hideFab = textFieldFocus.hasFocus);
    }
  }

  @override
  void initState() {
    super.initState();
    textFieldFocus.addListener(setHideFab);
  }

  @override
  void dispose() {
    textFieldFocus.removeListener(setHideFab);
    super.dispose();
  }

  void submitAction([_]) async {
    controller.text = controller.text.trim();
    if (!formKey.currentState.validate()) return;
    UrlLauncher(context, '$prefix${controller.text}').openMatrixToUrl();
  }

  String validateForm(String value) {
    if (value.isEmpty) {
      return L10n.of(context).pleaseEnterAMatrixIdentifier;
    }
    if (!controller.text.isValidMatrixId ||
        !supportedSigils.contains(controller.text.sigil)) {
      return L10n.of(context).makeSureTheIdentifierIsValid;
    }
    if (controller.text == Matrix.of(context).client.userID) {
      return L10n.of(context).youCannotInviteYourself;
    }
    return null;
  }

  void inviteAction() => FluffyShare.share(
        'https://matrix.to/#/${Matrix.of(context).client.userID}',
        context,
      );

  void openScannerAction() async {
    await Permission.camera.request();
    await showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      //useSafeArea: false,
      builder: (_) => const QrScannerModal(),
    );
  }

  @override
  Widget build(BuildContext context) => NewPrivateChatView(this);
}
