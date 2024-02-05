import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:provider/provider.dart';

import 'package:fluffychat/utils/app_state.dart';
import 'package:fluffychat/utils/voip/voip_plugin.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../utils/voip/call_state_proxy.dart';
import '../../../utils/voip/group_call_session_state.dart';
import '../../../widgets/avatar.dart';
import 'call_timer.dart';

class CallBanner extends StatelessWidget {
  final CallStateProxy proxy;
  final VoipPlugin? voipPlugin;
  const CallBanner({super.key, required this.proxy, this.voipPlugin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBright = theme.brightness == Brightness.light;
    return ListTile(
      onTap: () {
        Provider.of<AppState>(context, listen: false).bannerClickedOnPath =
            FluffyChatApp.router.routerDelegate.currentConfiguration.uri
                .toString();

        FluffyChatApp.router.go('/rooms/${proxy.room.id}/call');
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      tileColor: Colors.green,
      contentPadding: const EdgeInsets.all(0),
      minVerticalPadding: 0,
      horizontalTitleGap: 0,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 12.0,
        ),
        child: Avatar(
          mxContent: proxy.room.avatar,
          size: 52,
          name: proxy.room.getLocalizedDisplayname(),
          client: proxy.room.client,
        ),
      ),
      title: Text(
        proxy.room.getLocalizedDisplayname(),
        style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16),
      ),
      subtitle: CallTimer(
        appendText: proxy is GroupCallSessionState
            ? L10n.of(context)!.groupCall
            : proxy.type == VoipType.kVoice
                ? L10n.of(context)!.audioCall
                : L10n.of(context)!.videoCall,
        proxy: proxy,
        appBar: true,
        voipPlugin: voipPlugin ?? Matrix.of(context).voipPlugin,
        overrideTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: isBright
                  ? Colors.white.withOpacity(0.8)
                  : Colors.black.withOpacity(0.72),
            ),
      ),
      trailing: const Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
