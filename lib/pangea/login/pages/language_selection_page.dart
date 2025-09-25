import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => LanguageSelectionPageState();
}

class LanguageSelectionPageState extends State<LanguageSelectionPage> {
  LanguageModel? _selectedLanguage;

  @override
  void initState() {
    super.initState();
  }

  void _setSelectedLanguage(LanguageModel? l) {
    setState(() => _selectedLanguage = l);
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
                const SizedBox(height: 50.0),
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
                Text(
                  L10n.of(context).chooseLanguage,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedLanguage != null
                      ? () => context.go(
                            Matrix.of(context).client.isLogged()
                                ? "/course/${_selectedLanguage!.langCode}"
                                : "/home/languages/${_selectedLanguage!.langCode}",
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.surface,
                    foregroundColor: theme.colorScheme.onSurface,
                    side: BorderSide(
                      width: 1,
                      color: theme.colorScheme.onSurface,
                    ),
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
