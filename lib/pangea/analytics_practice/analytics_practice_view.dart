import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/analytics_practice/analytics_practice_page.dart';
import 'package:fluffychat/pangea/analytics_practice/completed_activity_session_view.dart';
import 'package:fluffychat/pangea/analytics_practice/ongoing_activity_session_view.dart';
import 'package:fluffychat/pangea/analytics_practice/practice_timer_widget.dart';
import 'package:fluffychat/pangea/analytics_practice/unsubscribed_practice_page.dart';
import 'package:fluffychat/pangea/analytics_summary/animated_progress_bar.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/utils/async_state.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class AnalyticsPracticeView extends StatelessWidget {
  final AnalyticsPracticeState controller;

  const AnalyticsPracticeView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final session = controller.session.session;
    const loading = Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator.adaptive(),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8.0,
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: controller.progress,
                builder: (context, progress, _) => AnimatedProgressBar(
                  height: 20.0,
                  widthPercent: progress,
                  barColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: controller.activityState,
              builder: (context, state, _) => PracticeTimerWidget(
                key: ValueKey(session?.startedAt ?? DateTime(0)),
                initialSeconds: session?.state.elapsedSeconds ?? 0,
                onTimeUpdate: controller.session.updateElapsedTime,
                isRunning:
                    session?.isComplete != true &&
                    state is AsyncLoaded<MultipleChoicePracticeActivityModel>,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: MaxWidthBody(
          withScrolling: false,
          showBorder: false,
          child: Builder(
            builder: (context) {
              final error = controller.session.sessionError;
              if (error != null) {
                return error is UnsubscribedException
                    ? const UnsubscribedPracticePage()
                    : ErrorIndicator(message: error.toLocalizedString(context));
              }

              final session = controller.session.session;
              if (session != null) {
                return session.isComplete
                    ? CompletedActivitySessionView(
                        session: session,
                        launchSession: controller.startSession,
                        levelProgress: controller.levelProgress,
                      )
                    : OngoingActivitySessionView(controller);
              }

              return loading;
            },
          ),
        ),
      ),
    );
  }
}
