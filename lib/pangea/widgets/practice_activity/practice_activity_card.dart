import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_acitivity_record_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_record_model.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/pangea/widgets/practice_activity/practice_activity.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

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
  List<PracticeActivityEvent> practiceActivities = [];
  PracticeActivityEvent? practiceEvent;
  PracticeActivityRecordModel? recordModel;
  bool sending = false;

  int get practiceEventIndex => practiceActivities.indexWhere(
        (activity) => activity.event.eventId == practiceEvent?.event.eventId,
      );

  bool get isPrevEnabled =>
      practiceEventIndex > 0 &&
      practiceActivities.length > (practiceEventIndex - 1);

  bool get isNextEnabled =>
      practiceEventIndex >= 0 &&
      practiceEventIndex < practiceActivities.length - 1;

  // the first record for this practice activity
  // assosiated with the current user
  PracticeActivityRecordEvent? get recordEvent =>
      practiceEvent?.userRecords.firstOrNull;

  @override
  void initState() {
    super.initState();
    setPracticeActivities();
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

  /// Initalizes the practice activities for the current language
  /// and sets the first activity as the current activity
  void setPracticeActivities() {
    if (langCode == null) return;
    practiceActivities =
        widget.pangeaMessageEvent.practiceActivities(langCode!);
    if (practiceActivities.isEmpty) return;

    practiceActivities.sort(
      (a, b) => a.event.originServerTs.compareTo(b.event.originServerTs),
    );

    // if the current activity hasn't been set yet, show the first uncompleted activity
    // if there is one. If not, show the first activity
    final List<PracticeActivityEvent> incompleteActivities =
        practiceActivities.where((element) => !element.isComplete).toList();
    practiceEvent ??= incompleteActivities.isNotEmpty
        ? incompleteActivities.first
        : practiceActivities.first;
    setState(() {});
  }

  void navigateActivities({Direction? direction, int? index}) {
    final bool enableNavigation = (direction == Direction.f && isNextEnabled) ||
        (direction == Direction.b && isPrevEnabled) ||
        (index != null && index >= 0 && index < practiceActivities.length);
    if (enableNavigation) {
      final int newIndex = index ??
          (direction == Direction.f
              ? practiceEventIndex + 1
              : practiceEventIndex - 1);
      practiceEvent = practiceActivities[newIndex];
      setState(() {});
    }
  }

  void sendRecord() {
    if (recordModel == null || practiceEvent == null) return;
    setState(() => sending = true);
    MatrixState.pangeaController.activityRecordController
        .send(recordModel!, practiceEvent!)
        .catchError((error) {
      ErrorHandler.logError(
        e: error,
        s: StackTrace.current,
        data: {
          'recordModel': recordModel?.toJson(),
          'practiceEvent': practiceEvent?.event.toJson(),
        },
      );
      return null;
    }).whenComplete(() => setState(() => sending = false));
  }

  @override
  Widget build(BuildContext context) {
    final Widget navigationButtons = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Opacity(
          opacity: isPrevEnabled ? 1.0 : 0,
          child: IconButton(
            onPressed: isPrevEnabled
                ? () => navigateActivities(direction: Direction.b)
                : null,
            icon: const Icon(Icons.keyboard_arrow_left_outlined),
            tooltip: L10n.of(context)!.previous,
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: recordEvent == null ? 1.0 : 0.5,
            child: sending
                ? const CircularProgressIndicator.adaptive()
                : TextButton(
                    onPressed: recordEvent == null ? sendRecord : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        AppConfig.primaryColor,
                      ),
                    ),
                    child: Text(L10n.of(context)!.submit),
                  ),
          ),
        ),
        Opacity(
          opacity: isNextEnabled ? 1.0 : 0,
          child: IconButton(
            onPressed: isNextEnabled
                ? () => navigateActivities(direction: Direction.f)
                : null,
            icon: const Icon(Icons.keyboard_arrow_right_outlined),
            tooltip: L10n.of(context)!.next,
          ),
        ),
      ],
    );

    if (practiceEvent == null || practiceActivities.isEmpty) {
      return Text(
        L10n.of(context)!.noActivitiesFound,
        style: BotStyle.text(context),
      );
      // return GeneratePracticeActivityButton(
      //   pangeaMessageEvent: widget.pangeaMessageEvent,
      //   onActivityGenerated: updatePracticeActivity,
      // );
    }
    return Column(
      children: [
        PracticeActivity(
          pangeaMessageEvent: widget.pangeaMessageEvent,
          practiceEvent: practiceEvent!,
          controller: this,
        ),
        navigationButtons,
      ],
    );
  }
}
