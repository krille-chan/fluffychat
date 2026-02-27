import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/pangea/choreographer/assistance_state_enum.dart';
import 'package:fluffychat/pangea/choreographer/choreographer.dart';
import 'package:fluffychat/pangea/choreographer/choreographer_state_extension.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_state_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_status_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/replacement_type_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/span_choice_type_enum.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/choice_array.dart';
import 'package:fluffychat/pangea/common/widgets/feedback_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SpanCard extends StatefulWidget {
  final Choreographer choreographer;
  final Future Function(String) onFeedbackSubmitted;
  final VoidCallback close;

  const SpanCard({
    super.key,
    required this.choreographer,
    required this.onFeedbackSubmitted,
    required this.close,
  });

  @override
  State<SpanCard> createState() => SpanCardState();
}

class SpanCardState extends State<SpanCard> {
  final ScrollController scrollController = ScrollController();

  double? _previousOffset;
  Offset _slideFrom = const Offset(0.1, 0); // default slide from right

  @override
  void initState() {
    super.initState();
    widget.choreographer.addListener(_onAssistanceStateChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.choreographer.igcController.clearActiveMatch();
    });

    scrollController.dispose();
    widget.choreographer.removeListener(_onAssistanceStateChange);
    super.dispose();
  }

  ValueNotifier<PangeaMatchState?> get _activeMatch =>
      widget.choreographer.igcController.activeMatch;

  void _onAssistanceStateChange() {
    if (widget.choreographer.assistanceState != AssistanceStateEnum.fetched) {
      widget.close();
    }
  }

  Future<void> _onChoiceSelect(
    PangeaMatchState match,
    int index,
    PangeaMatchStatusEnum status,
  ) async {
    final choice = match.updatedMatch.match.choices?[index];
    final correct = choice?.type.isSuggestion == true;
    final selected = choice?.selected == true;

    match.selectChoice(index);
    setState(() {});

    if (!correct && !selected) return;
    await Future.delayed(
      Duration(milliseconds: 600),
      () => _updateMatch(match, status),
    );
  }

  Future<void> _updateMatch(
    PangeaMatchState match,
    PangeaMatchStatusEnum status,
  ) async {
    try {
      final igc = widget.choreographer.igcController;
      igc.updateMatchStatus(match, status);
      if (!status.isOpen) {
        igc.hasOpenMatches ? igc.setActiveMatch() : widget.close();
      }
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        level: SentryLevel.warning,
        data: {"match": match.toJson()},
      );
      widget.choreographer.clearMatches(e);
      return;
    }
  }

  Future<void> _showFeedbackDialog() async {
    final resp = await showDialog(
      context: context,
      builder: (context) => FeedbackDialog(
        title: L10n.of(context).spanFeedbackTitle,
        onSubmit: (feedback) => Navigator.of(context).pop(feedback),
      ),
    );
    if (resp == null || resp.isEmpty) {
      return;
    }

    await widget.onFeedbackSubmitted(resp);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.choreographer.igcController.matchUpdateStream.stream,
      builder: (context, _) => SizedBox(
        height: 200.0,
        child: ValueListenableBuilder(
          valueListenable: _activeMatch,
          builder: (context, match, _) {
            if (match == null) return SizedBox();

            final newOffset = match.updatedMatch.match.offset.toDouble();
            if (_previousOffset != null) {
              if (newOffset < _previousOffset!) {
                // Moving backward → slide from left
                _slideFrom = const Offset(-0.1, 0);
              } else if (newOffset > _previousOffset!) {
                // Moving forward → slide from right
                _slideFrom = const Offset(0.1, 0);
              }
            }
            _previousOffset = newOffset;

            return Column(
              mainAxisSize: .min,
              children: [
                SizedBox(
                  height: 40.0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Theme.of(context).iconTheme.color,
                        onPressed: widget.close,
                      ),
                      Expanded(
                        child: Text(
                          match.updatedMatch.match.type.displayName(context),
                          textAlign: TextAlign.center,
                          style: BotStyle.text(
                            context,
                            big: true,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.flag_outlined),
                        color: Theme.of(context).iconTheme.color,
                        onPressed: _showFeedbackDialog,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: _slideFrom,
                        end: Offset.zero,
                      ).animate(animation);

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: slideAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: _MatchContent(
                      key: ValueKey(match.hashCode),
                      match: match,
                      scrollController: scrollController,
                      onChoiceSelect: _onChoiceSelect,
                      onUpdateMatch: _updateMatch,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MatchContent extends StatelessWidget {
  final PangeaMatchState match;
  final ScrollController scrollController;
  final Future<void> Function(PangeaMatchState, int, PangeaMatchStatusEnum)
  onChoiceSelect;
  final Future<void> Function(PangeaMatchState, PangeaMatchStatusEnum)
  onUpdateMatch;

  const _MatchContent({
    super.key,
    required this.match,
    required this.scrollController,
    required this.onChoiceSelect,
    required this.onUpdateMatch,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = match.updatedMatch.status.isOpen;

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Column(
            spacing: 12.0,
            children: [
              Text(
                match.updatedMatch.match.message ??
                    match.updatedMatch.match.type.defaultPrompt(context),
                style: BotStyle.text(context),
                textAlign: TextAlign.center,
              ),
              isOpen
                  ? ChoicesArray(
                      isLoading: false,
                      choices: match.updatedMatch.match.choices?.map((e) {
                        return Choice(
                          text: e.value,
                          color: e.selected ? e.type.color : null,
                          isGold: e.type.isSuggestion,
                        );
                      }).toList(),
                      onPressed: (value, index) => onChoiceSelect(
                        match,
                        index,
                        PangeaMatchStatusEnum.accepted,
                      ),
                      selectedChoiceIndex:
                          match.updatedMatch.match.selectedChoiceIndex,
                      id: match.hashCode.toString(),
                      langCode: MatrixState
                          .pangeaController
                          .userController
                          .userL2Code!,
                    )
                  : Row(
                      spacing: 16.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(match.originalMatch.match.errorSpan),
                              const Icon(Icons.arrow_forward, size: 16.0),
                              Text(
                                match
                                        .updatedMatch
                                        .match
                                        .selectedChoice
                                        ?.value ??
                                    L10n.of(context).nothingFound,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Symbols.undo),
                          onPressed: () =>
                              onUpdateMatch(match, PangeaMatchStatusEnum.undo),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
