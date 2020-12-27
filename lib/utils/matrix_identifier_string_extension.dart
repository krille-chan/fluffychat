import '../app_config.dart';

extension MatrixIdentifierStringExtension on String {
  /// Separates room identifiers with an event id and possibly a query parameter into its components.
  MatrixIdentifierStringExtensionResults parseIdentifierIntoParts() {
    final isUrl = startsWith(AppConfig.inviteLinkPrefix);
    var s = this;
    if (isUrl) {
      // as we decode a component we may only call it on the url part *before* the "query" part
      final parts = replaceFirst(AppConfig.inviteLinkPrefix, '').split('?');
      s = Uri.decodeComponent(parts.removeAt(0)) + '?' + parts.join('?');
    }
    final match = RegExp(r'^([#!@+][^:]*:[^\/?]*)(?:\/(\$[^?]*))?(?:\?(.*))?$')
        .firstMatch(s);
    if (match == null) {
      return null;
    }
    return MatrixIdentifierStringExtensionResults(
      primaryIdentifier: match.group(1),
      secondaryIdentifier: match.group(2),
      queryString: match.group(3)?.isNotEmpty ?? false ? match.group(3) : null,
    );
  }
}

class MatrixIdentifierStringExtensionResults {
  final String primaryIdentifier;
  final String secondaryIdentifier;
  final String queryString;

  MatrixIdentifierStringExtensionResults(
      {this.primaryIdentifier, this.secondaryIdentifier, this.queryString});
}
