import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card_row.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/language_level_dropdown.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

class ActivitySuggestionDialogContent extends StatelessWidget {
  final ActivitySuggestionDialogState controller;

  const ActivitySuggestionDialogContent({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    switch (controller.widget.controller.launchState) {
      case ActivityLaunchState.base:
        return _ActivitySuggestionBaseContent(controller: controller);
      case ActivityLaunchState.editing:
        return _ActivitySuggestionEditContent(controller: controller);
      case ActivityLaunchState.launching:
        return _ActivitySuggestionLaunchContent(controller: controller);
    }
  }
}

class _ActivitySuggestionDialogImage extends StatelessWidget {
  final ActivityPlannerBuilderState activityController;
  final double width;

  const _ActivitySuggestionDialogImage({
    required this.activityController,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      width: (width / 2) + 42.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: activityController.avatar != null
            ? Image.memory(
                activityController.avatar!,
                fit: BoxFit.cover,
              )
            : activityController.updatedActivity.imageURL != null
                ? activityController.updatedActivity.imageURL!.startsWith("mxc")
                    ? MxcImage(
                        uri: Uri.parse(
                          activityController.updatedActivity.imageURL!,
                        ),
                        width: width / 2,
                        height: 200,
                        cacheKey: activityController.updatedActivity.bookmarkId,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: activityController.updatedActivity.imageURL!,
                        fit: BoxFit.cover,
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
                      )
                : null,
      ),
    );
  }
}

class _ActivitySuggestionDialogFrame extends StatelessWidget {
  final Widget topContent;
  final List<Widget> centerContent;
  final Widget bottomContent;

  const _ActivitySuggestionDialogFrame({
    required this.topContent,
    required this.centerContent,
    required this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              spacing: 8.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                topContent,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    spacing: 14.0,
                    children: centerContent,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: bottomContent,
        ),
      ],
    );
  }
}

class _ActivitySuggestionBaseContent extends StatelessWidget {
  final ActivitySuggestionDialogState controller;

  const _ActivitySuggestionBaseContent({
    required this.controller,
  });

  ActivityPlannerBuilderState get activityController =>
      controller.widget.controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final topContent = _ActivitySuggestionDialogImage(
      activityController: activityController,
      width: controller.width,
    );

    final centerContent = [
      ActivitySuggestionCardRow(
        icon: Icons.event_note_outlined,
        child: Text(
          activityController.updatedActivity.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Symbols.target,
        child: Text(
          activityController.updatedActivity.learningObjective,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Symbols.steps,
        child: Text(
          activityController.updatedActivity.instructions,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Icons.group_outlined,
        child: Text(
          L10n.of(context).countParticipants(
            activityController.updatedActivity.req.numberOfParticipants,
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Icons.school_outlined,
        child: Text(
          activityController.updatedActivity.req.cefrLevel.title(context),
          style: const TextStyle(fontSize: 16),
        ),
      ),
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
              children: activityController.vocab
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
        ),
      ),
    ];

    final bottomContent = Column(
      spacing: 12.0,
      children: [
        Row(
          spacing: 12.0,
          children: [
            Expanded(
              child: ElevatedButton(
                style: controller.buttonStyle,
                onPressed: activityController.startEditing,
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
            if (controller.widget.replaceActivity != null)
              Expanded(
                child: ElevatedButton(
                  style: controller.buttonStyle,
                  onPressed: controller.onRegenerate,
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
                style: controller.buttonStyle,
                // onPressed: _launchActivity,
                onPressed: () {
                  activityController.setLaunchState(
                    ActivityLaunchState.launching,
                  );
                },
                child: Row(
                  spacing: 12.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save_outlined),
                    Text(
                      controller.widget.buttonText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return _ActivitySuggestionDialogFrame(
      topContent: topContent,
      centerContent: centerContent,
      bottomContent: bottomContent,
    );
  }
}

class _ActivitySuggestionEditContent extends StatelessWidget {
  final ActivitySuggestionDialogState controller;

  const _ActivitySuggestionEditContent({
    required this.controller,
  });

  ActivityPlannerBuilderState get activityController =>
      controller.widget.controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final topContent = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _ActivitySuggestionDialogImage(
          activityController: activityController,
          width: controller.width,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(90),
          onTap: activityController.selectAvatar,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            radius: 20.0,
            child: Icon(
              Icons.add_a_photo_outlined,
              size: 20.0,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );

    final centerContent = [
      ActivitySuggestionCardRow(
        icon: Icons.event_note_outlined,
        child: TextFormField(
          controller: activityController.titleController,
          decoration: InputDecoration(
            labelText: L10n.of(context).activityTitle,
          ),
          maxLines: 2,
          minLines: 1,
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Symbols.target,
        child: TextFormField(
          controller: activityController.learningObjectivesController,
          decoration: InputDecoration(
            labelText: L10n.of(context).learningObjectiveLabel,
          ),
          maxLines: 4,
          minLines: 1,
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Symbols.steps,
        child: TextFormField(
          controller: activityController.instructionsController,
          decoration: InputDecoration(
            labelText: L10n.of(context).instructions,
          ),
          maxLines: 8,
          minLines: 1,
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Icons.group_outlined,
        child: TextFormField(
          controller: activityController.participantsController,
          decoration: InputDecoration(
            labelText: L10n.of(context).classRoster,
          ),
          maxLines: 1,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }

            try {
              final val = int.parse(value);
              if (val <= 0) {
                return L10n.of(context).pleaseEnterInt;
              }
              if (val > 50) {
                return L10n.of(context).maxFifty;
              }
            } catch (e) {
              return L10n.of(context).pleaseEnterANumber;
            }
            return null;
          },
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Icons.school_outlined,
        child: LanguageLevelDropdown(
          initialLevel: activityController.languageLevel,
          onChanged: activityController.setLanguageLevel,
        ),
      ),
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
              children: activityController.vocab
                  .mapIndexed(
                    (i, vocab) => Container(
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
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => activityController.removeVocab(
                            i,
                          ),
                          child: Row(
                            spacing: 4.0,
                            mainAxisSize: MainAxisSize.min,
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
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        child: Row(
          spacing: 4.0,
          children: [
            Expanded(
              child: TextFormField(
                controller: activityController.vocabController,
                decoration: InputDecoration(
                  hintText: L10n.of(
                    context,
                  ).addVocabulary,
                ),
                maxLines: 1,
                onFieldSubmitted: (_) => activityController.addVocab(),
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
              onPressed: activityController.addVocab,
            ),
          ],
        ),
      ),
    ];

    final bottomContent = Row(
      spacing: 12.0,
      children: [
        Expanded(
          child: ElevatedButton(
            style: controller.buttonStyle,
            onPressed: activityController.saveEdits,
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
            style: controller.buttonStyle,
            onPressed: activityController.clearEdits,
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
    );

    return _ActivitySuggestionDialogFrame(
      topContent: topContent,
      centerContent: centerContent,
      bottomContent: bottomContent,
    );
  }
}

class _ActivitySuggestionLaunchContent extends StatelessWidget {
  final ActivitySuggestionDialogState controller;

  const _ActivitySuggestionLaunchContent({
    required this.controller,
  });

  ActivityPlannerBuilderState get activityController =>
      controller.widget.controller;

  @override
  Widget build(BuildContext context) {
    final topContent = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Avatar(
        mxContent: activityController.room.avatar,
        name: activityController.room.getLocalizedDisplayname(
          MatrixLocals(
            L10n.of(context),
          ),
        ),
        size: (controller.width / 2),
        borderRadius: BorderRadius.circular(20.0),
      ),
    );

    final centerContent = [
      ActivitySuggestionCardRow(
        leading: Avatar(
          mxContent: activityController.room.avatar,
          name: activityController.room.getLocalizedDisplayname(
            MatrixLocals(
              L10n.of(context),
            ),
          ),
          size: 24.0,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          activityController.room.getLocalizedDisplayname(
            MatrixLocals(L10n.of(context)),
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ActivitySuggestionCardRow(
        leading: activityController.updatedActivity.imageURL != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: activityController.updatedActivity.imageURL!
                        .startsWith("mxc")
                    ? MxcImage(
                        uri: Uri.parse(
                          activityController.updatedActivity.imageURL!,
                        ),
                        width: 24.0,
                        height: 24.0,
                        cacheKey: activityController.updatedActivity.bookmarkId,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: activityController.updatedActivity.imageURL!,
                        fit: BoxFit.cover,
                        width: 24.0,
                        height: 24.0,
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
              )
            : const Icon(
                Icons.event_note_outlined,
                size: 24.0,
              ),
        child: Text(
          activityController.updatedActivity.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Icons.groups,
        child: Text(
          L10n.of(context).maximumActivityParticipants(
            activityController.updatedActivity.req.numberOfParticipants,
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ),
      ActivitySuggestionCardRow(
        icon: Icons.radar,
        child: Column(
          spacing: 4.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.of(context).numberOfActivities,
              style: const TextStyle(fontSize: 16),
            ),
            NumberCounter(
              count: activityController.numActivities,
              update: activityController.setNumActivities,
              min: 1,
              max: 5,
            ),
          ],
        ),
      ),
    ];

    final bottomContent = ElevatedButton(
      style: controller.buttonStyle,
      onPressed: controller.launchActivity,
      child: Row(
        spacing: 12.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.send_outlined),
          Text(
            L10n.of(context).launchToSpace,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return _ActivitySuggestionDialogFrame(
      topContent: topContent,
      centerContent: centerContent,
      bottomContent: bottomContent,
    );
  }
}
