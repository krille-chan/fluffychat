class JoinField {
  final List<String>? docs;
  final bool? hasNextPage;
  final int? totalDocs;

  const JoinField({
    this.docs,
    this.hasNextPage,
    this.totalDocs,
  });

  factory JoinField.fromJson(
    Map<String, dynamic> json,
  ) {
    final raw = json['docs'];
    final list = (raw is List) ? raw.map((e) => e as String).toList() : null;

    return JoinField(
      docs: list,
      hasNextPage: json['hasNextPage'] as bool?,
      totalDocs: json['totalDocs'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docs': docs,
      'hasNextPage': hasNextPage,
      'totalDocs': totalDocs,
    };
  }
}
