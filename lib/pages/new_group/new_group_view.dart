import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/new_group/new_group.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class NewGroupView extends StatelessWidget {
  final NewGroupController controller;

  const NewGroupView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    // #Pangea
    // final theme = Theme.of(context);
    // Pangea#

    final avatar = controller.avatar;
    // #Pangea
    // final error = controller.error;
    // Pangea#
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: BackButton(
            onPressed: controller.loading ? null : Navigator.of(context).pop,
          ),
        ),
        title: Text(
          controller.createGroupType == CreateGroupType.space
              // #Pangea
              // ? L10n.of(context).newSpace
              ? L10n.of(context).newCourse
              // : L10n.of(context).createGroup,
              : L10n.of(context).newChat,
          // Pangea#
        ),
      ),
      body: MaxWidthBody(
        // #Pangea
        showBorder: false,
        padding: const EdgeInsets.only(
          left: 32.0,
          right: 32.0,
          bottom: 32.0,
        ),
        // Pangea#
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // #Pangea
            // Simplying options here
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: SegmentedButton<CreateGroupType>(
            //     selected: {controller.createGroupType},
            //     onSelectionChanged: controller.setCreateGroupType,
            //     segments: [
            //       ButtonSegment(
            //         value: CreateGroupType.group,
            //         label: Text(L10n.of(context).group),
            //       ),
            //       ButtonSegment(
            //         value: CreateGroupType.space,
            //         label: Text(L10n.of(context).space),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 16),
            // Pangea#
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
                          width: Avatar.defaultSize * 2,
                          height: Avatar.defaultSize * 2,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              // #Pangea
              // child: TextField(
              child: Form(
                key: controller.formKey,
                child: TextFormField(
                  // Pangea#
                  autofocus: true,
                  controller: controller.nameController,
                  autocorrect: false,
                  readOnly: controller.loading,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.people_outlined),
                    labelText:
                        controller.createGroupType == CreateGroupType.space
                            // #Pangea
                            // ? L10n.of(context).spaceName
                            ? L10n.of(context).courseName
                            // : L10n.of(context).groupName,
                            : L10n.of(context).chatName,
                    // Pangea#
                  ),
                  // #Pangea
                  onFieldSubmitted: (value) {
                    controller.loading ? null : controller.submitAction();
                  },
                  validator: (value) => controller.canSubmit
                      ? null
                      : L10n.of(context).pleaseFillOut,
                  focusNode: controller.focusNode,
                  // Pangea#
                ),
              ),
            ),
            const SizedBox(height: 16),
            // #Pangea
            // SwitchListTile.adaptive(
            //   contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            //   secondary: const Icon(Icons.public_outlined),
            //   title: Text(
            //     controller.createGroupType == CreateGroupType.space
            //         ? L10n.of(context).spaceIsPublic
            //         : L10n.of(context).groupIsPublic,
            //   ),
            //   value: controller.publicGroup,
            //   onChanged: controller.loading ? null : controller.setPublicGroup,
            // ),
            // AnimatedSize(
            //   duration: FluffyThemes.animationDuration,
            //   curve: FluffyThemes.animationCurve,
            //   child: controller.publicGroup
            //       ? SwitchListTile.adaptive(
            //           contentPadding:
            //               const EdgeInsets.symmetric(horizontal: 32),
            //           secondary: const Icon(Icons.search_outlined),
            //           title: Text(L10n.of(context).groupCanBeFoundViaSearch),
            //           value: controller.groupCanBeFound,
            //           onChanged: controller.loading
            //               ? null
            //               : controller.setGroupCanBeFound,
            //         )
            //       : const SizedBox.shrink(),
            // ),
            // AnimatedSize(
            //   duration: FluffyThemes.animationDuration,
            //   curve: FluffyThemes.animationCurve,
            //   child: controller.createGroupType == CreateGroupType.space
            //       ? const SizedBox.shrink()
            //       : SwitchListTile.adaptive(
            //           contentPadding:
            //               const EdgeInsets.symmetric(horizontal: 32),
            //           secondary: Icon(
            //             Icons.lock_outlined,
            //             color: theme.colorScheme.onSurface,
            //           ),
            //           title: Text(
            //             L10n.of(context).enableEncryption,
            //             style: TextStyle(
            //               color: theme.colorScheme.onSurface,
            //             ),
            //           ),
            //           value: !controller.publicGroup,
            //           onChanged: null,
            //         ),
            // ),
            // Pangea#
            AnimatedSize(
              duration: FluffyThemes.animationDuration,
              curve: FluffyThemes.animationCurve,
              child: controller.createGroupType == CreateGroupType.space
                  ? ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 32),
                      trailing: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.info_outlined),
                      ),
                      // #Pangea
                      // subtitle: Text(L10n.of(context).newSpaceDescription),
                      subtitle:
                          Text(L10n.of(context).updatedNewSpaceDescription),
                      // Pangea#
                    )
                  : const SizedBox.shrink(),
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
                      : Text(
                          controller.createGroupType == CreateGroupType.space
                              // #Pangea
                              // ? L10n.of(context).createNewSpace
                              ? L10n.of(context).createNewCourse
                              // : L10n.of(context).createGroupAndInviteUsers,
                              : L10n.of(context).createChatAndInviteUsers,
                          // Pangea#
                        ),
                ),
              ),
            ),
            // #Pangea
            // AnimatedSize(
            //   duration: FluffyThemes.animationDuration,
            //   curve: FluffyThemes.animationCurve,
            //   child: error == null
            //       ? const SizedBox.shrink()
            //       : ListTile(
            //           leading: Icon(
            //             Icons.warning_outlined,
            //             color: theme.colorScheme.error,
            //           ),
            //           title: Text(
            //             error.toLocalizedString(context),
            //             style: TextStyle(
            //               color: theme.colorScheme.error,
            //             ),
            //           ),
            //         ),
            // ),
            // Pangea#
          ],
        ),
      ),
    );
  }
}
