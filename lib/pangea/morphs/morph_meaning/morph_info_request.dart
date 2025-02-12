class MorphInfoRequest {
  final String userL1;
  final String userL2;

  MorphInfoRequest({
    required this.userL1,
    required this.userL2,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_l1': userL1,
      'user_l2': userL2,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MorphInfoRequest &&
          userL1 == other.userL1 &&
          userL2 == other.userL2;

  @override
  int get hashCode => userL1.hashCode ^ userL2.hashCode;

  String get storageKey {
    return userL1 + userL2;
  }
}
