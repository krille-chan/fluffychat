import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/pages/class_settings/p_class_widgets/room_capacity_button.dart';
import 'package:fluffychat/pangea/pages/class_settings/p_class_widgets/room_rules_editor.dart';
import 'package:fluffychat/pangea/widgets/class/add_class_and_invite.dart';
import 'package:fluffychat/pangea/widgets/class/add_space_toggles.dart';
import 'package:fluffychat/pangea/widgets/space/class_settings.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'new_space.dart';

class NewSpaceView extends StatelessWidget {
  final NewSpaceController controller;

  const NewSpaceView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    // #Pangea
    final activeColor = Theme.of(context).brightness == Brightness.dark
        ? AppConfig.primaryColorLight
        : AppConfig.primaryColor;
    // Pangea#
    final avatar = controller.avatar;
    return Scaffold(
      appBar: AppBar(
        // #Pangea
        centerTitle: true,
        title: Text(
          controller.newClassMode
              ? L10n.of(context)!.createNewClass
              : L10n.of(context)!.newExchange,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.class_outlined),
            selectedIcon: const Icon(Icons.class_),
            color: controller.newClassMode ? activeColor : null,
            isSelected: controller.newClassMode,
            onPressed: () => context.go('/rooms/newspace'),
          ),
          IconButton(
            icon: const Icon(Icons.connecting_airports),
            selectedIcon: const Icon(Icons.connecting_airports),
            color: !controller.newClassMode ? activeColor : null,
            isSelected: !controller.newClassMode,
            onPressed: () => context.go('/rooms/newspace/exchange'),
          ),
        ],
        // title: Text(L10n.of(context)!.createNewSpace),
        // Pangea#
      ),
      body: MaxWidthBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // #Pangea
            // ListTile(
            //   trailing: const Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16.0),
            //     child: Icon(Icons.info_outlined),
            //   ),
            //   subtitle: Text(L10n.of(context)!.newSpaceDescription),
            // ),
            // const SizedBox(height: 16),
            // Pangea#
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(90),
                    onTap: controller.loading ? null : controller.selectPhoto,
                    child: CircleAvatar(
                      radius: Avatar.defaultSize / 2,
                      child: avatar == null
                          ? const Icon(Icons.camera_alt_outlined)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.memory(
                                avatar,
                                width: Avatar.defaultSize,
                                height: Avatar.defaultSize,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      // #Pangea
                      maxLength: 64,
                      // Pangea#
                      controller: controller.nameController,
                      autocorrect: false,
                      readOnly: controller.loading,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.people_outlined),
                        hintText: L10n.of(context)!.spaceName,
                        // #Pangea
                        // errorText: controller.nameError,
                        // Pangea#
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // #Pangea
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: TextField(
            //     controller: controller.topicController,
            //     minLines: 4,
            //     maxLines: 4,
            //     maxLength: 255,
            //     readOnly: controller.loading,
            //     decoration: InputDecoration(
            //       hintText: L10n.of(context)!.addChatDescription,
            //       errorText: controller.topicError,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),

            RoomCapacityButton(
              key: controller.addCapacityKey,
            ),
            if (controller.newClassMode)
              ClassSettings(
                key: controller.classSettingsKey,
                roomId: null,
                startOpen: true,
                initialSettings:
                    Matrix.of(context).client.lastUpdatedClassSettings,
              ),
            if (!controller.newClassMode)
              AddToSpaceToggles(
                key: controller.addToSpaceKey,
                startOpen: true,
                mode: !controller.newClassMode
                    ? AddToClassMode.exchange
                    : AddToClassMode.chat,
              ),
            FutureBuilder<PangeaRoomRules?>(
              future: Matrix.of(context).client.lastUpdatedRoomRules,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return RoomRulesEditor(
                    key: controller.rulesEditorKey,
                    roomId: null,
                    startOpen: false,
                    initialRules: snapshot.data,
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    ),
                  );
                }
              },
            ),
            // SwitchListTile.adaptive(
            //   title: Text(L10n.of(context)!.spaceIsPublic),
            //   value: controller.publicGroup,
            //   onChanged: controller.setPublicGroup,
            // ),
            // Pangea#
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed:
                      controller.loading ? null : controller.submitAction,
                  child: controller.loading
                      ? const LinearProgressIndicator()
                      : Row(
                          children: [
                            Expanded(
                              child: Text(
                                // #Pangea
                                // L10n.of(context)!.createNewSpace,
                                controller.newClassMode
                                    ? L10n.of(context)!.createClass
                                    : L10n.of(context)!.createExchange,
                                // Pangea#
                              ),
                            ),
                            Icon(Icons.adaptive.arrow_forward_outlined),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
