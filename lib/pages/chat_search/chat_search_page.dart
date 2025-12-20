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

  final List<Event> messages = [];
  final List<Event> images = [];
  final List<Event> files = [];
  String? messagesNextBatch, imagesNextBatch, filesNextBatch;
  bool messagesEndReached = false;
  bool imagesEndReached = false;
  bool filesEndReached = false;
  bool isLoading = false;
  DateTime? searchedUntil;

  void restartSearch() {
    setState(() {
      messages.clear();
      images.clear();
      files.clear();
      messagesNextBatch = imagesNextBatch = filesNextBatch = searchedUntil =
          null;
      messagesEndReached = imagesEndReached = filesEndReached = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startSearch();
    });
  }

  void startSearch() async {
    switch (tabController.index) {
      case 0:
        final searchQuery = searchController.text.trim();
        if (searchQuery.isEmpty) return;
        setState(() {
          isLoading = true;
        });
        final result = await room!.searchEvents(
          searchTerm: searchController.text.trim(),
          nextBatch: messagesNextBatch,
        );
        setState(() {
          isLoading = false;
          messages.addAll(result.events);
          messagesNextBatch = result.nextBatch;
          messagesEndReached = result.nextBatch == null;
          searchedUntil = result.searchedUntil;
        });
        return;
      case 1:
        setState(() {
          isLoading = true;
        });
        final result = await room!.searchEvents(
          searchFunc: (event) => {
            MessageTypes.Image,
            MessageTypes.Video,
          }.contains(event.messageType),
          nextBatch: imagesNextBatch,
        );
        setState(() {
          isLoading = false;
          images.addAll(result.events);
          imagesNextBatch = result.nextBatch;
          imagesEndReached = result.nextBatch == null;
          searchedUntil = result.searchedUntil;
        });
        return;
      case 2:
        setState(() {
          isLoading = true;
        });
        final result = await room!.searchEvents(
          searchFunc: (event) =>
              event.messageType == MessageTypes.File ||
              (event.messageType == MessageTypes.Audio &&
                  !event.content.containsKey('org.matrix.msc3245.voice')),
          nextBatch: filesNextBatch,
        );
        setState(() {
          isLoading = false;
          files.addAll(result.events);
          filesNextBatch = result.nextBatch;
          filesEndReached = result.nextBatch == null;
          searchedUntil = result.searchedUntil;
        });
        return;
      default:
        return;
    }
  }

  void _onTabChanged() {
    switch (tabController.index) {
      case 1:
      case 2:
        startSearch();
        break;
      case 0:
      default:
        restartSearch();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    tabController.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChatSearchView(this);
}
