import 'dart:async';

import 'package:flutter/material.dart';

import 'package:async/async.dart';
import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/choreographer/igc/igc_repo.dart';
import 'package:fluffychat/pangea/choreographer/igc/igc_request_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/igc_response_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_state_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_status_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/span_data_model.dart';
import 'package:fluffychat/pangea/common/models/llm_feedback_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class IgcController {
  final Function(Object) onError;
  final VoidCallback onFetch;
  IgcController(this.onError, this.onFetch);

  bool _isFetching = false;
  String? _currentText;

  /// Last request made - stored for feedback rerun
  IGCRequestModel? _lastRequest;

  /// Last response received - stored for feedback rerun
  IGCResponseModel? _lastResponse;

  final List<PangeaMatchState> _matches = [];

  StreamController<PangeaMatchState> matchUpdateStream =
      StreamController.broadcast();

  ValueNotifier<PangeaMatchState?> activeMatch = ValueNotifier(null);

  String? get currentText => _currentText;

  List<PangeaMatchState> get matches => _matches;

  List<PangeaMatchState> get sortedMatches => _matches.sorted(
    (a, b) =>
        a.updatedMatch.match.offset.compareTo(b.updatedMatch.match.offset),
  );

  List<PangeaMatchState> get openMatches =>
      _matches.where((m) => m.updatedMatch.status.isOpen).toList();

  bool get hasOpenMatches => openMatches.isNotEmpty;

  List<PangeaMatchState> get closedNormalizationCorrections => _matches
      .where((m) => m.updatedMatch.status == PangeaMatchStatusEnum.automatic)
      .toList();

  List<PangeaMatchState> get openNormalizationMatches => _matches
      .where(
        (match) =>
            match.updatedMatch.status.isOpen &&
            match.updatedMatch.match.isNormalizationError(),
      )
      .toList();

  IGCRequestModel _igcRequest(
    String text,
    List<PreviousMessage> prevMessages,
  ) => IGCRequestModel(
    fullText: text,
    userId: MatrixState.pangeaController.userController.client.userID!,
    enableIGC: true,
    enableIT: true,
    prevMessages: prevMessages,
  );

  void dispose() {
    matchUpdateStream.close();
    activeMatch.dispose();
  }

  void clear() {
    _isFetching = false;
    _currentText = null;
    _lastRequest = null;
    _lastResponse = null;
    _matches.clear();
    MatrixState.pAnyState.closeAllOverlays();
  }

  void clearMatches() => _matches.clear();

  void clearCurrentText() => _currentText = null;

  void setActiveMatch({PangeaMatchState? match}) {
    if (match != null) {
      final isValidMatch = _matches.any((m) => m == match);

      if (!isValidMatch) {
        throw "setActiveMatch called with invalid match";
      }
    }

    if (_matches.isEmpty) {
      throw "setActiveMatch called without open matches";
    }

    match ??= openMatches.firstOrNull ?? _matches.first;
    if (match.updatedMatch.status == PangeaMatchStatusEnum.open) {
      updateMatchStatus(match, PangeaMatchStatusEnum.viewed);
    }
    activeMatch.value = match;
  }

  void clearActiveMatch() => activeMatch.value = null;

  PangeaMatchState? getMatchByOffset(int offset) => matches.firstWhereOrNull(
    (match) => match.updatedMatch.match.isOffsetInMatchSpan(offset),
  );

  void setSpanData(PangeaMatchState matchState, SpanData spanData) {
    final openMatch = openMatches.firstWhereOrNull(
      (m) => m.originalMatch == matchState.originalMatch,
    );

    matchState.setMatch(spanData);
    _matches.remove(openMatch);
    _matches.add(matchState);
  }

  void updateMatchStatus(PangeaMatchState match, PangeaMatchStatusEnum status) {
    final PangeaMatchState currentMatch = _matches.firstWhere(
      (m) => m.originalMatch == match.originalMatch,
      orElse: () => throw StateError('No match found while updating match.'),
    );

    final selectedChoice = match.updatedMatch.match.selectedChoice;

    match.setStatus(status);
    if (status == PangeaMatchStatusEnum.undo) {
      match.resetChoices();
    }

    _matches.remove(currentMatch);
    _matches.add(match);

    switch (status) {
      case PangeaMatchStatusEnum.accepted:
      case PangeaMatchStatusEnum.automatic:
        if (selectedChoice == null) {
          throw ArgumentError('acceptMatch called with a null selectedChoice.');
        }
        _applyReplacement(
          match.updatedMatch.match.offset,
          match.updatedMatch.match.length,
          selectedChoice.value,
        );
      case PangeaMatchStatusEnum.undo:
        final selectedValue = selectedChoice?.value;
        if (selectedValue == null) {
          throw StateError(
            'Cannot update match without a selectedChoice value.',
          );
        }

        final currentOffset = match.updatedMatch.match.offset;
        final currentLength = match.updatedMatch.match.length;
        final replacement = match.originalMatch.match.errorSpan;

        _applyReplacement(currentOffset, currentLength, replacement);
      case PangeaMatchStatusEnum.open:
      case PangeaMatchStatusEnum.viewed:
        break;
    }
    matchUpdateStream.add(match);
  }

  Future<void> acceptNormalizationMatches() async {
    final matches = openNormalizationMatches;
    if (matches.isEmpty) return;

    final expectedSpans = matches.map((m) => m.originalMatch).toSet();
    final completer = Completer<void>();

    int completedCount = 0;

    late final StreamSubscription<PangeaMatchState> sub;
    sub = matchUpdateStream.stream.listen((match) {
      if (expectedSpans.remove(match.originalMatch)) {
        completedCount++;
        if (completedCount >= matches.length) {
          completer.complete();
          sub.cancel();
        }
      }
    });

    try {
      for (final match in matches) {
        match.selectBestChoice();
        updateMatchStatus(match, PangeaMatchStatusEnum.automatic);
      }

      // If no updates arrive (edge case), auto-timeout after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        if (!completer.isCompleted) {
          completer.complete();
          sub.cancel();
        }
      });
    } catch (e, s) {
      ErrorHandler.logError(e: e, s: s, data: {"currentText": currentText});
      if (!completer.isCompleted) completer.complete();
    }

    return completer.future;
  }

  /// Applies a text replacement to [_currentText] and adjusts match offsets.
  ///
  /// Called internally when a correction is accepted or undone.
  void _applyReplacement(int offset, int length, String replacement) {
    if (_currentText == null) {
      throw StateError('_applyReplacement called with null _currentText');
    }

    final start = _currentText!.characters.take(offset);
    final end = _currentText!.characters.skip(offset + length);
    final updatedText = start + replacement.characters + end;
    _currentText = updatedText.toString();

    final lengthOffset = replacement.characters.length - length;

    for (final matchState in _matches) {
      final match = matchState.updatedMatch.match;
      final updatedMatch = match.copyWith(
        fullText: _currentText,
        offset: match.offset > offset
            ? match.offset + lengthOffset
            : match.offset,
        length: match.offset == offset && match.length == length
            ? replacement.characters.length
            : match.length,
      );
      matchState.setMatch(updatedMatch);
    }
  }

  Future<void> getIGCTextData(
    String text,
    List<PreviousMessage> prevMessages,
  ) async {
    if (text.isEmpty) return clear();
    if (_isFetching) return;

    final request = _igcRequest(text, prevMessages);
    await _fetchIGC(request);
  }

  /// Re-runs IGC with user feedback about the previous response.
  /// Returns true if feedback was submitted, false if no previous data.
  Future<bool> rerunWithFeedback(String feedbackText) async {
    debugPrint('rerunWithFeedback called with: $feedbackText');
    debugPrint('_lastRequest: $_lastRequest, _lastResponse: $_lastResponse');
    if (_lastRequest == null || _lastResponse == null) {
      ErrorHandler.logError(
        e: StateError(
          'rerunWithFeedback called without prior request/response',
        ),
        data: {
          'hasLastRequest': _lastRequest != null,
          'hasLastResponse': _lastResponse != null,
          'currentText': _currentText,
        },
      );
      return false;
    }
    if (_isFetching) {
      debugPrint('rerunWithFeedback: already fetching, returning false');
      return false;
    }

    // Create feedback containing the original response
    final feedback = LLMFeedbackModel<IGCResponseModel>(
      feedback: feedbackText,
      content: _lastResponse!,
      contentToJson: (r) => r.toJson(),
    );

    // Clear existing matches and state
    clearMatches();

    // Create request with feedback attached
    final requestWithFeedback = _lastRequest!.copyWithFeedback([feedback]);
    debugPrint(
      'requestWithFeedback.feedback.length: ${requestWithFeedback.feedback.length}',
    );
    debugPrint('requestWithFeedback.hashCode: ${requestWithFeedback.hashCode}');
    debugPrint('_lastRequest.hashCode: ${_lastRequest!.hashCode}');
    debugPrint('Calling IgcRepo.get...');
    return _fetchIGC(requestWithFeedback);
  }

  Future<bool> _fetchIGC(IGCRequestModel request) async {
    _isFetching = true;
    _lastRequest = request;

    final res =
        await IgcRepo.get(
          MatrixState.pangeaController.userController.accessToken,
          request,
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            return Result.error(
              TimeoutException(
                request.feedback.isNotEmpty
                    ? 'IGC feedback request timed out'
                    : 'IGC request timed out',
              ),
            );
          },
        );

    if (res.isError) {
      debugPrint('IgcRepo.get error: ${res.asError}');
      onError(res.asError!);
      clear();
      return false;
    }

    debugPrint('IgcRepo.get success, calling onFetch');
    onFetch();

    if (!_isFetching) return false;

    _lastResponse = res.result!;
    _currentText = res.result!.originalInput;
    for (final match in res.result!.matches) {
      final matchState = PangeaMatchState(
        match: match.match,
        status: PangeaMatchStatusEnum.open,
        original: match,
      );
      _matches.add(matchState);
    }
    _isFetching = false;
    return true;
  }
}
