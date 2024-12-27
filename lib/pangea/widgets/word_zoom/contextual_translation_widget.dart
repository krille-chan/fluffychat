import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/repo/full_text_translation_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ContextualTranslationWidget extends StatefulWidget {
  final PangeaToken token;
  final String fullText;
  final String langCode;
  final VoidCallback onPressed;

  final String? definition;
  final Function(String) setDefinition;

  const ContextualTranslationWidget({
    super.key,
    required this.token,
    required this.fullText,
    required this.langCode,
    required this.onPressed,
    required this.setDefinition,
    this.definition,
  });

  @override
  ContextualTranslationWidgetState createState() =>
      ContextualTranslationWidgetState();
}

class ContextualTranslationWidgetState
    extends State<ContextualTranslationWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.definition == null) {
      _fetchDefinition();
    }
  }

  @override
  void didUpdateWidget(covariant ContextualTranslationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token && widget.definition == null) {
      _fetchDefinition();
    }
  }

  Future<void> _fetchDefinition() async {
    final FullTextTranslationResponseModel response =
        await FullTextTranslationRepo.translate(
      accessToken: MatrixState.pangeaController.userController.accessToken,
      request: FullTextTranslationRequestModel(
        text: widget.fullText,
        tgtLang:
            MatrixState.pangeaController.languageController.userL1?.langCode ??
                LanguageKeys.defaultLanguage,
        userL2:
            MatrixState.pangeaController.languageController.userL2?.langCode ??
                LanguageKeys.defaultLanguage,
        userL1:
            MatrixState.pangeaController.languageController.userL1?.langCode ??
                LanguageKeys.defaultLanguage,
        offset: widget.token.text.offset,
        length: widget.token.text.length,
        deepL: false,
      ),
    );
    widget.setDefinition(response.bestTranslation);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 60,
        child: IconButton(
          iconSize: 30,
          onPressed: widget.onPressed,
          icon: const Icon(Symbols.dictionary),
        ),
      ),
    );
  }
}
