import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'homeserver_picker.dart';
import 'homeserver_tile.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(title: Text(L10n.of(context)!.selectCommunity)),
        body: PageTransitionSwitcher(
          transitionBuilder: (
            Widget child,
            Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              fillColor: Colors.transparent,
              child: child,
            );
          },
          child: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  key: ValueKey(controller.isLoading),
                  slivers: [
                    SliverAppBar(
                      // pinned: _pinned,
                      // snap: _snap,
                      // floating: _floating,
                      expandedHeight: 256,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.asset(
                          Theme.of(context).brightness == Brightness.dark
                              ? 'assets/banner_dark.png'
                              : 'assets/banner.png',
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller.homeserverController,
                          readOnly: !AppConfig.allowOtherHomeservers,
                          autocorrect: false,
                          onChanged: controller.searchHomeserver,
                          decoration: InputDecoration(
                            // prefixText: 'https://',
                            hintText: L10n.of(context)!.homeserver,
                            suffixIcon: const Icon(Icons.search),
                            labelText: L10n.of(context)!.customHomeserver,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).bottomAppBarTheme.color,
                          clipBehavior: Clip.hardEdge,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.homeserverCount,
                            itemBuilder: (BuildContext context, int index) {
                              if (controller.filteredHomeservers.length <=
                                  index) {
                                if (controller.customHomeserverLoading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  if (controller.domain != null) {
                                    return CustomHomeserverTile(
                                      domain: controller.domain!,
                                      onSelect: () => controller
                                          .setHomeserver(controller.domain!),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                              }
                              final e = controller.filteredHomeservers[index];
                              return HomeserverTile(
                                benchmark: e,
                                controller: controller,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const Divider(),
                          JoinMatrixAttributionTile(),
                        ],
                      ),
                    )
                  ],
                ),
        ),
        bottomNavigationBar: Material(
          elevation: 6,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonBar(
                children: [
                  OutlinedButton(
                    onPressed: controller.domain != null
                        ? () => controller.setHomeserver(controller.domain!)
                        : null,
                    child: Text(L10n.of(context)!.selectServer),
                  )
                ],
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => launch(AppConfig.privacyUrl),
                    child: Text(
                      L10n.of(context)!.privacy,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => PlatformInfos.showDialog(context),
                    child: Text(
                      L10n.of(context)!.about,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
