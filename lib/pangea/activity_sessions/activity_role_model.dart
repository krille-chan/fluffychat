class ActivityRoleModel {
  final String id;
  final String userId;
  final String? role;
  DateTime? finishedAt;
  DateTime? archivedAt;

  ActivityRoleModel({
    required this.id,
    required this.userId,
    this.role,
    this.finishedAt,
    this.archivedAt,
  });

  bool get isFinished => finishedAt != null;

  bool get isArchived => archivedAt != null;

  factory ActivityRoleModel.fromJson(Map<String, dynamic> json) {
    return ActivityRoleModel(
      id: json['id'],
      userId: json['userId'],
      role: json['role'],
      finishedAt: json['finishedAt'] != null
          ? DateTime.parse(json['finishedAt'])
          : null,
      archivedAt: json['archivedAt'] != null
          ? DateTime.parse(json['archivedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'role': role,
      'finishedAt': finishedAt?.toIso8601String(),
      'archivedAt': archivedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityRoleModel &&
        other.userId == userId &&
        other.role == role &&
        other.finishedAt == finishedAt &&
        other.archivedAt == archivedAt &&
        other.id == id;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      role.hashCode ^
      (finishedAt?.hashCode ?? 0) ^
      (archivedAt?.hashCode ?? 0) ^
      id.hashCode;
}
