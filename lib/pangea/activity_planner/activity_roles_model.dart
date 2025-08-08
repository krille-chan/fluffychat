import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_role_model.dart';

class ActivityRolesModel {
  final Event? event;
  late List<ActivityRoleModel> _roles;

  ActivityRolesModel({this.event, List<ActivityRoleModel>? roles}) {
    assert(
      event != null || roles != null,
      "Either event or roles must be provided",
    );

    if (roles != null) {
      _roles = roles;
    } else {
      final rolesList = event!.content["roles"] as List<dynamic>? ?? [];
      try {
        _roles = rolesList
            .map<ActivityRoleModel>((e) => ActivityRoleModel.fromJson(e))
            .toList();
      } catch (e) {
        _roles = [];
      }
    }
  }

  List<ActivityRoleModel> get roles => _roles;

  ActivityRoleModel? role(String userId) {
    return _roles.firstWhereOrNull((r) => r.userId == userId);
  }

  /// If this user already has a role, replace it with the new one.
  /// Otherwise, add the new role.
  void updateRole(ActivityRoleModel role) {
    final index = _roles.indexWhere((r) => r.userId == role.userId);
    index != -1 ? _roles[index] = role : _roles.add(role);
  }

  void finishAll() {
    for (final role in _roles) {
      if (role.isFinished) continue;
      role.finishedAt = DateTime.now();
    }
  }

  static ActivityRolesModel get empty => ActivityRolesModel(
        roles: [],
      );

  Map<String, dynamic> toJson() {
    return {
      "roles": _roles.map((role) => role.toJson()).toList(),
    };
  }

  static ActivityRolesModel fromJson(Map<String, dynamic> json) {
    final roles = (json["roles"] as List<dynamic>?)
        ?.map<ActivityRoleModel>((e) => ActivityRoleModel.fromJson(e))
        .toList();

    return ActivityRolesModel(roles: roles);
  }
}
