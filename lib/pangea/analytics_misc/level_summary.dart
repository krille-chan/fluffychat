import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/constructs/construct_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

// New component renamed to ConstructSummaryAlertDialog with a max width
class ConstructSummaryAlertDialog extends StatelessWidget {
  final String title;
  final String content;

  const ConstructSummaryAlertDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Text(content),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(L10n.of(context).close),
        ),
      ],
    );
  }
}

class LevelSummaryDialog extends StatelessWidget {
  final int level;
  final String analyticsRoomId;
  final String summaryStateEventId;
  final ConstructSummary? constructSummary;

  const LevelSummaryDialog({
    super.key,
    required this.analyticsRoomId,
    required this.level,
    required this.summaryStateEventId,
    this.constructSummary,
  });

  @override
  Widget build(BuildContext context) {
    final Client client = Matrix.of(context).client;
    final futureSummary = client
        .getOneRoomEvent(analyticsRoomId, summaryStateEventId)
        .then((rawEvent) => ConstructSummary.fromJson(rawEvent.content));
    if (constructSummary != null) {
      return ConstructSummaryAlertDialog(
        title: L10n.of(context).levelSummaryPopupTitle(level),
        content: constructSummary!.textSummary,
      );
    } else {
      return FutureBuilder<ConstructSummary>(
        future: futureSummary,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return ConstructSummaryAlertDialog(
              title: L10n.of(context).levelSummaryPopupTitle(level),
              content: L10n.of(context).error502504Desc,
            );
          } else if (snapshot.hasData) {
            final constructSummary = snapshot.data!;
            return ConstructSummaryAlertDialog(
              title: L10n.of(context).levelSummaryPopupTitle(level),
              content: constructSummary.textSummary,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    }
  }
}
