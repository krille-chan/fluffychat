import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_plan_search_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivitySuggestionCarousel extends StatefulWidget {
  final Function(
    ActivityPlanModel?,
    Uint8List? avatar,
    String? filename,
  ) onActivitySelected;
  final ActivityPlanModel? selectedActivity;
  final Uint8List? selectedActivityImage;
  final bool enabled;

  const ActivitySuggestionCarousel({
    required this.onActivitySelected,
    required this.selectedActivity,
    required this.selectedActivityImage,
    this.enabled = true,
    super.key,
  });

  @override
  ActivitySuggestionCarouselState createState() =>
      ActivitySuggestionCarouselState();
}

class ActivitySuggestionCarouselState
    extends State<ActivitySuggestionCarousel> {
  bool _isOpen = true;
  bool _loading = true;
  String? _error;

  double get _cardWidth => _isColumnMode ? 250.0 : 200.0;
  final double _cardHeight = 275.0;

  ActivityPlanModel? _currentActivity;
  final List<ActivityPlanModel> _activityItems = [];

  @override
  void initState() {
    super.initState();
    _setActivityItems();
  }

  Future<void> _setActivityItems() async {
    try {
      final ActivityPlanRequest request = ActivityPlanRequest(
        topic: "",
        mode: "",
        objective: "",
        media: MediaEnum.nan,
        cefrLevel: LanguageLevelTypeEnum.a1,
        languageOfInstructions: LanguageKeys.defaultLanguage,
        targetLanguage:
            MatrixState.pangeaController.languageController.userL2?.langCode ??
                LanguageKeys.defaultLanguage,
        numberOfParticipants: 3,
        count: 5,
      );
      final resp = await ActivitySearchRepo.get(request);
      _activityItems.addAll(resp.activityPlans);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      _currentActivity =
          _activityItems.isNotEmpty ? _activityItems.first : null;
      if (mounted) setState(() {});
    }
  }

  bool get _isColumnMode => FluffyThemes.isColumnMode(context);

  int? get _currentIndex {
    if (_currentActivity == null) return null;
    final index = _activityItems.indexOf(_currentActivity!);
    return index == -1 ? null : index;
  }

  bool get _canMoveLeft =>
      widget.enabled && _currentIndex != null && _currentIndex! > 0;

  bool get _canMoveRight =>
      widget.enabled &&
      _currentIndex != null &&
      _currentIndex! < _activityItems.length - 1;

  void _moveLeft() {
    if (!_canMoveLeft) return;
    _setActivityByIndex(_currentIndex! - 1);
  }

  void _moveRight() {
    if (!_canMoveRight) return;
    _setActivityByIndex(_currentIndex! + 1);
  }

  void _setActivityByIndex(int index) {
    if (index < 0 || index >= _activityItems.length) return;
    setState(() {
      _currentActivity = _activityItems[index];
    });
  }

  void _close() {
    widget.onActivitySelected(null, null, null);
    setState(() => _isOpen = false);
  }

  void _onClickCard() {
    if (widget.selectedActivity == _currentActivity) {
      widget.onActivitySelected(
        null,
        null,
        null,
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return ActivitySuggestionDialog(
          activity: _currentActivity!,
          buttonText: L10n.of(context).selectActivity,
          onLaunch: widget.onActivitySelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSize(
      duration: FluffyThemes.animationDuration,
      child: !_isOpen
          ? const SizedBox.shrink()
          : AnimatedOpacity(
              duration: FluffyThemes.animationDuration,
              opacity: widget.enabled ? 1.0 : 0.5,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16.0,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          L10n.of(context).newChatActivityTitle,
                          style: theme.textTheme.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: widget.enabled ? _close : null,
                        ),
                      ],
                    ),
                    Text(L10n.of(context).newChatActivityDesc),
                    Row(
                      spacing: _isColumnMode ? 16.0 : 4.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MouseRegion(
                          cursor: _canMoveLeft
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.basic,
                          child: GestureDetector(
                            onTap: _canMoveLeft ? _moveLeft : null,
                            child: Icon(
                              Icons.chevron_left_outlined,
                              size: 32.0,
                              color: _canMoveLeft ? null : theme.disabledColor,
                            ),
                          ),
                        ),
                        Container(
                          constraints:
                              BoxConstraints(maxHeight: _cardHeight + 12.0),
                          child: _error != null ||
                                  (_currentActivity == null && !_loading)
                              ? const SizedBox.shrink()
                              : _loading
                                  ? Shimmer.fromColors(
                                      baseColor: theme.colorScheme.primary
                                          .withAlpha(50),
                                      highlightColor: theme.colorScheme.primary
                                          .withAlpha(150),
                                      child: Container(
                                        height: _cardHeight,
                                        width: _cardWidth,
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.surfaceContainer,
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                        ),
                                      ),
                                    )
                                  : ActivitySuggestionCard(
                                      selected: widget.selectedActivity ==
                                          _currentActivity,
                                      activity: _currentActivity!,
                                      onPressed:
                                          widget.enabled ? _onClickCard : null,
                                      width: _cardWidth,
                                      height: _cardHeight,
                                      padding: 0.0,
                                      image: _currentActivity ==
                                              widget.selectedActivity
                                          ? widget.selectedActivityImage
                                          : null,
                                      onChange: () {
                                        if (mounted) setState(() {});
                                      },
                                    ),
                        ),
                        MouseRegion(
                          cursor: _canMoveRight
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.basic,
                          child: GestureDetector(
                            onTap: _canMoveRight ? _moveRight : null,
                            child: Icon(
                              Icons.chevron_right_outlined,
                              size: 32.0,
                              color: _canMoveRight ? null : theme.disabledColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16.0,
                      children: _activityItems.mapIndexed((i, activity) {
                        final selected = activity == _currentActivity;
                        return InkWell(
                          enableFeedback: widget.enabled,
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: widget.enabled
                              ? () => _setActivityByIndex(i)
                              : null,
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: selected ? 0.0 : 0.5,
                              sigmaY: selected ? 0.0 : 0.5,
                            ),
                            child: Opacity(
                              opacity: selected ? 1.0 : 0.5,
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(12.0),
                                  child: activity.imageURL != null
                                      ? CachedNetworkImage(
                                          imageUrl: activity.imageURL!,
                                          errorWidget: (context, url, error) {
                                            return CircleAvatar(
                                              backgroundColor:
                                                  theme.colorScheme.secondary,
                                              radius: 12.0,
                                            );
                                          },
                                          progressIndicatorBuilder:
                                              (context, url, progress) {
                                            return CircularProgressIndicator(
                                              value: progress.progress,
                                            );
                                          },
                                        )
                                      : CircleAvatar(
                                          backgroundColor:
                                              theme.colorScheme.secondary,
                                          radius: 12.0,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
