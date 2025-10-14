import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/widgets/p_language_dropdown.dart';
import 'package:fluffychat/pangea/login/utils/lang_code_repo.dart';
import 'package:fluffychat/widgets/matrix.dart';

class IdenticalLanguageException implements Exception {}

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => LanguageSelectionPageState();
}

class LanguageSelectionPageState extends State<LanguageSelectionPage> {
  Object? _error;

  LanguageModel? _selectedLanguage;
  LanguageModel? _baseLanguage;

  @override
  void initState() {
    super.initState();
    _baseLanguage =
        MatrixState.pangeaController.languageController.systemLanguage;
  }

  void _setSelectedLanguage(LanguageModel? l) {
    setState(() => _selectedLanguage = l);
  }

  void _setBaseLanguage(LanguageModel? l) {
    setState(() => _baseLanguage = l);
  }

  Future<void> _submit() async {
    setState(() => _error = null);

    if (_selectedLanguage == null) return;
    if (_selectedLanguage?.langCodeShort == _baseLanguage?.langCodeShort) {
      setState(() => _error = IdenticalLanguageException());
      return;
    }

    await LangCodeRepo.set(
      LanguageSettings(
        targetLangCode: _selectedLanguage!.langCode,
        baseLangCode: _baseLanguage?.langCode,
      ),
    );
    context.go(
      GoRouterState.of(context).fullPath?.contains('home') == true
          ? '/home/language/signup'
          : '/registration/create',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languages = MatrixState.pangeaController.pLanguageStore.targetOptions;

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).languages),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: Column(
              spacing: 24.0,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            bottom: 60.0,
                          ),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            alignment: WrapAlignment.center,
                            children: languages
                                .map(
                                  (l) => FilterChip(
                                    selected: _selectedLanguage == l,
                                    backgroundColor: _selectedLanguage == l
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.surface,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    label: Text(
                                      l.getDisplayName(context) ??
                                          l.displayName,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    onSelected: (selected) {
                                      _setSelectedLanguage(
                                        selected ? l : null,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: IgnorePointer(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  theme.colorScheme.surface,
                                  theme.colorScheme.surface.withAlpha(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: FluffyThemes.animationDuration,
                  child: _selectedLanguage != null &&
                          _selectedLanguage?.langCodeShort ==
                              _baseLanguage?.langCodeShort
                      ? PLanguageDropdown(
                          languages: languages,
                          onChange: _setBaseLanguage,
                          initialLanguage: _baseLanguage,
                          decorationText: L10n.of(context).myBaseLanguage,
                          error: _error is IdenticalLanguageException
                              ? L10n.of(context).noIdenticalLanguages
                              : null,
                        )
                      : const SizedBox(),
                ),
                Text(
                  L10n.of(context).chooseLanguage,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedLanguage != null ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(L10n.of(context).letsGo),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
