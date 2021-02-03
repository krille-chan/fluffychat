import 'package:fluffychat/components/list_items/status_list_tile.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class StatusList extends StatefulWidget {
  const StatusList({Key key}) : super(key: key);
  @override
  _StatusListState createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  bool _onlyContacts = false;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            elevation: _onlyContacts ? 7 : null,
            color: !_onlyContacts ? null : Theme.of(context).primaryColor,
            child: Text(
              L10n.of(context).contacts,
              style: TextStyle(color: _onlyContacts ? Colors.white : null),
            ),
            onPressed: () => setState(() => _onlyContacts = true),
          ),
          RaisedButton(
            elevation: !_onlyContacts ? 7 : null,
            color: _onlyContacts ? null : Theme.of(context).primaryColor,
            child: Text(
              L10n.of(context).all,
              style: TextStyle(color: !_onlyContacts ? Colors.white : null),
            ),
            onPressed: () => setState(() => _onlyContacts = false),
          ),
        ],
      ),
      Divider(height: 1),
      StreamBuilder<Object>(
          stream: Matrix.of(context)
              .client
              .onAccountData
              .stream
              .where((a) => a.type == Status.namespace),
          builder: (context, snapshot) {
            final statuses = Matrix.of(context).statuses.values.toList()
              ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
            if (_onlyContacts) {
              final client = Matrix.of(context).client;
              statuses.removeWhere(
                  (p) => client.getDirectChatFromUserId(p.senderId) == null);
            }
            if (statuses.isEmpty) {
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text(
                  L10n.of(context).noStatusesFound,
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 24),
              separatorBuilder: (_, __) => Divider(height: 1),
              itemCount: statuses.length,
              itemBuilder: (context, i) => StatusListTile(status: statuses[i]),
            );
          }),
    ]);
  }
}
