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
  Stream<(List<Event>, String?)>? galleryStream;
  Stream<(List<Event>, String?)>? fileStream;

  void restartSearch() {
    if (searchController.text.isEmpty) {
      setState(() {
        searchStream = null;
      });
      return;
    }
    setState(() {
      searchStream = const Stream.empty();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startMessageSearch();
    });
  }

  void startMessageSearch({
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
            searchTerm: searchController.text,
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
          // Deduplication workaround for
          // https://github.com/famedly/matrix-dart-sdk/issues/1831
          .map(
            (result) => (
              <String, Event>{
                for (final event in result.$1) event.eventId: event,
              }.values.toList(),
              result.$2,
            ),
          )
          .asBroadcastStream();
    });
  }

  void startGallerySearch({
    String? prevBatch,
    List<Event>? previousSearchResult,
  }) async {
    final timeline = this.timeline ??= await room!.getTimeline();

    setState(() {
      galleryStream = timeline
          .startSearch(
            searchFunc: (event) => {
              MessageTypes.Image,
              MessageTypes.Video,
            }.contains(event.messageType),
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
          // Deduplication workaround for
          // https://github.com/famedly/matrix-dart-sdk/issues/1831
          .map(
            (result) => (
              <String, Event>{
                for (final event in result.$1) event.eventId: event,
              }.values.toList(),
              result.$2,
            ),
          )
          .asBroadcastStream();
    });
  }

  void startFileSearch({
    String? prevBatch,
    List<Event>? previousSearchResult,
  }) async {
    final timeline = this.timeline ??= await room!.getTimeline();

    setState(() {
      fileStream = timeline
          .startSearch(
            searchFunc: (event) =>
                event.messageType == MessageTypes.File ||
                (event.messageType == MessageTypes.Audio &&
                    !event.content.containsKey('org.matrix.msc3245.voice')),
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
          // Deduplication workaround for
          // https://github.com/famedly/matrix-dart-sdk/issues/1831
          .map(
            (result) => (
              <String, Event>{
                for (final event in result.$1) event.eventId: event,
              }.values.toList(),
              result.$2,
            ),
          )
          .asBroadcastStream();
    });
  }

  void _onTabChanged() {
    switch (tabController.index) {
      case 1:
        startGallerySearch();
        break;
      case 2:
        startFileSearch();
        break;
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
