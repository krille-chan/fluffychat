import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/repo/lemma_definition_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaDefinitionWidget extends StatefulWidget {
  final PangeaToken token;
  final String tokenLang;
  final VoidCallback onPressed;

  const LemmaDefinitionWidget({
    super.key,
    required this.token,
    required this.tokenLang,
    required this.onPressed,
  });

  @override
  LemmaDefinitionWidgetState createState() => LemmaDefinitionWidgetState();
}

class LemmaDefinitionWidgetState extends State<LemmaDefinitionWidget> {
  late Future<String> _definition;

  @override
  void initState() {
    super.initState();
    _definition = _fetchDefinition();
  }

  Future<String> _fetchDefinition() async {
    if (widget.token.shouldDoPosActivity) {
      return '?';
    } else {
      final res = await LemmaDictionaryRepo.get(
        LemmaDefinitionRequest(
          lemma: widget.token.lemma.text,
          partOfSpeech: widget.token.pos,
          lemmaLang: widget.tokenLang,
          userL1: MatrixState
                  .pangeaController.languageController.userL1?.langCode ??
              LanguageKeys.defaultLanguage,
        ),
      );
      return res.definition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _definition,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // TODO better error widget
          return Text('Error: ${snapshot.error}');
        } else {
          return ActionChip(
            avatar: const Icon(Icons.book),
            label: Text(snapshot.data ?? 'No definition found'),
            onPressed: widget.onPressed,
          );
        }
      },
    );
  }
}
