// shows n rows of activity suggestions vertically, where n is the number of rows
// as the user tries to scroll horizontally to the right, the client will fetch more activity suggestions

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_generator/media_enum.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_plan_search_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_search_enum.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivitySuggestionsArea extends StatefulWidget {
  final Axis? scrollDirection;
  final Room room;

  const ActivitySuggestionsArea({
    super.key,
    this.scrollDirection,
    required this.room,
  });
  @override
  ActivitySuggestionsAreaState createState() => ActivitySuggestionsAreaState();
}

class ActivitySuggestionsAreaState extends State<ActivitySuggestionsArea> {
  StreamSubscription? _languageStream;

  @override
  void initState() {
    super.initState();
    _setActivityItems();

    _languageStream ??= MatrixState
        .pangeaController.userController.languageStream.stream
        .listen((update) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _setActivityItems(),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _languageStream?.cancel();
    super.dispose();
  }

  // _loading is true when _setActivityItems is currently requesting activities
  bool _loading = true;
  ActivitySearchEnum _status = ActivitySearchEnum.waiting;

  bool get _isColumnMode => FluffyThemes.isColumnMode(context);

  final List<ActivityPlanModel> _activityItems = [];
  final ScrollController _scrollController = ScrollController();
  double get cardHeight => _isColumnMode ? 325.0 : 250.0;
  double get cardWidth => _isColumnMode ? 225.0 : 150.0;

  String get instructionLanguage =>
      MatrixState.pangeaController.languageController.userL1?.langCode ??
      LanguageKeys.defaultLanguage;
  String get targetLanguage =>
      MatrixState.pangeaController.languageController.userL2?.langCode ??
      LanguageKeys.defaultLanguage;

  ActivityPlanRequest get _request {
    return ActivityPlanRequest(
      topic: "",
      mode: "",
      objective: "",
      media: MediaEnum.nan,
      cefrLevel: LanguageLevelTypeEnum.a1,
      languageOfInstructions: instructionLanguage,
      targetLanguage: targetLanguage,
      numberOfParticipants: 3,
      count: 5,
    );
  }

  Future<void> _setActivityItems({int retries = 0}) async {
    if (retries > 3) {
      if (mounted) {
        setState(() {
          _status = ActivitySearchEnum.timeout;
          _loading = false;
        });
      }
      return;
    }

    try {
      if (retries == 0 && mounted) {
        setState(() {
          _activityItems.clear();
          _loading = true;
          _status = ActivitySearchEnum.waiting;
        });
      }

      final resp = await ActivitySearchRepo.get(_request).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          if (mounted) setState(() => _status = ActivitySearchEnum.timeout);

          Future.delayed(const Duration(seconds: 5), () {
            if (mounted) _setActivityItems(retries: retries + 1);
          });

          return Future<ActivityPlanResponseWrapper>.error(
            TimeoutException(
              L10n.of(context).activitySuggestionTimeoutMessage,
            ),
          );
        },
      );
      _activityItems.addAll(resp.response.activityPlans);
      _status = _status.fromCode(resp.statusCode);
      if (_status != ActivitySearchEnum.error) {
        if (_activityItems.isEmpty) {
          if (mounted) setState(() => _status = ActivitySearchEnum.timeout);

          Future.delayed(const Duration(seconds: 5), () {
            if (mounted) _setActivityItems(retries: retries + 1);
          });
        } else {
          if (mounted) setState(() => _loading = false);
        }
      }
    } on TimeoutException {
      rethrow;
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'retries': retries,
          'request': _request.toJson(),
        },
        level: SentryLevel.warning,
      );
    }
  }

  void _onReplaceActivity(int index, ActivityPlanModel a) {
    setState(() => _activityItems[index] = a);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Show all loaded activities, or a loading view if there are none
    final List<Widget> cards = _activityItems.isEmpty
        ? List.generate(5, (i) {
            return Shimmer.fromColors(
              baseColor: theme.colorScheme.primary.withAlpha(20),
              highlightColor: theme.colorScheme.primary.withAlpha(50),
              child: Container(
                height: cardHeight,
                width: cardWidth,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            );
          })
        : _activityItems
            .mapIndexed((index, activity) {
              return ActivitySuggestionCard(
                activity: activity,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ActivityPlannerBuilder(
                        initialActivity: activity,
                        room: widget.room,
                        builder: (controller) {
                          return ActivitySuggestionDialog(
                            controller: controller,
                            buttonText: L10n.of(context).saveAndLaunch,
                            replaceActivity: (a) =>
                                _onReplaceActivity(index, a),
                          );
                        },
                      );
                    },
                  );
                },
                width: cardWidth,
                height: cardHeight,
                onChange: () {
                  if (mounted) setState(() {});
                },
              );
            })
            .cast<Widget>()
            .toList();

    final scrollDirection = widget.scrollDirection ??
        (_isColumnMode ? Axis.horizontal : Axis.vertical);

    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: FluffyThemes.animationDuration,
          child: _status.hideCards
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 16.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Text(
                          _status.message(L10n.of(context)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (_loading && _status == ActivitySearchEnum.timeout)
                        const CircularProgressIndicator(),
                      if (!_loading && _status == ActivitySearchEnum.timeout)
                        ElevatedButton(
                          onPressed: _setActivityItems,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            foregroundColor:
                                theme.colorScheme.onPrimaryContainer,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                          ),
                          child: Text(L10n.of(context).tryAgain),
                        ),
                    ],
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(),
                  child: Column(
                    children: [
                      scrollDirection == Axis.horizontal
                          ? Scrollbar(
                              thumbVisibility: true,
                              controller: _scrollController,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    spacing: 8.0,
                                    children: cards,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                runSpacing: 16.0,
                                spacing: 4.0,
                                children: cards,
                              ),
                            ),
                      if (cards.length < 5)
                        Padding(
                          padding: const EdgeInsetsGeometry.all(16.0),
                          child: ErrorIndicator(
                            message: _status.message(L10n.of(context)),
                          ),
                        ),
                      if (cards.length < 5 && _loading)
                        const CircularProgressIndicator(),
                      if (cards.length < 5 && !_loading)
                        Padding(
                          padding: const EdgeInsetsGeometry.only(bottom: 16),
                          child: ElevatedButton(
                            onPressed: _setActivityItems,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              foregroundColor:
                                  theme.colorScheme.onPrimaryContainer,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                            ),
                            child: Text(L10n.of(context).tryAgain),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
