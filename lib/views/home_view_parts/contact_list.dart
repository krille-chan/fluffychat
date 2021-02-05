import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/default_app_bar_search_field.dart';
import 'package:fluffychat/components/list_items/contact_list_tile.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import '../../utils/client_presence_extension.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: EdgeInsets.all(12),
        child: DefaultAppBarSearchField(
          hintText: L10n.of(context).search,
          prefixIcon: Icon(Icons.search_outlined),
          onChanged: (t) => setState(() => _searchQuery = t),
          padding: EdgeInsets.zero,
        ),
      ),
      ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: Icon(Icons.add_outlined),
          radius: Avatar.defaultSize / 2,
        ),
        title: Text('Add new contact'),
        onTap: () =>
            AdaptivePageLayout.of(context).pushNamed('/newprivatechat'),
      ),
      Divider(height: 1),
      StreamBuilder<Object>(
          stream: Matrix.of(context).client.onSync.stream,
          builder: (context, snapshot) {
            final contactList = Matrix.of(context)
                .client
                .contactList
                .where((p) => p.senderId
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();
            if (contactList.isEmpty) {
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text(
                  'No contacts found...',
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 24),
              itemCount: contactList.length,
              itemBuilder: (context, i) =>
                  ContactListTile(contact: contactList[i]),
            );
          }),
    ]);
  }
}
