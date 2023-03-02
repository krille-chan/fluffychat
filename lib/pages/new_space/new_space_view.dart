import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'new_space.dart';

class NewSpaceView extends StatelessWidget {
  final NewSpaceController controller;

  const NewSpaceView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.createNewSpace),
      ),
      body: MaxWidthBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: controller.controller,
                autofocus: true,
                autocorrect: false,
                textInputAction: TextInputAction.go,
                onSubmitted: controller.submitAction,
                decoration: InputDecoration(
                  labelText: L10n.of(context)!.spaceName,
                  prefixIcon: const Icon(Icons.people_outlined),
                  hintText: L10n.of(context)!.enterASpacepName,
                ),
              ),
            ),
            SwitchListTile.adaptive(
              title: Text(L10n.of(context)!.spaceIsPublic),
              value: controller.publicGroup,
              onChanged: controller.setPublicGroup,
            ),
            ListTile(
              trailing: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.info_outlined),
              ),
              subtitle: Text(L10n.of(context)!.newSpaceDescription),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.submitAction,
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
