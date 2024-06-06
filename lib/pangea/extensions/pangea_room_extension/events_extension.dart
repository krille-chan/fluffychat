part of "pangea_room_extension.dart";

extension EventsRoomExtension on Room {
  Future<bool> _leaveIfFull() async {
    await postLoad();
    if (!isRoomAdmin &&
        (_capacity != null) &&
        (await _numNonAdmins) >= (int.parse(_capacity!))) {
      if (!isSpace) {
        markUnread(false);
      }
      await leave();
      return true;
    }
    return false;
  }

  Future<Event?> _sendPangeaEvent({
    required Map<String, dynamic> content,
    required String parentEventId,
    required String type,
  }) async {
    try {
      debugPrint("creating $type child for $parentEventId");
      Sentry.addBreadcrumb(Breadcrumb.fromJson(content));
      if (parentEventId.contains("web")) {
        debugger(when: kDebugMode);
        Sentry.addBreadcrumb(
          Breadcrumb(
            message:
                "sendPangeaEvent with likely invalid parentEventId $parentEventId",
          ),
        );
      }
      final Map<String, dynamic> repContent = {
        // what is the functionality of m.reference?
        "m.relates_to": {"rel_type": type, "event_id": parentEventId},
        type: content,
      };

      final String? newEventId = await sendEvent(repContent, type: type);

      if (newEventId == null) {
        debugger(when: kDebugMode);
        return null;
      }

      //PTODO - handle the frequent case of a null newEventId
      final Event? newEvent = await getEventById(newEventId);

      if (newEvent == null) {
        debugger(when: kDebugMode);
      }

      return newEvent;
    } catch (err, stack) {
      // debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "type": type,
          "parentEventId": parentEventId,
          "content": content,
        },
      );
      return null;
    }
  }

  Future<String?> _pangeaSendTextEvent(
    String message, {
    String? txid,
    Event? inReplyTo,
    String? editEventId,
    bool parseMarkdown = true,
    bool parseCommands = false,
    String msgtype = MessageTypes.Text,
    String? threadRootEventId,
    String? threadLastEventId,
    PangeaRepresentation? originalSent,
    PangeaRepresentation? originalWritten,
    PangeaMessageTokens? tokensSent,
    PangeaMessageTokens? tokensWritten,
    ChoreoRecord? choreo,
    UseType? useType,
  }) {
    // if (parseCommands) {
    //   return client.parseAndRunCommand(this, message,
    //       inReplyTo: inReplyTo,
    //       editEventId: editEventId,
    //       txid: txid,
    //       threadRootEventId: threadRootEventId,
    //       threadLastEventId: threadLastEventId);
    // }
    final event = <String, dynamic>{
      'msgtype': msgtype,
      'body': message,
      ModelKey.choreoRecord: choreo?.toJson(),
      ModelKey.originalSent: originalSent?.toJson(),
      ModelKey.originalWritten: originalWritten?.toJson(),
      ModelKey.tokensSent: tokensSent?.toJson(),
      ModelKey.tokensWritten: tokensWritten?.toJson(),
      ModelKey.useType: useType?.string,
    };
    if (parseMarkdown) {
      final html = markdown(
        event['body'],
        getEmotePacks: () => getImagePacksFlat(ImagePackUsage.emoticon),
        getMention: getMention,
      );
      // if the decoded html is the same as the body, there is no need in sending a formatted message
      if (HtmlUnescape().convert(html.replaceAll(RegExp(r'<br />\n?'), '\n')) !=
          event['body']) {
        event['format'] = 'org.matrix.custom.html';
        event['formatted_body'] = html;
      }
    }
    return sendEvent(
      event,
      txid: txid,
      inReplyTo: inReplyTo,
      editEventId: editEventId,
      threadRootEventId: threadRootEventId,
      threadLastEventId: threadLastEventId,
    );
  }

  /// update state event and return eventId
  Future<String> _updateStateEvent(Event stateEvent) {
    if (stateEvent.stateKey == null) {
      throw Exception("stateEvent.stateKey is null");
    }
    return client.setRoomStateWithKey(
      id,
      stateEvent.type,
      stateEvent.stateKey!,
      stateEvent.content,
    );
  }

  Future<List<RecentMessageRecord>> get _messageListForAllChildChats async {
    try {
      if (!isSpace) return [];
      final List<Room> spaceChats = spaceChildren
          .where((e) => e.roomId != null)
          .map((e) => client.getRoomById(e.roomId!))
          .where((element) => element != null)
          .cast<Room>()
          .where((element) => !element.isSpace)
          .toList();

      final List<Future<List<RecentMessageRecord>>> msgListFutures = [];
      for (final chat in spaceChats) {
        msgListFutures.add(chat._messageListForChat);
      }
      final List<List<RecentMessageRecord>> msgLists =
          await Future.wait(msgListFutures);

      final List<RecentMessageRecord> joined = [];
      for (final msgList in msgLists) {
        joined.addAll(msgList);
      }
      return joined;
    } catch (err) {
      // debugger(when: kDebugMode);
      rethrow;
    }
  }

  Future<List<RecentMessageRecord>> get _messageListForChat async {
    try {
      int numberOfSearches = 0;

      if (isSpace) {
        throw Exception(
          "In messageListForChat with room that is not a chat",
        );
      }
      final Timeline timeline = await getTimeline();

      while (timeline.canRequestHistory && numberOfSearches < 50) {
        await timeline.requestHistory(historyCount: 100);
        numberOfSearches += 1;
      }
      if (timeline.canRequestHistory) {
        debugger(when: kDebugMode);
      }

      final List<RecentMessageRecord> msgs = [];
      for (final event in timeline.events) {
        if (event.senderId == client.userID &&
            event.type == EventTypes.Message &&
            event.content['msgtype'] == MessageTypes.Text) {
          final PangeaMessageEvent pMsgEvent = PangeaMessageEvent(
            event: event,
            timeline: timeline,
            ownMessage: true,
          );
          msgs.add(
            RecentMessageRecord(
              eventId: event.eventId,
              chatId: id,
              useType: pMsgEvent.useType,
              time: event.originServerTs,
            ),
          );
        }
      }
      return msgs;
    } catch (err, s) {
      if (kDebugMode) rethrow;
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
      return [];
    }
  }

  ConstructEvent? _vocabEventLocal(String lemma) {
    if (!isAnalyticsRoom) throw Exception("not an analytics room");

    final Event? matrixEvent = getState(PangeaEventTypes.vocab, lemma);

    return matrixEvent != null ? ConstructEvent(event: matrixEvent) : null;
  }

  Future<ConstructEvent> _vocabEvent(
    String lemma,
    ConstructType type, [
    bool makeIfNull = false,
  ]) async {
    try {
      if (!isAnalyticsRoom) throw Exception("not an analytics room");

      ConstructEvent? localEvent = _vocabEventLocal(lemma);

      if (localEvent != null) return localEvent;

      await postLoad();
      localEvent = _vocabEventLocal(lemma);

      if (localEvent == null && isRoomOwner && makeIfNull) {
        final Event matrixEvent = await _createVocabEvent(lemma, type);
        localEvent = ConstructEvent(event: matrixEvent);
      }

      return localEvent!;
    } catch (err) {
      debugger(when: kDebugMode);
      rethrow;
    }
  }

  Future<List<OneConstructUse>> _removeEditedLemmas(
    List<OneConstructUse> lemmaUses,
  ) async {
    final List<String> removeUses = [];
    for (final use in lemmaUses) {
      if (use.msgId == null) continue;
      final List<String> removeIds = await client.getEditHistory(
        use.chatId,
        use.msgId!,
      );
      removeUses.addAll(removeIds);
    }
    lemmaUses.removeWhere((use) => removeUses.contains(use.msgId));
    final allEvents = await allConstructEvents;
    for (final constructEvent in allEvents) {
      await constructEvent.removeEdittedUses(removeUses, client);
    }
    return lemmaUses;
  }

  Future<void> _saveConstructUsesSameLemma(
    String lemma,
    ConstructType type,
    List<OneConstructUse> lemmaUses, {
    bool isEdit = false,
  }) async {
    final ConstructEvent? localEvent = _vocabEventLocal(lemma);

    if (isEdit) {
      lemmaUses = await removeEditedLemmas(lemmaUses);
    }

    if (localEvent == null) {
      await client.setRoomStateWithKey(
        id,
        PangeaEventTypes.vocab,
        lemma,
        ConstructUses(lemma: lemma, type: type, uses: lemmaUses).toJson(),
      );
    } else {
      localEvent.addAll(lemmaUses);
      await updateStateEvent(localEvent.event);
    }
  }

  Future<List<ConstructEvent>> get _allConstructEvents async {
    await postLoad();
    return states[PangeaEventTypes.vocab]
            ?.values
            .map((Event event) => ConstructEvent(event: event))
            .toList()
            .cast<ConstructEvent>() ??
        [];
  }

  Future<Event> _createVocabEvent(String lemma, ConstructType type) async {
    try {
      if (!isRoomOwner) {
        throw Exception(
          "Tried to create vocab event in room where user is not owner",
        );
      }
      final String eventId = await client.setRoomStateWithKey(
        id,
        PangeaEventTypes.vocab,
        lemma,
        ConstructUses(lemma: lemma, type: type).toJson(),
      );
      final Event? event = await getEventById(eventId);

      if (event == null) {
        debugger(when: kDebugMode);
        throw Exception(
          "null event after creation with eventId $eventId in _createVocabEvent",
        );
      }
      return event;
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack, data: powerLevels);
      rethrow;
    }
  }
}
