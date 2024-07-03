import 'dart:developer';

import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:fluffychat/pangea/widgets/common/bot_face_svg.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_mode_dynamic_zone.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_mode_select.dart';
import 'package:fluffychat/pangea/widgets/space/language_level_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import '../../../widgets/matrix.dart';
import '../../constants/pangea_event_types.dart';
import '../../extensions/pangea_room_extension/pangea_room_extension.dart';
import '../../utils/error_handler.dart';

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
    widget.room?.isBotRoom.then((bool isBotRoom) {
      setState(() {
        addBot = isBotRoom;
      });
    });
    parentSpace = widget.activeSpaceId != null
        ? Matrix.of(context).client.getRoomById(widget.activeSpaceId!)
        : null;
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

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ListTile(
            title: Text(
              L10n.of(context)!.convoBotSettingsTitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(L10n.of(context)!.convoBotSettingsDescription),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
              child: const Icon(Icons.psychology_outlined),
            ),
            trailing: Icon(
              isOpen
                  ? Icons.keyboard_arrow_down_outlined
                  : Icons.keyboard_arrow_right_outlined,
            ),
            onTap: () => setState(() => isOpen = !isOpen),
          ),
          if (isOpen)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isOpen ? null : 0,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      title: Text(
                        L10n.of(context)!.addConversationBot,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(L10n.of(context)!.addConversationBotDesc),
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        foregroundColor:
                            Theme.of(context).textTheme.bodyLarge!.color,
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
                                L10n.of(context)!
                                    .addConversationBotButtonRemove,
                              )
                            : Text(
                                L10n.of(context)!
                                    .addConversationBotButtonInvite,
                              ),
                      ),
                    ),
                  ),
                  if (addBot) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 16, 0, 0),
                      child: Text(
                        L10n.of(context)!.conversationLanguageLevel,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: LanguageLevelDropdown(
                        initialLevel: botOptions.languageLevel,
                        onChanged: (int? newValue) => updateBotOption(() {
                          botOptions.languageLevel = newValue!;
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 16, 0, 0),
                      child: Text(
                        L10n.of(context)!.conversationBotModeSelectDescription,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ConversationBotModeSelect(
                        initialMode: botOptions.mode,
                        onChanged: (String? mode) => updateBotOption(
                          () {
                            botOptions.mode = mode ?? "discussion";
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 0, 12, 0),
                      child: ConversationBotModeDynamicZone(
                        initialBotOptions: botOptions,
                        onChanged: (BotOptionsModel? newOptions) {
                          updateBotOption(() {
                            if (newOptions != null) {
                              botOptions = newOptions;
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
        ],
      );
}
