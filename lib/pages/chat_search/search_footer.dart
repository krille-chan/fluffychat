import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/date_time_extension.dart';

class SearchFooter extends StatelessWidget {
  final DateTime? searchedUntil;
  final bool endReached, isLoading;
  final void Function() onStartSearch;

  const SearchFooter({
    super.key,
    required this.searchedUntil,
    required this.endReached,
    required this.isLoading,
    required this.onStartSearch,
  });

  @override
  Widget build(BuildContext context) {
    if (endReached) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(L10n.of(context).noMoreResultsFound),
        ),
      );
    }
    final theme = Theme.of(context);
    final searchedUntil = this.searchedUntil;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            if (searchedUntil != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  L10n.of(
                    context,
                  ).chatSearchedUntil(searchedUntil.localizedTime(context)),
                  style: TextStyle(fontSize: 10.5),
                ),
              ),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
              ),
              onPressed: isLoading ? null : onStartSearch,
              icon: isLoading
                  ? SizedBox.square(
                      dimension: 18,
                      child: const CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.arrow_downward_outlined),
              label: Text(L10n.of(context).searchMore),
            ),
          ],
        ),
      ),
    );
  }
}
