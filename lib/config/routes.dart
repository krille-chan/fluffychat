import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/archive/archive.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat_access_settings/chat_access_settings_controller.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_members/chat_members.dart';
import 'package:fluffychat/pages/chat_permissions_settings/chat_permissions_settings.dart';
import 'package:fluffychat/pages/chat_search/chat_search_page.dart';
import 'package:fluffychat/pages/device_settings/device_settings.dart';
import 'package:fluffychat/pages/invitation_selection/invitation_selection.dart';
import 'package:fluffychat/pages/login/login.dart';
import 'package:fluffychat/pages/new_group/new_group.dart';
import 'package:fluffychat/pages/new_private_chat/new_private_chat.dart';
import 'package:fluffychat/pages/settings/settings.dart';
import 'package:fluffychat/pages/settings_3pid/settings_3pid.dart';
import 'package:fluffychat/pages/settings_chat/settings_chat.dart';
import 'package:fluffychat/pages/settings_emotes/settings_emotes.dart';
import 'package:fluffychat/pages/settings_homeserver/settings_homeserver.dart';
import 'package:fluffychat/pages/settings_ignore_list/settings_ignore_list.dart';
import 'package:fluffychat/pages/settings_multiple_emotes/settings_multiple_emotes.dart';
import 'package:fluffychat/pages/settings_notifications/settings_notifications.dart';
import 'package:fluffychat/pages/settings_password/settings_password.dart';
import 'package:fluffychat/pages/settings_security/settings_security.dart';
import 'package:fluffychat/pages/settings_style/settings_style.dart';
import 'package:fluffychat/pangea/activity_generator/activity_generator.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_page.dart';
import 'package:fluffychat/pangea/activity_suggestions/suggestions_page.dart';
import 'package:fluffychat/pangea/find_your_people/find_your_people.dart';
import 'package:fluffychat/pangea/find_your_people/find_your_people_side_view.dart';
import 'package:fluffychat/pangea/guard/p_vguard.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/pangea/login/pages/login_or_signup_view.dart';
import 'package:fluffychat/pangea/login/pages/signup.dart';
import 'package:fluffychat/pangea/login/pages/space_code_onboarding.dart';
import 'package:fluffychat/pangea/login/pages/user_settings.dart';
import 'package:fluffychat/pangea/onboarding/onboarding.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/pangea/spaces/utils/join_with_alias.dart';
import 'package:fluffychat/pangea/spaces/utils/join_with_link.dart';
import 'package:fluffychat/pangea/subscription/pages/settings_subscription.dart';
import 'package:fluffychat/widgets/config_viewer.dart';
import 'package:fluffychat/widgets/layouts/empty_page.dart';
import 'package:fluffychat/widgets/layouts/two_column_layout.dart';
import 'package:fluffychat/widgets/log_view.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/share_scaffold_dialog.dart';

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
        state,
        // #Pangea
        // const HomeserverPicker(addMultiAccount: false),
        const LoginOrSignupView(),
        // Pangea#
      ),
      redirect: loggedInRedirect,
      routes: [
        GoRoute(
          path: 'login',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            const Login(),
          ),
          redirect: loggedInRedirect,
        ),
        // #Pangea
        GoRoute(
          path: 'signup',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            const SignupPage(),
          ),
          redirect: loggedInRedirect,
          routes: [
            GoRoute(
              path: 'email',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                const SignupPage(withEmail: true),
              ),
              redirect: loggedInRedirect,
            ),
          ],
        ),
        // Pangea#
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
    // #Pangea
    GoRoute(
      path: '/join_with_link',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        JoinClassWithLink(
          classCode: state.uri.queryParameters[SpaceConstants.classCode],
        ),
      ),
    ),
    GoRoute(
      path: '/join_with_alias',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        JoinWithAlias(alias: state.uri.queryParameters['alias']),
      ),
    ),
    GoRoute(
      path: '/user_age',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        const UserSettingsPage(),
      ),
      redirect: loggedOutRedirect,
      routes: [
        GoRoute(
          path: 'join_space',
          pageBuilder: (context, state) {
            return defaultPageBuilder(
              context,
              state,
              const SpaceCodeOnboarding(),
            );
          },
          redirect: loggedOutRedirect,
        ),
      ],
    ),
    // Pangea#
    ShellRoute(
      // Never use a transition on the shell route. Changing the PageBuilder
      // here based on a MediaQuery causes the child to briefly be rendered
      // twice with the same GlobalKey, blowing up the rendering.
      pageBuilder: (context, state, child) => noTransitionPageBuilder(
        context,
        state,
        // #Pangea
        // FluffyThemes.isColumnMode(context) &&
        //         state.fullPath?.startsWith('/rooms/settings') == false
        FluffyThemes.isColumnMode(context) &&
                state.fullPath?.startsWith('/rooms/settings') == false &&
                state.fullPath?.startsWith('/rooms/communities') == false
            // Pangea#
            ? TwoColumnLayout(
                mainView: ChatList(
                  activeChat: state.pathParameters['roomid'],
                  // #Pangea
                  activeSpaceId: state.uri.queryParameters['spaceId'],
                  // Pangea#
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
          // #Pangea
          // redirect: loggedOutRedirect,
          redirect: (context, state) async {
            final resp = await loggedOutRedirect(context, state);
            if (resp != null) return resp;
            final isColumnMode = FluffyThemes.isColumnMode(context);

            final spaceId = state.uri.queryParameters['spaceId'];
            if (spaceId != null &&
                spaceId != 'clear' &&
                isColumnMode &&
                state.fullPath != null &&
                !state.fullPath!.contains('details')) {
              return '/rooms/$spaceId/details?spaceId=$spaceId';
            }

            return null;
          },
          // Pangea#
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            FluffyThemes.isColumnMode(context)
                // #Pangea
                // ? const EmptyPage()
                ? const Onboarding()
                // Pangea#
                : ChatList(
                    activeChat: state.pathParameters['roomid'],
                    // #Pangea
                    activeSpaceId: state.uri.queryParameters['spaceId'],
                    // Pangea#
                  ),
          ),
          routes: [
            GoRoute(
              path: 'archive',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                const Archive(),
              ),
              routes: [
                GoRoute(
                  path: ':roomid',
                  pageBuilder: (context, state) => defaultPageBuilder(
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
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                const NewPrivateChat(),
              ),
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'newgroup',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                // #Pangea
                // const NewGroup(),
                NewGroup(spaceId: state.uri.queryParameters['space']),
                // Pangea#
              ),
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'newspace',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                const NewGroup(createGroupType: CreateGroupType.space),
              ),
              redirect: loggedOutRedirect,
            ),
            // #Pangea
            ShellRoute(
              pageBuilder: (context, state, child) => defaultPageBuilder(
                context,
                state,
                FluffyThemes.isColumnMode(context)
                    ? TwoColumnLayout(
                        mainView: const FindYourPeopleSideView(),
                        sideView: child,
                        dividerColor: Colors.transparent,
                      )
                    : child,
              ),
              routes: [
                GoRoute(
                  path: 'communities',
                  redirect: loggedOutRedirect,
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    const FindYourPeople(),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'homepage',
              redirect: loggedOutRedirect,
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                const SuggestionsPage(),
              ),
              routes: [
                ...newRoomRoutes,
                GoRoute(
                  path: '/planner',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    const ActivityPlannerPage(),
                  ),
                  redirect: loggedOutRedirect,
                  routes: [
                    GoRoute(
                      path: '/generator',
                      redirect: loggedOutRedirect,
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const ActivityGenerator(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Pangea#
            ShellRoute(
              pageBuilder: (context, state, child) => defaultPageBuilder(
                context,
                state,
                FluffyThemes.isColumnMode(context)
                    ? TwoColumnLayout(
                        mainView: Settings(key: state.pageKey),
                        sideView: child,
                      )
                    : child,
              ),
              routes: [
                GoRoute(
                  path: 'settings',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    FluffyThemes.isColumnMode(context)
                        ? const EmptyPage()
                        : const Settings(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'notifications',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const SettingsNotifications(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'style',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const SettingsStyle(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'devices',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const DevicesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'chat',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const SettingsChat(),
                      ),
                      routes: [
                        GoRoute(
                          path: 'emotes',
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            state,
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
                    //     state,
                    //     const HomeserverPicker(addMultiAccount: true),
                    //   ),
                    //   routes: [
                    //     GoRoute(
                    //       path: 'login',
                    //       pageBuilder: (context, state) => defaultPageBuilder(
                    //         context,
                    //         state,
                    //         const Login(),
                    //       ),
                    //       redirect: loggedOutRedirect,
                    //     ),
                    //   ],
                    // ),
                    // Pangea#
                    GoRoute(
                      path: 'homeserver',
                      pageBuilder: (context, state) {
                        return defaultPageBuilder(
                          context,
                          state,
                          const SettingsHomeserver(),
                        );
                      },
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'homeserver',
                      pageBuilder: (context, state) {
                        return defaultPageBuilder(
                          context,
                          state,
                          const SettingsHomeserver(),
                        );
                      },
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'security',
                      redirect: loggedOutRedirect,
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const SettingsSecurity(),
                      ),
                      routes: [
                        GoRoute(
                          path: 'password',
                          pageBuilder: (context, state) {
                            return defaultPageBuilder(
                              context,
                              state,
                              const SettingsPassword(),
                            );
                          },
                          redirect: loggedOutRedirect,
                        ),
                        GoRoute(
                          path: 'ignorelist',
                          pageBuilder: (context, state) {
                            return defaultPageBuilder(
                              context,
                              state,
                              SettingsIgnoreList(
                                initialUserId: state.extra?.toString(),
                              ),
                            );
                          },
                          redirect: loggedOutRedirect,
                        ),
                        GoRoute(
                          path: '3pid',
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            state,
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
                        state,
                        const SettingsLearning(
                          isDialog: false,
                        ),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'subscription',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
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
              pageBuilder: (context, state) {
                final body = state.uri.queryParameters['body'];
                var shareItems = state.extra is List<ShareItem>
                    ? state.extra as List<ShareItem>
                    : null;
                if (body != null && body.isNotEmpty) {
                  shareItems ??= [];
                  shareItems.add(TextShareItem(body));
                }
                return defaultPageBuilder(
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
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    ChatSearchPage(
                      roomId: state.pathParameters['roomid']!,
                    ),
                  ),
                  redirect: loggedOutRedirect,
                ),
                // #Pangea
                // GoRoute(
                //   path: 'encryption',
                //   pageBuilder: (context, state) => defaultPageBuilder(
                //     context,
                //     state,
                //     const ChatEncryptionSettings(),
                //   ),
                //   redirect: loggedOutRedirect,
                // ),
                // Pangea#
                GoRoute(
                  path: 'invite',
                  pageBuilder: (context, state) => defaultPageBuilder(
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
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    ChatDetails(
                      roomId: state.pathParameters['roomid']!,
                    ),
                  ),
                  routes: [
                    // #Pangea
                    GoRoute(
                      path: 'planner',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        ActivityPlannerPage(
                          roomID: state.pathParameters['roomid']!,
                        ),
                      ),
                      redirect: loggedOutRedirect,
                      routes: [
                        GoRoute(
                          path: '/generator',
                          redirect: loggedOutRedirect,
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            state,
                            ActivityGenerator(
                              roomID: state.pathParameters['roomid']!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Pangea#
                    GoRoute(
                      path: 'access',
                      pageBuilder: (context, state) => defaultPageBuilder(
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
                      pageBuilder: (context, state) => defaultPageBuilder(
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
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const ChatPermissionsSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'invite',
                      pageBuilder: (context, state) => defaultPageBuilder(
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
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const MultipleEmotesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'emotes',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const EmotesSettings(),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                    GoRoute(
                      path: 'emotes/:state_key',
                      pageBuilder: (context, state) => defaultPageBuilder(
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
      // #Pangea
      noTransitionPageBuilder(context, state, child);
  // FluffyThemes.isColumnMode(context)
  //     ? noTransitionPageBuilder(context, state, child)
  //     : MaterialPage(
  //         key: state.pageKey,
  //         restorationId: state.pageKey.value,
  //         child: child,
  //       );
  // Pangea#

  // #Pangea
  static List<RouteBase> get newRoomRoutes => [
        GoRoute(
          path: 'newgroup',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            const NewGroup(),
          ),
          redirect: loggedOutRedirect,
        ),
        GoRoute(
          path: 'newspace',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            const NewGroup(createGroupType: CreateGroupType.space),
          ),
          redirect: loggedOutRedirect,
        ),
      ];
  // Pangea#
}
