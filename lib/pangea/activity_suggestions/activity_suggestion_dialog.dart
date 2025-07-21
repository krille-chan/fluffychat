import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_generation_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_room_selection.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card_row.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/language_level_dropdown.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

enum _PageMode {
  activity,
  roomSelection,
}

class ActivitySuggestionDialog extends StatefulWidget {
  final ActivityPlannerBuilderState controller;
  final String buttonText;

  final VoidCallback? onLaunch;
  final Function(ActivityPlanModel)? replaceActivity;

  const ActivitySuggestionDialog({
    required this.controller,
    required this.buttonText,
    this.onLaunch,
    this.replaceActivity,
    super.key,
  });

  @override
  ActivitySuggestionDialogState createState() =>
      ActivitySuggestionDialogState();
}

class ActivitySuggestionDialogState extends State<ActivitySuggestionDialog> {
  _PageMode _pageMode = _PageMode.activity;

  bool _loading = false;
  Object? _error;

  double get _width => FluffyThemes.isColumnMode(context)
      ? 400.0
      : MediaQuery.of(context).size.width;

  Future<void> _launchActivity() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      if (widget.onLaunch != null) {
        widget.onLaunch!.call();
        Navigator.of(context).pop();
      } else if (widget.controller.room != null &&
          !widget.controller.room!.isSpace) {
        final resp = await showFutureLoadingDialog(
          context: context,
          future: widget.controller.launchToRoom,
        );
        if (!resp.isError) {
          context.go("/rooms/${widget.controller.room!.id}");
          Navigator.of(context).pop();
        }
      } else {
        _setPageMode(_PageMode.roomSelection);
      }
    } catch (e, s) {
      _error = e;
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

  void _setPageMode(_PageMode mode) {
    setState(() {
      _pageMode = mode;
    });
  }

  Future<void> _onRegenerate() async {
    setState(() {
      _loading = true;
      _error = null;
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
      _error = e;
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
      _pageMode = _PageMode.activity;
      _loading = false;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primaryContainer,
      foregroundColor: theme.colorScheme.onPrimaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
    );

    final body = Stack(
      alignment: Alignment.topCenter,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
          ),
          child: Builder(
            builder: (context) {
              if (_pageMode == _PageMode.activity) {
                if (_error != null) {
                  return Center(
                    child: Column(
                      spacing: 16.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ErrorIndicator(
                          message:
                              L10n.of(context).errorRegenerateActivityMessage,
                        ),
                        Row(
                          spacing: 8.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: _onRegenerate,
                              style: buttonStyle,
                              child: Text(L10n.of(context).tryAgain),
                            ),
                            ElevatedButton(
                              onPressed: _resetActivity,
                              style: buttonStyle,
                              child: Text(L10n.of(context).reset),
                            ),
                          ],
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            spacing: 8.0,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24.0),
                                    width: (_width / 2) + 42.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: widget.controller.avatar != null
                                          ? Image.memory(
                                              widget.controller.avatar!,
                                              fit: BoxFit.cover,
                                            )
                                          : widget.controller.updatedActivity
                                                      .imageURL !=
                                                  null
                                              ? widget.controller
                                                      .updatedActivity.imageURL!
                                                      .startsWith("mxc")
                                                  ? MxcImage(
                                                      uri: Uri.parse(
                                                        widget
                                                            .controller
                                                            .updatedActivity
                                                            .imageURL!,
                                                      ),
                                                      width: _width / 2,
                                                      height: 200,
                                                      cacheKey: widget
                                                          .controller
                                                          .updatedActivity
                                                          .bookmarkId,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: widget
                                                          .controller
                                                          .updatedActivity
                                                          .imageURL!,
                                                      fit: BoxFit.cover,
                                                      placeholder: (
                                                        context,
                                                        url,
                                                      ) =>
                                                          const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (
                                                        context,
                                                        url,
                                                        error,
                                                      ) =>
                                                          const SizedBox(),
                                                    )
                                              : null,
                                    ),
                                  ),
                                  if (widget.controller.isEditing)
                                    InkWell(
                                      borderRadius: BorderRadius.circular(90),
                                      onTap: widget.controller.selectAvatar,
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        radius: 20.0,
                                        child: Icon(
                                          Icons.add_a_photo_outlined,
                                          size: 20.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    if (widget.controller.isEditing)
                                      ActivitySuggestionCardRow(
                                        icon: Icons.event_note_outlined,
                                        child: TextFormField(
                                          controller:
                                              widget.controller.titleController,
                                          decoration: InputDecoration(
                                            labelText:
                                                L10n.of(context).activityTitle,
                                          ),
                                          maxLines: 2,
                                          minLines: 1,
                                        ),
                                      )
                                    else
                                      ActivitySuggestionCardRow(
                                        icon: Icons.event_note_outlined,
                                        child: Text(
                                          widget
                                              .controller.updatedActivity.title,
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    if (widget.controller.isEditing)
                                      ActivitySuggestionCardRow(
                                        icon: Symbols.target,
                                        child: TextFormField(
                                          controller: widget.controller
                                              .learningObjectivesController,
                                          decoration: InputDecoration(
                                            labelText: L10n.of(context)
                                                .learningObjectiveLabel,
                                          ),
                                          maxLines: 4,
                                          minLines: 1,
                                        ),
                                      )
                                    else
                                      ActivitySuggestionCardRow(
                                        icon: Symbols.target,
                                        child: Text(
                                          widget.controller.updatedActivity
                                              .learningObjective,
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ),
                                    if (widget.controller.isEditing)
                                      ActivitySuggestionCardRow(
                                        icon: Symbols.steps,
                                        child: TextFormField(
                                          controller: widget.controller
                                              .instructionsController,
                                          decoration: InputDecoration(
                                            labelText:
                                                L10n.of(context).instructions,
                                          ),
                                          maxLines: 8,
                                          minLines: 1,
                                        ),
                                      )
                                    else
                                      ActivitySuggestionCardRow(
                                        icon: Symbols.steps,
                                        child: Text(
                                          widget.controller.updatedActivity
                                              .instructions,
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ),
                                    if (widget.controller.isEditing)
                                      ActivitySuggestionCardRow(
                                        icon: Icons.group_outlined,
                                        child: TextFormField(
                                          controller: widget.controller
                                              .participantsController,
                                          decoration: InputDecoration(
                                            labelText:
                                                L10n.of(context).classRoster,
                                          ),
                                          maxLines: 1,
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return null;
                                            }

                                            try {
                                              final val = int.parse(value);
                                              if (val <= 0) {
                                                return L10n.of(context)
                                                    .pleaseEnterInt;
                                              }
                                              if (val > 50) {
                                                return L10n.of(context)
                                                    .maxFifty;
                                              }
                                            } catch (e) {
                                              return L10n.of(context)
                                                  .pleaseEnterANumber;
                                            }
                                            return null;
                                          },
                                        ),
                                      )
                                    else
                                      ActivitySuggestionCardRow(
                                        icon: Icons.group_outlined,
                                        child: Text(
                                          L10n.of(context).countParticipants(
                                            widget.controller.updatedActivity
                                                .req.numberOfParticipants,
                                          ),
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ),
                                    if (widget.controller.isEditing)
                                      ActivitySuggestionCardRow(
                                        icon: Icons.school_outlined,
                                        child: LanguageLevelDropdown(
                                          initialLevel:
                                              widget.controller.languageLevel,
                                          onChanged: widget
                                              .controller.setLanguageLevel,
                                        ),
                                      )
                                    else
                                      ActivitySuggestionCardRow(
                                        icon: Icons.school_outlined,
                                        child: Text(
                                          widget.controller.updatedActivity.req
                                              .cefrLevel
                                              .title(context),
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ),
                                    if (widget.controller.isEditing)
                                      ActivitySuggestionCardRow(
                                        icon: Symbols.dictionary,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxHeight: 60.0,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Wrap(
                                              spacing: 4.0,
                                              runSpacing: 4.0,
                                              children: widget.controller.vocab
                                                  .mapIndexed(
                                                    (i, vocab) => Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 8.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: theme
                                                            .colorScheme.primary
                                                            .withAlpha(
                                                          20,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          24.0,
                                                        ),
                                                      ),
                                                      child: MouseRegion(
                                                        cursor:
                                                            SystemMouseCursors
                                                                .click,
                                                        child: GestureDetector(
                                                          onTap: () => widget
                                                              .controller
                                                              .removeVocab(
                                                            i,
                                                          ),
                                                          child: Row(
                                                            spacing: 4.0,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                vocab.lemma,
                                                              ),
                                                              const Icon(
                                                                Icons.close,
                                                                size: 12.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      ActivitySuggestionCardRow(
                                        icon: Symbols.dictionary,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxHeight: 60.0,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Wrap(
                                              spacing: 4.0,
                                              runSpacing: 4.0,
                                              children: widget.controller.vocab
                                                  .map(
                                                    (vocab) => Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 8.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: theme
                                                            .colorScheme.primary
                                                            .withAlpha(
                                                          20,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          24.0,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        vocab.lemma,
                                                        style: theme.textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (widget.controller.isEditing)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          spacing: 4.0,
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: widget
                                                    .controller.vocabController,
                                                decoration: InputDecoration(
                                                  hintText: L10n.of(
                                                    context,
                                                  ).addVocabulary,
                                                ),
                                                maxLines: 1,
                                                onFieldSubmitted: (_) => widget
                                                    .controller
                                                    .addVocab(),
                                              ),
                                            ),
                                            IconButton(
                                              padding: const EdgeInsets.all(
                                                0.0,
                                              ),
                                              constraints:
                                                  const BoxConstraints(), // override default min size of 48px
                                              iconSize: 16.0,
                                              icon: const Icon(
                                                Icons.add_outlined,
                                              ),
                                              onPressed:
                                                  widget.controller.addVocab,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: widget.controller.isEditing
                            ? Row(
                                spacing: 12.0,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: buttonStyle,
                                      onPressed: widget.controller.saveEdits,
                                      child: Row(
                                        children: [
                                          const Icon(Icons.save),
                                          Expanded(
                                            child: Text(
                                              L10n.of(context).save,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: buttonStyle,
                                      onPressed: widget.controller.clearEdits,
                                      child: Row(
                                        children: [
                                          const Icon(Icons.cancel),
                                          Expanded(
                                            child: Text(
                                              L10n.of(context).cancel,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                spacing: 12.0,
                                children: [
                                  Row(
                                    spacing: 12.0,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: buttonStyle,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.edit),
                                              Expanded(
                                                child: Text(
                                                  L10n.of(context).edit,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () => widget.controller
                                              .setEditing(true),
                                        ),
                                      ),
                                      if (widget.replaceActivity != null)
                                        Expanded(
                                          child: ElevatedButton(
                                            style: buttonStyle,
                                            onPressed: _onRegenerate,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.lightbulb_outline,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    L10n.of(context).regenerate,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: buttonStyle,
                                          onPressed: _launchActivity,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.send),
                                              Expanded(
                                                child: Text(
                                                  L10n.of(context)
                                                      .launchActivityButton,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                );
              }

              return ActivityRoomSelection(
                controller: widget.controller,
                backButton: BackButton(
                  onPressed: () => _setPageMode(
                    _PageMode.activity,
                  ),
                ),
              );
            },
          ),
        ),
        if (_pageMode == _PageMode.activity)
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
