import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/choreographer/widgets/has_error_button.dart';
import 'package:fluffychat/pangea/choreographer/widgets/language_permissions_warning_buttons.dart';
import 'package:fluffychat/pangea/spaces/models/space_model.dart';

class ChatFloatingActionButton extends StatefulWidget {
  final ChatController controller;
  const ChatFloatingActionButton({
    super.key,
    required this.controller,
  });

  @override
  ChatFloatingActionButtonState createState() =>
      ChatFloatingActionButtonState();
}

class ChatFloatingActionButtonState extends State<ChatFloatingActionButton> {
  bool showPermissionsError = false;
  StreamSubscription? _choreoSub;

  @override
  void initState() {
    final permissionsController =
        widget.controller.pangeaController.permissionsController;
    final itEnabled = permissionsController.isToolEnabled(
      ToolSetting.interactiveTranslator,
      widget.controller.room,
    );
    final igcEnabled = permissionsController.isToolEnabled(
      ToolSetting.interactiveGrammar,
      widget.controller.room,
    );
    showPermissionsError = !itEnabled || !igcEnabled;
    debugPrint("showPermissionsError: $showPermissionsError");

    if (showPermissionsError) {
      Future.delayed(
        const Duration(seconds: 5),
        () {
          if (mounted) setState(() => showPermissionsError = false);
        },
      );
    }

    // Rebuild the widget each time there's an update from choreo (i.e., an error).
    _choreoSub = widget.controller.choreographer.stateStream.stream.listen((_) {
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
    if (widget.controller.selectedEvents.isNotEmpty) {
      return const SizedBox.shrink();
    }
    if (widget.controller.showScrollDownButton) {
      return FloatingActionButton(
        onPressed: widget.controller.scrollDown,
        heroTag: null,
        mini: true,
        child: const Icon(Icons.arrow_downward_outlined),
      );
    }
    if (widget.controller.choreographer.errorService.error != null) {
      return ChoreographerHasErrorButton(
        widget.controller.choreographer.errorService.error!,
        widget.controller.choreographer,
      );
    }

    return showPermissionsError
        ? LanguagePermissionsButtons(
            choreographer: widget.controller.choreographer,
            roomID: widget.controller.roomId,
          )
        : const SizedBox.shrink();
  }
}
