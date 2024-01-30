import 'package:flutter/material.dart';

import 'package:fluffychat/utils/format_time_helper.dart';
import 'package:fluffychat/utils/voip/voip_plugin.dart';
import '../../../utils/voip/call_state_proxy.dart';

class CallTimer extends StatelessWidget {
  final CallStateProxy proxy;
  final VoipPlugin voipPlugin;
  final bool appBar;
  final TextStyle? overrideTextStyle;
  final String? appendText;
  const CallTimer({
    super.key,
    required this.voipPlugin,
    required this.appBar,
    this.overrideTextStyle,
    this.appendText,
    required this.proxy,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final ts = FormatTimeHelper.formatHHMMSS(
          ((DateTime.now().millisecondsSinceEpoch -
                      voipPlugin.connectedTsSinceEpoch -
                      voipPlugin.onHoldMs) /
                  1000)
              .floor(),
        );
        return Text(
          '${appendText?.isEmpty ?? true ? '' : '$appendText  '}${proxy.connected ? ts : voipPlugin.getCallStateSuffix(proxy, context)}',
          style: overrideTextStyle ??
              Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: appBar ? 12 : 16,
                  ),
        );
      },
    );
  }
}
