import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../../../config/app_config.dart';
import '../../../../widgets/matrix.dart';
import '../../../constants/pangea_event_types.dart';
import '../../../extensions/pangea_room_extension/pangea_room_extension.dart';

class RoomRulesEditor extends StatefulWidget {
  final String? roomId;
  final bool startOpen;
  final bool showAdd;
  final PangeaRoomRules? initialRules;

  const RoomRulesEditor({
    super.key,
    this.roomId,
    this.startOpen = true,
    this.showAdd = false,
    this.initialRules,
  });

  @override
  RoomRulesState createState() => RoomRulesState();
}

class RoomRulesState extends State<RoomRulesEditor> {
  Room? room;
  late PangeaRoomRules rules;
  late bool isOpen;

  RoomRulesState({
    Key? key,
  });

  @override
  void initState() {
    isOpen = widget.startOpen;

    room = widget.roomId != null
        ? Matrix.of(context).client.getRoomById(widget.roomId!)
        : null;

    rules = room?.pangeaRoomRules ?? widget.initialRules ?? PangeaRoomRules();

    super.initState();
  }

  Future<void> setRoomRules(String roomId) {
    return Matrix.of(context).client.setRoomStateWithKey(
          roomId,
          PangeaEventTypes.rules,
          '',
          (rules).toJson(),
        );
  }

  Future<void> updatePermission(void Function() makeLocalRuleChange) async {
    makeLocalRuleChange();
    if (room != null) {
      await showFutureLoadingDialog(
        context: context,
        future: () => setRoomRules(room!.id),
      );
    }
    setState(() {});
  }

  // //function to handleShowAdd
  // void handleShowAdd() {
  //   setState(() => isOpen = !isOpen);
  //   debugger(when: rules != null && kDebugMode);

  //   rules = PangeaRoomRules();
  // }

  void showNoPermission() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10n.of(context).noPermission),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // if (widget.showAdd)
        //   ListTile(
        //     title: Text(
        //       L10n.of(context).studentPermissions,
        //       style: TextStyle(
        //         color: Theme.of(context).colorScheme.secondary,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     subtitle: Text(L10n.of(context).addRoomRulesDesc),
        //     leading: CircleAvatar(
        //       backgroundColor: Theme.of(context).primaryColor,
        //       foregroundColor: Colors.white,
        //       radius: Avatar.defaultSize / 2,
        //       child: Icon(rules == null ? Icons.add : Icons.remove),
        //     ),
        //     trailing: Icon(
        //       isOpen
        //           ? Icons.keyboard_arrow_down_outlined
        //           : Icons.keyboard_arrow_right_outlined,
        //     ),
        //     onTap: handleShowAdd,
        //   ),

        ListTile(
          enableFeedback: !widget.startOpen,
          title: Text(
            L10n.of(context).studentPermissions,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(L10n.of(context).studentPermissionsDesc),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
            child: const Icon(
              Icons.settings_outlined,
            ),
          ),
          trailing: !widget.startOpen
              ? Icon(
                  isOpen
                      ? Icons.keyboard_arrow_down_outlined
                      : Icons.keyboard_arrow_right_outlined,
                )
              : null,
          onTap: () =>
              !widget.startOpen ? setState(() => isOpen = !isOpen) : null,
        ),
        if (isOpen)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isOpen ? null : 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
              child: Opacity(
                opacity: (room?.isRoomAdmin ?? true) ? 1 : 0.5,
                child: Column(
                  children: [
                    for (final setting in ToolSetting.values)
                      Column(
                        children: [
                          ListTile(
                            title: Text(
                              "${setting.toolName(
                                context,
                              )}: ${rules.languageToolPermissionsText(
                                context,
                                setting,
                              )}",
                            ),
                            subtitle: Text(setting.toolDescription(context)),
                          ),
                          Slider(
                            value: rules.getToolSettings(setting).toDouble(),
                            onChanged: (value) {
                              if (room?.isRoomAdmin ?? true) {
                                updatePermission(() {
                                  rules.setLanguageToolSetting(
                                    setting,
                                    value.toInt(),
                                  );
                                });
                              } else {
                                showNoPermission();
                              }
                            },
                            divisions: 2,
                            max: 2,
                            min: 0,
                            label: rules.languageToolPermissionsText(
                              context,
                              setting,
                            ),
                          ),
                        ],
                      ),
                    SwitchListTile.adaptive(
                      activeColor: AppConfig.activeToggleColor,
                      title: Text(L10n.of(context).oneToOneChatsWithinClass),
                      subtitle:
                          Text(L10n.of(context).oneToOneChatsWithinClassDesc),
                      value: rules.oneToOneChatClass,
                      onChanged: (value) => (room?.isRoomAdmin ?? true)
                          ? updatePermission(
                              () => rules.oneToOneChatClass = value,
                            )
                          : showNoPermission(),
                    ),
                    SwitchListTile.adaptive(
                      activeColor: AppConfig.activeToggleColor,
                      title: Text(L10n.of(context).createGroupChats),
                      subtitle: Text(L10n.of(context).createGroupChatsDesc),
                      value: rules.isCreateRooms,
                      onChanged: (value) => (room?.isRoomAdmin ?? true)
                          ? updatePermission(
                              () => rules.isCreateRooms = value,
                            )
                          : showNoPermission(),
                    ),
                    SwitchListTile.adaptive(
                      activeColor: AppConfig.activeToggleColor,
                      title: Text(L10n.of(context).shareVideo),
                      subtitle: Text(L10n.of(context).shareVideoDesc),
                      value: rules.isShareVideo,
                      onChanged: (value) => (room?.isRoomAdmin ?? true)
                          ? updatePermission(
                              () => rules.isShareVideo = value,
                            )
                          : showNoPermission(),
                    ),
                    SwitchListTile.adaptive(
                      activeColor: AppConfig.activeToggleColor,
                      title: Text(L10n.of(context).sharePhotos),
                      subtitle: Text(L10n.of(context).sharePhotosDesc),
                      value: rules.isSharePhoto,
                      onChanged: (value) => (room?.isRoomAdmin ?? true)
                          ? updatePermission(
                              () => rules.isSharePhoto = value,
                            )
                          : showNoPermission(),
                    ),
                    SwitchListTile.adaptive(
                      activeColor: AppConfig.activeToggleColor,
                      title: Text(L10n.of(context).shareFiles),
                      subtitle: Text(L10n.of(context).shareFilesDesc),
                      value: rules.isShareFiles,
                      onChanged: (value) => (room?.isRoomAdmin ?? true)
                          ? updatePermission(
                              () => rules.isShareFiles = value,
                            )
                          : showNoPermission(),
                    ),
                    SwitchListTile.adaptive(
                      activeColor: AppConfig.activeToggleColor,
                      title: Text(L10n.of(context).sendVoiceNotes),
                      subtitle: Text(L10n.of(context).sendVoiceNotesDesc),
                      value: rules.isVoiceNotes,
                      onChanged: (value) => (room?.isRoomAdmin ?? true)
                          ? updatePermission(
                              () => rules.isVoiceNotes = value,
                            )
                          : showNoPermission(),
                    ),
                    SwitchListTile.adaptive(
                      activeColor: AppConfig.activeToggleColor,
                      title: Text(L10n.of(context).shareLocation),
                      subtitle: Text(L10n.of(context).shareLocationDesc),
                      value: rules.isShareLocation,
                      onChanged: (value) => (room?.isRoomAdmin ?? true)
                          ? updatePermission(
                              () => rules.isShareLocation = value,
                            )
                          : showNoPermission(),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
