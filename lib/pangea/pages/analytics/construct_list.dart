import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/constants/match_rule_ids.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/pages/analytics/base_analytics_page.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../constants/pangea_event_types.dart';
import '../../models/construct_analytics_event.dart';
import '../../utils/error_handler.dart';

class ConstructList extends StatefulWidget {
  final AnalyticsSelected? selected;
  final AnalyticsSelected defaultSelected;
  final ConstructType constructType;
  final String title;

  const ConstructList({
    Key? key,
    required this.selected,
    required this.defaultSelected,
    required this.constructType,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConstructListState();
}

class ConstructListState extends State<ConstructList> {
  List<ConstructEvent> constructs = [];
  bool initialized = false;
  String? langCode;
  String? error;

  StreamSubscription<Event>? stateSub;
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();

    _updateConstructs();

    stateSub = MatrixState
        .pangeaController.matrixState.client.onRoomState.stream
        //could optimize here be determing if the vocab event is relevant for
        //currently displayed data
        .where((event) => event.type == PangeaEventTypes.vocab)
        .listen(onStateUpdate);
  }

  void onStateUpdate(Event newState) {
    if (!(refreshTimer?.isActive ?? false)) {
      refreshTimer = Timer(
        const Duration(seconds: 3),
        () => _updateConstructs(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    refreshTimer?.cancel();
    stateSub?.cancel();
  }

  @override
  void didUpdateWidget(ConstructList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selected?.id != oldWidget.selected?.id) {
      _updateConstructs();
    }
  }

  void _updateConstructs() {
    setState(() {
      initialized = false;
    });
    MatrixState.pangeaController.analytics
        .constuctEventsByAnalyticsSelected(
      selected: widget.selected,
      defaultSelected: widget.defaultSelected,
      constructType: widget.constructType,
    )
        .then((value) {
      setState(() {
        constructs = value;
        initialized = true;
        error = null;
      });
    }).onError((error, stackTrace) {
      ErrorHandler.logError(e: error, s: stackTrace);
      setState(() {
        constructs = [];
        initialized = true;
        error = error?.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return error != null
        ? Center(
            child: Text(error!),
          )
        : Column(
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              ConstructListView(
                constructs: constructs.where((element) {
                  debugPrint("element type is ${element.content.type}");
                  return element.content.lemma !=
                          "Try interactive translation" &&
                      element.content.lemma != "itStart" &&
                      element.content.lemma !=
                          MatchRuleIds.interactiveTranslation;
                }).toList(),
                init: initialized,
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
class ConstructListView extends StatelessWidget {
  final List<ConstructEvent> constructs;
  final bool init;

  const ConstructListView({
    Key? key,
    required this.constructs,
    required this.init,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!init) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (constructs.isEmpty) {
      return Expanded(
        child: Center(child: Text(L10n.of(context)!.noDataFound)),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: constructs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(constructs[index].content.lemma),
            subtitle: Text(
              '${L10n.of(context)!.total} ${constructs[index].content.uses.length}',
            ),
          );
        },
      ),
    );
  }
}
