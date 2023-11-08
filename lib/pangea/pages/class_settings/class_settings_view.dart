import 'package:fluffychat/pangea/pages/class_settings/class_settings_page.dart';
import 'package:fluffychat/pangea/pages/class_settings/p_class_widgets/room_rules_editor.dart';
import 'package:fluffychat/pangea/widgets/space/class_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/layouts/max_width_body.dart';

class ClassSettingsPageView extends StatelessWidget {
  final ClassSettingsController controller;
  const ClassSettingsPageView({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("in class settings page with roomId ${controller.roomId}");
    // PTODO-Lala - make the page scrollable anywhere, not just in the area of the elements
    // so like, the user should be able scroll using the mouse wheel from anywhere within this view
    // currently, your cursor needs be horizontally within the tiles in order to scroll
    return Scaffold(
      appBar: AppBar(
        leading: GoRouterState.of(context).path?.startsWith('/spaces/') ?? false
            ? null
            : IconButton(
                icon: const Icon(Icons.close_outlined),
                onPressed: () => controller.goback(context),
              ),
        centerTitle: true,
        title: Text(L10n.of(context)!.classSettings),
      ),
      body: ListView(
        children: [
          MaxWidthBody(
            child: ListTile(
              title: Center(
                child: TextButton.icon(
                  onPressed: controller.setDisplaynameAction,
                  onHover: controller.hoverEditNameIcon,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                  ),
                  label: Visibility(
                    visible: controller.showEditNameIcon,
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  icon: Text(
                    controller.className,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          MaxWidthBody(
            child: Column(
              children: [
                ClassSettings(
                  roomId: controller.roomId,
                  startOpen: true,
                ),
                RoomRulesEditor(roomId: controller.roomId),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showFutureLoadingDialog(
          context: context,
          future: () => controller.handleSave(context),
        ),
        label: Text(L10n.of(context)!.saveChanges),
        icon: const Icon(Icons.save_outlined),
      ),
    );
  }
}
