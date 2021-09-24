import 'dart:math';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:fluffychat/widgets/content_banner.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';
import '../utils/localized_exception_extension.dart';

class ProfileBottomSheet extends StatelessWidget {
  final String userId;
  final BuildContext outerContext;
  const ProfileBottomSheet({
    @required this.userId,
    @required this.outerContext,
    Key key,
  }) : super(key: key);

  void _startDirectChat(BuildContext context) async {
    final result = await showFutureLoadingDialog<String>(
      context: context,
      future: () => Matrix.of(context).client.startDirectChat(userId),
    );
    if (result.error == null) {
      VRouter.of(context).toSegments(['rooms', result.result]);
      Navigator.of(context, rootNavigator: false).pop();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: min(
            MediaQuery.of(context).size.width, FluffyThemes.columnWidth * 1.5),
        child: Material(
          elevation: 4,
          child: SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                leading: IconButton(
                  icon: Icon(Icons.arrow_downward_outlined),
                  onPressed: Navigator.of(context, rootNavigator: false).pop,
                  tooltip: L10n.of(context).close,
                ),
              ),
              body: FutureBuilder<Profile>(
                  future:
                      Matrix.of(context).client.getProfileFromUserId(userId),
                  builder: (context, snapshot) {
                    final profile = snapshot.data;

                    return Column(
                      children: [
                        Expanded(
                          child: profile == null
                              ? Container(
                                  alignment: Alignment.center,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  child: snapshot.hasError
                                      ? Text(snapshot.error
                                          .toLocalizedString(context))
                                      : CircularProgressIndicator(),
                                )
                              : ContentBanner(
                                  profile.avatarUrl,
                                  defaultIcon: Icons.person_outline,
                                  client: Matrix.of(context).client,
                                ),
                        ),
                        ListTile(
                          title: Text(profile?.displayName ?? userId.localpart),
                          subtitle: Text(userId),
                          trailing: Icon(Icons.account_box_outlined),
                        ),
                        Center(
                          child: FloatingActionButton.extended(
                            onPressed: () => _startDirectChat(context),
                            label: Text(L10n.of(context).newChat),
                            icon: Icon(Icons.send_outlined),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
