import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/navigation_rail.dart';
import 'settings.dart';

class SettingsView extends StatelessWidget {
  final SettingsController controller;

  const SettingsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // #Pangea
    // final showChatBackupBanner = controller.showChatBackupBanner;
    // Pangea#
    final activeRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    // #Pangea
    // final accountManageUrl = Matrix.of(context)
    //     .client
    //     .wellKnown
    //     ?.additionalProperties
    //     .tryGetMap<String, Object?>('org.matrix.msc2965.authentication')
    //     ?.tryGet<String>('account');
    // Pangea#
    return Row(
      children: [
        if (FluffyThemes.isColumnMode(context)) ...[
          SpacesNavigationRail(
            activeSpaceId: null,
            onGoToChats: () => context.go('/rooms'),
            onGoToSpaceId: (spaceId) => context.go('/rooms?spaceId=$spaceId'),
          ),
          Container(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ],
        Expanded(
          child: Scaffold(
            // #Pangea
            // appBar: FluffyThemes.isColumnMode(context)
            //     ? null
            //     : AppBar(
            //         title: Text(L10n.of(context).settings),
            //         leading: Center(
            //           child: BackButton(
            //             onPressed: () => context.go('/rooms'),
            //           ),
            //         ),
            //       ),
            // Pangea#
            body: ListTileTheme(
              iconColor: theme.colorScheme.onSurface,
              child: ListView(
                key: const Key('SettingsListViewContent'),
                children: <Widget>[
                  FutureBuilder<Profile>(
                    future: controller.profileFuture,
                    builder: (context, snapshot) {
                      final profile = snapshot.data;
                      final mxid = Matrix.of(context).client.userID ??
                          L10n.of(context).user;
                      final displayname =
                          profile?.displayName ?? mxid.localpart ?? mxid;
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Stack(
                              children: [
                                Avatar(
                                  mxContent: profile?.avatarUrl,
                                  name: displayname,
                                  // #Pangea
                                  presenceUserId: profile?.userId,
                                  // Pangea#
                                  size: Avatar.defaultSize * 2.5,
                                ),
                                if (profile != null)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: FloatingActionButton.small(
                                      elevation: 2,
                                      onPressed: controller.setAvatarAction,
                                      heroTag: null,
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  onPressed: controller.setDisplaynameAction,
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 16,
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        theme.colorScheme.onSurface,
                                    iconColor: theme.colorScheme.onSurface,
                                  ),
                                  label: Text(
                                    displayname,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () =>
                                      FluffyShare.share(mxid, context),
                                  icon: const Icon(
                                    Icons.copy_outlined,
                                    size: 14,
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        theme.colorScheme.secondary,
                                    iconColor: theme.colorScheme.secondary,
                                  ),
                                  label: Text(
                                    mxid,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    //    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // #Pangea
                  // if (accountManageUrl != null)
                  //   ListTile(
                  //     leading: const Icon(Icons.account_circle_outlined),
                  //     title: Text(L10n.of(context).manageAccount),
                  //     trailing: const Icon(Icons.open_in_new_outlined),
                  //     onTap: () => launchUrlString(
                  //       accountManageUrl,
                  //       mode: LaunchMode.inAppBrowserView,
                  //     ),
                  //   ),
                  // Divider(color: theme.dividerColor),
                  // if (showChatBackupBanner == null)
                  //   ListTile(
                  //     leading: const Icon(Icons.backup_outlined),
                  //     title: Text(L10n.of(context).chatBackup),
                  //     trailing: const CircularProgressIndicator.adaptive(),
                  //   )
                  // else
                  //   SwitchListTile.adaptive(
                  //     controlAffinity: ListTileControlAffinity.trailing,
                  //     value: controller.showChatBackupBanner == false,
                  //     secondary: const Icon(Icons.backup_outlined),
                  //     title: Text(L10n.of(context).chatBackup),
                  //     onChanged: controller.firstRunBootstrapAction,
                  //   ),
                  // Divider(
                  //   color: theme.dividerColor,
                  // ),
                  // Pangea#
                  ListTile(
                    leading: const Icon(Icons.format_paint_outlined),
                    title: Text(L10n.of(context).changeTheme),
                    tileColor: activeRoute.startsWith('/rooms/settings/style')
                        ? theme.colorScheme.surfaceContainerHigh
                        : null,
                    onTap: () => context.go('/rooms/settings/style'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: Text(L10n.of(context).notifications),
                    tileColor:
                        activeRoute.startsWith('/rooms/settings/notifications')
                            ? theme.colorScheme.surfaceContainerHigh
                            : null,
                    onTap: () => context.go('/rooms/settings/notifications'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.devices_outlined),
                    title: Text(L10n.of(context).devices),
                    onTap: () => context.go('/rooms/settings/devices'),
                    tileColor: activeRoute.startsWith('/rooms/settings/devices')
                        ? theme.colorScheme.surfaceContainerHigh
                        : null,
                  ),
                  ListTile(
                    leading: const Icon(Icons.forum_outlined),
                    title: Text(L10n.of(context).chat),
                    onTap: () => context.go('/rooms/settings/chat'),
                    tileColor: activeRoute.startsWith('/rooms/settings/chat')
                        ? theme.colorScheme.surfaceContainerHigh
                        : null,
                  ),
                  // #Pangea
                  ListTile(
                    leading: const Icon(Icons.account_circle_outlined),
                    title: Text(L10n.of(context).subscriptionManagement),
                    onTap: () => context.go('/rooms/settings/subscription'),
                    tileColor:
                        activeRoute.startsWith('/rooms/settings/subscription')
                            ? theme.colorScheme.surfaceContainerHigh
                            : null,
                  ),
                  // Pangea#
                  ListTile(
                    leading: const Icon(Icons.shield_outlined),
                    title: Text(L10n.of(context).security),
                    onTap: () => context.go('/rooms/settings/security'),
                    tileColor:
                        activeRoute.startsWith('/rooms/settings/security')
                            ? theme.colorScheme.surfaceContainerHigh
                            : null,
                  ),
                  Divider(color: theme.dividerColor),
                  // #Pangea
                  ListTile(
                    leading: const Icon(Icons.help_outline_outlined),
                    title: Text(L10n.of(context).help),
                    onTap: () async {
                      await showFutureLoadingDialog(
                        context: context,
                        future: () async {
                          final roomId =
                              await Matrix.of(context).client.startDirectChat(
                                    Environment.supportUserId,
                                    enableEncryption: false,
                                  );
                          context.go('/rooms/$roomId');
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shield_outlined),
                    title: Text(L10n.of(context).termsAndConditions),
                    onTap: () => launchUrlString(AppConfig.termsOfServiceUrl),
                    trailing: const Icon(Icons.open_in_new_outlined),
                  ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListTile(
                          leading: const Icon(Icons.info_outline),
                          trailing: const Icon(Icons.copy_outlined),
                          onTap: () async {
                            if (snapshot.data == null) return;
                            await Clipboard.setData(
                              ClipboardData(
                                text:
                                    "${snapshot.data!.version}+${snapshot.data!.buildNumber}",
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(L10n.of(context).copiedToClipboard),
                              ),
                            );
                          },
                          title: Text(
                            snapshot.data != null
                                ? L10n.of(context).versionText(
                                    snapshot.data!.version,
                                    snapshot.data!.buildNumber,
                                  )
                                : L10n.of(context).versionNotFound,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return ListTile(
                          leading: const Icon(Icons.error_outline),
                          title: Text(L10n.of(context).versionFetchError),
                        );
                      } else {
                        return ListTile(
                          leading: const CircularProgressIndicator(),
                          title: Text(L10n.of(context).fetchingVersion),
                        );
                      }
                    },
                  ),
                  // Conditional ListTile based on the environment (staging or not)
                  if (Environment.isStaging)
                    ListTile(
                      leading: const Icon(Icons.bug_report_outlined),
                      title: Text(L10n.of(context).connectedToStaging),
                    ),
                  // ListTile(
                  //   leading: const Icon(Icons.dns_outlined),
                  //   title: Text(
                  //     L10n.of(context).aboutHomeserver(
                  //       Matrix.of(context).client.userID?.domain ??
                  //           'homeserver',
                  //     ),
                  //   ),
                  //   onTap: () => context.go('/rooms/settings/homeserver'),
                  //   tileColor:
                  //       activeRoute.startsWith('/rooms/settings/homeserver')
                  //           ? theme.colorScheme.surfaceContainerHigh
                  //           : null,
                  // ),
                  // ListTile(
                  //   leading: const Icon(Icons.privacy_tip_outlined),
                  //   title: Text(L10n.of(context).privacy),
                  //   onTap: () => launchUrlString(AppConfig.privacyUrl),
                  // ),
                  // ListTile(
                  //   leading: const Icon(Icons.info_outline_rounded),
                  //   title: Text(L10n.of(context).about),
                  //   onTap: () => PlatformInfos.showDialog(context),
                  // ),
                  // Pangea#
                  Divider(color: theme.dividerColor),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: Text(L10n.of(context).logout),
                    onTap: controller.logoutAction,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
