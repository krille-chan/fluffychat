import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/widgets/navigation_rail.dart';
import 'chat_list_body.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluffychat/widgets/audio_player_stream.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !controller.isSearchMode && controller.activeSpaceId == null,
      onPopInvokedWithResult: (pop, _) {
        if (pop) return;
        if (controller.activeSpaceId != null) {
          controller.clearActiveSpace();
          return;
        }
        if (controller.isSearchMode) {
          controller.cancelSearch();
          return;
        }
      },
      child: Row(
        children: [
          if (FluffyThemes.isColumnMode(context) ||
              AppConfig.displayNavigationRail) ...[
            SpacesNavigationRail(
              activeSpaceId: controller.activeSpaceId,
              onGoToChats: controller.clearActiveSpace,
              onGoToSpaceId: controller.setActiveSpace,
            ),
            Container(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ],
          Expanded(
            child: GestureDetector(
              onTap: FocusManager.instance.primaryFocus?.unfocus,
              excludeFromSemantics: true,
              behavior: HitTestBehavior.translucent,
              child: Scaffold(
                body: Stack(
                  children: [
                    ChatListViewBody(controller),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height *
                          0.2, // mesma altura do banner
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: const AudioPlayerStream(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01,
                          ),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                final uri = Uri.parse(
                                    'https://www.radiohemp.com/chama/');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Image.asset(
                                'assets/banner-de-apoio-CHAMA.png',
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // floatingActionButton: !controller.isSearchMode &&
                //         controller.activeSpaceId == null
                //     ? FloatingActionButton.extended(
                //         backgroundColor: Theme.of(context).colorScheme.primary,
                //         foregroundColor: Colors.white,
                //         elevation: 0,
                //         onPressed: () => context.go('/rooms/newprivatechat'),
                //         icon: Icon(
                //           Icons.add_outlined,
                //           color: Theme.of(context).colorScheme.onPrimary,
                //         ),
                //         label: Text(
                //           L10n.of(context).chat,
                //           overflow: TextOverflow.fade,
                //           style: TextStyle(
                //             color: Theme.of(context).colorScheme.onPrimary,
                //             fontSize: 15,
                //           ),
                //         ),
                //       )
                //     : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
