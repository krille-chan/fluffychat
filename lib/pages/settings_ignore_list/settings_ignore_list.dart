import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import '../../widgets/matrix.dart';
import 'settings_ignore_list_view.dart';

class SettingsIgnoreList extends StatefulWidget {
  final String? initialUserId;

  const SettingsIgnoreList({super.key, this.initialUserId});

  @override
  SettingsIgnoreListController createState() => SettingsIgnoreListController();
}

class SettingsIgnoreListController extends State<SettingsIgnoreList> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialUserId = widget.initialUserId;
    if (initialUserId != null) {
      controller.text = initialUserId;
    }
  }

  String? errorText;

  void ignoreUser(BuildContext context) {
    final userId = controller.text.trim();
    if (userId.isEmpty) return;
    if (!userId.isValidMatrixId || userId.sigil != '@') {
      setState(() {
        errorText = L10n.of(context).invalidInput;
      });
      return;
    }
    setState(() {
      errorText = null;
    });

    showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.ignoreUser(userId),
    );
    controller.clear();
  }

  @override
  Widget build(BuildContext context) => SettingsIgnoreListView(this);
}
