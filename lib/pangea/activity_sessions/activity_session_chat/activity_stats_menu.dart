import 'dart:async';

import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_details_row.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/word_zoom_widget.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityStatsMenu extends StatefulWidget {
  final ChatController controller;
  const ActivityStatsMenu(
    this.controller, {
    super.key,
  });

  @override
  State<ActivityStatsMenu> createState() => ActivityStatsMenuState();
}

class ActivityStatsMenuState extends State<ActivityStatsMenu> {
  ActivitySummaryAnalyticsModel? analytics;
  Room get room => widget.controller.room;

  StreamSubscription? _analyticsSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateUsedVocab();
    });

    _analyticsSubscription = widget
        .controller.pangeaController.getAnalytics.analyticsStream.stream
        .listen((_) {
      _updateUsedVocab();
    });
  }

  @override
  void dispose() {
    _analyticsSubscription?.cancel();
    super.dispose();
  }

  Set<String>? get _usedVocab => analytics?.constructs[room.client.userID!]
      ?.constructsOfType(ConstructTypeEnum.vocab)
      .map((id) => id.lemma.toLowerCase())
      .toSet();

  Future<void> _updateUsedVocab() async {
    final analytics = await room.getActivityAnalytics();
    if (mounted) {
      setState(() => this.analytics = analytics);
    }
  }

  int _getAssignedRolesCount() {
    final assignedRoles = room.assignedRoles;
    if (assignedRoles == null) return 0;
    final nonBotRoles = assignedRoles.values.where(
      (role) => role.userId != BotName.byEnvironment,
    );

    return nonBotRoles.length;
  }

  bool _isBotParticipant() {
    final assignedRoles = room.assignedRoles;
    if (assignedRoles == null) return false;
    return assignedRoles.values.any(
      (role) => role.userId == BotName.byEnvironment,
    );
  }

  Future<void> _finishActivity({bool forAll = false}) async {
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        forAll
            ? await room.finishActivityForAll()
            : await room.finishActivity();
        if (mounted) {
          widget.controller.setShowDropdown(false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!room.showActivityChatUI) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    // Completion status variables
    final bool userComplete = room.hasCompletedActivity;
    final bool activityComplete = room.activityIsFinished;
    bool shouldShowEndForAll = true;
    bool shouldShowImDone = true;

    if (!room.isRoomAdmin) {
      shouldShowEndForAll = false;
    }

    //dont need endforall if only w bot
    if ((_getAssignedRolesCount() == 1) && (_isBotParticipant() == true)) {
      shouldShowEndForAll = false;
    }

    if (activityComplete) {
      //activity is finished, no buttons
      shouldShowImDone = false;
      shouldShowEndForAll = false;
    }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: widget.controller.showActivityDropdown ? 0 : null,
      child: Column(
        children: [
          ClipRect(
            child: AnimatedAlign(
              duration: FluffyThemes.animationDuration,
              curve: Curves.easeInOut,
              heightFactor: widget.controller.showActivityDropdown ? 1.0 : 0.0,
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy < -2) {
                    widget.controller.setShowDropdown(false);
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 12.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        spacing: 8.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ActivitySessionDetailsRow(
                            icon: Symbols.radar,
                            iconSize: 16.0,
                            child: Text(
                              room.activityPlan!.learningObjective,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                          ActivitySessionDetailsRow(
                            icon: Symbols.dictionary,
                            iconSize: 16.0,
                            child: Wrap(
                              spacing: 4.0,
                              runSpacing: 4.0,
                              children: [
                                ...room.activityPlan!.vocab.map(
                                  (v) => VocabTile(
                                    vocab: v,
                                    langCode:
                                        room.activityPlan!.req.targetLanguage,
                                    isUsed: (_usedVocab ?? {})
                                        .contains(v.lemma.toLowerCase()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        L10n.of(context).activityDropdownDesc,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!userComplete) ...[
                        if (shouldShowEndForAll)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              side: BorderSide(
                                color: theme.colorScheme.secondaryContainer,
                                width: 2,
                              ),
                              foregroundColor: theme.colorScheme.primary,
                              backgroundColor: theme.colorScheme.surface,
                            ),
                            onPressed: () => _finishActivity(forAll: true),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  L10n.of(context).endForAll,
                                  style: TextStyle(
                                    fontSize: isColumnMode ? 16.0 : 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (shouldShowImDone)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                            ),
                            onPressed: _finishActivity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  L10n.of(context).endActivityTitle,
                                  style: TextStyle(
                                    fontSize: isColumnMode ? 16.0 : 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (widget.controller.showActivityDropdown)
            Expanded(
              child: GestureDetector(
                onTap: () => widget.controller.setShowDropdown(false),
                child: Container(color: Colors.black.withAlpha(100)),
              ),
            ),
        ],
      ),
    );
  }
}

class VocabTile extends StatelessWidget {
  final Vocab vocab;
  final String langCode;
  final bool isUsed;

  const VocabTile({
    super.key,
    required this.vocab,
    required this.langCode,
    required this.isUsed,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isUsed ? AppConfig.goldLight.withAlpha(100) : Colors.transparent;
    return CompositedTransformTarget(
      link: MatrixState.pAnyState
          .layerLinkAndKey(
            "activity-vocab-${vocab.lemma}",
          )
          .link,
      child: InkWell(
        key: MatrixState.pAnyState
            .layerLinkAndKey(
              "activity-vocab-${vocab.lemma}",
            )
            .key,
        borderRadius: BorderRadius.circular(
          24.0,
        ),
        onTap: () {
          OverlayUtil.showPositionedCard(
            overlayKey: "activity-vocab-${vocab.lemma}",
            context: context,
            cardToShow: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4.0,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppConfig.borderRadius),
                  ),
                ),
                child: WordZoomWidget(
                  token: PangeaTokenText(
                    content: vocab.lemma,
                    length: vocab.lemma.characters.length,
                    offset: 0,
                  ),
                  construct: ConstructIdentifier(
                    lemma: vocab.lemma,
                    type: ConstructTypeEnum.vocab,
                    category: vocab.pos,
                  ),
                  langCode: langCode,
                  onClose: () {
                    MatrixState.pAnyState.closeOverlay(
                      "activity-vocab-${vocab.lemma}",
                    );
                  },
                ),
              ),
            ),
            transformTargetId: "activity-vocab-${vocab.lemma}",
            closePrevOverlay: false,
            addBorder: false,
            maxWidth: AppConfig.toolbarMinWidth,
            maxHeight: AppConfig.toolbarMaxHeight,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            vocab.lemma,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
