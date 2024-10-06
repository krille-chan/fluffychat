import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'new_space.dart';

class NewSpaceView extends StatelessWidget {
  final NewSpaceController controller;

  const NewSpaceView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = controller.avatar;
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).createNewSpace),
      ),
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
                  labelText: L10n.of(context).spaceName,
                  errorText: controller.nameError,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 32),
              title: Text(L10n.of(context).spaceIsPublic),
              value: controller.publicGroup,
              onChanged: controller.setPublicGroup,
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 32),
              trailing: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.info_outlined),
              ),
              subtitle: Text(L10n.of(context).newSpaceDescription),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      controller.loading ? null : controller.submitAction,
                  child: controller.loading
                      ? const LinearProgressIndicator()
                      : Text(L10n.of(context).createNewSpace),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
