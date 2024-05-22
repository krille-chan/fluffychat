import 'package:fluffychat/pangea/models/bot_options_model.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_discussion_keywords_input.dart';
import 'package:fluffychat/pangea/widgets/conversation_bot/conversation_bot_discussion_topic_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ConversationBotDiscussionZone extends StatelessWidget {
  final BotOptionsModel initialBotOptions;
  // call this to update propagate changes to parents
  final void Function(BotOptionsModel) onChanged;

  const ConversationBotDiscussionZone({
    super.key,
    required this.initialBotOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final String discussionTopic = initialBotOptions.discussionTopic ?? "";
    final String discussionKeywords =
        initialBotOptions.discussionKeywords ?? "";
    // int discussionTriggerScheduleHourInterval =
    //     initialBotOptions.discussionTriggerScheduleHourInterval ?? 24;
    // String discussionTriggerReactionKey =
    //     initialBotOptions.discussionTriggerReactionKey ?? "⏩";
    // List<String> reactionKeyOptions = ["⏩"];
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          L10n.of(context)!.conversationBotDiscussionZone_title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Text(
              L10n.of(context)!
                  .conversationBotDiscussionZone_discussionTopicLabel,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ConversationBotDiscussionTopicInput(
            initialBotOptions: initialBotOptions,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Text(
              L10n.of(context)!
                  .conversationBotDiscussionZone_discussionKeywordsLabel,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ConversationBotDiscussionKeywordsInput(
            initialBotOptions: initialBotOptions,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 12),
        // CheckboxListTile(
        //   title: Text(
        //     L10n.of(context)!
        //         .conversationBotDiscussionZone_discussionTriggerScheduleEnabledLabel,
        //   ),
        //   value: initialBotOptions.discussionTriggerScheduleEnabled ?? false,
        //   onChanged: (value) {
        //     initialBotOptions.discussionTriggerScheduleEnabled = value ?? false;
        //     onChanged?.call(initialBotOptions);
        //   },
        // ),
        // if (initialBotOptions.discussionTriggerScheduleEnabled == true)
        //   Padding(
        //     padding: const EdgeInsets.all(8),
        //     child: TextField(
        //       keyboardType: TextInputType.number,
        //       controller: TextEditingController(
        //         text: discussionTriggerScheduleHourInterval.toString(),
        //       ),
        //       onChanged: (value) {
        //         discussionTriggerScheduleHourInterval =
        //             int.tryParse(value) ?? 0;
        //       },
        //       decoration: InputDecoration(
        //         labelText: L10n.of(context)!
        //             .conversationBotDiscussionZone_discussionTriggerScheduleHourIntervalLabel,
        //         floatingLabelBehavior: FloatingLabelBehavior.auto,
        //         suffixIcon: IconButton(
        //           icon: const Icon(Icons.check),
        //           onPressed: () {
        //             if (discussionTriggerScheduleHourInterval !=
        //                 initialBotOptions
        //                     .discussionTriggerScheduleHourInterval) {
        //               initialBotOptions.discussionTriggerScheduleHourInterval =
        //                   discussionTriggerScheduleHourInterval;
        //               onChanged?.call(
        //                 initialBotOptions,
        //               );
        //             }
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
        // const SizedBox(height: 12),
        CheckboxListTile(
          title: Text(
            L10n.of(context)!
                .conversationBotDiscussionZone_discussionTriggerReactionEnabledLabel,
          ),
          value: initialBotOptions.discussionTriggerReactionEnabled ?? false,
          onChanged: (value) {
            initialBotOptions.discussionTriggerReactionEnabled = value ?? false;
            initialBotOptions.discussionTriggerReactionKey =
                "⏩"; // hard code this for now
            onChanged.call(initialBotOptions);
          },
        ),
        // if (initialBotOptions.discussionTriggerReactionEnabled == true)
        //   Padding(
        //     padding: const EdgeInsets.all(8),
        //     child: Column(
        //       children: [
        //         Text(
        //           L10n.of(context)!
        //               .conversationBotDiscussionZone_discussionTriggerReactionKeyLabel,
        //           style: TextStyle(
        //             color: Theme.of(context).colorScheme.secondary,
        //             fontWeight: FontWeight.bold,
        //           ),
        //           textAlign: TextAlign.left,
        //         ),
        //         Container(
        //           decoration: BoxDecoration(
        //             border: Border.all(
        //               color: Theme.of(context).colorScheme.secondary,
        //               width: 0.5,
        //             ),
        //             borderRadius: const BorderRadius.all(Radius.circular(10)),
        //           ),
        //           child: DropdownButton(
        //             // Initial Value
        //             hint: Padding(
        //               padding: const EdgeInsets.only(left: 15),
        //               child: Text(
        //                 reactionKeyOptions[0],
        //                 style: const TextStyle().copyWith(
        //                   color: Theme.of(context).textTheme.bodyLarge!.color,
        //                   fontSize: 14,
        //                 ),
        //                 overflow: TextOverflow.clip,
        //                 textAlign: TextAlign.center,
        //               ),
        //             ),
        //             isExpanded: true,
        //             underline: Container(),
        //             // Down Arrow Icon
        //             icon: const Icon(Icons.keyboard_arrow_down),
        //             // Array list of items
        //             items: [
        //               for (final entry in reactionKeyOptions)
        //                 DropdownMenuItem(
        //                   value: entry,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(left: 15),
        //                     child: Text(
        //                       entry,
        //                       style: const TextStyle().copyWith(
        //                         color: Theme.of(context)
        //                             .textTheme
        //                             .bodyLarge!
        //                             .color,
        //                         fontSize: 14,
        //                       ),
        //                       overflow: TextOverflow.clip,
        //                       textAlign: TextAlign.center,
        //                     ),
        //                   ),
        //                 ),
        //             ],
        //             onChanged: (String? value) {
        //               if (value !=
        //                   initialBotOptions.discussionTriggerReactionKey) {
        //                 initialBotOptions.discussionTriggerReactionKey = value;
        //                 onChanged?.call(
        //                   initialBotOptions,
        //                 );
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        const SizedBox(height: 12),
      ],
    );
  }
}
