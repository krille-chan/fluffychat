import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/msc_extensions/msc_3381_polls/poll_event_extension.dart';

class PollEvent extends StatelessWidget {
  final Event event;
  final Timeline timeline;
  final Color textColor;
  const PollEvent(
    this.event, {
    required this.textColor,
    required this.timeline,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fontSize = AppConfig.messageFontSize * AppConfig.fontSizeFactor;
    final content = event.parsedPollEventContent.pollStartContent;
    final answers = event.getPollResponses(timeline);
    final answersLength = answers.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          content.question.mText,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
        for (final answer in content.answers)
          Builder(
            builder: (context) {
              final votes =
                  answers.values.where((v) => v.contains(answer.id)).length;
              final percentage = answersLength == 0 ? 0 : votes / answersLength;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  SizedBox(
                    height: 32,
                    child: Material(
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final ownAnswers =
                              answers[event.room.client.userID] ?? {};
                          if (ownAnswers.contains(answer.id)) {
                            ownAnswers.remove(answer.id);
                          } else {
                            ownAnswers.add(answer.id);
                          }
                          showFutureLoadingDialog(
                            context: context,
                            future: () => event.answerPoll(ownAnswers.toList()),
                          );
                        },
                        borderRadius:
                            BorderRadius.circular(AppConfig.borderRadius),
                        child: Stack(
                          children: [
                            LinearProgressIndicator(
                              minHeight: 32,
                              backgroundColor: textColor.withAlpha(16),
                              color: textColor.withAlpha(64),
                              value: percentage.toDouble(),
                              borderRadius:
                                  BorderRadius.circular(AppConfig.borderRadius),
                            ),
                            Center(
                              child: Text(
                                answer.mText,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (answersLength > 0)
                    Text(
                      L10n.of(context).countVotes(
                        votes,
                        (percentage * 100).round(),
                      ),
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: textColor),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}
