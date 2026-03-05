import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_session_model.dart';
import 'package:fluffychat/pangea/analytics_practice/analytics_practice_session_repo.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_generation_repo.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class _PracticeQueueEntry {
  final MessageActivityRequest request;
  final Completer<MultipleChoicePracticeActivityModel> completer;

  _PracticeQueueEntry({required this.request, required this.completer});
}

class PracticeSessionController {
  PracticeSessionController();

  AnalyticsPracticeSessionModel? session;
  bool isLoadingSession = false;
  Object? sessionError;

  final Queue<_PracticeQueueEntry> _queue = Queue();

  void clear() {
    _queue.clear();
  }

  List<MessageActivityRequest> get activityRequests =>
      session?.activityRequests ?? [];

  List<OneConstructUse> get bonusUses => session?.state.allBonusUses ?? [];

  int get hintsUsed => session?.state.hintsUsed ?? 0;

  double get progress => session?.progress ?? 0;

  String getCompletionMessage(BuildContext context) =>
      session?.getCompletionMessage(context) ??
      L10n.of(context).youveCompletedPractice;

  void updateElapsedTime(int seconds) {
    session?.setElapsedSeconds(seconds);
  }

  void updateHintsPressed() {
    session?.useHint();
  }

  void updateElapsedSeconds(int seconds) {
    session?.setElapsedSeconds(seconds);
  }

  void completeActivity() {
    session?.completeActivity();
  }

  void skipActivity() {
    session?.incrementSkippedActivities();
  }

  void submitAnswer(List<OneConstructUse> uses) {
    session?.submitAnswer(uses);
  }

  Future<void> startSession(ConstructTypeEnum type) async {
    try {
      isLoadingSession = true;
      sessionError = null;
      session = null;

      final l2 =
          MatrixState.pangeaController.userController.userL2?.langCodeShort;
      if (l2 == null) throw Exception('User L2 language not set');
      session = await AnalyticsPracticeSessionRepo.get(type, l2);
    } catch (e, s) {
      ErrorHandler.logError(e: e, s: s, data: {});
      sessionError = e;
    } finally {
      isLoadingSession = false;
    }
  }

  Future<void> completeSession() async {
    session?.finishSession();
  }

  Future<MultipleChoicePracticeActivityModel?> _initActivityData(
    Future Function(PracticeTarget) onSkip,
    Future Function(MultipleChoicePracticeActivityModel) onFetch,
  ) async {
    final requests = activityRequests;
    for (var i = 0; i < requests.length; i++) {
      try {
        final req = requests[i];
        final res = await _fetchActivity(req, onFetch);
        _fillActivityQueue(requests.skip(i + 1).toList(), onSkip, onFetch);
        return res;
      } catch (e) {
        await onSkip(requests[i].target);
        // Try next request
        continue;
      }
    }
    return null;
  }

  Future<void> _fillActivityQueue(
    List<MessageActivityRequest> requests,
    Future Function(PracticeTarget) onSkip,
    Future Function(MultipleChoicePracticeActivityModel) onFetch,
  ) async {
    for (final request in requests) {
      final completer = Completer<MultipleChoicePracticeActivityModel>();
      _queue.add(_PracticeQueueEntry(request: request, completer: completer));
      _fetchActivity(request, onFetch)
          .then((activity) {
            activity != null
                ? completer.complete(activity)
                : completer.completeError(
                    Exception("Failed to fetch activity"),
                  );
          })
          .catchError((e, s) async {
            completer.completeError(e);
            await onSkip(request.target);
            return null;
          });
    }
  }

  Future<MultipleChoicePracticeActivityModel?> _fetchActivity(
    MessageActivityRequest req,
    Future Function(MultipleChoicePracticeActivityModel) onFetch,
  ) async {
    final result = await PracticeRepo.getPracticeActivity(req, messageInfo: {});

    if (result.isError ||
        result.result is! MultipleChoicePracticeActivityModel) {
      throw Exception();
    }

    final activityModel = result.result as MultipleChoicePracticeActivityModel;
    await onFetch(activityModel);
    return activityModel;
  }

  Future<MultipleChoicePracticeActivityModel?> getNextActivity(
    Future Function(PracticeTarget) onSkip,
    Future Function(MultipleChoicePracticeActivityModel) onFetch,
  ) async {
    final session = this.session;
    if (session == null) {
      throw Exception("Called getNextActivity without loading session");
    }

    if (!session.isComplete && _queue.isEmpty) {
      final initialActivity = await _initActivityData(onSkip, onFetch);
      if (initialActivity == null && session.state.currentIndex == 0) {
        // No activities were successfully loaded, and we haven't completed any yet, so throw an error
        throw Exception("Failed to load any activities");
      }
      return initialActivity;
    }

    while (_queue.isNotEmpty) {
      final nextActivityCompleter = _queue.removeFirst();

      try {
        final activity = await nextActivityCompleter.completer.future;
        return activity;
      } catch (e) {
        // Completer failed, skip to next
        continue;
      }
    }

    if (session.state.currentIndex == 0) {
      // No activities were successfully loaded, and we haven't completed any yet, so throw an error
      throw Exception("Failed to load any activities");
    }

    return null;
  }
}
