import 'package:fluffychat/pangea/pages/class_settings/p_class_widgets/room_capacity_button.dart';
import 'package:fluffychat/pangea/widgets/class/add_space_toggles.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'new_space.dart';

class NewSpaceView extends StatelessWidget {
  final NewSpaceController controller;

  const NewSpaceView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = controller.avatar;
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.createNewSpace),
      ),
      // #Pangea
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.loading ? null : controller.submitAction,
        icon: controller.loading ? null : const Icon(Icons.workspaces_outlined),
        label: controller.loading
            ? const CircularProgressIndicator.adaptive()
            : Text(L10n.of(context)!.createSpace),
      ),
      // Pangea#
      body: MaxWidthBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(90),
              onTap: controller.loading ? null : controller.selectPhoto,
              child: CircleAvatar(
                radius: Avatar.defaultSize,
                child: avatar == null
                    ? const Icon(Icons.add_a_photo_outlined)
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
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                autofocus: true,
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
            const SizedBox(height: 16),
            // #Pangea
            RoomCapacityButton(
              key: controller.addCapacityKey,
            ),
            AddToSpaceToggles(
              key: controller.addToSpaceKey,
              startOpen: true,
              spaceMode: true,
            ),
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
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed:
            //           controller.loading ? null : controller.submitAction,
            //       child: controller.loading
            //           ? const LinearProgressIndicator()
            //           : Row(
            //               children: [
            //                 Expanded(
            //                   child: Text(
            //                     L10n.of(context)!.createNewSpace,
            //                   ),
            //                 ),
            //                 Icon(Icons.adaptive.arrow_forward_outlined),
            //               ],
            //             ),
            //     ),
            //   ),
            // ),
            // Pangea#
          ],
        ),
      ),
    );
  }
}
