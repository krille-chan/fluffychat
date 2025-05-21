import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/presence_builder.dart';
import '../../utils/url_launcher.dart';
import '../future_loading_dialog.dart';
import '../hover_builder.dart';
import '../matrix.dart';
import '../mxc_image_viewer.dart';

class UserDialog extends StatelessWidget {
  static Future<void> show({
    required BuildContext context,
    required Profile profile,
    bool noProfileWarning = false,
  }) =>
      showAdaptiveDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => UserDialog(
          profile,
          noProfileWarning: noProfileWarning,
        ),
      );

  final Profile profile;
  final bool noProfileWarning;

  const UserDialog(this.profile, {this.noProfileWarning = false, super.key});

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final dmRoomId = client.getDirectChatFromUserId(profile.userId);
    final displayname = profile.displayName ??
        profile.userId.localpart ??
        L10n.of(context).user;
    var copied = false;
    final theme = Theme.of(context);
    final avatar = profile.avatarUrl;
    return AlertDialog.adaptive(
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256),
        child: Center(child: Text(displayname, textAlign: TextAlign.center)),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
        child: PresenceBuilder(
          userId: profile.userId,
          client: Matrix.of(context).client,
          builder: (context, presence) {
            if (presence == null) return const SizedBox.shrink();
            final statusMsg = presence.statusMsg;
            final lastActiveTimestamp = presence.lastActiveTimestamp;
            final presenceText = presence.currentlyActive == true
                ? L10n.of(context).currentlyActive
                : lastActiveTimestamp != null
                    ? L10n.of(context).lastActiveAgo(
                        lastActiveTimestamp.localizedTimeShort(context),
                      )
                    : null;
            return SingleChildScrollView(
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HoverBuilder(
                    builder: (context, hovered) => StatefulBuilder(
                      builder: (context, setState) => MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: profile.userId),
                            );
                            setState(() {
                              copied = true;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: AnimatedScale(
                                      duration: FluffyThemes.animationDuration,
                                      curve: FluffyThemes.animationCurve,
                                      scale: hovered
                                          ? 1.33
                                          : copied
                                              ? 1.25
                                              : 1.0,
                                      child: Icon(
                                        copied
                                            ? Icons.check_circle
                                            : Icons.copy,
                                        size: 12,
                                        color: copied ? Colors.green : null,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(text: profile.userId),
                              ],
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 10),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Avatar(
                      mxContent: avatar,
                      name: displayname,
                      size: Avatar.defaultSize * 2,
                      onTap: avatar != null
                          ? () => showDialog(
                                context: context,
                                builder: (_) => MxcImageViewer(avatar),
                              )
                          : null,
                    ),
                  ),
                  if (presenceText != null)
                    Text(
                      presenceText,
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  if (statusMsg != null)
                    SelectableLinkify(
                      text: statusMsg,
                      textScaleFactor:
                          MediaQuery.textScalerOf(context).scale(1),
                      textAlign: TextAlign.center,
                      options: const LinkifyOptions(humanize: false),
                      linkStyle: TextStyle(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: theme.colorScheme.primary,
                      ),
                      onOpen: (url) =>
                          UrlLauncher(context, url.url).launchUrl(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        if (client.userID != profile.userId) ...[
          AdaptiveDialogAction(
            bigButtons: true,
            onPressed: () async {
              final router = GoRouter.of(context);
              Navigator.of(context).pop();
              final roomIdResult = await showFutureLoadingDialog(
                context: context,
                future: () => client.startDirectChat(profile.userId),
              );
              final roomId = roomIdResult.result;
              if (roomId == null) return;
              router.go('/rooms/$roomId');
            },
            child: Text(
              dmRoomId == null
                  ? L10n.of(context).startConversation
                  : L10n.of(context).sendAMessage,
            ),
          ),
          AdaptiveDialogAction(
            bigButtons: true,
            onPressed: () {
              final router = GoRouter.of(context);
              Navigator.of(context).pop();
              router.go(
                '/rooms/settings/security/ignorelist',
                extra: profile.userId,
              );
            },
            child: Text(
              L10n.of(context).ignoreUser,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
        AdaptiveDialogAction(
          bigButtons: true,
          onPressed: Navigator.of(context).pop,
          child: Text(L10n.of(context).close),
        ),
      ],
    );
  }
}
