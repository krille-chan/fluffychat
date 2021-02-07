import 'dart:async';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/default_app_bar_search_field.dart';
import 'package:fluffychat/components/list_items/contact_list_tile.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:flutter/material.dart';
import '../../app_config.dart';
import '../../utils/client_presence_extension.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ContactList extends StatefulWidget {
  final Stream onAppBarButtonTap;

  const ContactList({Key key, this.onAppBarButtonTap}) : super(key: key);
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  StreamSubscription _onAppBarButtonTapSub;
  StreamSubscription _onSync;
  final GlobalKey<DefaultAppBarSearchFieldState> _searchField = GlobalKey();

  @override
  void initState() {
    _onAppBarButtonTapSub =
        widget.onAppBarButtonTap.where((i) => i == 0).listen((_) async {
      await _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      );
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _searchField.currentState.requestFocus(),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _onSync?.cancel();
    _onAppBarButtonTapSub?.cancel();
    super.dispose();
  }

  DateTime _lastSetState = DateTime.now();
  Timer _coolDown;

  void _updateView() {
    _lastSetState = DateTime.now();
    setState(() => null);
  }

  @override
  Widget build(BuildContext context) {
    _onSync ??= Matrix.of(context).client.onSync.stream.listen((_) {
      if (DateTime.now().millisecondsSinceEpoch -
              _lastSetState.millisecondsSinceEpoch <
          1000) {
        _coolDown?.cancel();
        _coolDown = Timer(Duration(seconds: 1), _updateView);
      } else {
        _updateView();
      }
    });
    return ListView(
      controller: _scrollController,
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: DefaultAppBarSearchField(
            key: _searchField,
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
          title: Text(L10n.of(context).addNewContact),
          onTap: () =>
              AdaptivePageLayout.of(context).pushNamed('/newprivatechat'),
        ),
        Divider(height: 1),
        Builder(builder: (context) {
          final contactList = Matrix.of(context)
              .client
              .contactList
              .where((p) =>
                  p.senderId.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();
          if (contactList.isEmpty) {
            return Column(
              children: [
                SizedBox(height: 32),
                Icon(
                  Icons.people_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                RaisedButton(
                  elevation: 7,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.share_outlined, color: Colors.white),
                      SizedBox(width: 16),
                      Text(
                        L10n.of(context).inviteContact,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => FluffyShare.share(
                      L10n.of(context).inviteText(
                          Matrix.of(context).client.userID,
                          'https://matrix.to/#/${Matrix.of(context).client.userID}'),
                      context),
                ),
              ],
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
      ],
    );
  }
}
