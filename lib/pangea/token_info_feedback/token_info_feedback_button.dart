import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_dialog.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_request.dart';
import 'package:fluffychat/widgets/matrix.dart';

class TokenInfoFeedbackButton extends StatelessWidget {
  final TokenInfoFeedbackRequestData requestData;
  final String langCode;
  final PangeaMessageEvent event;
  final VoidCallback onUpdate;

  const TokenInfoFeedbackButton({
    super.key,
    required this.requestData,
    required this.langCode,
    required this.event,
    required this.onUpdate,
  });

  Future<void> _submitFeedback(BuildContext context) async {
    final resp = await showDialog(
      context: context,
      builder: (context) => TokenInfoFeedbackDialog(
        requestData: requestData,
        langCode: langCode,
        event: event,
        onUpdate: onUpdate,
      ),
    );

    if (resp != null && resp is String) {
      _showSuccessSnackBar(resp, context);
    }
  }

  void _showSuccessSnackBar(String message, BuildContext context) {
    OverlayUtil.showOverlay(
      overlayKey: "token_feedback_snackbar",
      context: context,
      child: _TokenFeedbackNotification(message: message),
      transformTargetId: '',
      position: OverlayPositionEnum.top,
      backDropToDismiss: false,
      closePrevOverlay: false,
      canPop: false,
    );

    Future.delayed(const Duration(seconds: 10), () {
      MatrixState.pAnyState.closeOverlay("token_feedback_snackbar");
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.flag_outlined),
      onPressed: () => _submitFeedback(context),
      tooltip: L10n.of(context).reportWordIssueTooltip,
    );
  }
}

class _TokenFeedbackNotification extends StatefulWidget {
  final String message;

  const _TokenFeedbackNotification({
    required this.message,
  });

  @override
  State<_TokenFeedbackNotification> createState() =>
      _TokenFeedbackNotificationState();
}

class _TokenFeedbackNotificationState extends State<_TokenFeedbackNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      ),
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _slideController.reverse();
    if (mounted) {
      MatrixState.pAnyState.closeOverlay("token_feedback_snackbar");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const BotFace(
                  width: 30,
                  expression: BotExpression.idle,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _close,
                  tooltip: L10n.of(context).close,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
