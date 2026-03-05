import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/authentication/p_logout.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/local_notifications_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

class EnableNotifications extends StatefulWidget {
  const EnableNotifications({super.key});

  @override
  EnableNotificationsController createState() =>
      EnableNotificationsController();
}

class EnableNotificationsController extends State<EnableNotifications> {
  Profile? profile;

  @override
  void initState() {
    _setProfile();
    super.initState();
  }

  Future<void> _setProfile() async {
    final client = Matrix.of(context).client;
    try {
      profile = await client.getProfileFromUserId(client.userID!);
    } catch (e, s) {
      ErrorHandler.logError(e: e, s: s, data: {'userId': client.userID});
    } finally {
      if (mounted) setState(() {});
    }
  }

  Future<void> _requestNotificationPermission() async {
    await Matrix.of(context).requestNotificationPermission();
    if (mounted) {
      context.go("/registration/notifications/course");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(
                onPressed: () => pLogoutAction(context, bypassWarning: true),
              ),
              const SizedBox(width: 40.0),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: MaxWidthBody(
          maxWidth: 300,
          withScrolling: false,
          showBorder: false,
          child: Container(
            alignment: .center,
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 16.0,
            ),
            child: Column(
              spacing: 32.0,
              mainAxisSize: .min,
              children: [
                PangeaLogoSvg(width: 72),
                Column(
                  spacing: 12.0,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      L10n.of(context).enableNotificationsTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: .center,
                    ),
                    ElevatedButton(
                      onPressed: _requestNotificationPermission,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(L10n.of(context).enableNotificationsDesc),
                        ],
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () =>
                      context.go("/registration/notifications/course"),
                  child: Text(L10n.of(context).skipForNow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
