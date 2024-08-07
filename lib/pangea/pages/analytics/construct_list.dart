import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/time_span.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/models/analytics/construct_list_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

class ConstructList extends StatefulWidget {
  final ConstructTypeEnum constructType;
  final AnalyticsSelected defaultSelected;
  final AnalyticsSelected? selected;
  final TimeSpan timeSpan;
  final PangeaController pangeaController;
  final StreamController refreshStream;

  const ConstructList({
    super.key,
    required this.constructType,
    required this.defaultSelected,
    required this.pangeaController,
    required this.refreshStream,
    required this.timeSpan,
    this.selected,
  });

  @override
  State<StatefulWidget> createState() => ConstructListState();
}

class ConstructListState extends State<ConstructList> {
  String? langCode;
  String? error;

  @override
  Widget build(BuildContext context) {
    return error != null
        ? Center(
            child: Text(error!),
          )
        : Column(
            children: [
              ConstructListView(
                pangeaController: widget.pangeaController,
                defaultSelected: widget.defaultSelected,
                selected: widget.selected,
                refreshStream: widget.refreshStream,
                timeSpan: widget.timeSpan,
              ),
            ],
          );
  }
}

// list view of construct events
// parameters
//  1) a list of construct events and
//  2) a boolean indicating whether the list has been initialized
// if not initialized, show loading indicator
// for each tile,
//    title = construct.content.lemma
//    subtitle = total uses, equal to construct.content.uses.length
// list has a fixed height of 400 and is scrollable
class ConstructListView extends StatefulWidget {
  final PangeaController pangeaController;
  final AnalyticsSelected defaultSelected;
  final TimeSpan timeSpan;
  final AnalyticsSelected? selected;
  final StreamController refreshStream;

  const ConstructListView({
    super.key,
    required this.pangeaController,
    required this.defaultSelected,
    required this.timeSpan,
    required this.refreshStream,
    this.selected,
  });

  @override
  State<StatefulWidget> createState() => ConstructListViewState();
}

class ConstructListViewState extends State<ConstructListView> {
  final ConstructTypeEnum constructType = ConstructTypeEnum.grammar;
  final Map<String, Timeline> _timelinesCache = {};
  final Map<String, PangeaMessageEvent> _msgEventCache = {};
  final List<PangeaMessageEvent> _msgEvents = [];
  bool fetchingConstructs = true;
  bool fetchingUses = false;
  StreamSubscription? refreshSubscription;
  String? currentLemma;

  @override
  void initState() {
    super.initState();
    widget.pangeaController.analytics
        .getConstructs(
          constructType: constructType,
          forceUpdate: true,
        )
        .whenComplete(() => setState(() => fetchingConstructs = false))
        .then(
          (value) => setState(
            () => constructs = ConstructListModel(
              type: constructType,
              uses: value,
            ),
          ),
        );

    refreshSubscription = widget.refreshStream.stream.listen((forceUpdate) {
      // postframe callback to let widget rebuild with the new selected parameter
      // before sending selected to getConstructs function
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.pangeaController.analytics
            .getConstructs(
              constructType: constructType,
              forceUpdate: true,
            )
            .then(
              (value) => setState(() {
                ConstructListModel(
                  type: constructType,
                  uses: value,
                );
              }),
            );
      });
    });
  }

  @override
  void dispose() {
    refreshSubscription?.cancel();
    super.dispose();
  }

  void setCurrentLemma(String? lemma) {
    currentLemma = lemma;
    setState(() {});
  }

  Future<PangeaMessageEvent?> getMessageEvent(
    OneConstructUse use,
  ) async {
    final Client client = Matrix.of(context).client;
    PangeaMessageEvent msgEvent;
    if (_msgEventCache.containsKey(use.msgId)) {
      return _msgEventCache[use.msgId]!;
    }
    final Room? msgRoom = use.getRoom(client);
    if (msgRoom == null) {
      return null;
    }

    Timeline? timeline;
    if (_timelinesCache.containsKey(use.chatId)) {
      timeline = _timelinesCache[use.chatId];
    } else {
      timeline = msgRoom.timeline ?? await msgRoom.getTimeline();
      _timelinesCache[use.chatId] = timeline;
    }

    final Event? event = await use.getEvent(client);
    if (event == null || timeline == null) {
      return null;
    }

    msgEvent = PangeaMessageEvent(
      event: event,
      timeline: timeline,
      ownMessage: event.senderId == client.userID,
    );
    _msgEventCache[use.msgId] = msgEvent;
    return msgEvent;
  }

  Future<void> fetchUses() async {
    if (fetchingUses) return;
    if (currentLemma == null) {
      setState(() => _msgEvents.clear());
      return;
    }

    setState(() => fetchingUses = true);
    try {
      final List<OneConstructUse> uses = constructs?.constructs
              .firstWhereOrNull(
                (element) => element.lemma == currentLemma,
              )
              ?.uses ??
          [];
      _msgEvents.clear();

      for (final OneConstructUse use in uses) {
        final PangeaMessageEvent? msgEvent = await getMessageEvent(use);
        final RepresentationEvent? repEvent =
            msgEvent?.originalSent ?? msgEvent?.originalWritten;
        if (repEvent?.choreo == null) {
          continue;
        }
        _msgEvents.add(msgEvent!);
      }
      setState(() => fetchingUses = false);
    } catch (err, s) {
      setState(() => fetchingUses = false);
      debugPrint("Error fetching uses: $err");
      ErrorHandler.logError(
        e: err,
        s: s,
        m: "Failed to fetch uses for current construct $currentLemma",
      );
    }
  }

  ConstructListModel? constructs;

  // given the current lemma and list of message events, return a list of
  // MessageEventMatch objects, which contain one PangeaMessageEvent to one PangeaMatch
  // this is because some message events may have has more than one PangeaMatch of a
  // given lemma type.
  List<MessageEventMatch> getMessageEventMatches() {
    if (currentLemma == null) return [];
    final List<MessageEventMatch> allMsgErrorSteps = [];

    for (final msgEvent in _msgEvents) {
      if (allMsgErrorSteps.any(
        (element) => element.msgEvent.eventId == msgEvent.eventId,
      )) {
        continue;
      }
      // get all the pangea matches in that message which have that lemma
      final List<PangeaMatch>? msgErrorSteps = msgEvent.errorSteps(
        currentLemma!,
      );
      if (msgErrorSteps == null) continue;

      allMsgErrorSteps.addAll(
        msgErrorSteps.map(
          (errorStep) => MessageEventMatch(
            msgEvent: msgEvent,
            lemmaMatch: errorStep,
          ),
        ),
      );
    }
    return allMsgErrorSteps;
  }

  Future<void> showConstructMessagesDialog() async {
    await showDialog<ConstructMessagesDialog>(
      context: context,
      builder: (c) => ConstructMessagesDialog(controller: this),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (fetchingConstructs || fetchingUses) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (constructs?.constructs.isEmpty ?? true) {
      return Expanded(
        child: Center(child: Text(L10n.of(context)!.noDataFound)),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: constructs!.constructs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              constructs!.constructs[index].lemma,
            ),
            subtitle: Text(
              '${L10n.of(context)!.total} ${constructs!.constructs[index].uses.length}',
            ),
            onTap: () async {
              final String lemma = constructs!.constructs[index].lemma;
              setCurrentLemma(lemma);
              fetchUses().then((_) => showConstructMessagesDialog());
            },
          );
        },
      ),
    );
  }
}

class ConstructMessagesDialog extends StatelessWidget {
  final ConstructListViewState controller;
  const ConstructMessagesDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.currentLemma == null || controller.constructs == null) {
      return const AlertDialog(content: CircularProgressIndicator.adaptive());
    }

    final msgEventMatches = controller.getMessageEventMatches();

    final currentConstruct = controller.constructs!.constructs.firstWhereOrNull(
      (construct) => construct.lemma == controller.currentLemma,
    );
    final noData = currentConstruct == null ||
        currentConstruct.uses.length > controller._msgEvents.length;

    return AlertDialog(
      title: Center(child: Text(controller.currentLemma!)),
      content: SizedBox(
        height: noData ? 90 : 250,
        width: noData ? 200 : 400,
        child: Column(
          children: [
            if (noData)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(L10n.of(context)!.roomDataMissing),
                ),
              ),
            Expanded(
              child: ListView(
                children: [
                  ...msgEventMatches.mapIndexed(
                    (index, event) => Column(
                      children: [
                        ConstructMessage(
                          msgEvent: event.msgEvent,
                          lemma: controller.currentLemma!,
                          errorMessage: event.lemmaMatch,
                        ),
                        if (index < msgEventMatches.length - 1)
                          const Divider(height: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: false).pop(),
          child: Text(
            L10n.of(context)!.close.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class ConstructMessage extends StatelessWidget {
  final PangeaMessageEvent msgEvent;
  final PangeaMatch errorMessage;
  final String lemma;

  const ConstructMessage({
    super.key,
    required this.msgEvent,
    required this.errorMessage,
    required this.lemma,
  });

  @override
  Widget build(BuildContext context) {
    final String? chosen = errorMessage.match.choices
        ?.firstWhereOrNull(
          (element) => element.selected == true,
        )
        ?.value;

    if (chosen == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          ConstructMessageMetadata(msgEvent: msgEvent),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<User?>(
                      future: msgEvent.event.fetchSenderUser(),
                      builder: (context, snapshot) {
                        final displayname = snapshot.data?.calcDisplayname() ??
                            msgEvent.event.senderFromMemoryOrFallback
                                .calcDisplayname();
                        return Text(
                          displayname,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: (Theme.of(context).brightness ==
                                    Brightness.light
                                ? displayname.color
                                : displayname.lightColorText),
                          ),
                        );
                      },
                    ),
                    ConstructMessageBubble(
                      errorText: errorMessage.match.fullText,
                      replacementText: chosen,
                      start: errorMessage.match.offset,
                      end:
                          errorMessage.match.offset + errorMessage.match.length,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConstructMessageBubble extends StatelessWidget {
  final String errorText;
  final String replacementText;
  final int start;
  final int end;

  const ConstructMessageBubble({
    super.key,
    required this.errorText,
    required this.replacementText,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: AppConfig.messageFontSize * AppConfig.fontSizeFactor,
      height: 1.3,
    );

    return IntrinsicWidth(
      child: Material(
        color: Theme.of(context).colorScheme.primaryContainer,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(AppConfig.borderRadius),
            bottomLeft: Radius.circular(AppConfig.borderRadius),
            bottomRight: Radius.circular(AppConfig.borderRadius),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppConfig.borderRadius,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: errorText.substring(0, start),
                  style: defaultStyle,
                ),
                TextSpan(
                  text: errorText.substring(start, end),
                  style: defaultStyle.merge(
                    TextStyle(
                      backgroundColor: Colors.red.withOpacity(0.25),
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 2.5,
                    ),
                  ),
                ),
                const TextSpan(text: " "),
                TextSpan(
                  text: replacementText,
                  style: defaultStyle.merge(
                    TextStyle(
                      backgroundColor: Colors.green.withOpacity(0.25),
                    ),
                  ),
                ),
                TextSpan(
                  text: errorText.substring(end),
                  style: defaultStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConstructMessageMetadata extends StatelessWidget {
  final PangeaMessageEvent msgEvent;

  const ConstructMessageMetadata({
    super.key,
    required this.msgEvent,
  });

  @override
  Widget build(BuildContext context) {
    final String roomName = msgEvent.event.room.getLocalizedDisplayname();
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
      child: Column(
        children: [
          Text(
            msgEvent.event.originServerTs.localizedTime(context),
            style: TextStyle(fontSize: 13 * AppConfig.fontSizeFactor),
          ),
          Text(roomName),
        ],
      ),
    );
  }
}

class MessageEventMatch {
  final PangeaMessageEvent msgEvent;
  final PangeaMatch lemmaMatch;

  MessageEventMatch({
    required this.msgEvent,
    required this.lemmaMatch,
  });
}
