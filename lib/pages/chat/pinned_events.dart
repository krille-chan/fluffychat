import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_content.dart';

class PinnedEvents extends StatelessWidget {
  final ChatController controller;

  const PinnedEvents(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pinnedEventIds = controller.room!.pinnedEventIds;

    if (pinnedEventIds.isEmpty) {
      return Container();
    }
    final completers = pinnedEventIds.map<Completer<Event?>>((e) {
      final completer = Completer<Event?>();
      controller.room!
          .getEventById(e)
          .then((value) => completer.complete(value));
      return completer;
    });
    return FutureBuilder<List<Event?>>(
        future: Future.wait(completers.map((e) => e.future).toList()),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty &&
              snapshot.data!.first != null) {
            return Material(
              color: Theme.of(context).secondaryHeaderColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 96,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemBuilder: (c, i) {
                    final event = snapshot.data![i]!;
                    return ListTile(
                      tileColor: Colors.transparent,
                      onTap: () => controller.scrollToEventId(event.eventId),
                      leading: IconButton(
                        icon: const Icon(Icons.push_pin_outlined),
                        tooltip: L10n.of(context)!.unpin,
                        onPressed: () => controller.unpinEvent(event.eventId),
                      ),
                      title: MessageContent(
                        snapshot.data![i]!,
                        textColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            Logs().e('Error loading pinned events.', snapshot.error);
            return ListTile(
                tileColor: Theme.of(context).secondaryHeaderColor,
                title: Text(L10n.of(context)!.pinnedEventsError));
          } else {
            return ListTile(
              tileColor: Theme.of(context).secondaryHeaderColor,
              title: const Center(
                child: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }
}
