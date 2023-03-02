import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pages/chat/add_widget_tile.dart';

class AddWidgetTileView extends StatelessWidget {
  final AddWidgetTileState controller;

  const AddWidgetTileView({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(L10n.of(context)!.addWidget),
      leading: const Icon(Icons.add),
      initiallyExpanded: controller.initiallyExpanded,
      children: [
        CupertinoSegmentedControl(
          groupValue: controller.widgetType,
          padding: const EdgeInsets.all(8),
          children: {
            'm.etherpad': Text(L10n.of(context)!.widgetEtherpad),
            'm.jitsi': Text(L10n.of(context)!.widgetJitsi),
            'm.video': Text(L10n.of(context)!.widgetVideo),
            'm.custom': Text(L10n.of(context)!.widgetCustom),
          }.map(
            (key, value) => MapEntry(
              key,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: value,
              ),
            ),
          ),
          onValueChanged: controller.setWidgetType,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller.nameController,
            autofocus: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.label),
              label: Text(L10n.of(context)!.widgetName),
              errorText: controller.nameError,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller.urlController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.add_link),
              label: Text(L10n.of(context)!.link),
              errorText: controller.urlError,
            ),
          ),
        ),
        ButtonBar(
          children: [
            TextButton(
              onPressed: controller.addWidget,
              child: Text(L10n.of(context)!.addWidget),
            ),
          ],
        )
      ],
    );
  }
}
