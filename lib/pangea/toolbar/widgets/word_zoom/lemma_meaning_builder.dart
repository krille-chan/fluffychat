import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_repo.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaMeaningBuilder extends StatefulWidget {
  final String langCode;
  final ConstructIdentifier constructId;
  final Widget Function(
    BuildContext context,
    LemmaMeaningBuilderState controller,
  ) builder;

  const LemmaMeaningBuilder({
    super.key,
    required this.langCode,
    required this.constructId,
    required this.builder,
  });

  @override
  LemmaMeaningBuilderState createState() => LemmaMeaningBuilderState();
}

class LemmaMeaningBuilderState extends State<LemmaMeaningBuilder> {
  LemmaInfoResponse? lemmaInfo;
  bool isLoading = true;
  Object? error;

  @override
  void initState() {
    super.initState();
    _fetchLemmaMeaning();
  }

  @override
  void didUpdateWidget(covariant LemmaMeaningBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.constructId != widget.constructId ||
        oldWidget.langCode != widget.langCode) {
      _fetchLemmaMeaning();
    }
  }

  LemmaInfoRequest get _request => LemmaInfoRequest(
        lemma: widget.constructId.lemma,
        partOfSpeech: widget.constructId.category,
        lemmaLang: widget.langCode,
        userL1:
            MatrixState.pangeaController.languageController.userL1?.langCode ??
                LanguageKeys.defaultLanguage,
      );

  Future<void> _fetchLemmaMeaning() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final resp = await LemmaInfoRepo.get(_request);
      lemmaInfo = resp;
    } catch (e) {
      error = e;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      this,
    );
  }
}
