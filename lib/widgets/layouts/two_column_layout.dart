import 'package:fluffychat/pages/global_banner_scaffold.dart';
import 'package:fluffychat/utils/app_state.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TwoColumnLayout extends StatelessWidget {
  final Widget mainView;
  final Widget sideView;
  final bool displayNavigationRail;

  const TwoColumnLayout({
    super.key,
    required this.mainView,
    required this.sideView,
    required this.displayNavigationRail,
  });
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        body: Column(
          children: [
            Selector<AppState, Widget?>(
              selector: (_, state) => state.globalBanner,
              builder: (context, banner, _) {
                final showBanner = !GlobalBannerScaffold.ignoreBannerRoutes.any(
                      (route) => GoRouter.of(context)
                          .routerDelegate
                          .currentConfiguration
                          .uri
                          .toString()
                          .contains(route),
                    ) &&
                    Matrix.of(context).client.isLogged();
                return AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Column(
                    children: [
                      if (showBanner && banner != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                          ),
                          child: banner,
                        ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    width: 360.0 + (displayNavigationRail ? 64 : 0),
                    child: mainView,
                  ),
                  Container(
                    width: 1.0,
                    color: Theme.of(context).dividerColor,
                  ),
                  Expanded(
                    child: ClipRRect(
                      child: sideView,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
