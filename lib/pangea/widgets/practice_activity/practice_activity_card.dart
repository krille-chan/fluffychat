import 'dart:developer';

import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_content.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class PracticeActivityCard extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;

  const PracticeActivityCard({
    super.key,
    required this.pangeaMessageEvent,
  });

  @override
  MessagePracticeActivityCardState createState() =>
      MessagePracticeActivityCardState();
}

class MessagePracticeActivityCardState extends State<PracticeActivityCard> {
  PracticeActivityEvent? practiceEvent;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    final String? langCode = MatrixState.pangeaController.languageController
        .activeL2Model()
        ?.langCode;

    if (langCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context)!.noLanguagesSet)),
      );
      debugger(when: kDebugMode);
      return;
    }

    practiceEvent =
        widget.pangeaMessageEvent.practiceActivities(langCode).firstOrNull;

    if (practiceEvent == null) {
      debugger(when: kDebugMode);
    }
    setState(() {});
  }

  void updatePracticeActivity(PracticeActivityEvent? newEvent) {
    setState(() {
      practiceEvent = newEvent;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (practiceEvent == null) {
      return Text(
        L10n.of(context)!.noActivitiesFound,
        style: BotStyle.text(context),
      );
      // return GeneratePracticeActivityButton(
      //   pangeaMessageEvent: widget.pangeaMessageEvent,
      //   onActivityGenerated: updatePracticeActivity,
      // );
    }
    return PracticeActivityContent(
      practiceEvent: practiceEvent!,
      pangeaMessageEvent: widget.pangeaMessageEvent,
    );
  }
}
