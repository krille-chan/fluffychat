import 'package:flutter/material.dart';
import 'package:fluffychat/widgets/streaming/video_streaming.dart';
import 'package:go_router/go_router.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluffychat/l10n/l10n.dart';
import '../streaming/video_streaming_model.dart';

class LivePreviewDialog extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String? title;

  const LivePreviewDialog({
    super.key,
    required this.roomId,
    required this.roomName,
    this.title,
  });

  static void show(
    BuildContext context, {
    required String roomId,
    required String roomName,
    String? title,
  }) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (_) => LivePreviewDialog(
        roomId: roomId,
        roomName: roomName,
        title: title,
      ),
    );
  }

  @override
  State<LivePreviewDialog> createState() => _LivePreviewDialogState();
}

class _LivePreviewDialogState extends State<LivePreviewDialog> {
  final String playbackUrl = dotenv.env['IVS_PLAYBACK_URL'] ?? '';
  String? latestDebugInfo;
  bool loading = false;

  final TextEditingController titleController = TextEditingController();
  String? titleError;
  String previewTitle = '';

  @override
  void initState() {
    super.initState();
    previewTitle = widget.title ?? '';
    titleController.text = previewTitle;
  }

  Future<void> _submit() async {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      setState(() {
        titleError = L10n.of(context).liveTitle;
      });
      return;
    }

    setState(() {
      loading = true;
    });

    final client = Matrix.of(context).client;
    final room = client.getRoomById(widget.roomId);

    final model = VideoStreamingModel(
      title: title,
      playbackUrl: playbackUrl,
    );

    await VideoStreamingModel.sendLiveWidget(
      room: room,
      model: model,
    );

    Navigator.of(context, rootNavigator: true).pop();
    context.go('/rooms/${widget.roomId}');
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.live_tv_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.live.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.liveTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      onChanged: (value) {
                        setState(() {
                          previewTitle = value;
                          titleError = null;
                        });
                      },
                      style: TextStyle(
                        color: theme.colorScheme.onSecondary,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.enterLiveTitleHint,
                        border: const OutlineInputBorder(),
                        isDense: true,
                        errorText: titleError,
                        errorStyle: TextStyle(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.preview,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.tertiary,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: VideoStreaming(
                        title: previewTitle,
                        playbackUrl: playbackUrl,
                        isAdmin: true,
                        isPreview: true,
                        onDebugInfoChanged: (info) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                latestDebugInfo = info;
                              });
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      latestDebugInfo ?? '',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          child: loading
                              ? const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: LinearProgressIndicator(),
                                )
                              : Text(
                                  l10n.showLiveForRoom(widget.roomName),
                                  style: const TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                tooltip: l10n.close,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
