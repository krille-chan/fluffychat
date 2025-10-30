import 'package:fluffychat/l10n/l10n.dart';

class ActivityRoleModel {
  final String id;
  final String userId;
  final String? role;
  DateTime? finishedAt;
  DateTime? archivedAt;
  bool dismissedGoalTooltip;

  ActivityRoleModel({
    required this.id,
    required this.userId,
    this.role,
    this.finishedAt,
    this.archivedAt,
    this.dismissedGoalTooltip = false,
  });

  bool get isFinished => finishedAt != null;

  bool get isArchived => archivedAt != null;

  String? stateEventMessage(String displayName, L10n l10n) {
    if (isArchived) {
      return null;
    }

    if (isFinished) {
      return l10n.finishedTheActivity(displayName);
    }

    return l10n.joinedTheActivity(
      displayName,
      role ?? l10n.participant,
    );
  }

  factory ActivityRoleModel.fromJson(Map<String, dynamic> json) {
    return ActivityRoleModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String?,
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'])
          : null,
      archivedAt: json['archived_at'] != null
          ? DateTime.parse(json['archived_at'])
          : null,
      dismissedGoalTooltip: json['dismissed_goal_tooltip'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'role': role,
      'finished_at': finishedAt?.toIso8601String(),
      'archived_at': archivedAt?.toIso8601String(),
      'dismissed_goal_tooltip': dismissedGoalTooltip,
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
