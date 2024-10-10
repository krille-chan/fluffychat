import 'dart:developer';

import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/common/bot_face_svg.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_settings_form.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

class ConversationBotSettings extends StatefulWidget {
  final Room? room;
  final bool startOpen;
  final String? activeSpaceId;

  const ConversationBotSettings({
    super.key,
    this.room,
    this.startOpen = false,
    this.activeSpaceId,
  });

  @override
  ConversationBotSettingsState createState() => ConversationBotSettingsState();
}

class ConversationBotSettingsState extends State<ConversationBotSettings> {
  late BotOptionsModel botOptions;
  late bool isOpen;
  late bool isCreating;
  bool addBot = false;
  Room? parentSpace;

  ConversationBotSettingsState({Key? key});

  @override
  void initState() {
    super.initState();
    isOpen = widget.startOpen;
    botOptions = widget.room?.botOptions != null
        ? BotOptionsModel.fromJson(widget.room?.botOptions?.toJson())
        : BotOptionsModel();
    widget.room?.botIsInRoom.then((bool isBotRoom) {
      setState(() {
        addBot = isBotRoom;
      });
    });
    parentSpace = widget.activeSpaceId != null
        ? Matrix.of(context).client.getRoomById(widget.activeSpaceId!)
        : null;
    isCreating = widget.room == null;
  }

  Future<void> setBotOption() async {
    if (widget.room == null) return;
    try {
      await Matrix.of(context).client.setRoomStateWithKey(
            widget.room!.id,
            PangeaEventTypes.botOptions,
            '',
            botOptions.toJson(),
          );
    } catch (err, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: err, s: stack);
    }
  }

  Future<void> updateBotOption(void Function() makeLocalChange) async {
    makeLocalChange();
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        try {
          await setBotOption();
        } catch (err, stack) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(e: err, s: stack);
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              isCreating
                  ? L10n.of(context)!.addConversationBot
                  : L10n.of(context)!.botConfig,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: isCreating
                ? Text(L10n.of(context)!.addConversationBotDesc)
                : null,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
              child: const BotFace(
                width: 30.0,
                expression: BotExpression.idle,
              ),
            ),
            trailing: isCreating
                ? ElevatedButton(
                    onPressed: () async {
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: addBot
                                ? Text(
                                    L10n.of(context)!
                                        .addConversationBotButtonTitleRemove,
                                  )
                                : Text(
                                    L10n.of(context)!
                                        .addConversationBotDialogTitleInvite,
                                  ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(L10n.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(!addBot);
                                },
                                child: addBot
                                    ? Text(
                                        L10n.of(context)!
                                            .addConversationBotDialogRemoveConfirmation,
                                      )
                                    : Text(
                                        L10n.of(context)!
                                            .addConversationBotDialogInviteConfirmation,
                                      ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        setState(() => addBot = true);
                        widget.room?.invite(BotName.byEnvironment);
                      } else {
                        setState(() => addBot = false);
                        widget.room?.kick(BotName.byEnvironment);
                      }
                    },
                    child: addBot
                        ? Text(
                            L10n.of(context)!.addConversationBotButtonRemove,
                          )
                        : Text(
                            L10n.of(context)!.addConversationBotButtonInvite,
                          ),
                  )
                : const Icon(Icons.settings),
            onTap: isCreating
                ? null
                : () async {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setState) => AlertDialog(
                            title: Text(
                              L10n.of(context)!.botConfig,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        L10n.of(context)!.conversationBotStatus,
                                      ),
                                      Switch(
                                        value: addBot,
                                        onChanged: (value) {
                                          setState(
                                            () => addBot = value,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                if (addBot)
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 0.5,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: ConversationBotSettingsForm(
                                          botOptions: botOptions,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(L10n.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  L10n.of(context)!
                                      .conversationBotConfigConfirmChange,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                    if (confirm == true) {
                      updateBotOption(() {
                        botOptions = botOptions;
                      });
                      final bool isBotRoomMember =
                          await widget.room?.botIsInRoom ?? false;
                      if (addBot && !isBotRoomMember) {
                        await widget.room?.invite(BotName.byEnvironment);
                      } else if (!addBot && isBotRoomMember) {
                        await widget.room?.kick(BotName.byEnvironment);
                      }
                    }
                  },
          ),
          if (isCreating && addBot)
            ConversationBotSettingsForm(
              botOptions: botOptions,
            ),
        ],
      ),
    );
  }
}
