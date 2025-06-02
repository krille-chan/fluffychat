import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image/image.dart';
import 'package:matrix/matrix.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_image/qr_image.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import '../config/themes.dart';

Future<void> showQrCodeViewer(
  BuildContext context,
  String content,
) =>
    showDialog(
      context: context,
      builder: (context) => QrCodeViewer(content: content),
    );

class QrCodeViewer extends StatelessWidget {
  final String content;

  const QrCodeViewer({required this.content, super.key});

  void _save(BuildContext context) async {
    final imageResult = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final inviteLink = 'https://matrix.to/#/$content';
        final image = QRImage(
          inviteLink,
          size: 256,
          radius: 1,
        ).generate();
        return compute(encodePng, image);
      },
    );
    final bytes = imageResult.result;
    if (bytes == null) return;
    if (!context.mounted) return;

    MatrixImageFile(
      bytes: bytes,
      name: 'QR_Code_$content.png',
      mimeType: 'image/png',
    ).save(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inviteLink = 'https://matrix.to/#/$content';
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(128),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.black.withAlpha(128),
          ),
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(context).pop,
          color: Colors.white,
          tooltip: L10n.of(context).close,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withAlpha(128),
            ),
            icon: Icon(Icons.adaptive.share_outlined),
            onPressed: () => FluffyShare.share(
              inviteLink,
              context,
            ),
            color: Colors.white,
            tooltip: L10n.of(context).share,
          ),
          const SizedBox(width: 8),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withAlpha(128),
            ),
            icon: const Icon(Icons.download_outlined),
            onPressed: () => _save(context),
            color: Colors.white,
            tooltip: L10n.of(context).downloadFile,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(32.0),
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: FluffyThemes.columnWidth),
                child: PrettyQrView.data(
                  data: inviteLink,
                  decoration: PrettyQrDecoration(
                    shape: PrettyQrSmoothSymbol(
                      roundFactor: 1,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SelectableText(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
