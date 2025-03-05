import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_misc/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_repo.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaMeaningWidget extends StatefulWidget {
  final String pos;
  final String text;
  final String langCode;
  final TextStyle? style;

  const LemmaMeaningWidget({
    super.key,
    required this.pos,
    required this.text,
    required this.langCode,
    this.style,
  });

  @override
  LemmaMeaningWidgetState createState() => LemmaMeaningWidgetState();
}

class LemmaMeaningWidgetState extends State<LemmaMeaningWidget> {
  bool _editMode = false;
  late TextEditingController _controller;
  static const int maxCharacters = 140;
  LemmaInfoResponse? _cachedResponse;

  String get _lemma => widget.text;

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

  LemmaInfoRequest get _request => LemmaInfoRequest(
        lemma: _lemma,
        partOfSpeech: widget.pos,
        lemmaLang: widget.langCode,
        userL1:
            MatrixState.pangeaController.languageController.userL1?.langCode ??
                LanguageKeys.defaultLanguage,
      );

  Future<LemmaInfoResponse> _lemmaMeaning() async {
    if (_cachedResponse != null) {
      return _cachedResponse!;
    }

    final response = await LemmaInfoRepo.get(_request);
    _cachedResponse = response;
    return response;
  }

  void _toggleEditMode(bool value) => setState(() => _editMode = value);

  Future<void> editLemmaMeaning(String userEdit) async {
    // Truncate to max characters if needed
    final truncatedEdit = userEdit.length > maxCharacters
        ? userEdit.substring(0, maxCharacters)
        : userEdit;

    final originalMeaning = await _lemmaMeaning();

    LemmaInfoRepo.set(
      _request,
      LemmaInfoResponse(emoji: originalMeaning.emoji, meaning: truncatedEdit),
    );

    // Update the cached response
    _cachedResponse =
        LemmaInfoResponse(emoji: originalMeaning.emoji, meaning: truncatedEdit);

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
    return FutureBuilder<LemmaInfoResponse>(
      future: _lemmaMeaning(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _setMeaningText(snapshot.data!.meaning);
        }

        if (_editMode) {
          return LemmaEditView(
            lemma: _lemma,
            pos: widget.pos,
            meaning: snapshot.data?.meaning ?? "",
            controller: _controller,
            toggleEditMode: _toggleEditMode,
            editLemmaMeaning: editLemmaMeaning,
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const TextLoadingShimmer();
        }

        if (snapshot.hasError || snapshot.data == null) {
          debugger(when: kDebugMode);
          return Text(
            snapshot.error.toString(),
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
              child: Text(
                snapshot.data!.meaning,
                textAlign: TextAlign.center,
                style: widget.style,
              ),
            ),
          ),
        );
      },
    );
  }
}

class LemmaEditView extends StatelessWidget {
  final String lemma;
  final String pos;
  final String meaning;
  final TextEditingController controller;
  final void Function(bool) toggleEditMode;
  final void Function(String) editLemmaMeaning;

  const LemmaEditView({
    required this.lemma,
    required this.pos,
    required this.meaning,
    required this.controller,
    required this.toggleEditMode,
    required this.editLemmaMeaning,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).whatIsMeaning(lemma, pos)}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              minLines: 1,
              maxLines: 3,
              maxLength: LemmaMeaningWidgetState.maxCharacters,
              controller: controller,
              // decoration: InputDecoration(
              //   hintText: data.meaning,
              // ),
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
                        ? editLemmaMeaning(controller.text)
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
