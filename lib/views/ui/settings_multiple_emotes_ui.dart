import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class MultipleEmotesSettings extends StatelessWidget {
  final String roomId;

  MultipleEmotesSettings(this.roomId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(roomId);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).emotePacks),
      ),
      body: StreamBuilder(
        stream: room.onUpdate.stream,
        builder: (context, snapshot) {
          final packs =
              room.states['im.ponies.room_emotes'] ?? <String, Event>{};
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
                    await AdaptivePageLayout.of(context).pushNamed(
                      '/settings/emotes',
                      arguments: {
                        'room': room,
                        'stateKey': keys[i],
                      },
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
