import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'homeserver_picker.dart';

class HomeserverAppBar extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverAppBar({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: controller.homeserverFocusNode,
      controller: controller.homeserverController,
      onChanged: controller.onChanged,
      decoration: InputDecoration(
        prefixIcon: Navigator.of(context).canPop()
            ? IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        prefixText: '${L10n.of(context)!.homeserver}: ',
        hintText: L10n.of(context)!.enterYourHomeserver,
        suffixIcon: const Icon(Icons.search),
        errorText: controller.error,
      ),
      readOnly: !AppConfig.allowOtherHomeservers,
      onSubmitted: (_) => controller.checkHomeserverAction(),
      autocorrect: false,
    );
  }
}
