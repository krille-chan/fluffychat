part of "pangea_room_extension.dart";

extension EventsRoomExtension on Room {
  Future<bool> _leaveIfFull() async {
    if (!isRoomAdmin &&
        (_capacity != null) &&
        (await _numNonAdmins) > (_capacity!)) {
      if (!isSpace) {
        markUnread(false);
      }
      await leave();
      return true;
    }
    return false;
  }

  Future<void> _archive() async {
    final students = (await requestParticipants())
        .where(
          (e) =>
              e.id != client.userID &&
              e.powerLevel < ClassDefaultValues.powerLevelOfAdmin &&
              e.id != BotName.byEnvironment,
        )
        .toList();
    try {
      for (final student in students) {
        await kick(student.id);
      }
      if (!isSpace && membership == Membership.join && isUnread) {
        await markUnread(false);
      }
      await leave();
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s, data: toJson());
    }
  }

  Future<bool> _archiveSpace(
    BuildContext context,
    Client client, {
    bool onlyAdmin = false,
  }) async {
    final confirmed = await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.areYouSure,
          okLabel: L10n.of(context)!.yes,
          cancelLabel: L10n.of(context)!.cancel,
          message: onlyAdmin
              ? L10n.of(context)!.onlyAdminDescription
              : L10n.of(context)!.archiveSpaceDescription,
        ) ==
        OkCancelResult.ok;
    if (!confirmed) return false;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () async {
        final List<Room> children = await getChildRooms();
        for (final Room child in children) {
          if (!child.isAnalyticsRoom && !child.isArchived) {
            if (child.membership != Membership.join) {
              child.join;
            }
            if (child.isSpace) {
              await child.archiveSubspace();
            } else {
              await child.archive();
            }
          }
        }
        await _archive();
      },
    );
    MatrixState.pangeaController.classController
        .setActiveSpaceIdInChatListController(
      null,
    );
    return success.error == null;
  }

  Future<void> _archiveSubspace() async {
    final List<Room> children = await getChildRooms();
    for (final Room child in children) {
      if (!child.isAnalyticsRoom && !child.isArchived) {
        if (child.membership != Membership.join) {
          child.join;
        }
        if (child.isSpace) {
          await child.archiveSubspace();
        } else {
          await child.archive();
        }
      }
    }
    await _archive();
  }

  Future<bool> _leaveSpace(BuildContext context, Client client) async {
    final confirmed = await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.areYouSure,
          okLabel: L10n.of(context)!.yes,
          cancelLabel: L10n.of(context)!.cancel,
          message: L10n.of(context)!.leaveSpaceDescription,
        ) ==
        OkCancelResult.ok;
    if (!confirmed) return false;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () async {
        try {
          final List<Room> children = await getChildRooms();
          for (final Room child in children) {
            if (!child.isAnalyticsRoom && !child.isArchived) {
              if (!child.isSpace &&
                  child.membership == Membership.join &&
                  child.isUnread) {
                await child.markUnread(false);
              }
              if (child.isSpace) {
                await child.leaveSubspace();
              } else {
                await child.leave();
              }
            }
          }
          await leave();
        } catch (err, stack) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(e: err, s: stack, data: powerLevels);
          rethrow;
        }
      },
    );
    MatrixState.pangeaController.classController
        .setActiveSpaceIdInChatListController(
      null,
    );
    return success.error == null;
  }

  Future<void> _leaveSubspace() async {
    final List<Room> children = await getChildRooms();
    for (final Room child in children) {
      if (!child.isAnalyticsRoom && !child.isArchived) {
        if (!child.isSpace &&
            child.membership == Membership.join &&
            child.isUnread) {
          await child.markUnread(false);
        }
        if (child.isSpace) {
          await child.leaveSubspace();
        } else {
          await child.leave();
        }
      }
    }
    await leave();
  }

  Future<Event?> _sendPangeaEvent({
    required Map<String, dynamic> content,
    required String parentEventId,
    required String type,
  }) async {
    try {
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
      final Timeline timeline = this.timeline ?? await getTimeline();

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
              useType: pMsgEvent.msgUseType,
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

  // ConstructEvent? _vocabEventLocal(String lemma) {
  //   if (!isAnalyticsRoom) throw Exception("not an analytics room");

  //   final Event? matrixEvent = getState(PangeaEventTypes.vocab, lemma);

  //   return matrixEvent != null ? ConstructEvent(event: matrixEvent) : null;
  // }

  // Future<ConstructEvent> _vocabEvent(
  //   String lemma,
  //   ConstructType type, [
  //   bool makeIfNull = false,
  // ]) async {
  //   try {
  //     if (!isAnalyticsRoom) throw Exception("not an analytics room");

  //     ConstructEvent? localEvent = _vocabEventLocal(lemma);

  //     if (localEvent != null) return localEvent;

  //     await postLoad();
  //     localEvent = _vocabEventLocal(lemma);

  //     if (localEvent == null && isRoomOwner && makeIfNull) {
  //       final Event matrixEvent = await _createVocabEvent(lemma, type);
  //       localEvent = ConstructEvent(event: matrixEvent);
  //     }

  //     return localEvent!;
  //   } catch (err) {
  //     debugger(when: kDebugMode);
  //     rethrow;
  //   }
  // }

  // Future<Event> _createVocabEvent(String lemma, ConstructType type) async {
  //   try {
  //     if (!isRoomOwner) {
  //       throw Exception(
  //         "Tried to create vocab event in room where user is not owner",
  //       );
  //     }
  //     final String eventId = await client.setRoomStateWithKey(
  //       id,
  //       PangeaEventTypes.vocab,
  //       lemma,
  //       ConstructUses(lemma: lemma, type: type).toJson(),
  //     );
  //     final Event? event = await getEventById(eventId);

  //     if (event == null) {
  //       debugger(when: kDebugMode);
  //       throw Exception(
  //         "null event after creation with eventId $eventId in _createVocabEvent",
  //       );
  //     }
  //     return event;
  //   } catch (err, stack) {
  //     debugger(when: kDebugMode);
  //     ErrorHandler.logError(e: err, s: stack, data: powerLevels);
  //     rethrow;
  //   }
  // }

  // fetch event of a certain type by a certain sender
  // since a certain time or up to a certain amount
  Future<List<Event>> getEventsBySender({
    required String type,
    required String sender,
    DateTime? since,
    int? count,
  }) async {
    try {
      int numberOfSearches = 0;
      final Timeline timeline = this.timeline ?? await getTimeline();

      List<Event> relevantEvents() => timeline.events
          .where((event) => event.senderId == sender && event.type == type)
          .toList();

      bool reachedEnd() {
        if (since != null) {
          return relevantEvents().any(
            (event) => event.originServerTs.isBefore(since),
          );
        }
        if (count != null) {
          return relevantEvents().length >= count;
        }
        return false;
      }

      while (timeline.canRequestHistory &&
          !reachedEnd() &&
          numberOfSearches < 10) {
        await timeline.requestHistory(historyCount: 100);
        numberOfSearches += 1;
        if (reachedEnd()) {
          break;
        }
      }

      final List<Event> fetchedEvents = timeline.events
          .where((event) => event.senderId == sender && event.type == type)
          .toList();

      if (since != null) {
        fetchedEvents.removeWhere(
          (event) => event.originServerTs.isBefore(since),
        );
      }

      final List<Event> events = [];
      for (Event event in fetchedEvents) {
        if (event.relationshipType == RelationshipTypes.edit) continue;
        if (event.hasAggregatedEvents(timeline, RelationshipTypes.edit)) {
          event = event.getDisplayEvent(timeline);
        }
        events.add(event);
      }

      return events;
    } catch (err, s) {
      if (kDebugMode) rethrow;
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: s);
      return [];
    }
  }
}
