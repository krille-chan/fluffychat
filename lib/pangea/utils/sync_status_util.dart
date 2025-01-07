import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/localized_exception_extension.dart';
import '../../widgets/matrix.dart';

class PLoadingStatus extends StatefulWidget {
  final void Function()? onFinish;

  final Widget child;
  final Widget? shimmerChild;
  const PLoadingStatus({
    super.key,
    required this.child,
    this.onFinish,
    this.shimmerChild,
  });

  @override
  PLoadingStatusState createState() => PLoadingStatusState();
}

class PLoadingStatusState extends State<PLoadingStatus> {
  late final StreamSubscription _onSyncSub;
  bool isFinished = false;
  @override
  void initState() {
    _onSyncSub = Matrix.of(context).client.onSyncStatus.stream.listen(
          (status) => setState(() {
            if (status.status == SyncStatus.finished) {
              //PTODO - test this
              if (!isFinished) {
                isFinished = true;
                widget.onFinish?.call();
              }
            }
          }),
        );
    super.initState();
  }

  @override
  void dispose() {
    _onSyncSub.cancel();
    super.dispose();
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

    return hide ? widget.child : shimmerComponent;
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
