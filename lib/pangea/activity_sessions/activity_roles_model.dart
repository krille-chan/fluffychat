import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';

class ActivityRolesModel {
  final Map<String, ActivityRoleModel> roles;

  const ActivityRolesModel(this.roles);

  ActivityRoleModel? role(String userId) {
    return roles.values.firstWhereOrNull((r) => r.userId == userId);
  }

  void updateRole(ActivityRoleModel role) {
    roles[role.id] = role;
  }

  void dismissTooltip(ActivityRoleModel role) {
    roles[role.id]?.dismissedGoalTooltip = true;
  }

  void finishAll() {
    for (final id in roles.keys) {
      if (roles[id]!.isFinished) continue;
      roles[id]!.finishedAt = DateTime.now();
    }
  }

  static ActivityRolesModel get empty {
    final roles = <String, ActivityRoleModel>{};
    return ActivityRolesModel(roles);
  }

  Map<String, dynamic> toJson() {
    return {
      "roles": roles.map((id, role) => MapEntry(id, role.toJson())),
    };
  }

  static ActivityRolesModel fromJson(Map<String, dynamic> json) {
    final roles = (json['roles'] as Map<String, dynamic>)
        .map((id, value) => MapEntry(id, ActivityRoleModel.fromJson(value)));

    return ActivityRolesModel(
      roles,
    );
  }
}
