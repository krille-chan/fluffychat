import 'dart:async';

import 'package:fluffychat/pangea/enum/assistance_state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../pages/chat/chat.dart';

class ChoreographerSendButton extends StatefulWidget {
  const ChoreographerSendButton({
    super.key,
    required this.controller,
  });
  final ChatController controller;

  @override
  State<ChoreographerSendButton> createState() =>
      ChoreographerSendButtonState();
}

class ChoreographerSendButtonState extends State<ChoreographerSendButton> {
  StreamSubscription? _choreoSub;

  @override
  void initState() {
    // Rebuild the widget each time there's an update from
    // choreo. This keeps the spin up-to-date.
    _choreoSub =
        widget.controller.choreographer.stateListener.stream.listen((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _choreoSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // widget.controller.choreographer.isFetching &&
        //         widget.controller.choreographer.isAutoIGCEnabled
        //     ? Container(
        //         height: 56,
        //         width: 56,
        //         padding: const EdgeInsets.all(13),
        //         child: const CircularProgressIndicator(),
        //       )
        //     :
        Container(
      height: 56,
      alignment: Alignment.center,
      child: IconButton(
        icon: const Icon(Icons.send_outlined),
        color:
            widget.controller.choreographer.assistanceState.stateColor(context),
        onPressed: () {
          widget.controller.choreographer.incrementTimesClicked();
          widget.controller.choreographer.send(context);
        },
        tooltip: L10n.of(context).send,
      ),
    );
  }
}
