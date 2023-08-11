import 'package:flutter/cupertino.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/add_story/add_story.dart';
import 'package:fluffychat/pages/archive/archive.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pages/chat_encryption_settings/chat_encryption_settings.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_permissions_settings/chat_permissions_settings.dart';
import 'package:fluffychat/pages/device_settings/device_settings.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:fluffychat/pages/invitation_selection/invitation_selection.dart';
import 'package:fluffychat/pages/login/login.dart';
import 'package:fluffychat/pages/new_group/new_group.dart';
import 'package:fluffychat/pages/new_private_chat/new_private_chat.dart';
import 'package:fluffychat/pages/new_space/new_space.dart';
import 'package:fluffychat/pages/settings/settings.dart';
import 'package:fluffychat/pages/settings_3pid/settings_3pid.dart';
import 'package:fluffychat/pages/settings_chat/settings_chat.dart';
import 'package:fluffychat/pages/settings_emotes/settings_emotes.dart';
import 'package:fluffychat/pages/settings_ignore_list/settings_ignore_list.dart';
import 'package:fluffychat/pages/settings_multiple_emotes/settings_multiple_emotes.dart';
import 'package:fluffychat/pages/settings_notifications/settings_notifications.dart';
import 'package:fluffychat/pages/settings_security/settings_security.dart';
import 'package:fluffychat/pages/settings_stories/settings_stories.dart';
import 'package:fluffychat/pages/settings_style/settings_style.dart';
import 'package:fluffychat/pages/story/story_page.dart';
import 'package:fluffychat/widgets/layouts/empty_page.dart';
import 'package:fluffychat/widgets/layouts/side_view_layout.dart';
import 'package:fluffychat/widgets/layouts/two_column_layout.dart';
import 'package:fluffychat/widgets/log_view.dart';

class AppRoutes {
  final List<Client> clients;

  bool get isLoggedIn => clients.any((client) => client.isLogged());

  AppRoutes(this.clients);

  List<RouteBase> get routes => [
        GoRoute(
          path: '/',
          redirect: (context, state) => isLoggedIn ? '/rooms' : '/home',
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const HomeserverPicker(),
          ),
          redirect: (context, state) => isLoggedIn ? '/rooms' : null,
          routes: [
            GoRoute(
              path: 'login',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const Login(),
              ),
              redirect: (context, state) => isLoggedIn ? '/rooms' : null,
            ),
          ],
        ),
        GoRoute(
          path: '/logs',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const LogViewer(),
          ),
        ),
        ShellRoute(
          pageBuilder: (context, state, child) => defaultPageBuilder(
            context,
            FluffyThemes.isColumnMode(context) &&
                    state.fullPath?.startsWith('/rooms/settings') == false
                ? TwoColumnLayout(
                    displayNavigationRail:
                        state.path?.startsWith('/rooms/settings') != true,
                    mainView: ChatList(
                      activeChat: state.pathParameters['roomid'],
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
              redirect: (context, state) => !isLoggedIn ? '/home' : null,
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                FluffyThemes.isColumnMode(context)
                    ? const EmptyPage()
                    : ChatList(
                        activeChat: state.pathParameters['roomid'],
                      ),
              ),
              routes: [
                GoRoute(
                  path: 'stories/create',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    const AddStoryPage(),
                  ),
                  redirect: (context, state) => !isLoggedIn ? '/home' : null,
                ),
                GoRoute(
                  path: 'stories/:roomid',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    const StoryPage(),
                  ),
                  redirect: (context, state) => !isLoggedIn ? '/home' : null,
                  routes: [
                    GoRoute(
                      path: 'share',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const AddStoryPage(),
                      ),
                      redirect: (context, state) =>
                          !isLoggedIn ? '/home' : null,
                    ),
                  ],
                ),
                GoRoute(
                  path: 'spaces/:roomid',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    ChatDetails(
                      roomId: state.pathParameters['roomid']!,
                    ),
                  ),
                  routes: _chatDetailsRoutes,
                  redirect: (context, state) => !isLoggedIn ? '/home' : null,
                ),
                GoRoute(
                  path: 'archive',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    const Archive(),
                  ),
                  routes: [
                    GoRoute(
                      path: ':roomid',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        ChatPage(
                          roomId: state.pathParameters['roomid']!,
                        ),
                      ),
                      redirect: (context, state) =>
                          !isLoggedIn ? '/home' : null,
                    ),
                  ],
                  redirect: (context, state) => !isLoggedIn ? '/home' : null,
                ),
                GoRoute(
                  path: 'newprivatechat',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    const NewPrivateChat(),
                  ),
                  redirect: (context, state) => !isLoggedIn ? '/home' : null,
                ),
                GoRoute(
                  path: 'newgroup',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    const NewGroup(),
                  ),
                  redirect: (context, state) => !isLoggedIn ? '/home' : null,
                ),
                GoRoute(
                  path: 'newspace',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    const NewSpace(),
                  ),
                  redirect: (context, state) => !isLoggedIn ? '/home' : null,
                ),
                ShellRoute(
                  pageBuilder: (context, state, child) => defaultPageBuilder(
                    context,
                    FluffyThemes.isColumnMode(context)
                        ? TwoColumnLayout(
                            mainView: const Settings(),
                            sideView: child,
                            displayNavigationRail: false,
                          )
                        : child,
                  ),
                  routes: [
                    GoRoute(
                      path: 'settings',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        FluffyThemes.isColumnMode(context)
                            ? const EmptyPage()
                            : const Settings(),
                      ),
                      routes: _settingsRoutes,
                      redirect: (context, state) =>
                          !isLoggedIn ? '/home' : null,
                    ),
                  ],
                ),
                ShellRoute(
                  pageBuilder: (context, state, child) => defaultPageBuilder(
                    context,
                    SideViewLayout(
                      mainView: ChatPage(
                        roomId: state.pathParameters['roomid']!,
                      ),
                      sideView:
                          state.fullPath == '/rooms/:roomid' ? null : child,
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: ':roomid',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const EmptyPage(),
                      ),
                      redirect: (context, state) =>
                          !isLoggedIn ? '/home' : null,
                      routes: [
                        GoRoute(
                          path: 'encryption',
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            const ChatEncryptionSettings(),
                          ),
                          redirect: (context, state) =>
                              !isLoggedIn ? '/home' : null,
                        ),
                        GoRoute(
                          path: 'invite',
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            const InvitationSelection(),
                          ),
                          redirect: (context, state) =>
                              !isLoggedIn ? '/home' : null,
                        ),
                        GoRoute(
                          path: 'details',
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            ChatDetails(
                              roomId: state.pathParameters['roomid']!,
                            ),
                          ),
                          routes: _chatDetailsRoutes,
                          redirect: (context, state) =>
                              !isLoggedIn ? '/home' : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ];

  List<RouteBase> get _chatDetailsRoutes => [
        GoRoute(
          path: 'permissions',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const ChatPermissionsSettings(),
          ),
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
        ),
        GoRoute(
          path: 'invite',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const InvitationSelection(),
          ),
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
        ),
        GoRoute(
          path: 'multiple_emotes',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const MultipleEmotesSettings(),
          ),
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
        ),
        GoRoute(
          path: 'emotes',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const EmotesSettings(),
          ),
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
        ),
        GoRoute(
          path: 'emotes/:state_key',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const EmotesSettings(),
          ),
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
        ),
      ];

  List<RouteBase> get _settingsRoutes => [
        GoRoute(
          path: 'notifications',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const SettingsNotifications(),
          ),
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
        ),
        GoRoute(
          path: 'style',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const SettingsStyle(),
          ),
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
        ),
        GoRoute(
          path: 'devices',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const DevicesSettings(),
          ),
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
        ),
        GoRoute(
          path: 'chat',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const SettingsChat(),
          ),
          routes: [
            GoRoute(
              path: 'emotes',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const EmotesSettings(),
              ),
            ),
          ],
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
        ),
        GoRoute(
          path: 'addaccount',
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const HomeserverPicker(),
          ),
          routes: [
            GoRoute(
              path: 'login',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const Login(),
              ),
              redirect: (context, state) => !isLoggedIn ? '/home' : null,
            ),
          ],
        ),
        GoRoute(
          path: 'security',
          redirect: (context, state) => !isLoggedIn ? '/home' : null,
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const SettingsSecurity(),
          ),
          routes: [
            GoRoute(
              path: 'stories',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const SettingsStories(),
              ),
              redirect: (context, state) => !isLoggedIn ? '/home' : null,
            ),
            GoRoute(
              path: 'ignorelist',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const SettingsIgnoreList(),
              ),
              redirect: (context, state) => !isLoggedIn ? '/home' : null,
            ),
            GoRoute(
              path: '3pid',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const Settings3Pid(),
              ),
              redirect: (context, state) => !isLoggedIn ? '/home' : null,
            ),
          ],
        ),
      ];

  Page defaultPageBuilder(BuildContext context, Widget child) =>
      CustomTransitionPage(
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FluffyThemes.isColumnMode(context)
                ? FadeTransition(opacity: animation, child: child)
                : CupertinoPageTransition(
                    primaryRouteAnimation: animation,
                    secondaryRouteAnimation: secondaryAnimation,
                    linearTransition: false,
                    child: child,
                  ),
      );
}
