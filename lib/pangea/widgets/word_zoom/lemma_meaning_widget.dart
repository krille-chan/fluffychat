import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/widgets/text_loading_shimmer.dart';
import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/repo/lemma_info/lemma_info_repo.dart';
import 'package:fluffychat/pangea/repo/lemma_info/lemma_info_request.dart';
import 'package:fluffychat/utils/feedback_dialog.dart';
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
  late Future<String> _definitionFuture;

  @override
  void initState() {
    super.initState();
    _definitionFuture = _fetchDefinition();
  }

  Future<String> _fetchDefinition([String? feedback]) async {
    final LemmaInfoRequest lemmaDefReq = LemmaInfoRequest(
      lemma: widget.lemma,
      partOfSpeech: widget.pos,

      /// This assumes that the user's L2 is the language of the lemma
      lemmaLang: widget.langCode,
      userL1:
          MatrixState.pangeaController.languageController.userL1?.langCode ??
              LanguageKeys.defaultLanguage,
    );

    final res = await LemmaInfoRepo.get(lemmaDefReq, feedback);
    return res.meaning;
  }

  void _showFeedbackDialog(String offendingContentString) async {
    // setState(() {
    //   _definitionFuture = _fetchDefinition(offendingContentString);
    // });
    await showFeedbackDialog(
      context,
      Text(offendingContentString),
      (feedback) async {
        setState(() {
          _definitionFuture = _fetchDefinition(feedback);
        });
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _definitionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const TextLoadingShimmer();
        }

        if (snapshot.hasError) {
          debugger(when: kDebugMode);
          return Text(
            snapshot.error.toString(),
            textAlign: TextAlign.center,
          );
        }

        return GestureDetector(
          onLongPress: () => _showFeedbackDialog(snapshot.data as String),
          onDoubleTap: () => _showFeedbackDialog(snapshot.data as String),
          child: Text(
            snapshot.data as String,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
