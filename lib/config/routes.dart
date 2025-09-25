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
import 'package:fluffychat/pangea/activity_sessions/activity_session_start/activity_session_start_page.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_page/analytics_page.dart';
import 'package:fluffychat/pangea/analytics_summary/progress_indicators_enum.dart';
import 'package:fluffychat/pangea/chat_settings/pages/edit_course.dart';
import 'package:fluffychat/pangea/chat_settings/pages/pangea_invitation_selection.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/course_creation/new_course_page.dart';
import 'package:fluffychat/pangea/course_creation/selected_course_page.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/find_your_people/find_your_people.dart';
import 'package:fluffychat/pangea/guard/p_vguard.dart';
import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/pangea/login/pages/language_selection_page.dart';
import 'package:fluffychat/pangea/login/pages/login_or_signup_view.dart';
import 'package:fluffychat/pangea/login/pages/new_trip_page.dart';
import 'package:fluffychat/pangea/login/pages/plan_trip_page.dart';
import 'package:fluffychat/pangea/login/pages/private_trip_page.dart';
import 'package:fluffychat/pangea/login/pages/public_trip_page.dart';
import 'package:fluffychat/pangea/login/pages/signup.dart';
import 'package:fluffychat/pangea/onboarding/onboarding.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics.dart';
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
    // Matrix.of(context).widget.clients.any((client) => client.isLogged())
    //       ? '/rooms'
    //       : null;
    return PAuthGaurd.loggedInRedirect(context, state);
    // Pangea#
  }

  static FutureOr<String?> loggedOutRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    // #Pangea
    // Matrix.of(context).widget.clients.any((client) => client.isLogged())
    //     ? null
    //     : '/home';
    return PAuthGaurd.loggedOutRedirect(context, state);
    // Pangea#
  }

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
            // #Pangea
            // Login(client: state.extra as Client),
            const Login(),
            // Pangea#
          ),
          redirect: loggedInRedirect,
          // #Pangea
          routes: [
            GoRoute(
              path: 'email',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                const Login(withEmail: true),
              ),
              redirect: loggedInRedirect,
            ),
          ],
          // Pangea#
        ),
        // #Pangea
        GoRoute(
          path: 'languages',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            const LanguageSelectionPage(),
          ),
          redirect: loggedInRedirect,
          routes: [
            GoRoute(
              path: ':langcode',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                SignupPage(
                  langCode: state.pathParameters['langcode']!,
                ),
              ),
              redirect: loggedInRedirect,
              routes: [
                GoRoute(
                  path: 'email',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    SignupPage(
                      withEmail: true,
                      langCode: state.pathParameters['langcode']!,
                    ),
                  ),
                  redirect: loggedInRedirect,
                ),
              ],
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
      path: '/course',
      pageBuilder: (context, state) => defaultPageBuilder(
        context,
        state,
        const LanguageSelectionPage(),
      ),
      redirect: loggedOutRedirect,
      routes: [
        GoRoute(
          path: ':langcode',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            PlanTripPage(
              langCode: state.pathParameters['langcode']!,
            ),
          ),
          redirect: loggedOutRedirect,
          routes: [
            GoRoute(
              path: 'private',
              pageBuilder: (context, state) {
                return defaultPageBuilder(
                  context,
                  state,
                  PrivateTripPage(
                    langCode: state.pathParameters['langcode']!,
                  ),
                );
              },
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'public',
              pageBuilder: (context, state) {
                return defaultPageBuilder(
                  context,
                  state,
                  PublicTripPage(
                    langCode: state.pathParameters['langcode']!,
                  ),
                );
              },
              redirect: loggedOutRedirect,
            ),
            GoRoute(
              path: 'own',
              pageBuilder: (context, state) {
                return defaultPageBuilder(
                  context,
                  state,
                  NewTripPage(
                    langCode: state.pathParameters['langcode']!,
                  ),
                );
              },
              redirect: loggedOutRedirect,
              routes: [
                GoRoute(
                  path: ':courseid',
                  pageBuilder: (context, state) {
                    return defaultPageBuilder(
                      context,
                      state,
                      SelectedCourse(
                        state.pathParameters['courseid']!,
                      ),
                    );
                  },
                  redirect: loggedOutRedirect,
                ),
              ],
            ),
          ],
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
        //     ? TwoColumnLayout(
        //         mainView: ChatList(
        //           activeChat: state.pathParameters['roomid'],
        //           displayNavigationRail:
        //               state.path?.startsWith('/rooms/settings') != true,
        //         ),
        //         sideView: child,
        //       )
        //     : child,
        TwoColumnLayout(
          state: state,
          sideView: child,
        ),
        // Pangea#
      ),
      routes: [
        GoRoute(
          path: '/rooms',
          redirect: loggedOutRedirect,
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
                    activeSpaceId: state.pathParameters['spaceid'],
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
            // ShellRoute(
            //   pageBuilder: (context, state, child) => defaultPageBuilder(
            //     context,
            //     state,
            //     FluffyThemes.isColumnMode(context)
            //         ? TwoColumnLayout(
            //             mainView: PangeaSideView(path: state.fullPath),
            //             sideView: child,
            //           )
            //         : child,
            //   ),
            //   routes: [
            // Pangea#
            GoRoute(
              path: 'communities',
              redirect: loggedOutRedirect,
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                const FindYourPeople(),
              ),
              routes: [
                GoRoute(
                  path: 'newcourse',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    const NewCourse(),
                  ),
                  redirect: loggedOutRedirect,
                  routes: [
                    GoRoute(
                      path: ':courseId',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        SelectedCourse(state.pathParameters['courseId']!),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'analytics',
              redirect: loggedOutRedirect,
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                const AnalyticsPage(
                  indicator: ProgressIndicatorEnum.wordsUsed,
                ),
              ),
              routes: [
                GoRoute(
                  path: ConstructTypeEnum.morph.string,
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    const AnalyticsPage(
                      indicator: ProgressIndicatorEnum.morphsUsed,
                    ),
                  ),
                  redirect: loggedOutRedirect,
                  routes: [
                    GoRoute(
                      path: ':construct',
                      pageBuilder: (context, state) {
                        final construct = ConstructIdentifier.fromString(
                          state.pathParameters['construct']!,
                        );
                        return defaultPageBuilder(
                          context,
                          state,
                          AnalyticsPage(
                            indicator: ProgressIndicatorEnum.morphsUsed,
                            construct: construct,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: ConstructTypeEnum.vocab.string,
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    const AnalyticsPage(
                      indicator: ProgressIndicatorEnum.wordsUsed,
                    ),
                  ),
                  redirect: loggedOutRedirect,
                  routes: [
                    GoRoute(
                      path: ':construct',
                      pageBuilder: (context, state) {
                        final construct = ConstructIdentifier.fromString(
                          state.pathParameters['construct']!,
                        );
                        return defaultPageBuilder(
                          context,
                          state,
                          AnalyticsPage(
                            indicator: ProgressIndicatorEnum.wordsUsed,
                            construct: construct,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'activities',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    const AnalyticsPage(
                      indicator: ProgressIndicatorEnum.activities,
                    ),
                  ),
                  redirect: loggedOutRedirect,
                  routes: [
                    GoRoute(
                      path: ':roomid',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        ChatPage(
                          roomId: state.pathParameters['roomid']!,
                          eventId: state.uri.queryParameters['event'],
                          backButton: BackButton(
                            onPressed: () => context.go(
                              "/rooms/analytics/activities",
                            ),
                          ),
                        ),
                      ),
                      redirect: loggedOutRedirect,
                    ),
                  ],
                ),
                GoRoute(
                  path: 'level',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    const AnalyticsPage(
                      indicator: ProgressIndicatorEnum.level,
                    ),
                  ),
                  redirect: loggedOutRedirect,
                ),
              ],
            ),
            // Pangea#
            // #Pangea
            // ShellRoute(
            //   pageBuilder: (context, state, child) => defaultPageBuilder(
            //     context,
            //     state,
            //     FluffyThemes.isColumnMode(context)
            //         ? TwoColumnLayout(
            //             mainView: Settings(key: state.pageKey),
            //             sideView: child,
            //           )
            //         : child,
            //   ),
            //   routes: [
            // Pangea#
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
                //         Login(client: state.extra as Client),
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
            // #Pangea
            GoRoute(
              path: 'spaces',
              pageBuilder: (context, state) => defaultPageBuilder(
                context,
                state,
                const EmptyPage(),
              ),
              redirect: (context, state) {
                if (state.pathParameters['spaceid'] == null) {
                  return "/rooms";
                }
                return loggedOutRedirect(context, state);
              },
              routes: [
                GoRoute(
                  path: ':spaceid',
                  pageBuilder: (context, state) => defaultPageBuilder(
                    context,
                    state,
                    ChatDetails(
                      roomId: state.pathParameters['spaceid']!,
                      activeTab: state.uri.queryParameters['tab'],
                    ),
                  ),
                  redirect: loggedOutRedirect,
                  routes: [
                    GoRoute(
                      path: 'details',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        const EmptyPage(),
                      ),
                      redirect: (context, state) {
                        String subroute =
                            state.fullPath?.split(":spaceid/details").last ??
                                "";

                        if (state.uri.queryParameters.isNotEmpty) {
                          final queryString = state.uri.queryParameters.entries
                              .map((e) => '${e.key}=${e.value}')
                              .join('&');
                          subroute = '$subroute?$queryString';
                        }
                        return "/rooms/spaces/${state.pathParameters['spaceid']}$subroute";
                      },
                      routes: roomDetailsRoutes('spaceid'),
                    ),
                    ...roomDetailsRoutes('spaceid'),
                    GoRoute(
                      path: 'addcourse',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        NewCourse(
                          spaceId: state.pathParameters['spaceid']!,
                        ),
                      ),
                      redirect: loggedOutRedirect,
                      routes: [
                        GoRoute(
                          path: ':courseId',
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            state,
                            SelectedCourse(
                              state.pathParameters['courseId']!,
                              spaceId: state.pathParameters['spaceid']!,
                            ),
                          ),
                          redirect: loggedOutRedirect,
                        ),
                      ],
                    ),
                    GoRoute(
                      path: 'activity/:activityid',
                      pageBuilder: (context, state) => defaultPageBuilder(
                        context,
                        state,
                        ActivitySessionStartPage(
                          activityId: state.pathParameters['activityid']!,
                          roomId: state.uri.queryParameters['roomid'],
                          parentId: state.pathParameters['spaceid']!,
                          launch: state.uri.queryParameters['launch'] == 'true',
                        ),
                      ),
                      redirect: loggedOutRedirect,
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
                        GoRoute(
                          path: 'invite',
                          pageBuilder: (context, state) => defaultPageBuilder(
                            context,
                            state,
                            PangeaInvitationSelection(
                              roomId: state.pathParameters['roomid']!,
                              initialFilter:
                                  state.uri.queryParameters['filter'] != null
                                      ? InvitationFilter.fromString(
                                          state.uri.queryParameters['filter']!,
                                        )
                                      : null,
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
                          routes: roomDetailsRoutes('roomid'),
                          redirect: loggedOutRedirect,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Pangea#
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
              // #Pangea
              // redirect: loggedOutRedirect,
              redirect: (context, state) {
                String subroute = state.fullPath!.split('roomid').last;
                if (state.uri.queryParameters.isNotEmpty) {
                  final queryString = state.uri.queryParameters.entries
                      .map((e) => '${e.key}=${e.value}')
                      .join('&');
                  subroute = '$subroute?$queryString';
                }

                final roomId = state.pathParameters['roomid']!;
                final room = Matrix.of(context).client.getRoomById(roomId);
                if (room != null && room.isSpace) {
                  return "/rooms/spaces/${room.id}$subroute";
                }

                final parent = room?.firstSpaceParent;
                if (parent != null && state.fullPath != null) {
                  return "/rooms/spaces/${parent.id}/$roomId$subroute";
                }
                return loggedOutRedirect(context, state);
              },
              // Pangea#
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
                    PangeaInvitationSelection(
                      roomId: state.pathParameters['roomid']!,
                      initialFilter: state.uri.queryParameters['filter'] != null
                          ? InvitationFilter.fromString(
                              state.uri.queryParameters['filter']!,
                            )
                          : null,
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
                  // #Pangea
                  routes: roomDetailsRoutes('roomid'),
                  // routes: [
                  //   GoRoute(
                  //     path: 'access',
                  //     pageBuilder: (context, state) => defaultPageBuilder(
                  //       context,
                  //       state,
                  //       ChatAccessSettings(
                  //         roomId: state.pathParameters['roomid']!,
                  //       ),
                  //     ),
                  //     redirect: loggedOutRedirect,
                  //   ),
                  //   GoRoute(
                  //     path: 'members',
                  //     pageBuilder: (context, state) => defaultPageBuilder(
                  //       context,
                  //       state,
                  //       ChatMembersPage(
                  //         roomId: state.pathParameters['roomid']!,
                  //       ),
                  //     ),
                  //     redirect: loggedOutRedirect,
                  //   ),
                  //   GoRoute(
                  //     path: 'permissions',
                  //     pageBuilder: (context, state) => defaultPageBuilder(
                  //       context,
                  //       state,
                  //       const ChatPermissionsSettings(),
                  //     ),
                  //     redirect: loggedOutRedirect,
                  //   ),
                  //   GoRoute(
                  //     path: 'invite',
                  //     pageBuilder: (context, state) => defaultPageBuilder(
                  //       context,
                  //       state,
                  //       PangeaInvitationSelection(
                  //         roomId: state.pathParameters['roomid']!,
                  //         initialFilter:
                  //             state.uri.queryParameters['filter'] != null
                  //                 ? InvitationFilter.fromString(
                  //                     state.uri.queryParameters['filter']!,
                  //                   )
                  //                 : null,
                  //       ),
                  //     ),
                  //     redirect: loggedOutRedirect,
                  //   ),
                  //   GoRoute(
                  //     path: 'multiple_emotes',
                  //     pageBuilder: (context, state) => defaultPageBuilder(
                  //       context,
                  //       state,
                  //       const MultipleEmotesSettings(),
                  //     ),
                  //     redirect: loggedOutRedirect,
                  //   ),
                  //   GoRoute(
                  //     path: 'emotes',
                  //     pageBuilder: (context, state) => defaultPageBuilder(
                  //       context,
                  //       state,
                  //       const EmotesSettings(),
                  //     ),
                  //     redirect: loggedOutRedirect,
                  //   ),
                  //   GoRoute(
                  //     path: 'emotes/:state_key',
                  //     pageBuilder: (context, state) => defaultPageBuilder(
                  //       context,
                  //       state,
                  //       const EmotesSettings(),
                  //     ),
                  //     redirect: loggedOutRedirect,
                  //   ),
                  // ],
                  // Pangea#
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

  static List<RouteBase> roomDetailsRoutes(String roomKey) => [
        GoRoute(
          path: '/edit',
          redirect: loggedOutRedirect,
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            EditCourse(roomId: state.pathParameters[roomKey]!),
          ),
        ),
        GoRoute(
          path: '/analytics',
          redirect: loggedOutRedirect,
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            SpaceAnalytics(
              roomId: state.pathParameters[roomKey]!,
            ),
          ),
        ),
        GoRoute(
          path: 'access',
          pageBuilder: (context, state) => defaultPageBuilder(
            context,
            state,
            ChatAccessSettings(
              roomId: state.pathParameters[roomKey]!,
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
              roomId: state.pathParameters[roomKey]!,
              filter: state.uri.queryParameters['filter'],
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
            PangeaInvitationSelection(
              roomId: state.pathParameters[roomKey]!,
              initialFilter: state.uri.queryParameters['filter'] != null
                  ? InvitationFilter.fromString(
                      state.uri.queryParameters['filter']!,
                    )
                  : null,
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
      ];
  // Pangea#
}
