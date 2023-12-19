import 'dart:async';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/archive/archive.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_members/chat_members.dart';
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
import 'package:fluffychat/pangea/guard/p_vguard.dart';
import 'package:fluffychat/pangea/pages/analytics/student_analytics/student_analytics.dart';
import 'package:fluffychat/pangea/pages/class_settings/class_settings_page.dart';
import 'package:fluffychat/pangea/pages/exchange/add_exchange_to_class.dart';
import 'package:fluffychat/pangea/pages/find_partner/find_partner.dart';
import 'package:fluffychat/pangea/pages/p_user_age/p_user_age.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/pages/settings_subscription/settings_subscription.dart';
import 'package:fluffychat/pangea/pages/sign_up/signup.dart';
import 'package:fluffychat/pangea/widgets/class/join_with_link.dart';
import 'package:fluffychat/widgets/layouts/empty_page.dart';
import 'package:fluffychat/widgets/layouts/two_column_layout.dart';
import 'package:fluffychat/widgets/log_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../pangea/pages/analytics/class_analytics/class_analytics.dart';
import '../pangea/pages/analytics/class_list/class_list.dart';

abstract class AppRoutes {
  static FutureOr<String?> loggedInRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    // #Pangea
    // Matrix.of(context).client.isLogged() ? '/rooms' : null;
    return PAuthGaurd.loggedInRedirect(context, state);
    // Pangea#
  }

  static FutureOr<String?> loggedOutRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    // #Pangea
    // Matrix.of(context).client.isLogged() ? null : '/home';
    return PAuthGaurd.loggedOutRedirect(context, state);
    // Pangea#
  }

  AppRoutes();

  static final List<RouteBase> routes = [
    GoRoute(
      path: '/',
      redirect: (context, state) =>
          Matrix.of(context).client.isLogged() ? '/rooms' : '/home',
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        const HomeserverPicker(),
      ),
      redirect: loggedInRedirect,
      routes: [
        GoRoute(
          path: 'login',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const Login(),
          ),
          redirect: loggedInRedirect,
        ),
        // #Pangea
        GoRoute(
          path: 'signup',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const SignupPage(),
          ),
          redirect: loggedInRedirect,
        ),
        // Pangea#
      ],
    ),
    GoRoute(
      path: '/logs',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        const LogViewer(),
      ),
    ),
    // #Pangea
    GoRoute(
      path: '/user_age',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        const PUserAge(),
      ),
      redirect: loggedOutRedirect,
    ),
    // Pangea#
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
        // #Pangea
        GoRoute(
          path: '/spaces/:roomid',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            ChatDetails(
              roomId: state.pathParameters['roomid']!,
            ),
          ),
          redirect: loggedOutRedirect,
        ),
        GoRoute(
          path: '/join_with_link',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            const JoinClassWithLink(),
          ),
          redirect: loggedOutRedirect,
        ),
        // Pangea#
        GoRoute(
          path: '/rooms',
          redirect: loggedOutRedirect,
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            FluffyThemes.isColumnMode(context)
                ? const EmptyPage()
                : ChatList(
                    activeChat: state.pathParameters['roomid'],
                  ),
          ),
          routes: [
            // #Pangea
            GoRoute(
              path: 'mylearning',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const StudentAnalyticsPage(),
              ),
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'analytics',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const AnalyticsClassList(),
              ),
              redirect: loggedOutRedirect,
              routes: [
                GoRoute(
                  path: ':classid',
                  redirect: loggedOutRedirect,
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    const ClassAnalyticsPage(),
                  ),
                ),
              ],
            ),
            // GoRoute(
            //   path: 'stories/create',
            //   pageBuilder: (context, state) => defaultPageBuilder(
            //     context,
            //     const AddStoryPage(),
            //   ),
            //   redirect: loggedOutRedirect,
            // ),
            // GoRoute(
            //   path: 'stories/:roomid',
            //   pageBuilder: (context, state) => defaultPageBuilder(
            //     context,
            //     const StoryPage(),
            //   ),
            //   redirect: loggedOutRedirect,
            //   routes: [
            //     GoRoute(
            //       path: 'share',
            //       pageBuilder: (context, state) => defaultPageBuilder(
            //         context,
            //         const AddStoryPage(),
            //       ),
            //       redirect: loggedOutRedirect,
            //     ),
            //   ],
            // ),
            // Pangea#
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
                  redirect: loggedOutRedirect,
                ),
              ],
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'newprivatechat',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const NewPrivateChat(),
              ),
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              // #Pangea
              // path: 'newgroup',
              path: 'newgroup/:spaceid',
              // Pangea#
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const NewGroup(),
              ),
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'newspace',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const NewSpace(),
              ),
              redirect: loggedOutRedirect,
            ),
            // #Pangea
            GoRoute(
              path: 'newspace/:newexchange',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const NewSpace(),
              ),
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'join_exchange/:exchangeid',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const AddExchangeToClass(),
              ),
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'partner',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                const FindPartner(),
              ),
              redirect: loggedOutRedirect,
            ),
            // Pangea#
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
                  routes: [
                    GoRoute(
                      path: 'notifications',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const SettingsNotifications(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'style',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const SettingsStyle(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'devices',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const DevicesSettings(),
                      ),
                      redirect: loggedOutRedirect,
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
                      redirect: loggedOutRedirect,
                    ),
                    // #Pangea
                    // GoRoute(
                    //   path: 'addaccount',
                    //   redirect: loggedOutRedirect,
                    //   pageBuilder: (context, state) => defaultPageBuilder(
                    //     context,
                    //     const HomeserverPicker(),
                    //   ),
                    //   routes: [
                    //     GoRoute(
                    //       path: 'login',
                    //       pageBuilder: (context, state) => defaultPageBuilder(
                    //         context,
                    //         const Login(),
                    //       ),
                    //       redirect: loggedOutRedirect,
                    //     ),
                    //   ],
                    // ),
                    // Pangea#
                    GoRoute(
                      path: 'security',
                      redirect: loggedOutRedirect,
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
                          redirect: loggedOutRedirect,
                        ),
                        GoRoute(
                          path: 'ignorelist',
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            const SettingsIgnoreList(),
                          ),
                          redirect: loggedOutRedirect,
                        ),
                        GoRoute(
                          path: '3pid',
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            const Settings3Pid(),
                          ),
                          redirect: loggedOutRedirect,
                        ),
                      ],
                    ),
                    // #Pangea
                    GoRoute(
                      path: 'learning',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const SettingsLearning(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'subscription',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const SubscriptionManagement(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    // Pangea#
                  ],
                  redirect: loggedOutRedirect,
                ),
              ],
            ),
            GoRoute(
              path: ':roomid',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                ChatPage(roomId: state.pathParameters['roomid']!),
              ),
              redirect: loggedOutRedirect,
              routes: [
                // #Pangea
                // GoRoute(
                //   path: 'encryption',
                //   pageBuilder: (context, state) => defaultPageBuilder(
                //     context,
                //     const ChatEncryptionSettings(),
                //   ),
                //   redirect: loggedOutRedirect,
                // ),
                // Pangea#
                GoRoute(
                  path: 'invite',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    InvitationSelection(
                      roomId: state.pathParameters['roomid']!,
                    ),
                  ),
                  redirect: loggedOutRedirect,
                ),
                GoRoute(
                  path: 'details',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    ChatDetails(
                      roomId: state.pathParameters['roomid']!,
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: 'members',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        ChatMembersPage(
                          roomId: state.pathParameters['roomid']!,
                        ),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'permissions',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const ChatPermissionsSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    // #Pangea
                    GoRoute(
                      path: 'class_settings',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const ClassSettingsPage(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    // Pangea#
                    GoRoute(
                      path: 'invite',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        InvitationSelection(
                          roomId: state.pathParameters['roomid']!,
                        ),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'multiple_emotes',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const MultipleEmotesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'emotes',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const EmotesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'emotes/:state_key',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        const EmotesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                  ],
                  redirect: loggedOutRedirect,
                ),
                // #Pangea
                // GoRoute(
                //   path: 'tasks',
                //   pageBuilder: (context, state) => defaultPageBuilder(
                //     context,
                //     TasksPage(
                //       room: Matrix.of(context)
                //           .client
                //           .getRoomById(state.pathParameters['roomid']!)!,
                //     ),
                //   ),
                // ),
                // Pangea#
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  static Page defaultPageBuilder(BuildContext context, Widget child) =>
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
