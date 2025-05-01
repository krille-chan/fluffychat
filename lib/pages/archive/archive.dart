import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:hermes/l10n/l10n.dart';
import 'package:hermes/pages/archive/archive_view.dart';
import 'package:hermes/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:hermes/widgets/future_loading_dialog.dart';
import 'package:hermes/widgets/matrix.dart';

class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  ArchiveController createState() => ArchiveController();
}

class ArchiveController extends State<Archive> {
  List<Room> archive = [];

  Future<List<Room>> getArchive(BuildContext context) async {
    if (archive.isNotEmpty) return archive;
    return archive = await Matrix.of(context).client.loadArchive();
  }

  void forgetRoomAction(int i) async {
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        Logs().v('Forget room ${archive.last.getLocalizedDisplayname()}');
        await archive[i].forget();
        archive.removeAt(i);
      },
    );
    setState(() {});
  }

  void forgetAllAction() async {
    final archive = this.archive;
    final client = Matrix.of(context).client;
    if (archive.isEmpty) return;
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
          message: L10n.of(context).clearArchive,
        ) !=
        OkCancelResult.ok) {
      return;
    }
    await showFutureLoadingDialog(
      context: context,
      futureWithProgress: (onProgress) async {
        final count = archive.length;
        while (archive.isNotEmpty) {
          onProgress(1 - (archive.length / count));
          Logs().v('Forget room ${archive.last.getLocalizedDisplayname()}');
          await archive.last.forget();
          archive.removeLast();
        }
      },
    );
    client.clearArchivesFromCache();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => ArchiveView(this);
}
