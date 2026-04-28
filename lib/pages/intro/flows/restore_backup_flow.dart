import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

Future<void> restoreBackupFlow(BuildContext context) async {
  final matrix = Matrix.of(context);
  final picked = await selectFiles(context);
  final file = picked.firstOrNull;
  if (file == null) return;

  if (!context.mounted) return;
  await showFutureLoadingDialog(
    context: context,
    future: () async {
      final client = await matrix.getLoginClient();
      await client.importDump(String.fromCharCodes(await file.readAsBytes()));
      matrix.initMatrix();
    },
  );
}
