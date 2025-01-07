import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';
import '../constants/class_default_values.dart';
import '../extensions/pangea_room_extension/pangea_room_extension.dart';

class ClassChatPowerLevels {
  static Future<Map<String, dynamic>> powerLevelOverrideForClassChat(
    BuildContext context,
    Room? parent,
  ) async {
    final Client client = Matrix.of(context).client;
    final Map<String, dynamic> powerLevelOverride = {};
    powerLevelOverride['events'] = {
      EventTypes.SpaceChild: 0,
    };
    powerLevelOverride['users'] = {};

    final List<User> spaceAdmin = [];

    if (parent != null) {
      final List<User> classTeachers = await parent.teachers;
      spaceAdmin.addAll(classTeachers);
    }

    for (final admin in spaceAdmin) {
      powerLevelOverride['users'][admin.id] =
          ClassDefaultValues.powerLevelOfAdmin;
    }

    powerLevelOverride['users'][client.userID] =
        ClassDefaultValues.powerLevelOfAdmin;

    return powerLevelOverride;
  }
}
