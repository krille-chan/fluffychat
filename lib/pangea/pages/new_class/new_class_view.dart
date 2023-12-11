import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/constants/class_default_values.dart';
import 'package:fluffychat/pangea/pages/new_class/new_class.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import '../../widgets/space/class_settings.dart';
import '../class_settings/p_class_widgets/room_rules_editor.dart';

class NewSpaceView extends StatelessWidget {
  // #Pangea
  // final NewSpaceController controller;
  final NewClassController controller;
  // Pangea#

  const NewSpaceView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // #Pangea
        centerTitle: true,
        // Pangea#
        title: Text(L10n.of(context)!.createNewClass),
      ),
      body: MaxWidthBody(
        // #Pangea
        child: ListView(
          // child: Column(
          // mainAxisSize: MainAxisSize.min,
          // #Pangea
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                // #Pangea
                maxLength: ClassDefaultValues.maxClassName,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                // #Pangea
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
            // #Pangea
            ClassSettings(
              key: controller.classSettingsKey,
              roomId: null,
              startOpen: true,
            ),
            RoomRulesEditor(
              key: controller.rulesEditorKey,
              roomId: null,
            ),
            const SizedBox(height: 45),
            // SwitchListTile.adaptive(
            //   title: Text(L10n.of(context)!.spaceIsPublic),
            //   value: controller.publicGroup,
            //   onChanged: controller.setPublicGroup,
            // ),
            // ListTile(
            //   trailing: const Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.0),
            //     child: Icon(Icons.info_outlined),
            //   ),
            //   subtitle: Text(L10n.of(context)!.newSpaceDescription),
            // ),
            // #Pangea
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
