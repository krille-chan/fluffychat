import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/controllers/archive_controller.dart';
import 'package:fluffychat/controllers/homeserver_picker_controller.dart';
import 'package:fluffychat/controllers/sign_up_controller.dart';
import 'package:fluffychat/controllers/sign_up_password_controller.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:fluffychat/views/chat_details.dart';
import 'package:fluffychat/views/chat_encryption_settings.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:fluffychat/views/chat_permissions_settings.dart';
import 'package:fluffychat/views/empty_page.dart';
import 'package:fluffychat/views/invitation_selection.dart';
import 'package:fluffychat/views/loading_view.dart';
import 'package:fluffychat/views/log_view.dart';
import 'package:fluffychat/views/login.dart';
import 'package:fluffychat/views/new_group.dart';
import 'package:fluffychat/views/new_private_chat.dart';
import 'package:fluffychat/views/search_view.dart';
import 'package:fluffychat/views/settings.dart';
import 'package:fluffychat/views/settings_3pid.dart';
import 'package:fluffychat/views/settings_devices.dart';
import 'package:fluffychat/views/settings_emotes.dart';
import 'package:fluffychat/views/settings_ignore_list.dart';
import 'package:fluffychat/views/settings_multiple_emotes.dart';
import 'package:fluffychat/views/settings_notifications.dart';
import 'package:fluffychat/views/settings_style.dart';
import 'package:flutter/material.dart';

class FluffyRoutes {
  final BuildContext context;

  const FluffyRoutes(this.context);

  ViewData onGenerateRoute(RouteSettings settings) {
    final parts = settings.name.split('/');

    // Routes if the app is loading
    if (Matrix.of(context).loginState == null) {
      return ViewData(mainView: (_) => LoadingView());
      // Routes if user is NOT logged in
    } else if (Matrix.of(context).loginState == LoginState.loggedOut) {
      switch (parts[1]) {
        case '':
          return ViewData(mainView: (_) => HomeserverPicker());
        case 'login':
          return ViewData(mainView: (_) => Login());
        case 'signup':
          if (parts.length == 5 && parts[2] == 'password') {
            return ViewData(
              mainView: (_) => SignUpPassword(
                parts[3],
                displayname: parts[4],
                avatar: settings.arguments,
              ),
            );
          }
          return ViewData(mainView: (_) => SignUp());
      }
    }
    // Routes IF user is logged in
    else {
      switch (parts[1]) {
        case '':
          return ViewData(
              mainView: (_) => ChatList(), emptyView: (_) => EmptyPage());
        case 'rooms':
          final roomId = parts[2];
          if (parts.length == 3) {
            return ViewData(
              leftView: (_) => ChatList(activeChat: roomId),
              mainView: (_) => Chat(roomId),
            );
          } else if (parts.length == 4) {
            final action = parts[3];
            switch (action) {
              case 'details':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: roomId),
                  mainView: (_) => Chat(roomId),
                  rightView: (_) => ChatDetails(roomId),
                );
              case 'encryption':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: roomId),
                  mainView: (_) => Chat(roomId),
                  rightView: (_) => ChatEncryptionSettings(roomId),
                );
              case 'permissions':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: roomId),
                  mainView: (_) => Chat(roomId),
                  rightView: (_) => ChatPermissionsSettings(roomId),
                );
              case 'invite':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: roomId),
                  mainView: (_) => Chat(roomId),
                  rightView: (_) => InvitationSelection(roomId),
                );
              case 'emotes':
                return ViewData(
                  leftView: (_) => ChatList(activeChat: roomId),
                  mainView: (_) => Chat(roomId),
                  rightView: (_) => MultipleEmotesSettings(roomId),
                );
              default:
                return ViewData(
                  leftView: (_) => ChatList(activeChat: roomId),
                  mainView: (_) => Chat(roomId,
                      scrollToEventId: action.sigil == '\$' ? action : null),
                );
            }
          }
          return ViewData(
              mainView: (_) => ChatList(), emptyView: (_) => EmptyPage());
        case 'archive':
          return ViewData(
            mainView: (_) => Archive(),
            emptyView: (_) => EmptyPage(),
          );
        case 'logs':
          return ViewData(
            mainView: (_) => LogViewer(),
          );
        case 'newgroup':
          return ViewData(
            leftView: (_) => ChatList(),
            mainView: (_) => NewGroup(),
          );
        case 'newprivatechat':
          return ViewData(
            leftView: (_) => ChatList(),
            mainView: (_) => NewPrivateChat(),
          );
        case 'search':
          if (parts.length == 3) {
            return ViewData(
                mainView: (_) => SearchView(alias: parts[2]),
                emptyView: (_) => EmptyPage());
          }
          return ViewData(
              mainView: (_) => SearchView(), emptyView: (_) => EmptyPage());
        case 'settings':
          if (parts.length == 3) {
            final action = parts[2];
            switch (action) {
              case '3pid':
                return ViewData(
                  leftView: (_) => Settings(),
                  mainView: (_) => Settings3Pid(),
                );
              case 'devices':
                return ViewData(
                  leftView: (_) => Settings(),
                  mainView: (_) => DevicesSettings(),
                );
              case 'emotes':
                return ViewData(
                  leftView: (_) => Settings(),
                  mainView: (_) => EmotesSettings(
                    room: ((settings.arguments ?? {}) as Map)['room'],
                    stateKey: ((settings.arguments ?? {}) as Map)['stateKey'],
                  ),
                );
              case 'ignore':
                return ViewData(
                  leftView: (_) => Settings(),
                  mainView: (_) => SettingsIgnoreList(
                    initialUserId: settings.arguments,
                  ),
                );
              case 'notifications':
                return ViewData(
                  leftView: (_) => Settings(),
                  mainView: (_) => SettingsNotifications(),
                );
              case 'style':
                return ViewData(
                  leftView: (_) => Settings(),
                  mainView: (_) => SettingsStyle(),
                );
            }
          } else {
            return ViewData(
                mainView: (_) => Settings(), emptyView: (_) => EmptyPage());
          }
          return ViewData(
              mainView: (_) => ChatList(), emptyView: (_) => EmptyPage());
      }
    }

    // If route cant be found:
    return ViewData(
      mainView: (_) => Center(
        child: Text('Route "${settings.name}" not found...'),
      ),
    );
  }
}

class SettingsDevices {}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
