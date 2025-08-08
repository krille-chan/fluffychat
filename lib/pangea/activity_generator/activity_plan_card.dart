import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/language_level_dropdown.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class ActivityPlanCard extends StatefulWidget {
  final VoidCallback regenerate;
  final ActivityPlannerBuilderState controller;

  const ActivityPlanCard({
    super.key,
    required this.regenerate,
    required this.controller,
  });

  @override
  ActivityPlanCardState createState() => ActivityPlanCardState();
}

class ActivityPlanCardState extends State<ActivityPlanCard> {
  static const double itemPadding = 12;

  Future<ActivityPlanModel> _addBookmark(ActivityPlanModel activity) async {
    try {
      return BookmarkedActivitiesRepo.save(activity);
    } catch (e, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: stack, data: activity.toJson());
      return activity; // Return the original activity in case of error
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _removeBookmark() async {
    try {
      BookmarkedActivitiesRepo.remove(
        widget.controller.updatedActivity.bookmarkId,
      );
    } catch (e, stack) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: stack,
        data: widget.controller.updatedActivity.toJson(),
      );
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _onLaunch() async {
    final resp = await showFutureLoadingDialog(
      context: context,
      future: () async {
        if (!widget.controller.room.isSpace) {
          throw Exception(
            "Cannot launch activity in a non-space room",
          );
        }

        await widget.controller.launchToSpace();
        context.go("/rooms?spaceId=${widget.controller.room.id}");
        Navigator.of(context).pop();
      },
    );

    if (!resp.isError) {
      context.go("/rooms?spaceId=${widget.controller.room.id}");
    }
  }

  bool get _isBookmarked => BookmarkedActivitiesRepo.isBookmarked(
        widget.controller.updatedActivity,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: itemPadding),
          child: Form(
            key: widget.controller.formKey,
            child: Column(
              children: [
                AnimatedSize(
                  duration: FluffyThemes.animationDuration,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: 200.0,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                        alignment: Alignment.center,
                        child: widget.controller.isLaunching
                            ? Avatar(
                                mxContent: widget.controller.room.avatar,
                                name: widget.controller.room
                                    .getLocalizedDisplayname(
                                  MatrixLocals(
                                    L10n.of(context),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                size: 200.0,
                              )
                            : widget.controller.imageURL != null ||
                                    widget.controller.avatar != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: widget.controller.avatar == null
                                        ? CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                widget.controller.imageURL!,
                                            placeholder: (context, url) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                            errorWidget: (context, url, error) {
                                              return const Padding(
                                                padding: EdgeInsets.all(28.0),
                                              );
                                            },
                                          )
                                        : Image.memory(
                                            widget.controller.avatar!,
                                            fit: BoxFit.cover,
                                          ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(28.0),
                                  ),
                      ),
                      if (widget.controller.isEditing)
                        InkWell(
                          borderRadius: BorderRadius.circular(90),
                          onTap: widget.controller.selectAvatar,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            radius: 20.0,
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: 20.0,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.controller.isLaunching
                        ? [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Avatar(
                                  mxContent: widget.controller.room.avatar,
                                  name: widget.controller.room
                                      .getLocalizedDisplayname(
                                    MatrixLocals(L10n.of(context)),
                                  ),
                                  size: 24.0,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                const SizedBox(width: itemPadding),
                                Expanded(
                                  child: Text(
                                    widget.controller.room
                                        .getLocalizedDisplayname(
                                      MatrixLocals(L10n.of(context)),
                                    ),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: itemPadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                widget.controller.updatedActivity.imageURL !=
                                        null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        child: widget.controller.updatedActivity
                                                .imageURL!
                                                .startsWith("mxc")
                                            ? MxcImage(
                                                uri: Uri.parse(
                                                  widget
                                                      .controller
                                                      .updatedActivity
                                                      .imageURL!,
                                                ),
                                                width: 24.0,
                                                height: 24.0,
                                                cacheKey: widget.controller
                                                    .updatedActivity.bookmarkId,
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: widget.controller
                                                    .updatedActivity.imageURL!,
                                                fit: BoxFit.cover,
                                                width: 24.0,
                                                height: 24.0,
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
                                              ),
                                      )
                                    : const Icon(
                                        Icons.event_note_outlined,
                                        size: 24.0,
                                      ),
                                const SizedBox(width: itemPadding),
                                Expanded(
                                  child: Text(
                                    widget.controller.updatedActivity.title,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: itemPadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.groups, size: 24.0),
                                const SizedBox(width: itemPadding),
                                Expanded(
                                  child: Text(
                                    L10n.of(context)
                                        .maximumActivityParticipants(
                                      widget.controller.updatedActivity.req
                                          .numberOfParticipants,
                                    ),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: itemPadding),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.radar, size: 24.0),
                                const SizedBox(width: itemPadding),
                                Expanded(
                                  child: Column(
                                    spacing: 4.0,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        L10n.of(context).numberOfActivities,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      NumberCounter(
                                        count: widget.controller.numActivities,
                                        update:
                                            widget.controller.setNumActivities,
                                        min: 1,
                                        max: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: itemPadding),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                foregroundColor:
                                    theme.colorScheme.onPrimaryContainer,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                              ),
                              onPressed: _onLaunch,
                              child: Row(
                                children: [
                                  const Icon(Icons.send_outlined),
                                  Expanded(
                                    child: Text(
                                      L10n.of(context).launchToSpace,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        : [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.event_note_outlined),
                                const SizedBox(width: itemPadding),
                                Expanded(
                                  child: widget.controller.isEditing
                                      ? TextField(
                                          controller:
                                              widget.controller.titleController,
                                          decoration: InputDecoration(
                                            labelText:
                                                L10n.of(context).activityTitle,
                                          ),
                                          maxLines: null,
                                        )
                                      : Text(
                                          widget
                                              .controller.updatedActivity.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                ),
                                if (!widget.controller.isEditing)
                                  IconButton(
                                    onPressed: _isBookmarked
                                        ? () => _removeBookmark()
                                        : () => _addBookmark(
                                              widget.controller.updatedActivity,
                                            ),
                                    icon: Icon(
                                      _isBookmarked
                                          ? Icons.save
                                          : Icons.save_outlined,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: itemPadding),
                            Row(
                              children: [
                                Icon(
                                  Symbols.target,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: itemPadding),
                                Expanded(
                                  child: widget.controller.isEditing
                                      ? TextField(
                                          controller: widget.controller
                                              .learningObjectivesController,
                                          decoration: InputDecoration(
                                            labelText:
                                                l10n.learningObjectiveLabel,
                                          ),
                                          maxLines: null,
                                        )
                                      : Text(
                                          widget.controller.updatedActivity
                                              .learningObjective,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: itemPadding),
                            Row(
                              children: [
                                Icon(
                                  Symbols.steps_rounded,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: itemPadding),
                                Expanded(
                                  child: widget.controller.isEditing
                                      ? TextField(
                                          controller: widget.controller
                                              .instructionsController,
                                          decoration: InputDecoration(
                                            labelText: l10n.instructions,
                                          ),
                                          maxLines: null,
                                        )
                                      : Text(
                                          widget.controller.updatedActivity
                                              .instructions,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: itemPadding),
                            Row(
                              children: [
                                Icon(
                                  Icons.school_outlined,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: itemPadding),
                                Expanded(
                                  child: widget.controller.isEditing
                                      ? LanguageLevelDropdown(
                                          initialLevel:
                                              widget.controller.languageLevel,
                                          onChanged: widget
                                              .controller.setLanguageLevel,
                                        )
                                      : Text(
                                          widget.controller.updatedActivity.req
                                              .cefrLevel
                                              .title(context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: itemPadding),
                            if (widget.controller.vocab.isNotEmpty) ...[
                              Row(
                                children: [
                                  Icon(
                                    Symbols.dictionary,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: itemPadding),
                                  Expanded(
                                    child: Wrap(
                                      spacing: 4.0,
                                      runSpacing: 4.0,
                                      children: List<Widget>.generate(
                                          widget.controller.vocab.length,
                                          (int index) {
                                        return widget.controller.isEditing
                                            ? Chip(
                                                label: Text(
                                                  widget.controller.vocab[index]
                                                      .lemma,
                                                ),
                                                onDeleted: () => widget
                                                    .controller
                                                    .removeVocab(index),
                                                backgroundColor:
                                                    Colors.transparent,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                shape: const StadiumBorder(
                                                  side: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              )
                                            : Chip(
                                                label: Text(
                                                  widget.controller.vocab[index]
                                                      .lemma,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                shape: const StadiumBorder(
                                                  side: BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (widget.controller.isEditing) ...[
                              const SizedBox(height: itemPadding),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: itemPadding),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:
                                            widget.controller.vocabController,
                                        decoration: InputDecoration(
                                          labelText: l10n.addVocabulary,
                                        ),
                                        onSubmitted: (value) {
                                          widget.controller.addVocab();
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: widget.controller.addVocab,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: itemPadding),
                              Row(
                                spacing: 12.0,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.primaryContainer,
                                        foregroundColor: theme
                                            .colorScheme.onPrimaryContainer,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                        ),
                                      ),
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
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.primaryContainer,
                                        foregroundColor: theme
                                            .colorScheme.onPrimaryContainer,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                        ),
                                      ),
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
                              ),
                            ] else
                              Column(
                                spacing: 12.0,
                                children: [
                                  const SizedBox(),
                                  Row(
                                    spacing: 12.0,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: theme
                                                .colorScheme.primaryContainer,
                                            foregroundColor: theme
                                                .colorScheme.onPrimaryContainer,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                            ),
                                          ),
                                          onPressed:
                                              widget.controller.startEditing,
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
                                        ),
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: theme
                                                .colorScheme.primaryContainer,
                                            foregroundColor: theme
                                                .colorScheme.onPrimaryContainer,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                            ),
                                          ),
                                          onPressed: widget.regenerate,
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
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: theme
                                                .colorScheme.primaryContainer,
                                            foregroundColor: theme
                                                .colorScheme.onPrimaryContainer,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                            ),
                                          ),
                                          onPressed: () {
                                            widget.controller.setLaunchState(
                                              ActivityLaunchState.launching,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.save_outlined),
                                              Expanded(
                                                child: Text(
                                                  L10n.of(context)
                                                      .saveAndLaunch,
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
                          ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
