import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_builder.dart';

class LemmaMeaningWidget extends StatelessWidget {
  final LemmaMeaningBuilderState controller;

  final ConstructUses constructUse;
  final TextStyle? style;
  final InlineSpan? leading;

  const LemmaMeaningWidget({
    super.key,
    required this.controller,
    required this.constructUse,
    this.style,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const TextLoadingShimmer();
    }

    if (controller.error != null) {
      debugger(when: kDebugMode);
      return ErrorIndicator(
        message: L10n.of(context).errorFetchingDefinition,
        style: style,
      );
    }

    if (controller.editMode) {
      controller.controller.text = controller.lemmaInfo?.meaning ?? "";
      return Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).whatIsMeaning(
                constructUse.lemma,
                constructUse.category,
              )}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                minLines: 1,
                maxLines: 3,
                controller: controller.controller,
                decoration: InputDecoration(
                  hintText: controller.lemmaInfo?.meaning,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => controller.toggleEditMode(false),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Text(L10n.of(context).cancel),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => controller.controller.text !=
                              controller.lemmaInfo?.meaning &&
                          controller.controller.text.isNotEmpty
                      ? controller.editLemmaMeaning(controller.controller.text)
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Text(L10n.of(context).saveChanges),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: L10n.of(context).doubleClickToEdit,
            child: GestureDetector(
              onLongPress: () => controller.toggleEditMode(true),
              onDoubleTap: () => controller.toggleEditMode(true),
              child: RichText(
                textAlign: leading == null ? TextAlign.center : TextAlign.start,
                text: TextSpan(
                  style: style,
                  children: [
                    if (leading != null) leading!,
                    if (leading != null)
                      const WidgetSpan(child: SizedBox(width: 6.0)),
                    TextSpan(
                      text: controller.lemmaInfo?.meaning,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
