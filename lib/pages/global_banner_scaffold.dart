import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/app_state.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:fluffychat/widgets/matrix.dart';

class GlobalBannerScaffold extends StatefulWidget {
  // the actual page below the banner
  final Widget child;

  const GlobalBannerScaffold({super.key, required this.child});

  // add strings or whole routes you don't want banner to be in
  static const ignoreBannerRoutes = ['call'];

  @override
  State<GlobalBannerScaffold> createState() => _GlobalBannerScaffoldState();
}

class _GlobalBannerScaffoldState extends State<GlobalBannerScaffold> {
  StreamSubscription? _onSyncStatusSub;

  @override
  void dispose() {
    _onSyncStatusSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FluffyThemes.isColumnMode(context)) return widget.child;
    return Selector<AppState, Widget?>(
      selector: (_, state) => state.globalBanner,
      child: widget.child,
      builder: (context, banner, child) {
        final bool showBanner = banner != null &&
            !GlobalBannerScaffold.ignoreBannerRoutes.any(
              (route) => FluffyChatApp
                  .router.routerDelegate.currentConfiguration.uri
                  .toString()
                  .contains(route),
            ) &&
            Matrix.of(context).client.isLogged();

        return showBanner
            ? Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  toolbarHeight: showBanner ? 70 : 0,
                  automaticallyImplyLeading: false,
                  title: Column(
                    children: [
                      if (showBanner)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: banner,
                        ),
                    ],
                  ),
                ),
                body: child,
              )
            : child ?? widget.child; // only for null safety, never occurs
      },
    );
  }
}
