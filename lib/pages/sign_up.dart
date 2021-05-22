import 'dart:async';
import 'dart:io';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/views/sign_up_view.dart';
import 'package:fluffychat/utils/platform_infos.dart';

import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

import '../main.dart';

class SignUp extends StatefulWidget {
  @override
  SignUpController createState() => SignUpController();
}

class SignUpController extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  String usernameError;
  bool loading = false;
  MatrixFile avatar;

  LoginTypes _loginTypes;
  StreamSubscription _intentDataStreamSubscription;

  void _loginWithToken(String token) {
    if (token?.isEmpty ?? true) return;
    showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.login(
            type: AuthenticationTypes.token,
            token: token,
            initialDeviceDisplayName: PlatformInfos.clientName,
          ),
    );
  }

  void _processIncomingUris(String text) async {
    if (text == null || !text.startsWith(AppConfig.appOpenUrlScheme)) return;
    AdaptivePageLayout.of(context).popUntilIsFirst();
    final token = Uri.parse(text).queryParameters['loginToken'];
    if (token != null) _loginWithToken(token);
  }

  void _initReceiveUri() {
    if (!PlatformInfos.isMobile) return;
    // For receiving shared Uris
    _intentDataStreamSubscription = linkStream.listen(_processIncomingUris);
    if (FluffyChatApp.gotInitialLink == false) {
      FluffyChatApp.gotInitialLink = true;
      getInitialLink().then(_processIncomingUris);
    }
  }

  @override
  void initState() {
    super.initState();
    _initReceiveUri();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final token =
            Uri.parse(html.window.location.href).queryParameters['loginToken'];
        _loginWithToken(token);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription?.cancel();
  }

  bool get passwordLoginSupported => _loginTypes.flows
      .any((flow) => flow.type == AuthenticationTypes.password);

  bool get ssoLoginSupported =>
      _loginTypes.flows.any((flow) => flow.type == AuthenticationTypes.sso);

  Future<LoginTypes> getLoginTypes() async {
    _loginTypes ??= await Matrix.of(context).client.getLoginFlows();
    return _loginTypes;
  }

  void ssoLoginAction() {
    if (!kIsWeb && !PlatformInfos.isMobile) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Single sign on is not suppored on ${Platform.operatingSystem}'),
        ),
      );
      return;
    }
    final redirectUrl = kIsWeb
        ? html.window.location.href
        : AppConfig.appOpenUrlScheme.toLowerCase() + '://sso';
    launch(
        '${Matrix.of(context).client.homeserver?.toString()}/_matrix/client/r0/login/sso/redirect?redirectUrl=${Uri.encodeQueryComponent(redirectUrl)}');
  }

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
      await matrix.client.checkUsernameAvailability(preferredUsername);
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
  Widget build(BuildContext context) => SignUpView(this);
}
