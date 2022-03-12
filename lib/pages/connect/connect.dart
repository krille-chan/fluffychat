import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/connect/connect_view.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:fluffychat/pages/settings/settings.dart';
import 'package:fluffychat/utils/famedlysdk_store.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/localized_exception_extension.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  ConnectPageController createState() => ConnectPageController();
}

class ConnectPageController extends State<ConnectPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? error;
  bool loading = true;
  bool showPassword = false;

  MatrixFile? avatar;

  Timer? _coolDown;
  String? username;
  bool? usernameTaken;

  final usernameFormatter =
      FilteringTextInputFormatter(RegExp(r'[a-z0-9\._]'), allow: true);

  void setUsername(String username) {
    this.username = username;
    setState(() {
      usernameTaken = null;
    });
    _coolDown?.cancel();
    if (username.isNotEmpty) {
      _coolDown = Timer(const Duration(milliseconds: 500), checkUsername);
    }
  }

  void toggleShowPassword() => setState(() => showPassword = !showPassword);

  String? get domain => VRouter.of(context).queryParameters['domain'];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      checkHomeserverAction();
    });
    super.initState();
  }

  /// Starts an analysis of the given homeserver. It uses the current domain and
  /// makes sure that it is prefixed with https. Then it searches for the
  /// well-known information and forwards to the login page depending on the
  /// login type.
  Future<void> checkHomeserverAction() async {
    if (domain == null || domain!.isEmpty) {
      throw L10n.of(context)!.changeTheHomeserver;
    }
    var homeserver = domain;

    if (!homeserver!.startsWith('https://')) {
      homeserver = 'https://$homeserver';
    }

    setState(() {
      error = _rawLoginTypes = registrationSupported = null;
      loading = true;
    });

    try {
      await Matrix.of(context).getLoginClient().checkHomeserver(homeserver);

      _rawLoginTypes = await Matrix.of(context).getLoginClient().request(
            RequestType.GET,
            '/client/r0/login',
          );
      try {
        await Matrix.of(context).getLoginClient().register();
        registrationSupported = true;
      } on MatrixException catch (e) {
        registrationSupported = e.requireAdditionalAuthentication;
      }
    } catch (e) {
      setState(() => error = (e).toLocalizedString(context));
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Map<String, dynamic>? _rawLoginTypes;
  bool? registrationSupported;

  List<IdentityProvider> get identityProviders {
    if (!ssoLoginSupported) return [];
    final rawProviders = _rawLoginTypes!.tryGetList('flows')!.singleWhere(
        (flow) =>
            flow['type'] == AuthenticationTypes.sso)['identity_providers'];
    final list = (rawProviders as List)
        .map((json) => IdentityProvider.fromJson(json))
        .toList();
    if (PlatformInfos.isCupertinoStyle) {
      list.sort((a, b) => a.brand == 'apple' ? -1 : 1);
    }
    return list;
  }

  bool get passwordLoginSupported =>
      Matrix.of(context)
          .getLoginClient()
          .supportedLoginTypes
          .contains(AuthenticationTypes.password) &&
      _rawLoginTypes!
          .tryGetList('flows')!
          .any((flow) => flow['type'] == AuthenticationTypes.password);

  bool get ssoLoginSupported =>
      Matrix.of(context)
          .getLoginClient()
          .supportedLoginTypes
          .contains(AuthenticationTypes.sso) &&
      _rawLoginTypes!
          .tryGetList('flows')!
          .any((flow) => flow['type'] == AuthenticationTypes.sso);

  static const String ssoHomeserverKey = 'sso-homeserver';

  void ssoLoginAction(String id) async {
    if (kIsWeb) {
      // We store the homserver in the local storage instead of a redirect
      // parameter because of possible CSRF attacks.
      Store().setItem(ssoHomeserverKey,
          Matrix.of(context).getLoginClient().homeserver.toString());
    }
    final redirectUrl = kIsWeb
        ? html.window.origin! + '/web/auth.html'
        : AppConfig.appOpenUrlScheme.toLowerCase() + '://login';
    final url =
        '${Matrix.of(context).getLoginClient().homeserver?.toString()}/_matrix/client/r0/login/sso/redirect/${Uri.encodeComponent(id)}?redirectUrl=${Uri.encodeQueryComponent(redirectUrl)}';
    final urlScheme = Uri.parse(redirectUrl).scheme;
    final result = await FlutterWebAuth.authenticate(
      url: url,
      callbackUrlScheme: urlScheme,
    );
    final token = Uri.parse(result).queryParameters['loginToken'];
    if (token != null) _loginWithToken(token);
  }

  void signUpAction() => VRouter.of(context).to(
        'signup',
        queryParameters: {'domain': domain!, 'username': username!},
      );

  void _loginWithToken(String token) {
    if (token.isEmpty) return;

    showFutureLoadingDialog(
      context: context,
      future: () async {
        if (Matrix.of(context).getLoginClient().homeserver == null) {
          await Matrix.of(context).getLoginClient().checkHomeserver(
                await Store().getItem(ConnectPageController.ssoHomeserverKey),
              );
        }
        await Matrix.of(context).getLoginClient().login(
              LoginType.mLoginToken,
              token: token,
              initialDeviceDisplayName: PlatformInfos.clientName,
            );
      },
    );
  }

  String? usernameTextFieldValidator(String? value) {
    usernameController.text =
        usernameController.text.trim().toLowerCase().replaceAll(' ', '_');
    if (value!.isEmpty) {
      return L10n.of(context)!.pleaseChooseAUsername;
    }
    return null;
  }

  String? password1TextFieldValidator(String? value) {
    const minLength = 8;
    if (value!.isEmpty) {
      return L10n.of(context)!.chooseAStrongPassword;
    }
    if (value.length < minLength) {
      return L10n.of(context)!.pleaseChooseAtLeastChars(minLength.toString());
    }
    return null;
  }

  String? password2TextFieldValidator(String? value) {
    if (value!.isEmpty) {
      return L10n.of(context)!.chooseAStrongPassword;
    }
    if (value != passwordController.text) {
      return L10n.of(context)!.passwordsDoNotMatch;
    }
    return null;
  }

  String? emailTextFieldValidator(String? value) {
    if (value!.isNotEmpty && !value.contains('@')) {
      return L10n.of(context)!.pleaseEnterValidEmail;
    }
    return null;
  }

  void signup([_]) async {
    setState(() {
      error = null;
    });
    if (!formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {
      final client = Matrix.of(context).getLoginClient();
      final email = emailController.text;
      if (email.isNotEmpty) {
        Matrix.of(context).currentClientSecret =
            DateTime.now().millisecondsSinceEpoch.toString();
        Matrix.of(context).currentThreepidCreds =
            await client.requestTokenToRegisterEmail(
          Matrix.of(context).currentClientSecret,
          email,
          0,
        );
      }
      await client.uiaRequestBackground(
        (auth) => client.register(
          username: usernameController.text,
          password: passwordController.text,
          initialDeviceDisplayName: PlatformInfos.clientName,
          auth: auth,
        ),
      );
    } catch (e) {
      error = (e).toLocalizedString(context);
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => ConnectPageView(this);

  Future<void> setAvatarAction() async {
    final actions = [
      if (PlatformInfos.isMobile)
        SheetAction(
          key: AvatarAction.camera,
          label: L10n.of(context)!.openCamera,
          isDefaultAction: true,
          icon: Icons.camera_alt_outlined,
        ),
      SheetAction(
        key: AvatarAction.file,
        label: L10n.of(context)!.openGallery,
        icon: Icons.photo_outlined,
      ),
      if (avatar != null)
        SheetAction(
          key: AvatarAction.remove,
          label: L10n.of(context)!.removeYourAvatar,
          isDestructiveAction: true,
          icon: Icons.delete_outlined,
        ),
    ];
    final action = actions.length == 1
        ? actions.single
        : await showModalActionSheet<AvatarAction>(
            context: context,
            title: L10n.of(context)!.changeYourAvatar,
            actions: actions,
          );
    if (action == null) return;
    if (action == AvatarAction.remove) {
      setState(() => avatar = null);
      return;
    }
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().pickImage(
        source: action == AvatarAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 50,
      );
      if (result == null) return;
      final file = await _buildAvatar(await result.readAsBytes(), result.name);
      setState(() => avatar = file);
    } else {
      final result =
          await FilePickerCross.importFromStorage(type: FileTypeCross.image);
      if (result.fileName == null) return;
      final file = await _buildAvatar(result.toUint8List(), result.path!);

      setState(() => avatar = file);
    }
  }

  // we don't need 4k wallpapers as avatars...
  Future<MatrixImageFile?> _buildAvatar(Uint8List bytes, String name) {
    final file = MatrixImageFile(
      bytes: bytes,
      name: name,
    );
    return file.generateThumbnail(
      dimension: 1024,
      compute: Matrix.of(context).getLoginClient().runInBackground,
    );
  }

  void checkUsername() {
    // TODO(TheOneWithTheBraid): Check whether username available
    setState(() {
      usernameTaken = false;
    });
  }

  void applyAvatar() => Matrix.of(context).getLoginClient().setAvatar(avatar);
}
