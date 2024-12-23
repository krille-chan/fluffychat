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
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
          message: onlyAdmin
              ? L10n.of(context).onlyAdminDescription
              : L10n.of(context).archiveSpaceDescription,
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
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
          message: L10n.of(context).leaveSpaceDescription,
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
          ErrorHandler.logError(
            e: err,
            s: stack,
            data: {
              "powerLevel": client.userID != null
                  ? getPowerLevelByUserId(client.userID!)
                  : null,
            },
          );
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

  /// Get a list of events in the room that are of type [PangeaEventTypes.construct]
  /// and have the sender as [userID]. If [count] is provided, the function will
  /// return at most [count] events.
  Future<List<Event>> getRoomAnalyticsEvents({
    String? userID,
    int? count,
  }) async {
    userID ??= client.userID;
    if (userID == null) return [];
    GetRoomEventsResponse resp = await client.getRoomEvents(
      id,
      Direction.b,
      limit: count ?? 100,
      filter: jsonEncode(
        StateFilter(
          types: [
            PangeaEventTypes.construct,
          ],
          senders: [userID],
        ),
      ),
    );

    int numSearches = 0;
    while (numSearches < 10 && resp.end != null) {
      if (count != null && resp.chunk.length <= count) break;
      final nextResp = await client.getRoomEvents(
        id,
        Direction.b,
        limit: count ?? 100,
        filter: jsonEncode(
          StateFilter(
            types: [
              PangeaEventTypes.construct,
            ],
            senders: [userID],
          ),
        ),
        from: resp.end,
      );
      nextResp.chunk.addAll(resp.chunk);
      resp = nextResp;
      numSearches += 1;
    }

    return resp.chunk.map((e) => Event.fromMatrixEvent(e, this)).toList();
  }
}
