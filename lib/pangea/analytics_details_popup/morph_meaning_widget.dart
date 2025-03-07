import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_misc/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_meaning/morph_info_repo.dart';

class MorphMeaningWidget extends StatefulWidget {
  final String feature;
  final String tag;
  final TextStyle? style;
  final InlineSpan? leading;

  const MorphMeaningWidget({
    super.key,
    required this.feature,
    required this.tag,
    this.style,
    this.leading,
  });

  @override
  MorphMeaningWidgetState createState() => MorphMeaningWidgetState();
}

class MorphMeaningWidgetState extends State<MorphMeaningWidget> {
  bool _editMode = false;
  late TextEditingController _controller;
  static const int maxCharacters = 140;
  String? _cachedResponse;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _morphMeaning() async {
    if (_cachedResponse != null) {
      return _cachedResponse!;
    }

    final response = await MorphInfoRepo.get(
      feature: widget.feature,
      tag: widget.tag,
    );
    _cachedResponse = response;
    return response ?? L10n.of(context).meaningNotFound;
  }

  void _toggleEditMode(bool value) => setState(() => _editMode = value);

  Future<void> editMorphMeaning(String userEdit) async {
    // Truncate to max characters if needed
    final truncatedEdit = userEdit.length > maxCharacters
        ? userEdit.substring(0, maxCharacters)
        : userEdit;

    await MorphInfoRepo.setMorphDefinition(
      feature: widget.feature,
      tag: widget.tag,
      defintion: truncatedEdit,
    );

    // Update the cached response
    _cachedResponse = truncatedEdit;
    _toggleEditMode(false);
  }

  void _setMeaningText(String initialText) {
    _controller.text = initialText.substring(
      0,
      min(initialText.length, maxCharacters),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _morphMeaning(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _setMeaningText(snapshot.data!);
        }

        if (_editMode) {
          return MorphEditView(
            morphFeature: widget.feature,
            morphTag: widget.tag,
            meaning: snapshot.data ?? "",
            controller: _controller,
            toggleEditMode: _toggleEditMode,
            editMorphMeaning: editMorphMeaning,
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const TextLoadingShimmer();
        }

        if (snapshot.hasError || snapshot.data == null) {
          debugger(when: kDebugMode);
          return Text(
            L10n.of(context).oopsSomethingWentWrong,
            textAlign: TextAlign.center,
            style: widget.style,
          );
        }

        return Flexible(
          child: Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: L10n.of(context).doubleClickToEdit,
            child: GestureDetector(
              onLongPress: () => _toggleEditMode(true),
              onDoubleTap: () => _toggleEditMode(true),
              child: RichText(
                text: TextSpan(
                  style: widget.style,
                  children: [
                    if (widget.leading != null) widget.leading!,
                    if (widget.leading != null) const TextSpan(text: '  '),
                    TextSpan(text: snapshot.data!),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MorphEditView extends StatelessWidget {
  final String morphFeature;
  final String morphTag;
  final String meaning;
  final TextEditingController controller;
  final void Function(bool) toggleEditMode;
  final void Function(String) editMorphMeaning;

  const MorphEditView({
    required this.morphFeature,
    required this.morphTag,
    required this.meaning,
    required this.controller,
    required this.toggleEditMode,
    required this.editMorphMeaning,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).whatIsMeaning(
              getGrammarCopy(
                    category: morphFeature,
                    lemma: morphTag,
                    context: context,
                  ) ??
                  morphTag,
              '',
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
              maxLength: MorphMeaningWidgetState.maxCharacters,
              controller: controller,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => toggleEditMode(false),
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
                onPressed: () =>
                    controller.text != meaning && controller.text.isNotEmpty
                        ? editMorphMeaning(controller.text)
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
}
