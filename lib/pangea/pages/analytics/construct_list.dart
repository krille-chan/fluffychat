import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/construct_analytics_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/models/constructs_analytics_model.dart';
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
  final ConstructType constructType;
  final AnalyticsSelected defaultSelected;
  final AnalyticsSelected? selected;
  final BaseAnalyticsController controller;
  final PangeaController pangeaController;

  const ConstructList({
    super.key,
    required this.constructType,
    required this.defaultSelected,
    required this.controller,
    required this.pangeaController,
    this.selected,
  });

  @override
  State<StatefulWidget> createState() => ConstructListState();
}

class ConstructListState extends State<ConstructList> {
  bool initialized = false;
  String? langCode;
  String? error;

  @override
  void initState() {
    super.initState();
    widget.pangeaController.analytics
        .setConstructs(
          constructType: widget.constructType,
          removeIT: true,
          defaultSelected: widget.defaultSelected,
          selected: widget.selected,
          forceUpdate: true,
        )
        .whenComplete(() => setState(() => initialized = true));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return error != null
        ? Center(
            child: Text(error!),
          )
        : Column(
            children: [
              ConstructListView(
                init: initialized,
                controller: widget.controller,
                pangeaController: widget.pangeaController,
                defaultSelected: widget.defaultSelected,
                selected: widget.selected,
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
  // final List<ConstructEvent> constructs;
  final bool init;
  final BaseAnalyticsController controller;
  final PangeaController pangeaController;
  final AnalyticsSelected defaultSelected;
  final AnalyticsSelected? selected;

  const ConstructListView({
    super.key,
    required this.init,
    required this.controller,
    required this.pangeaController,
    required this.defaultSelected,
    this.selected,
  });

  @override
  State<StatefulWidget> createState() => ConstructListViewState();
}

class ConstructListViewState extends State<ConstructListView> {
  final Map<String, Timeline> _timelinesCache = {};
  final Map<String, PangeaMessageEvent> _msgEventCache = {};
  final List<PangeaMessageEvent> _msgEvents = [];
  bool fetchingUses = false;

  StreamSubscription<Event>? stateSub;
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();

    stateSub = Matrix.of(context)
        .client
        .onRoomState
        .stream
        //could optimize here be determing if the vocab event is relevant for
        //currently displayed data
        .where((event) => event.type == PangeaEventTypes.vocab)
        .listen(onStateUpdate);
  }

  Future<void> onStateUpdate(Event? newState) async {
    debugPrint("onStateUpdate construct list");
    if (refreshTimer?.isActive ?? false) return;
    refreshTimer = Timer(
      const Duration(seconds: 3),
      () async {
        await widget.pangeaController.analytics.setConstructs(
          constructType: ConstructType.grammar,
          removeIT: true,
          defaultSelected: widget.defaultSelected,
          selected: widget.selected,
          forceUpdate: true,
        );
        await fetchUses();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    refreshTimer?.cancel();
    stateSub?.cancel();
  }

  // @override
  // void didUpdateWidget(ConstructListView oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   fetchUses();
  // }

  int get lemmaIndex =>
      constructs?.indexWhere(
        (element) => element.content.lemma == widget.controller.currentLemma,
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
      timeline = await msgRoom.getTimeline();
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
      final List<OneConstructUse> uses = currentConstruct!.content.uses;
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
        m: "Failed to fetch uses for current construct ${currentConstruct?.content.lemma}",
      );
    }
  }

  List<ConstructEvent>? get constructs =>
      widget.pangeaController.analytics.constructs;

  ConstructEvent? get currentConstruct => constructs?.firstWhereOrNull(
        (element) => element.content.lemma == widget.controller.currentLemma,
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

  @override
  Widget build(BuildContext context) {
    if (!widget.init || fetchingUses) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if ((constructs?.isEmpty ?? true) ||
        (widget.controller.currentLemma != null && currentConstruct == null)) {
      return Expanded(
        child: Center(child: Text(L10n.of(context)!.noDataFound)),
      );
    }

    final msgEventMatches = getMessageEventMatches();

    return widget.controller.currentLemma == null
        ? Expanded(
            child: ListView.builder(
              itemCount: constructs!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    constructs![index].content.lemma,
                  ),
                  subtitle: Text(
                    '${L10n.of(context)!.total} ${constructs![index].content.uses.length}',
                  ),
                  onTap: () {
                    final String lemma = constructs![index].content.lemma;
                    widget.controller.setCurrentLemma(lemma);
                    fetchUses();
                  },
                );
              },
            ),
          )
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (constructs![lemmaIndex].content.uses.length >
                    _msgEvents.length)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(L10n.of(context)!.roomDataMissing),
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemCount: msgEventMatches.length,
                    itemBuilder: (context, index) {
                      return ConstructMessage(
                        msgEvent: msgEventMatches[index].msgEvent,
                        lemma: widget.controller.currentLemma!,
                        errorMessage: msgEventMatches[index].lemmaMatch,
                      );
                    },
                  ),
                ),
              ],
            ),
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
  final int? start;
  final int? end;

  const ConstructMessageBubble({
    super.key,
    required this.errorText,
    required this.replacementText,
    this.start,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
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
            text: (start == null || end == null)
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
                        text: errorText.substring(start!, end),
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
                        text: errorText.substring(end!),
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
    final String roomName = msgEvent.event.room.name.isEmpty
        ? Matrix.of(context)
                .client
                .getRoomById(msgEvent.event.room.id)
                ?.getLocalizedDisplayname() ??
            ""
        : msgEvent.event.room.name;

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
