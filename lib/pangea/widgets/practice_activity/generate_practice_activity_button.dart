import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class GeneratePracticeActivityButton extends StatelessWidget {
  final PangeaMessageEvent pangeaMessageEvent;
  final Function(PracticeActivityEvent?) onActivityGenerated;

  const GeneratePracticeActivityButton({
    super.key,
    required this.pangeaMessageEvent,
    required this.onActivityGenerated,
  });

  //TODO - probably disable the generation of activities for specific messages
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final String? l2Code = MatrixState.pangeaController.languageController
            .activeL1Model()
            ?.langCode;

        if (l2Code == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(L10n.of(context)!.noLanguagesSet),
            ),
          );
          return;
        }

        throw UnimplementedError();

        // final PracticeActivityEvent? practiceActivityEvent = await MatrixState
        //     .pangeaController.practiceGenerationController
        //     .getPracticeActivity(
        //   MessageActivityRequest(
        //     candidateMessages: [
        //       CandidateMessage(
        //         msgId: pangeaMessageEvent.eventId,
        //         roomId: pangeaMessageEvent.room.id,
        //         text:
        //             pangeaMessageEvent.representationByLanguage(l2Code)?.text ??
        //                 pangeaMessageEvent.body,
        //       ),
        //     ],
        //     userIds: pangeaMessageEvent.room.client.userID != null
        //         ? [pangeaMessageEvent.room.client.userID!]
        //         : null,
        //   ),
        //   pangeaMessageEvent,
        // );

        // onActivityGenerated(practiceActivityEvent);
      },
      child: Text(L10n.of(context)!.practice),
    );
  }
}
