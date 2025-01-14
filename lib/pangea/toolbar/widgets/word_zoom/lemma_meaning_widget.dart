import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics/repo/lemma_info_repo.dart';
import 'package:fluffychat/pangea/analytics/repo/lemma_info_request.dart';
import 'package:fluffychat/pangea/analytics/repo/lemma_info_response.dart';
import 'package:fluffychat/pangea/analytics/widgets/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaMeaningWidget extends StatefulWidget {
  final String lemma;
  final String pos;
  final String langCode;

  const LemmaMeaningWidget({
    super.key,
    required this.lemma,
    required this.pos,
    required this.langCode,
  });

  @override
  LemmaMeaningWidgetState createState() => LemmaMeaningWidgetState();
}

class LemmaMeaningWidgetState extends State<LemmaMeaningWidget> {
  bool _editMode = false;
  late TextEditingController _controller;

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
        lemma: widget.lemma,
        partOfSpeech: widget.pos,

        /// This assumes that the user's L2 is the language of the lemma
        lemmaLang: widget.langCode,
        userL1:
            MatrixState.pangeaController.languageController.userL1?.langCode ??
                LanguageKeys.defaultLanguage,
      );

  Future<LemmaInfoResponse> _lemmaMeaning() => LemmaInfoRepo.get(_request);

  void _toggleEditMode(bool value) => setState(() => _editMode = value);

  Future<void> editLemmaMeaning(String userEdit) async {
    final originalMeaning = await _lemmaMeaning();

    LemmaInfoRepo.set(
      _request,
      LemmaInfoResponse(emoji: originalMeaning.emoji, meaning: userEdit),
    );

    _toggleEditMode(false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LemmaInfoResponse>(
      future: _lemmaMeaning(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const TextLoadingShimmer();
        }

        if (snapshot.hasError || snapshot.data == null) {
          debugger(when: kDebugMode);
          return Text(
            snapshot.error.toString(),
            textAlign: TextAlign.center,
          );
        }

        if (_editMode) {
          _controller.text = snapshot.data!.meaning;
          return Container(
            constraints: const BoxConstraints(
              maxWidth: AppConfig.toolbarMinWidth,
              maxHeight: 225,
              minHeight: 100,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${L10n.of(context).pangeaBotIsFallible} ${L10n.of(context).whatIsMeaning(widget.lemma, widget.pos)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    minLines: 1,
                    maxLines: 3,
                    controller: _controller,
                    onSubmitted: editLemmaMeaning,
                    decoration: InputDecoration(
                      hintText: snapshot.data!.meaning,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _toggleEditMode(false),
                      child: Text(L10n.of(context).cancel),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () =>
                          _controller.text != snapshot.data!.meaning &&
                                  _controller.text.isNotEmpty
                              ? editLemmaMeaning(_controller.text)
                              : null,
                      child: Text(L10n.of(context).saveChanges),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return Flexible(
          child: GestureDetector(
            onLongPress: () => _toggleEditMode(true),
            onDoubleTap: () => _toggleEditMode(true),
            child: Tooltip(
              message: L10n.of(context).doubleClickToEdit,
              waitDuration: const Duration(milliseconds: 2000),
              child: Text(
                snapshot.data!.meaning,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
