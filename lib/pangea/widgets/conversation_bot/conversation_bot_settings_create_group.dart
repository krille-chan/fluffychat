import 'package:fluffychat/pangea/extensions/pangea_room_extension/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/widgets/common/bot_face_svg.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_settings.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

class ConversationBotSettingsCreateGroup extends StatefulWidget {
  final Room? room;
  final bool startOpen;
  final String? activeSpaceId;

  const ConversationBotSettingsCreateGroup({
    super.key,
    this.room,
    this.startOpen = false,
    this.activeSpaceId,
  });

  @override
  ConversationBotSettingsCreateGroupState createState() =>
      ConversationBotSettingsCreateGroupState();
}

class ConversationBotSettingsCreateGroupState
    extends State<ConversationBotSettingsCreateGroup> {
  late BotOptionsModel botOptions;
  late bool isOpen;
  bool addBot = false;
  Room? parentSpace;

  ConversationBotSettingsCreateGroupState({Key? key});

  @override
  void initState() {
    super.initState();
    isOpen = widget.startOpen;
    botOptions = widget.room?.botOptions != null
        ? BotOptionsModel.fromJson(widget.room?.botOptions?.toJson())
        : BotOptionsModel();
    widget.room?.isBotRoom.then((bool isBotRoom) {
      setState(() {
        addBot = isBotRoom;
      });
    });
    parentSpace = widget.activeSpaceId != null
        ? Matrix.of(context).client.getRoomById(widget.activeSpaceId!)
        : null;
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                L10n.of(context)!.addConversationBot,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(L10n.of(context)!.addConversationBotDesc),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
                child: const BotFace(
                  width: 30.0,
                  expression: BotExpression.idle,
                ),
              ),
              trailing: ElevatedButton(
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
              ),
            ),
            if (addBot) ...[
              ConversationBotSettings(
                room: widget.room,
                botOptions: botOptions,
              ),
            ],
          ],
        ),
      );
}
