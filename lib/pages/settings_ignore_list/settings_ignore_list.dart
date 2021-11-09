import 'package:flutter/material.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';

import '../../widgets/matrix.dart';
import 'settings_ignore_list_view.dart';

class SettingsIgnoreList extends StatefulWidget {
  final String initialUserId;

  const SettingsIgnoreList({Key key, this.initialUserId}) : super(key: key);

  @override
  SettingsIgnoreListController createState() => SettingsIgnoreListController();
}

class SettingsIgnoreListController extends State<SettingsIgnoreList> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialUserId != null) {
      controller.text = widget.initialUserId.replaceAll('@', '');
    }
  }

  void ignoreUser(BuildContext context) {
    if (controller.text.isEmpty) return;
    final userId = '@${controller.text}';

    showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.ignoreUser(userId),
    );
    controller.clear();
  }

  @override
  Widget build(BuildContext context) => SettingsIgnoreListView(this);
}
