import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:hermes/config/interactive_page_transition.dart';
import 'package:hermes/config/themes.dart';
import 'package:hermes/pages/archive/archive.dart';
import 'package:hermes/pages/chat/chat.dart';
import 'package:hermes/pages/chat_access_settings/chat_access_settings_controller.dart';
import 'package:hermes/pages/chat_details/chat_details.dart';
import 'package:hermes/pages/chat_encryption_settings/chat_encryption_settings.dart';
import 'package:hermes/pages/chat_list/chat_list.dart';
import 'package:hermes/pages/chat_members/chat_members.dart';
import 'package:hermes/pages/chat_permissions_settings/chat_permissions_settings.dart';
import 'package:hermes/pages/chat_search/chat_search_page.dart';
import 'package:hermes/pages/device_settings/device_settings.dart';
import 'package:hermes/pages/homeserver_picker/homeserver_picker.dart';
import 'package:hermes/pages/invitation_selection/invitation_selection.dart';
import 'package:hermes/pages/login/login.dart';
import 'package:hermes/pages/new_group/new_group.dart';
import 'package:hermes/pages/new_private_chat/new_private_chat.dart';
import 'package:hermes/pages/settings/settings.dart';
import 'package:hermes/pages/settings_3pid/settings_3pid.dart';
import 'package:hermes/pages/settings_chat/settings_chat.dart';
import 'package:hermes/pages/settings_emotes/settings_emotes.dart';
import 'package:hermes/pages/settings_homeserver/settings_homeserver.dart';
import 'package:hermes/pages/settings_ignore_list/settings_ignore_list.dart';
import 'package:hermes/pages/settings_multiple_emotes/settings_multiple_emotes.dart';
import 'package:hermes/pages/settings_notifications/settings_notifications.dart';
import 'package:hermes/pages/settings_password/settings_password.dart';
import 'package:hermes/pages/settings_security/settings_security.dart';
import 'package:hermes/pages/settings_style/settings_style.dart';
import 'package:hermes/widgets/config_viewer.dart';
import 'package:hermes/widgets/layouts/empty_page.dart';
import 'package:hermes/widgets/layouts/two_column_layout.dart';
import 'package:hermes/widgets/log_view.dart';
import 'package:hermes/widgets/matrix.dart';
import 'package:hermes/widgets/share_scaffold_dialog.dart';

abstract class AppRoutes {
  static FutureOr<String?> loggedInRedirect(
    BuildContext context,
    GoRouterState state,
  ) =>
      Matrix.of(context).widget.clients.any((client) => client.isLogged())
          ? '/rooms'
          : null;

  static FutureOr<String?> loggedOutRedirect(
    BuildContext context,
    GoRouterState state,
  ) =>
      Matrix.of(context).widget.clients.any((client) => client.isLogged())
          ? null
          : '/home';

  AppRoutes();

  static final List<RouteBase> routes = [
    GoRoute(
      path: '/',
      redirect: (context, state) =>
          Matrix.of(context).widget.clients.any((client) => client.isLogged())
              ? '/rooms'
              : '/home',
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        const HomeserverPicker(addMultiAccount: false),
      ),
      redirect: loggedInRedirect,
      routes: [
        GoRoute(
          path: 'login',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            Login(client: state.extra as Client),
          ),
          redirect: loggedInRedirect,
        ),
      ],
    ),
    GoRoute(
      path: '/logs',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        const LogViewer(),
      ),
    ),
    GoRoute(
      path: '/configs',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        const ConfigViewer(),
      ),
    ),
    ShellRoute(
      // Never use a transition on the shell route. Changing the PageBuilder
      // here based on a MediaQuery causes the child to briefly be rendered
      // twice with the same GlobalKey, blowing up the rendering.
      pageBuilder: (context, state, child) => noTransitionPageBuilder(
        context,
        state,
        PantheonThemes.isColumnMode(context) &&
                state.fullPath?.startsWith('/rooms/settings') == false
            ? TwoColumnLayout(
                mainView: ChatList(
                  activeChat: state.pathParameters['roomid'],
                  activeSpace: state.uri.queryParameters['spaceId'],
                  displayNavigationRail:
                      state.path?.startsWith('/rooms/settings') != true,
                ),
                sideView: child,
              )
            : child,
      ),
      routes: [
        GoRoute(
          path: '/rooms',
          redirect: loggedOutRedirect,
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            PantheonThemes.isColumnMode(context)
                ? const EmptyPage()
                : ChatList(
                    activeChat: state.pathParameters['roomid'],
                    activeSpace: state.uri.queryParameters['spaceId'],
                  ),
          ),
          routes: [
            GoRoute(
              path: 'archive',
              pageBuilder: (context, state) => swipePopPageBuilder(
                context,
                state,
                const Archive(),
              ),
              routes: [
                GoRoute(
                  path: ':roomid',
                  pageBuilder: (context, state) => swipePopPageBuilder(
                    context,
                    state,
                    ChatPage(
                      roomId: state.pathParameters['roomid']!,
                      eventId: state.uri.queryParameters['event'],
                    ),
                  ),
                  redirect: loggedOutRedirect,
                ),
              ],
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'newprivatechat',
              pageBuilder: (context, state) => swipePopPageBuilder(
                context,
                state,
                const NewPrivateChat(),
              ),
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'newgroup',
              pageBuilder: (context, state) => swipePopPageBuilder(
                context,
                state,
                const NewGroup(),
              ),
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'newspace',
              pageBuilder: (context, state) => swipePopPageBuilder(
                context,
                state,
                const NewGroup(createGroupType: CreateGroupType.space),
              ),
              redirect: loggedOutRedirect,
            ),
            ShellRoute(
              pageBuilder: (context, state, child) => noTransitionPageBuilder(
                context,
                state,
                PantheonThemes.isColumnMode(context)
                    ? TwoColumnLayout(
                        mainView: Settings(key: state.pageKey),
                        sideView: child,
                      )
                    : child,
              ),
              routes: [
                GoRoute(
                  path: 'settings',
                  pageBuilder: (context, state) => swipePopPageBuilder(
                    context,
                    state,
                    PantheonThemes.isColumnMode(context)
                        ? const EmptyPage()
                        : const Settings(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'notifications',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const SettingsNotifications(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'style',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const SettingsStyle(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'devices',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const DevicesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'chat',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const SettingsChat(),
                      ),
                      routes: [
                        GoRoute(
                          path: 'emotes',
                          pageBuilder: (context, state) => swipePopPageBuilder(
                            context,
                            state,
                            const EmotesSettings(),
                          ),
                        ),
                      ],
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'addaccount',
                      redirect: loggedOutRedirect,
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const HomeserverPicker(addMultiAccount: true),
                      ),
                      routes: [
                        GoRoute(
                          path: 'login',
                          pageBuilder: (context, state) => swipePopPageBuilder(
                            context,
                            state,
                            Login(client: state.extra as Client),
                          ),
                          redirect: loggedOutRedirect,
                        ),
                      ],
                    ),
                    GoRoute(
                      path: 'homeserver',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const SettingsHomeserver(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'security',
                      redirect: loggedOutRedirect,
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const SettingsSecurity(),
                      ),
                      routes: [
                        GoRoute(
                          path: 'password',
                          pageBuilder: (context, state) => swipePopPageBuilder(
                            context,
                            state,
                            const SettingsPassword(),
                          ),
                          redirect: loggedOutRedirect,
                        ),
                        GoRoute(
                          path: 'ignorelist',
                          pageBuilder: (context, state) => swipePopPageBuilder(
                            context,
                            state,
                            SettingsIgnoreList(
                              initialUserId: state.extra?.toString(),
                            ),
                          ),
                          redirect: loggedOutRedirect,
                        ),
                        GoRoute(
                          path: '3pid',
                          pageBuilder: (context, state) => swipePopPageBuilder(
                            context,
                            state,
                            const Settings3Pid(),
                          ),
                          redirect: loggedOutRedirect,
                        ),
                      ],
                    ),
                  ],
                  redirect: loggedOutRedirect,
                ),
              ],
            ),
            GoRoute(
              path: ':roomid',
              pageBuilder: (context, state) {
                final body = state.uri.queryParameters['body'];
                var shareItems = state.extra is List<ShareItem>
                    ? state.extra as List<ShareItem>
                    : null;
                if (body != null && body.isNotEmpty) {
                  shareItems ??= [];
                  shareItems.add(TextShareItem(body));
                }
                return swipePopPageBuilder(
                  context,
                  state,
                  ChatPage(
                    roomId: state.pathParameters['roomid']!,
                    shareItems: shareItems,
                    eventId: state.uri.queryParameters['event'],
                  ),
                );
              },
              redirect: loggedOutRedirect,
              routes: [
                GoRoute(
                  path: 'search',
                  pageBuilder: (context, state) => swipePopPageBuilder(
                    context,
                    state,
                    ChatSearchPage(
                      roomId: state.pathParameters['roomid']!,
                    ),
                  ),
                  redirect: loggedOutRedirect,
                ),
                GoRoute(
                  path: 'encryption',
                  pageBuilder: (context, state) => swipePopPageBuilder(
                    context,
                    state,
                    const ChatEncryptionSettings(),
                  ),
                  redirect: loggedOutRedirect,
                ),
                GoRoute(
                  path: 'invite',
                  pageBuilder: (context, state) => swipePopPageBuilder(
                    context,
                    state,
                    InvitationSelection(
                      roomId: state.pathParameters['roomid']!,
                    ),
                  ),
                  redirect: loggedOutRedirect,
                ),
                GoRoute(
                  path: 'details',
                  pageBuilder: (context, state) => swipePopPageBuilder(
                    context,
                    state,
                    ChatDetails(
                      roomId: state.pathParameters['roomid']!,
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: 'access',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        ChatAccessSettings(
                          roomId: state.pathParameters['roomid']!,
                        ),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'members',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        ChatMembersPage(
                          roomId: state.pathParameters['roomid']!,
                        ),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'permissions',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const ChatPermissionsSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'invite',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        InvitationSelection(
                          roomId: state.pathParameters['roomid']!,
                        ),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'multiple_emotes',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const MultipleEmotesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'emotes',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const EmotesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'emotes/:state_key',
                      pageBuilder: (context, state) => swipePopPageBuilder(
                        context,
                        state,
                        const EmotesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                  ],
                  redirect: loggedOutRedirect,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  static Page noTransitionPageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) =>
      NoTransitionPage(
        key: state.pageKey,
        restorationId: state.pageKey.value,
        child: child,
      );

  static Page defaultPageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) =>
      PantheonThemes.isColumnMode(context)
          ? noTransitionPageBuilder(context, state, child)
          : MaterialPage(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: child,
            );

  static Page swipePopPageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    if (PantheonThemes.isColumnMode(context)) {
      return noTransitionPageBuilder(context, state, child);
    }
    return SwipePopPage(
      key: state.pageKey,
      restorationId: state.pageKey.value,
      child: child,
    );
  }
}
