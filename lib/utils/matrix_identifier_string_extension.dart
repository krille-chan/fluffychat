extension MatrixIdentifierStringExtension on String {
  /// Separates room identifiers with an event id and possibly a query parameter into its components.
  MatrixIdentifierStringExtensionResults parseIdentifierIntoParts() {
    final match = RegExp(r'^([#!][^:]*:[^\/?]*)(?:\/(\$[^?]*))?(?:\?(.*))?$')
        .firstMatch(this);
    if (match == null) {
      return null;
    }
    return MatrixIdentifierStringExtensionResults(
      roomIdOrAlias: match.group(1),
      eventId: match.group(2),
      queryString: match.group(3),
    );
  }
}

class MatrixIdentifierStringExtensionResults {
  final String roomIdOrAlias;
  final String eventId;
  final String queryString;

  MatrixIdentifierStringExtensionResults(
      {this.roomIdOrAlias, this.eventId, this.queryString});
}
