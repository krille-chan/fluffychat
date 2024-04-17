import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_search/chat_search_view.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ChatSearchPage extends StatefulWidget {
  final String roomId;
  const ChatSearchPage({required this.roomId, super.key});

  @override
  ChatSearchController createState() => ChatSearchController();
}

class ChatSearchController extends State<ChatSearchPage>
    with SingleTickerProviderStateMixin {
  Room? get room => Matrix.of(context).client.getRoomById(widget.roomId);

  final TextEditingController searchController = TextEditingController();
  late final TabController tabController;

  Timeline? timeline;

  Stream<(List<Event>, String?)>? searchStream;

  void restartSearch() {
    if (tabController.index == 0 && searchController.text.isEmpty) {
      setState(() {
        searchStream = null;
      });
      return;
    }
    setState(() {
      searchStream = const Stream.empty();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startSearch();
    });
  }

  void startSearch({
    String? prevBatch,
    List<Event>? previousSearchResult,
  }) async {
    final timeline = this.timeline ??= await room!.getTimeline();

    if (tabController.index == 0 && searchController.text.isEmpty) {
      return;
    }

    setState(() {
      searchStream = timeline
          .startSearch(
            searchTerm: tabController.index == 0 ? searchController.text : null,
            searchFunc: switch (tabController.index) {
              1 => (event) => event.messageType == MessageTypes.Image,
              2 => (event) => event.messageType == MessageTypes.File,
              int() => null,
            },
            prevBatch: prevBatch,
            requestHistoryCount: 1000,
            limit: 32,
          )
          .map(
            (result) => (
              [
                if (previousSearchResult != null) ...previousSearchResult,
                ...result.$1,
              ],
              result.$2,
            ),
          )
          .asBroadcastStream();
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    tabController.addListener(restartSearch);
  }

  @override
  void dispose() {
    tabController.removeListener(restartSearch);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChatSearchView(this);
}
