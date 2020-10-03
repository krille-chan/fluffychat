import 'package:flutter/material.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../components/adaptive_page_layout.dart';
import '../utils/app_route.dart';
import 'chat_list.dart';
import 'settings_emotes.dart';

class MultipleEmotesSettingsView extends StatelessWidget {
  final Room room;

  MultipleEmotesSettingsView({this.room});

  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: MultipleEmotesSettings(room: room),
    );
  }
}

class MultipleEmotesSettings extends StatelessWidget {
  final Room room;

  MultipleEmotesSettings({this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).emotePacks),
      ),
      body: StreamBuilder(
        stream: room.onUpdate.stream,
        builder: (context, snapshot) {
          final packs =
              room.states.states['im.ponies.room_emotes'] ?? <String, Event>{};
          if (!packs.containsKey('')) {
            packs[''] = null;
          }
          final keys = packs.keys.toList();
          keys.sort();
          return ListView.separated(
              separatorBuilder: (BuildContext context, int i) => Container(),
              itemCount: keys.length,
              itemBuilder: (BuildContext context, int i) {
                final event = packs[keys[i]];
                var packName = keys[i].isNotEmpty ? keys[i] : 'Default Pack';
                if (event != null && event.content['pack'] is Map) {
                  if (event.content['pack']['displayname'] is String) {
                    packName = event.content['pack']['displayname'];
                  } else if (event.content['pack']['name'] is String) {
                    packName = event.content['pack']['name'];
                  }
                }
                return ListTile(
                  title: Text(packName),
                  onTap: () async {
                    await Navigator.of(context).push(
                      AppRoute.defaultRoute(
                        context,
                        EmotesSettingsView(room: room, stateKey: keys[i]),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
