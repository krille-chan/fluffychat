import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity_content.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class PracticeActivityCard extends StatefulWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageToolbarState controller;

  const PracticeActivityCard({
    super.key,
    required this.pangeaMessageEvent,
    required this.controller,
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

  String? get langCode {
    final String? langCode = MatrixState.pangeaController.languageController
        .activeL2Model()
        ?.langCode;

    if (langCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context)!.noLanguagesSet)),
      );
      debugger(when: kDebugMode);
      return null;
    }
    return langCode;
  }

  void loadInitialData() {
    if (langCode == null) return;
    debugPrint(
      "total events: ${widget.pangeaMessageEvent.practiceActivities(langCode!).length}",
    );
    debugPrint(
      "incomplete practice events: ${widget.pangeaMessageEvent.practiceActivities(langCode!).where((element) => !element.isComplete).length}",
    );
    updatePracticeActivity();
    // practiceEvent = widget.pangeaMessageEvent
    //     .practiceActivities(langCode)
    //     .firstWhereOrNull((activity) => !activity.isComplete);

    if (practiceEvent == null) {
      debugger(when: kDebugMode);
    }
  }

  void updatePracticeActivity() {
    if (langCode == null) return;
    setState(() {
      practiceEvent = widget.pangeaMessageEvent
          .practiceActivities(langCode!)
          .firstWhereOrNull(
            (activity) =>
                activity.event.eventId != practiceEvent?.event.eventId &&
                !activity.isComplete,
          );
    });
  }

  void showNextActivity() {
    if (langCode == null) return;
    updatePracticeActivity();
    widget.controller.updateMode(MessageMode.practiceActivity);
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
      controller: this,
    );
  }
}
