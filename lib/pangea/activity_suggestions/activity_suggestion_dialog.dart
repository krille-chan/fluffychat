import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_generator/activity_plan_generation_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog_content.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';

class ActivitySuggestionDialog extends StatefulWidget {
  final ActivityPlannerBuilderState controller;
  final String buttonText;

  final Function(ActivityPlanModel)? replaceActivity;

  const ActivitySuggestionDialog({
    required this.controller,
    required this.buttonText,
    this.replaceActivity,
    super.key,
  });

  @override
  ActivitySuggestionDialogState createState() =>
      ActivitySuggestionDialogState();
}

class ActivitySuggestionDialogState extends State<ActivitySuggestionDialog> {
  bool _loading = false;
  String? _regenerateError;
  String? _launchError;

  double get _width => FluffyThemes.isColumnMode(context)
      ? 400.0
      : MediaQuery.of(context).size.width;

  Future<void> launchActivity() async {
    try {
      if (!widget.controller.room.isSpace) {
        throw Exception(
          "Cannot launch activity in a non-space room",
        );
      }

      setState(() {
        _loading = true;
        _regenerateError = null;
        _launchError = null;
      });

      await widget.controller.launchToSpace();
      context.go("/rooms?spaceId=${widget.controller.room.id}");
      Navigator.of(context).pop();
    } catch (e, s) {
      _launchError = L10n.of(context).errorLaunchActivityMessage;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "request": widget.controller.updatedRequest.toJson(),
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> onRegenerate() async {
    setState(() {
      _loading = true;
      _regenerateError = null;
      _launchError = null;
    });

    try {
      final resp = await ActivityPlanGenerationRepo.get(
        widget.controller.updatedRequest,
        force: true,
      );
      final plan = resp.activityPlans.firstOrNull;
      if (plan == null) {
        throw Exception("No activity plan generated");
      }

      widget.replaceActivity?.call(plan);
      await widget.controller.overrideActivity(plan);
    } catch (e, s) {
      _regenerateError = L10n.of(context).errorRegenerateActivityMessage;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "request": widget.controller.updatedRequest.toJson(),
        },
      );
      return;
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _resetActivity() {
    widget.controller.resetActivity();
    setState(() {
      _loading = false;
      _regenerateError = null;
      _launchError = null;
    });
  }

  ButtonStyle get buttonStyle => ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
      );

  double get width => FluffyThemes.isColumnMode(context)
      ? 400.0
      : MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = this.buttonStyle;

    final body = Stack(
      alignment: Alignment.topCenter,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
          ),
          child: Builder(
            builder: (context) {
              if (_regenerateError != null || _launchError != null) {
                return Center(
                  child: Column(
                    spacing: 16.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ErrorIndicator(
                        message: _regenerateError ?? _launchError!,
                      ),
                      if (_regenerateError != null)
                        Row(
                          spacing: 8.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: onRegenerate,
                              style: buttonStyle,
                              child: Text(L10n.of(context).tryAgain),
                            ),
                            ElevatedButton(
                              onPressed: _resetActivity,
                              style: buttonStyle,
                              child: Text(L10n.of(context).reset),
                            ),
                          ],
                        )
                      else
                        ElevatedButton(
                          onPressed: launchActivity,
                          style: buttonStyle,
                          child: Text(L10n.of(context).tryAgain),
                        ),
                    ],
                  ),
                );
              }

              if (_loading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              return Form(
                key: widget.controller.formKey,
                child: ActivitySuggestionDialogContent(controller: this),
              );
            },
          ),
        ),
        Positioned(
          top: 4.0,
          left: 4.0,
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surface.withAlpha(170),
            ),
            icon: Icon(
              Icons.close_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: Navigator.of(context).pop,
            tooltip: L10n.of(context).close,
          ),
        ),
      ],
    );

    return FullWidthDialog(
      dialogContent: body,
      maxWidth: _width,
      maxHeight: 650.0,
    );
  }
}

class NumberCounter extends StatelessWidget {
  final int count;
  final Function(int) update;

  final int? min;
  final int? max;

  const NumberCounter({
    super.key,
    required this.count,
    required this.update,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        spacing: 4.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            iconSize: 24.0,
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(0.0),
            ),
            onPressed: min == null || count - 1 >= min!
                ? () {
                    if (count > 0) {
                      update(count - 1);
                    }
                  }
                : null,
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 24.0,
            style: max == null || count + 1 <= max!
                ? IconButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                  )
                : null,
            onPressed: max == null || count + 1 <= max!
                ? () {
                    update(count + 1);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
