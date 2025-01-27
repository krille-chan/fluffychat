import 'package:diacritic/diacritic.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';

String normalizeString(String input) {
  try {
    // Step 1: Remove diacritics (accents)
    String normalized = removeDiacritics(input);
    normalized = normalized.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    // Step 2: Remove punctuation
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]'), '');

    // Step 3: Convert to lowercase
    normalized = normalized.toLowerCase();

    // Step 4: Trim and normalize whitespace
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ').trim();

    return normalized.isEmpty ? input : normalized;
  } catch (e, s) {
    ErrorHandler.logError(
      e: e,
      s: s,
      data: {'input': input},
    );
    return input;
  }
}
