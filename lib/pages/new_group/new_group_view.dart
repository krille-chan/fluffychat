import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/new_group/new_group.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class NewGroupView extends StatelessWidget {
  final NewGroupController controller;

  const NewGroupView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final avatar = controller.avatar;
    final error = controller.error;
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: BackButton(
            onPressed: controller.loading ? null : Navigator.of(context).pop,
          ),
        ),
        title: Text(L10n.of(context)!.createGroup),
      ),
      body: MaxWidthBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
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
                      controller: controller.nameController,
                      autocorrect: false,
                      readOnly: controller.loading,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.people_outlined),
                        hintText: L10n.of(context)!.groupName,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: controller.topicController,
                minLines: 4,
                maxLines: 4,
                maxLength: 255,
                readOnly: controller.loading,
                decoration: InputDecoration(
                  hintText: L10n.of(context)!.addChatDescription,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              secondary: const Icon(Icons.public_outlined),
              title: Text(L10n.of(context)!.groupIsPublic),
              value: controller.publicGroup,
              onChanged: controller.loading ? null : controller.setPublicGroup,
            ),
            AnimatedSize(
              duration: FluffyThemes.animationDuration,
              child: controller.publicGroup
                  ? SwitchListTile.adaptive(
                      secondary: const Icon(Icons.search_outlined),
                      title: Text(L10n.of(context)!.groupCanBeFoundViaSearch),
                      value: controller.groupCanBeFound,
                      onChanged: controller.loading
                          ? null
                          : controller.setGroupCanBeFound,
                    )
                  : const SizedBox.shrink(),
            ),
            SwitchListTile.adaptive(
              secondary: Icon(
                Icons.lock_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text(
                L10n.of(context)!.enableEncryption,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              value: !controller.publicGroup,
              onChanged: null,
            ),
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
                                L10n.of(context)!.createGroupAndInviteUsers,
                              ),
                            ),
                            Icon(Icons.adaptive.arrow_forward_outlined),
                          ],
                        ),
                ),
              ),
            ),
            AnimatedSize(
              duration: FluffyThemes.animationDuration,
              child: error == null
                  ? const SizedBox.shrink()
                  : ListTile(
                      leading: Icon(
                        Icons.warning_outlined,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      title: Text(
                        error.toLocalizedString(context),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
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
