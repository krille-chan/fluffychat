import 'package:flutter/material.dart';
import 'package:fluffychat/widgets/streaming/video_streaming_model.dart';
import 'package:fluffychat/pages/extensions/extensions.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/live_preview_dialog.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';

class ExtensionCard extends StatefulWidget {
  final IconData? icon;
  final ExtensionType type;
  final String title;
  final String subtitle;
  final String roomId;
  final String roomName;

  const ExtensionCard({
    super.key,
    this.icon,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<ExtensionCard> createState() => _ExtensionCardState();
}

class _ExtensionCardState extends State<ExtensionCard> {
  bool isHovered = false;

  void _showDetailsDialog(BuildContext context) {
    if (widget.type == ExtensionType.live) {
      LivePreviewDialog.show(
        context,
        roomId: widget.roomId,
        roomName: widget.roomName,
      );
    }
  }

  Future<void> _closeLive() async {
    final confirmed = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context).confirm.toUpperCase(),
      message: L10n.of(context).closeLiveConfirm,
      okLabel: L10n.of(context).confirm,
      cancelLabel: L10n.of(context).cancel,
      isDestructive: true,
    );

    if (confirmed != OkCancelResult.ok) return;

    final client = Matrix.of(context).client;
    final room = client.getRoomById(widget.roomId);

    try {
      if (room != null) {
        await VideoStreamingModel.removeLiveWidget(room);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context).liveClosedSuccess),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context).liveCloseError(e.toString())),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<Map<String, bool>>(
      valueListenable: VideoStreamingModel.liveStatus,
      builder: (context, liveMap, _) {
        final isLive = liveMap[widget.roomId] == true;

        final borderColor = isHovered && !isLive
            ? theme.colorScheme.primary
            : theme.colorScheme.tertiary;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: isLive ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: isLive ? null : () => _showDetailsDialog(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(widget.icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  if (isLive && widget.type == ExtensionType.live) ...[],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (isLive &&
                                widget.type == ExtensionType.live) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  L10n.of(context).liveOnAir,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLive && widget.type == ExtensionType.live) ...[
                    OutlinedButton(
                      onPressed: _closeLive,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.tertiary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        L10n.of(context).closeLive,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
