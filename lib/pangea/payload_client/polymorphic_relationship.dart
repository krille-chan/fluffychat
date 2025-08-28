class PolymorphicRelationship {
  final String relationTo;
  final String value;

  PolymorphicRelationship({
    required this.relationTo,
    required this.value,
  });

  factory PolymorphicRelationship.fromJson(Map<String, dynamic> json) {
    return PolymorphicRelationship(
      relationTo: json['relationTo'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relationTo': relationTo,
      'value': value,
    };
  }
}
