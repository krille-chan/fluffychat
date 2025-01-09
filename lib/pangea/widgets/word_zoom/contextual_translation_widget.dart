import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/repo/lemma_definition_repo.dart';
import 'package:fluffychat/pangea/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class ContextualTranslationWidget extends StatelessWidget {
  final PangeaToken token;
  final String langCode;

  const ContextualTranslationWidget({
    super.key,
    required this.token,
    required this.langCode,
  });

  Future<String> _fetchDefinition() async {
    final LemmaDefinitionRequest lemmaDefReq = LemmaDefinitionRequest(
      lemma: token.lemma,
      partOfSpeech: token.pos,

      /// This assumes that the user's L2 is the language of the lemma
      lemmaLang: langCode,
      userL1:
          MatrixState.pangeaController.languageController.userL1?.langCode ??
              LanguageKeys.defaultLanguage,
    );

    final res = await LemmaDictionaryRepo.get(lemmaDefReq);
    return res.meaning;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchDefinition(),
      builder: (context, snapshot) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: snapshot.connectionState != ConnectionState.done
                ? const CircularProgressIndicator()
                : snapshot.hasError
                    ? CardErrorWidget(
                        error: L10n.of(context).oopsSomethingWentWrong,
                        padding: 0,
                        maxWidth: 500,
                      )
                    : Text(
                        snapshot.data ?? "...",
                        textAlign: TextAlign.center,
                      ),
          ),
        );
      },
    );
  }
}
