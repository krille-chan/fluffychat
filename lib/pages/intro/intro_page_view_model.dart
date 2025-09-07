import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';

import 'package:fluffychat/utils/tor_stub.dart'
    if (dart.library.html) 'package:tor_detector_web/tor_detector_web.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IntroPageViewModel extends StatefulWidget {
  final Widget Function(BuildContext, IntroPageViewModelState) builder;
  const IntroPageViewModel({required this.builder, super.key});

  @override
  State<IntroPageViewModel> createState() => IntroPageViewModelState();
}

class IntroPageViewModelState extends State<IntroPageViewModel> {
  bool isTorBrowser = false;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    _checkTorBrowser();
    super.initState();
  }

  Future<void> _checkTorBrowser() async {
    if (!kIsWeb) return;

    final isTor = await TorBrowserDetector.isTorBrowser;
    isTorBrowser = isTor;
  }

  Future<void> restoreBackup() async {
    final picked = await selectFiles(context);
    final file = picked.firstOrNull;
    if (file == null) return;
    setState(() {
      error = null;
      isLoading = true;
    });
    try {
      final client = await Matrix.of(context).getLoginClient();
      await client.importDump(String.fromCharCodes(await file.readAsBytes()));
      Matrix.of(context).initMatrix();
    } catch (e) {
      setState(() {
        error = e.toLocalizedString(context);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onMoreAction(MoreLoginActions action) async {
    switch (action) {
      case MoreLoginActions.importBackup:
        restoreBackup();
      case MoreLoginActions.privacy:
        launchUrlString(AppConfig.privacyUrl);
      case MoreLoginActions.about:
        PlatformInfos.showDialog(context);
      case MoreLoginActions.loginWithMxid:
        context.go(
          "/home/login_mxid",
          extra: await Matrix.of(context).getLoginClient(),
        );
    }
  }

  void createNewAccount() => context.go("/home/register");
  void loginToExistingAccount() => context.go("/home/login");
  void loginWithMxidExistingAccount() => context.go("/home/login_mxid");

  @override
  Widget build(BuildContext context) => widget.builder(context, this);
}

enum MoreLoginActions { loginWithMxid, importBackup, privacy, about }
