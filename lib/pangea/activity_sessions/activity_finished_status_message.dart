import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_participant_indicator.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_results_carousel.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class ActivityFinishedStatusMessage extends StatefulWidget {
  final Room room;

  const ActivityFinishedStatusMessage({
    super.key,
    required this.room,
  });

  @override
  ActivityFinishedStatusMessageState createState() =>
      ActivityFinishedStatusMessageState();
}

class ActivityFinishedStatusMessageState
    extends State<ActivityFinishedStatusMessage> {
  ActivityRoleModel? _highlightedRole;
  bool _expanded = true;

  @override
  void initState() {
    super.initState();
    _setDefaultHighlightedRole();

    if (widget.room.activityIsFinished && widget.room.activitySummary == null) {
      widget.room.fetchSummaries();
    }
  }

  @override
  void didUpdateWidget(ActivityFinishedStatusMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setDefaultHighlightedRole();
  }

  Map<String, ActivityRole> get _roles => widget.room.activityPlan?.roles ?? {};

  void _setExpanded(bool expanded) {
    if (mounted) setState(() => _expanded = expanded);
  }

  int get _hightlightedRoleIndex {
    if (_highlightedRole == null) {
      return -1; // No highlighted role
    }
    return rolesWithSummaries.indexOf(_highlightedRole!);
  }

  void _setDefaultHighlightedRole() {
    if (_hightlightedRoleIndex >= 0) return;

    final roles = rolesWithSummaries;
    _highlightedRole = roles.firstWhereOrNull(
      (r) => r.userId == widget.room.client.userID,
    );

    if (_highlightedRole == null && roles.isNotEmpty) {
      _highlightedRole = roles.first;
    }

    if (mounted) setState(() {});
  }

  void _highlightRole(ActivityRoleModel role) {
    if (mounted) setState(() => _highlightedRole = role);
  }

  bool get _canMoveLeft =>
      _hightlightedRoleIndex > 0 && _highlightedRole != null;

  bool get _canMoveRight =>
      _hightlightedRoleIndex < rolesWithSummaries.length - 1 &&
      _highlightedRole != null;

  void _moveLeft() {
    if (_hightlightedRoleIndex > 0) {
      _highlightRole(rolesWithSummaries[_hightlightedRoleIndex - 1]);
    }
  }

  void _moveRight() {
    if (_hightlightedRoleIndex < rolesWithSummaries.length - 1) {
      _highlightRole(rolesWithSummaries[_hightlightedRoleIndex + 1]);
    }
  }

  Future<void> _archiveToAnalytics() async {
    await widget.room.archiveActivity();
    await MatrixState.pangeaController.putAnalytics
        .sendActivityAnalytics(widget.room.id);
  }

  List<ActivityRoleModel> get rolesWithSummaries {
    if (widget.room.activitySummary?.summary == null) {
      return <ActivityRoleModel>[];
    }

    final roles = widget.room.activityRoles;
    return roles?.roles.values.where((role) {
          return widget.room.activitySummary!.summary!.participants.any(
            (p) => p.participantId == role.userId,
          );
        }).toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.room.activitySummary;
    final imageURL = widget.room.activityPlan!.imageURL;

    final theme = Theme.of(context);
    final isColumnMode = MediaQuery.of(context).size.width < 600;

    final user = widget.room.getParticipants().firstWhereOrNull(
          (u) => u.id == _highlightedRole?.userId,
        );

    final userSummary =
        widget.room.activitySummary?.summary?.participants.firstWhereOrNull(
      (p) => p.participantId == _highlightedRole!.userId,
    );

    return AnimatedSize(
      duration: FluffyThemes.animationDuration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _expanded
            ? [
                if (summary?.summary != null) ...[
                  IconButton(
                    icon: Icon(
                      Icons.expand_more,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => _setExpanded(!_expanded),
                  ),
                  const SizedBox(height: 8.0),
                  if (imageURL != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: imageURL.startsWith("mxc")
                          ? MxcImage(
                              uri: Uri.parse(imageURL),
                              width: 100.0,
                              height: 100.0,
                              cacheKey: widget.room.activityPlan!.bookmarkId,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: imageURL,
                              fit: BoxFit.cover,
                              width: 100.0,
                              height: 100.0,
                              placeholder: (
                                context,
                                url,
                              ) =>
                                  const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (
                                context,
                                url,
                                error,
                              ) =>
                                  const SizedBox(),
                            ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      summary!.summary!.summary,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isColumnMode ? 16.0 : 12.0,
                      ),
                    ),
                  ),
                  if (_highlightedRole != null && userSummary != null)
                    ActivityResultsCarousel(
                      selectedRole: _highlightedRole!,
                      moveLeft: _canMoveLeft ? _moveLeft : null,
                      moveRight: _canMoveRight ? _moveRight : null,
                      user: user,
                      summary: userSummary,
                    ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: rolesWithSummaries.map(
                      (role) {
                        final user =
                            widget.room.getParticipants().firstWhereOrNull(
                                  (u) => u.id == role.userId,
                                );

                        return ActivityParticipantIndicator(
                          availableRole: _roles[role.id]!,
                          avatarUrl: _roles[role.id]?.avatarUrl ??
                              user?.avatarUrl?.toString(),
                          onTap: _highlightedRole == role
                              ? null
                              : () => _highlightRole(role),
                          assignedRole: role,
                          selected: _highlightedRole == role,
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 20.0),
                ] else if (summary?.isLoading ?? false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 8.0,
                      children: [
                        const CircularProgressIndicator.adaptive(),
                        Text(L10n.of(context).loadingActivitySummary),
                      ],
                    ),
                  )
                else if (summary?.hasError ?? false)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 8.0,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.school_outlined,
                              size: 24.0,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                L10n.of(context).activitySummaryError,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => widget.room.fetchSummaries(),
                          child: Text(L10n.of(context).requestSummaries),
                        ),
                      ],
                    ),
                  ),
                if (!widget.room.isHiddenActivityRoom)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                    onPressed: () async {
                      final resp = await showFutureLoadingDialog(
                        context: context,
                        future: _archiveToAnalytics,
                      );

                      if (!resp.isError) {
                        context.go(
                          "/rooms/analytics?mode=activities",
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(L10n.of(context).archiveToAnalytics),
                      ],
                    ),
                  ),
              ]
            : [
                if (summary != null)
                  IconButton(
                    icon: Icon(
                      Icons.expand_less,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => _setExpanded(!_expanded),
                  ),
              ],
      ),
    );
  }
}
