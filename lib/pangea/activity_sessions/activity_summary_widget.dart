import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/src/utils/markdown.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_participant_list.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_details_row.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';

class ActivitySummary extends StatelessWidget {
  final ActivityPlanModel activity;
  final Room? room;
  final Room? course;
  final Map<String, ActivityRoleModel>? assignedRoles;

  final bool showInstructions;
  final VoidCallback toggleInstructions;

  final Function(String)? onTapParticipant;
  final bool Function(String)? canSelectParticipant;
  final bool Function(String)? isParticipantSelected;
  final double Function(ActivityRoleModel?)? getParticipantOpacity;

  const ActivitySummary({
    super.key,
    required this.activity,
    required this.showInstructions,
    required this.toggleInstructions,
    this.assignedRoles,
    this.onTapParticipant,
    this.canSelectParticipant,
    this.isParticipantSelected,
    this.getParticipantOpacity,
    this.room,
    this.course,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        constraints: const BoxConstraints(
          maxWidth: FluffyThemes.columnWidth * 1.5,
        ),
        child: Column(
          spacing: 4.0,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return ImageByUrl(
                  imageUrl: activity.imageURL,
                  width: min(
                    constraints.maxWidth,
                    MediaQuery.sizeOf(context).height * 0.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                );
              },
            ),
            ActivityParticipantList(
              activity: activity,
              room: room,
              assignedRoles: room?.assignedRoles ?? assignedRoles ?? {},
              course: course,
              onTap: onTapParticipant,
              canSelect: canSelectParticipant,
              isSelected: isParticipantSelected,
              getOpacity: getParticipantOpacity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Column(
                spacing: 4.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InlineEllipsisText(
                    text: activity.description,
                    maxLines: showInstructions ? null : 2,
                    trailingWidth: 50.0,
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 12.0),
                    trailing: WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: TextButton(
                          onPressed: toggleInstructions,
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                          ),
                          child: Text(
                            showInstructions
                                ? L10n.of(context).less
                                : L10n.of(context).moreLabel,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (showInstructions) ...[
                    Row(
                      spacing: 8.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          activity.req.mode,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                        Row(
                          spacing: 4.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.school, size: 12.0),
                            Text(
                              activity.req.cefrLevel.string,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ActivitySessionDetailsRow(
                      icon: Symbols.target,
                      iconSize: 16.0,
                      child: Text(
                        activity.learningObjective,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                    ActivitySessionDetailsRow(
                      icon: Symbols.steps,
                      iconSize: 16.0,
                      child: Html(
                        data: markdown(activity.instructions),
                        style: {
                          "body": Style(
                            margin: Margins.all(0),
                            padding: HtmlPaddings.all(0),
                            fontSize: FontSize(12.0),
                          ),
                        },
                      ),
                    ),
                    ActivitySessionDetailsRow(
                      icon: Symbols.dictionary,
                      iconSize: 16.0,
                      child: Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: activity.vocab
                            .map(
                              (vocab) => Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withAlpha(
                                    20,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    24.0,
                                  ),
                                ),
                                child: Text(
                                  vocab.lemma,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InlineEllipsisText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextStyle? style;
  final WidgetSpan trailing;
  final double trailingWidth;

  const InlineEllipsisText({
    super.key,
    required this.text,
    required this.trailing,
    required this.trailingWidth,
    this.maxLines,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    final span = TextSpan(text: text, style: effectiveStyle);
    return LayoutBuilder(
      builder: (context, constraints) {
        final tp = TextPainter(
          text: span,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
          ellipsis: '…',
        );

        tp.layout(maxWidth: constraints.maxWidth);
        String truncated = text;
        if (tp.didExceedMaxLines && maxLines != null) {
          // Find cutoff point where text fits
          final pos = tp.getPositionForOffset(
            Offset(
              constraints.maxWidth - trailingWidth,
              tp.preferredLineHeight * maxLines!,
            ),
          );
          final endIndex = tp.getOffsetBefore(pos.offset) ?? text.length;
          truncated = '${text.substring(0, endIndex).trimRight()}…';
        }

        tp.dispose();
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(text: truncated, style: effectiveStyle),
              trailing, // always visible
            ],
          ),
          maxLines: maxLines,
          overflow: TextOverflow.clip, // prevent extra wrapping
        );
      },
    );
  }
}
