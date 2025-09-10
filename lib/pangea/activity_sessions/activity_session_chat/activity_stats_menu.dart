import 'dart:async';

import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_details_row.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

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
      .map((id) => id.lemma)
      .toSet();

  double get _percentVocabComplete {
    final vocabList = room.activityPlan?.vocabList ?? [];
    if (vocabList.isEmpty || _usedVocab == null) {
      return 0;
    }
    return _usedVocab!.intersection(vocabList.toSet()).length /
        vocabList.length;
  }

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

  int _getCompletedRolesCount() {
    final assignedRoles = room.assignedRoles;
    if (assignedRoles == null) return 0;

    // Filter out the bot and count only finished non-bot roles
    return assignedRoles.values
        .where(
          (role) => role.userId != BotName.byEnvironment && role.isFinished,
        )
        .length;
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
    String message = "";

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
      message = L10n.of(context).activityComplete;
    } else {
      //activity is ongoing
      if (_getCompletedRolesCount() == 0 ||
          (_getAssignedRolesCount() == 1) && (_isBotParticipant() == true)) {
        //IF nobodys done or you're only playing with the bot,
        //Then it should show tips about your progress and nudge you to continue/end
        if ((_percentVocabComplete < .7) && (_usedVocab?.length ?? 0) < 50) {
          message = L10n.of(context).haventChattedMuch;
        } else {
          message = L10n.of(context).haveChatted;
        }
      } else {
        //user is in group with other users OR someone has wrapped up
        if (userComplete) {
          //user is done but group is ongoing, no buttons
          message = L10n.of(context).userDoneAndWaiting(
            _getCompletedRolesCount(),
            _getAssignedRolesCount(),
          );
        } else {
          //user is not done, buttons are present
          message = L10n.of(context).othersDoneAndWaiting(
            _getCompletedRolesCount(),
            _getAssignedRolesCount(),
          );
        }
      }
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
                                ...room.activityPlan!.vocabList.map(
                                  (vocabWord) => VocabTile(
                                    vocabWord: vocabWord,
                                    isUsed:
                                        (_usedVocab ?? {}).contains(vocabWord),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        message,
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
  final String vocabWord;
  final bool isUsed;

  const VocabTile({
    super.key,
    required this.vocabWord,
    required this.isUsed,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isUsed ? AppConfig.goldLight.withAlpha(100) : Colors.transparent;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        vocabWord,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
