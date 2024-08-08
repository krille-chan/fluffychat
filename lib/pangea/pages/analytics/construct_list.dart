import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_event.dart';
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
  final BaseAnalyticsController controller;
  final PangeaController pangeaController;
  final StreamController refreshStream;

  const ConstructList({
    super.key,
    required this.constructType,
    required this.defaultSelected,
    required this.controller,
    required this.pangeaController,
    required this.refreshStream,
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
                controller: widget.controller,
                pangeaController: widget.pangeaController,
                defaultSelected: widget.defaultSelected,
                selected: widget.selected,
                refreshStream: widget.refreshStream,
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
  final BaseAnalyticsController controller;
  final PangeaController pangeaController;
  final AnalyticsSelected defaultSelected;
  final AnalyticsSelected? selected;
  final StreamController refreshStream;

  const ConstructListView({
    super.key,
    required this.controller,
    required this.pangeaController,
    required this.defaultSelected,
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

  @override
  void initState() {
    super.initState();
    widget.pangeaController.analytics
        .getConstructs(
          constructType: constructType,
          removeIT: true,
          defaultSelected: widget.defaultSelected,
          selected: widget.selected,
          forceUpdate: true,
        )
        .whenComplete(() => setState(() => fetchingConstructs = false))
        .then((value) => setState(() => _constructs = value));

    refreshSubscription = widget.refreshStream.stream.listen((forceUpdate) {
      // postframe callback to let widget rebuild with the new selected parameter
      // before sending selected to getConstructs function
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.pangeaController.analytics
            .getConstructs(
              constructType: constructType,
              removeIT: true,
              defaultSelected: widget.defaultSelected,
              selected: widget.selected,
              forceUpdate: true,
            )
            .then(
              (value) => setState(() {
                _constructs = value;
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

  int get lemmaIndex =>
      constructs?.indexWhere(
        (element) => element.lemma == widget.controller.currentLemma,
      ) ??
      -1;

  Future<PangeaMessageEvent?> getMessageEvent(
    OneConstructUse use,
  ) async {
    final Client client = Matrix.of(context).client;
    PangeaMessageEvent msgEvent;
    if (_msgEventCache.containsKey(use.msgId!)) {
      return _msgEventCache[use.msgId!]!;
    }
    final Room? msgRoom = use.getRoom(client);
    if (msgRoom == null || use.msgId == null) {
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
    _msgEventCache[use.msgId!] = msgEvent;
    return msgEvent;
  }

  Future<void> fetchUses() async {
    if (fetchingUses) return;
    if (currentConstruct == null) {
      setState(() => _msgEvents.clear());
      return;
    }

    setState(() => fetchingUses = true);
    try {
      final List<OneConstructUse> uses = currentConstruct!.uses;
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
        m: "Failed to fetch uses for current construct ${currentConstruct?.lemma}",
      );
    }
  }

  List<ConstructAnalyticsEvent>? _constructs;

  List<ConstructUses>? get constructs {
    if (_constructs == null) {
      return null;
    }

    final List<OneConstructUse> filtered = List.from(_constructs!)
        .map((event) => event.content.uses)
        .expand((uses) => uses)
        .cast<OneConstructUse>()
        .where((use) => use.constructType == constructType)
        .toList();

    final Map<String, List<OneConstructUse>> lemmaToUses = {};
    for (final use in filtered) {
      if (use.lemma == null) continue;
      lemmaToUses[use.lemma!] ??= [];
      lemmaToUses[use.lemma!]!.add(use);
    }

    final constructUses = lemmaToUses.entries
        .map(
          (entry) => ConstructUses(
            lemma: entry.key,
            uses: entry.value,
            constructType: constructType,
          ),
        )
        .toList();

    constructUses.sort((a, b) {
      final comp = b.uses.length.compareTo(a.uses.length);
      if (comp != 0) return comp;
      return a.lemma.compareTo(b.lemma);
    });

    return constructUses;
  }

  ConstructUses? get currentConstruct => constructs?.firstWhereOrNull(
        (element) => element.lemma == widget.controller.currentLemma,
      );

  // given the current lemma and list of message events, return a list of
  // MessageEventMatch objects, which contain one PangeaMessageEvent to one PangeaMatch
  // this is because some message events may have has more than one PangeaMatch of a
  // given lemma type.
  List<MessageEventMatch> getMessageEventMatches() {
    if (widget.controller.currentLemma == null) return [];
    final List<MessageEventMatch> allMsgErrorSteps = [];

    for (final msgEvent in _msgEvents) {
      if (allMsgErrorSteps.any(
        (element) => element.msgEvent.eventId == msgEvent.eventId,
      )) {
        continue;
      }
      // get all the pangea matches in that message which have that lemma
      final List<PangeaMatch>? msgErrorSteps = msgEvent.errorSteps(
        widget.controller.currentLemma!,
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

    if (constructs?.isEmpty ?? true) {
      return Expanded(
        child: Center(child: Text(L10n.of(context)!.noDataFound)),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: constructs!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              constructs![index].lemma,
            ),
            subtitle: Text(
              '${L10n.of(context)!.total} ${constructs![index].uses.length}',
            ),
            onTap: () async {
              final String lemma = constructs![index].lemma;
              widget.controller.setCurrentLemma(lemma);
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
    if (controller.widget.controller.currentLemma == null ||
        controller.constructs == null ||
        controller.lemmaIndex < 0 ||
        controller.lemmaIndex >= controller.constructs!.length) {
      return const AlertDialog(content: CircularProgressIndicator.adaptive());
    }

    final msgEventMatches = controller.getMessageEventMatches();

    final noData = controller.constructs![controller.lemmaIndex].uses.length >
        controller._msgEvents.length;

    return AlertDialog(
      title: Center(child: Text(controller.widget.controller.currentLemma!)),
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
                          lemma: controller.widget.controller.currentLemma!,
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
            text: (end == null)
                ? TextSpan(
                    text: errorText,
                    style: defaultStyle,
                  )
                : TextSpan(
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
