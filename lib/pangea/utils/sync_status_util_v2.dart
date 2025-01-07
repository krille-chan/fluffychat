import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/localized_exception_extension.dart';
import '../../widgets/matrix.dart';
import 'error_handler.dart';

class PLoadingStatusV2 extends StatefulWidget {
  final void Function()? onFinish;

  final Widget child;
  final Widget? shimmerChild;
  const PLoadingStatusV2({
    super.key,
    required this.child,
    this.onFinish,
    this.shimmerChild,
  });

  @override
  PLoadingStatusStateV2 createState() => PLoadingStatusStateV2();
}

class PLoadingStatusStateV2 extends State<PLoadingStatusV2> {
  bool isFinished = false;
  @override
  void initState() {
    _waitForSync();
    super.initState();
  }

  _waitForSync() async {
    try {
      final Client client = Matrix.of(context).client;
      if (client.rooms.isEmpty) await client.roomsLoading;

      // await client.accountDataLoading;
      // client.prevBatch == null ? await client.onSync.stream.first : null;

      if (!isFinished) {
        isFinished = true;
        widget.onFinish?.call();
      }
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
      isFinished = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Client client = Matrix.of(context).client;
    final SyncStatusUpdate status = client.onSyncStatus.value ??
        const SyncStatusUpdate(SyncStatus.waitingForResponse);
    final bool hide = client.onSync.value != null &&
        status.status != SyncStatus.error &&
        client.prevBatch != null;

    final shimmerComponent = widget.shimmerChild == null
        ? PangeaDefaultShimmer(hide: hide, status: status)
        : widget.shimmerChild!;

    return isFinished ? widget.child : shimmerComponent;
  }
}

class PangeaDefaultShimmer extends StatelessWidget {
  const PangeaDefaultShimmer({
    super.key,
    required this.hide,
    required this.status,
  });

  final bool hide;
  final SyncStatusUpdate status;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceInOut,
      height: hide ? 0 : 36,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 2,
              value: hide ? 1.0 : status.progress,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            status.toLocalizedString(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

extension on SyncStatusUpdate {
  String toLocalizedString(BuildContext context) {
    switch (status) {
      case SyncStatus.waitingForResponse:
        return L10n.of(context).loadingPleaseWait;
      case SyncStatus.error:
        return ((error?.exception ?? Object()) as Object)
            .toLocalizedString(context);
      case SyncStatus.processing:
      case SyncStatus.cleaningUp:
      case SyncStatus.finished:
        return L10n.of(context).synchronizingPleaseWait;
    }
  }
}
