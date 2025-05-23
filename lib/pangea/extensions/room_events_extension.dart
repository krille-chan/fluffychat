part of "pangea_room_extension.dart";

extension EventsRoomExtension on Room {
  Future<void> leaveSpace() async {
    if (!isSpace) {
      debugPrint("room is not a space!");
      return;
    }

    for (final child in spaceChildren) {
      if (child.roomId == null) continue;
      final Room? room = client.getRoomById(child.roomId!);
      if (room == null || room.isAnalyticsRoom) continue;
      try {
        await room.leave();
      } catch (e, s) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            'roomID': room.id,
          },
        );
      }
    }

    try {
      await leave();
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'roomID': id,
        },
      );
    }
  }

  Future<Event?> sendPangeaEvent({
    required Map<String, dynamic> content,
    required String parentEventId,
    required String type,
  }) async {
    try {
      Sentry.addBreadcrumb(Breadcrumb(data: content));
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

  Map<String, dynamic> _getEventContent(
    Map<String, dynamic> content,
    Event? inReplyTo,
    String? editEventId,
  ) {
    final html = markdown(
      content['body'],
      getEmotePacks: () => getImagePacksFlat(ImagePackUsage.emoticon),
      getMention: getMention,
    );
    // if the decoded html is the same as the body, there is no need in sending a formatted message
    if (HtmlUnescape().convert(html.replaceAll(RegExp(r'<br />\n?'), '\n')) !=
        content['body']) {
      content['format'] = 'org.matrix.custom.html';
      content['formatted_body'] = html;
    }

    if (inReplyTo != null) {
      var replyText = '<${inReplyTo.senderId}> ${inReplyTo.body}';
      replyText = replyText.split('\n').map((line) => '> $line').join('\n');
      content['format'] = 'org.matrix.custom.html';
      // be sure that we strip any previous reply fallbacks
      final replyHtml = (inReplyTo.formattedText.isNotEmpty
              ? inReplyTo.formattedText
              : htmlEscape.convert(inReplyTo.body).replaceAll('\n', '<br>'))
          .replaceAll(
        RegExp(
          r'<mx-reply>.*</mx-reply>',
          caseSensitive: false,
          multiLine: false,
          dotAll: true,
        ),
        '',
      );
      final repliedHtml = content.tryGet<String>('formatted_body') ??
          htmlEscape
              .convert(content.tryGet<String>('body') ?? '')
              .replaceAll('\n', '<br>');
      content['formatted_body'] =
          '<mx-reply><blockquote><a href="https://matrix.to/#/${inReplyTo.roomId!}/${inReplyTo.eventId}">In reply to</a> <a href="https://matrix.to/#/${inReplyTo.senderId}">${inReplyTo.senderId}</a><br>$replyHtml</blockquote></mx-reply>$repliedHtml';
      // We escape all @room-mentions here to prevent accidental room pings when an admin
      // replies to a message containing that!
      content['body'] =
          '${replyText.replaceAll('@room', '@\u200broom')}\n\n${content.tryGet<String>('body') ?? ''}';
      content['m.relates_to'] = {
        'm.in_reply_to': {
          'event_id': inReplyTo.eventId,
        },
      };
    }

    if (editEventId != null) {
      final newContent = content.copy();
      content['m.new_content'] = newContent;
      content['m.relates_to'] = {
        'event_id': editEventId,
        'rel_type': RelationshipTypes.edit,
      };
      if (content['body'] is String) {
        content['body'] = '* ${content['body']}';
      }
      if (content['formatted_body'] is String) {
        content['formatted_body'] = '* ${content['formatted_body']}';
      }
    }

    return content;
  }

  String sendFakeMessage({
    required String text,
    Event? inReplyTo,
    String? editEventId,
  }) {
    // Create new transaction id
    final messageID = client.generateUniqueTransactionId();

    final baseContent = <String, dynamic>{
      'msgtype': MessageTypes.Text,
      'body': text,
    };

    final content = _getEventContent(baseContent, inReplyTo, editEventId);
    final Event event = Event(
      content: content,
      type: EventTypes.Message,
      senderId: client.userID!,
      eventId: messageID,
      room: this,
      originServerTs: DateTime.now(),
      status: EventStatus.sending,
    );

    timeline?.events.insert(0, event);
    return messageID;
  }

  Future<String?> pangeaSendTextEvent(
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
    String? messageTag,
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
    };
    if (choreo != null) {
      event[ModelKey.choreoRecord] = choreo.toJson();
    }
    if (originalSent != null) {
      event[ModelKey.originalSent] = originalSent.toJson();
    }
    if (originalWritten != null) {
      event[ModelKey.originalWritten] = originalWritten.toJson();
    }
    if (tokensSent != null) {
      event[ModelKey.tokensSent] = tokensSent.toJson();
    }
    if (tokensWritten != null) {
      event[ModelKey.tokensWritten] = tokensWritten.toJson();
    }
    if (messageTag != null) {
      event[ModelKey.messageTags] = messageTag;
    }

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

    final fullBody = _getEventContent(Map.from(event), inReplyTo, editEventId);
    final jsonString = jsonEncode(fullBody);
    final jsonSizeInBytes = utf8.encode(jsonString).length;
    const maxBodySize = 60000;
    if (jsonSizeInBytes > maxBodySize) {
      return Future.error(EventTooLarge(maxBodySize, jsonSizeInBytes));
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

  Future<void> sendActivityPlan(
    ActivityPlanModel activity, {
    Uint8List? avatar,
    String? avatarURL,
    String? filename,
  }) async {
    BookmarkedActivitiesRepo.save(activity);
    Uint8List? bytes = avatar;
    if (avatarURL != null && bytes == null) {
      try {
        final resp = await http
            .get(Uri.parse(avatarURL))
            .timeout(const Duration(seconds: 5));
        bytes = resp.bodyBytes;
      } catch (e, s) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            "avatarURL": avatarURL,
          },
        );
      }
    }

    MatrixFile? file;
    if (filename != null && bytes != null) {
      file = MatrixFile(
        bytes: bytes,
        name: filename,
      );
    }
    final eventId = await pangeaSendTextEvent(
      activity.markdown,
      messageTag: ModelKey.messageTagActivityPlan,
    );

    if (file != null) {
      await sendFileEvent(
        file,
        shrinkImageMaxDimension: 1600,
        extraContent: {
          ModelKey.messageTags: ModelKey.messageTagActivityPlan,
        },
      );
    }

    if (canSendDefaultStates) {
      await client.setRoomStateWithKey(
        id,
        PangeaEventTypes.activityPlan,
        "",
        activity.toJson(),
      );

      if (eventId != null) {
        await setPinnedEvents([eventId]);
      }
    }
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
