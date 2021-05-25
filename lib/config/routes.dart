import 'package:fluffychat/pages/archive.dart';
import 'package:fluffychat/pages/homeserver_picker.dart';
import 'package:fluffychat/pages/image_viewer.dart';
import 'package:fluffychat/pages/invitation_selection.dart';
import 'package:fluffychat/pages/settings_emotes.dart';
import 'package:fluffychat/pages/settings_multiple_emotes.dart';
import 'package:fluffychat/pages/sign_up.dart';
import 'package:fluffychat/pages/sign_up_password.dart';
import 'package:fluffychat/widgets/layouts/side_view_layout.dart';
import 'package:fluffychat/widgets/layouts/two_column_layout.dart';
import 'package:fluffychat/pages/chat.dart';
import 'package:fluffychat/pages/chat_details.dart';
import 'package:fluffychat/pages/chat_encryption_settings.dart';
import 'package:fluffychat/pages/chat_list.dart';
import 'package:fluffychat/pages/chat_permissions_settings.dart';
import 'package:fluffychat/pages/views/empty_page_view.dart';
import 'package:fluffychat/widgets/layouts/loading_view.dart';
import 'package:fluffychat/widgets/log_view.dart';
import 'package:fluffychat/pages/login.dart';
import 'package:fluffychat/pages/new_group.dart';
import 'package:fluffychat/pages/new_private_chat.dart';
import 'package:fluffychat/pages/search.dart';
import 'package:fluffychat/pages/settings.dart';
import 'package:fluffychat/pages/settings_3pid.dart';
import 'package:fluffychat/pages/device_settings.dart';
import 'package:fluffychat/pages/settings_ignore_list.dart';
import 'package:fluffychat/pages/settings_notifications.dart';
import 'package:fluffychat/pages/settings_style.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class AppRoutes {
  final bool columnMode;
  final String initialUrl;

  AppRoutes(this.columnMode, {this.initialUrl});

  List<VRouteElement> get routes => [
        if (initialUrl != null && initialUrl != '/')
          VRouteRedirector(
            path: '/',
            redirectTo: initialUrl,
          ),
        ..._homeRoutes,
        if (columnMode) ..._tabletRoutes,
        if (!columnMode) ..._mobileRoutes,
      ];

  List<VRouteElement> get _mobileRoutes => [
        VWidget(
          path: '/rooms',
          widget: ChatList(),
          stackedRoutes: [
            VWidget(path: ':roomid', widget: Chat(), stackedRoutes: [
              VWidget(
                path: 'image/:eventid',
                widget: ImageViewer(),
                buildTransition: _fadeTransition,
              ),
              VWidget(
                path: 'encryption',
                widget: ChatEncryptionSettings(),
              ),
              VWidget(
                path: 'invite',
                widget: InvitationSelection(),
              ),
              VWidget(
                path: 'details',
                widget: ChatDetails(),
                stackedRoutes: _chatDetailsRoutes,
              ),
            ]),
            VWidget(
              path: '/settings',
              widget: Settings(),
              stackedRoutes: _settingsRoutes,
            ),
            VWidget(
              path: '/search',
              widget: Search(),
            ),
            VWidget(
              path: '/archive',
              widget: Archive(),
            ),
            VWidget(
              path: '/newprivatechat',
              widget: NewPrivateChat(),
            ),
            VWidget(
              path: '/newgroup',
              widget: NewGroup(),
            ),
          ],
        ),
      ];
  List<VRouteElement> get _tabletRoutes => [
        VNester(
          path: '/rooms',
          widgetBuilder: (child) => TwoColumnLayout(
            mainView: ChatList(),
            sideView: child,
          ),
          buildTransition: _fadeTransition,
          nestedRoutes: [
            VWidget(
              path: '',
              widget: EmptyPage(),
              buildTransition: _fadeTransition,
              stackedRoutes: [
                VWidget(
                  path: '/newprivatechat',
                  widget: NewPrivateChat(),
                  buildTransition: _fadeTransition,
                ),
                VWidget(
                  path: '/newgroup',
                  widget: NewGroup(),
                  buildTransition: _fadeTransition,
                ),
                VNester(
                  path: ':roomid',
                  widgetBuilder: (child) => SideViewLayout(
                    mainView: Chat(),
                    sideView: child,
                  ),
                  buildTransition: _fadeTransition,
                  nestedRoutes: [
                    VWidget(
                      path: '',
                      widget: EmptyPage(),
                      buildTransition: _fadeTransition,
                    ),
                    VWidget(
                      path: 'image/:eventid',
                      widget: ImageViewer(),
                      buildTransition: _fadeTransition,
                    ),
                    VWidget(
                      path: 'encryption',
                      widget: ChatEncryptionSettings(),
                      buildTransition: _fadeTransition,
                    ),
                    VWidget(
                      path: 'details',
                      widget: ChatDetails(),
                      buildTransition: _fadeTransition,
                      stackedRoutes: _chatDetailsRoutes,
                    ),
                    VWidget(
                      path: 'invite',
                      widget: InvitationSelection(),
                      buildTransition: _fadeTransition,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        VWidget(
          path: '/rooms',
          widget: TwoColumnLayout(
            mainView: ChatList(),
            sideView: EmptyPage(),
          ),
          buildTransition: _fadeTransition,
          stackedRoutes: [
            VNester(
              path: '/settings',
              widgetBuilder: (child) => TwoColumnLayout(
                mainView: Settings(),
                sideView: child,
              ),
              buildTransition: _dynamicTransition,
              nestedRoutes: [
                VWidget(
                  path: '',
                  widget: EmptyPage(),
                  buildTransition: _dynamicTransition,
                  stackedRoutes: _settingsRoutes,
                ),
              ],
            ),
            VWidget(
              path: '/search',
              widget: TwoColumnLayout(
                mainView: Search(),
                sideView: EmptyPage(),
              ),
              buildTransition: _fadeTransition,
            ),
            VWidget(
              path: '/archive',
              widget: TwoColumnLayout(
                mainView: Archive(),
                sideView: EmptyPage(),
              ),
              buildTransition: _fadeTransition,
            ),
          ],
        ),
      ];

  List<VRouteElement> get _homeRoutes => [
        VWidget(path: '/', widget: LoadingView()),
        VWidget(
          path: '/home',
          widget: HomeserverPicker(),
          buildTransition: _fadeTransition,
          stackedRoutes: [
            VWidget(
                path: '/signup',
                widget: SignUp(),
                buildTransition: _fadeTransition,
                stackedRoutes: [
                  VWidget(
                    path: 'password/:username',
                    widget: SignUpPassword(),
                    buildTransition: _fadeTransition,
                  ),
                  VWidget(
                    path: '/login',
                    widget: Login(),
                    buildTransition: _fadeTransition,
                  ),
                ]),
          ],
        ),
      ];

  List<VRouteElement> get _chatDetailsRoutes => [
        VWidget(
          path: 'permissions',
          widget: ChatPermissionsSettings(),
          buildTransition: _dynamicTransition,
        ),
        VWidget(
          path: 'invite',
          widget: InvitationSelection(),
          buildTransition: _dynamicTransition,
        ),
        VWidget(
          path: 'emotes',
          widget: MultipleEmotesSettings(),
          buildTransition: _dynamicTransition,
        ),
      ];

  List<VRouteElement> get _settingsRoutes => [
        VWidget(
          path: 'emotes',
          widget: EmotesSettings(),
          buildTransition: _dynamicTransition,
        ),
        VWidget(
          path: 'notifications',
          widget: SettingsNotifications(),
          buildTransition: _dynamicTransition,
        ),
        VWidget(
          path: 'ignorelist',
          widget: SettingsIgnoreList(),
          buildTransition: _dynamicTransition,
        ),
        VWidget(
          path: 'style',
          widget: SettingsStyle(),
          buildTransition: _dynamicTransition,
        ),
        VWidget(
          path: 'devices',
          widget: DevicesSettings(),
          buildTransition: _dynamicTransition,
        ),
        VWidget(
          path: '/logs',
          widget: LogViewer(),
          buildTransition: _dynamicTransition,
        ),
        VWidget(
          path: '3pid',
          widget: Settings3Pid(),
          buildTransition: _dynamicTransition,
        ),
      ];

  final _fadeTransition = (animation1, _, child) =>
      FadeTransition(opacity: animation1, child: child);

  FadeTransition Function(dynamic, dynamic, dynamic) get _dynamicTransition =>
      columnMode ? _fadeTransition : null;
}
