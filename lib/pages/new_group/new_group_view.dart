import 'package:fluffychat/pages/new_group/new_group.dart';
import 'package:fluffychat/pangea/widgets/class/add_class_and_invite.dart';
import 'package:fluffychat/pangea/widgets/class/add_space_toggles.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class NewGroupView extends StatelessWidget {
  final NewGroupController controller;

  const NewGroupView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.createGroup),
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
                  // #Pangea
                  labelText: L10n.of(context)!.enterAGroupName,
                  // labelText: L10n.of(context)!.optionalGroupName,
                  prefixIcon: const Icon(Icons.people_outlined),
                  // hintText: L10n.of(context)!.enterAGroupName,
                  // Pangea#
                ),
              ),
            ),
            // #Pangea
            // SwitchListTile.adaptive(
            //   secondary: const Icon(Icons.public_outlined),
            //   title: Text(L10n.of(context)!.groupIsPublic),
            //   value: controller.publicGroup,
            //   onChanged: controller.setPublicGroup,
            // ),
            // SwitchListTile.adaptive(
            //   secondary: const Icon(Icons.lock_outlined),
            //   title: Text(L10n.of(context)!.enableEncryption),
            //   value: !controller.publicGroup,
            //   onChanged: null,
            // ),
            AddToSpaceToggles(
              key: controller.addToSpaceKey,
              startOpen: false,
              activeSpaceId: controller.activeSpaceId,
              mode: AddToClassMode.chat,
            ),
            const SizedBox(
              height: 50,
            ),
            // Pangea#
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
