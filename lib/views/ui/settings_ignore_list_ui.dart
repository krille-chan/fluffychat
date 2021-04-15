import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/avatar.dart';
import 'package:fluffychat/views/widgets/max_width_body.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../widgets/matrix.dart';

class SettingsIgnoreList extends StatefulWidget {
  final String initialUserId;

  SettingsIgnoreList({Key key, this.initialUserId}) : super(key: key);

  @override
  _SettingsIgnoreListState createState() => _SettingsIgnoreListState();
}

class _SettingsIgnoreListState extends State<SettingsIgnoreList> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialUserId != null) {
      _controller.text = widget.initialUserId.replaceAll('@', '');
    }
  }

  void _ignoreUser(BuildContext context) {
    if (_controller.text.isEmpty) return;
    final userId = '@${_controller.text}';

    showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.ignoreUser(userId),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).ignoredUsers),
      ),
      body: MaxWidthBody(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _ignoreUser(context),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'bad_guy:domain.abc',
                      prefixText: '@',
                      labelText: L10n.of(context).ignoreUsername,
                      suffixIcon: IconButton(
                        tooltip: L10n.of(context).ignore,
                        icon: Icon(Icons.done_outlined),
                        onPressed: () => _ignoreUser(context),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    L10n.of(context).ignoreListDescription,
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: StreamBuilder<Object>(
                  stream: client.onAccountData.stream
                      .where((a) => a.type == 'm.ignored_user_list'),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: client.ignoredUsers.length,
                      itemBuilder: (c, i) => FutureBuilder<Profile>(
                        future:
                            client.getProfileFromUserId(client.ignoredUsers[i]),
                        builder: (c, s) => ListTile(
                          leading: Avatar(
                            s.data?.avatarUrl ?? Uri.parse(''),
                            s.data?.displayname ?? client.ignoredUsers[i],
                          ),
                          title: Text(
                              s.data?.displayname ?? client.ignoredUsers[i]),
                          trailing: IconButton(
                            tooltip: L10n.of(context).delete,
                            icon: Icon(Icons.delete_forever_outlined),
                            onPressed: () => showFutureLoadingDialog(
                              context: context,
                              future: () =>
                                  client.unignoreUser(client.ignoredUsers[i]),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
