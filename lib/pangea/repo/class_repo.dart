import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/models/class_email_invite_model.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import '../network/requests.dart';
import '../network/urls.dart';

class PClassRepo {
  static classesBySpaceIds(String accessToken, List<String> spaceIds) async {
    final Requests req =
        Requests(baseUrl: PApiUrls.baseAPI, accessToken: accessToken);
    final Response res = await req
        .post(url: PApiUrls.classListBySpaceIds, body: {"class_ids": spaceIds});
    final json = jsonDecode(res.body);
    final List<ClassSettingsModel> pangeaClasses = json["results"]
        .map((e) {
          final ClassSettingsModel model = ClassSettingsModel.fromJson(e);
          return model;
        })
        .toList()
        .cast<ClassSettingsModel>();
    return pangeaClasses;
  }

  //Question for Jordan - what happens if code is incorrect? statuscode 400?
  // what about if user is already in the class?
  //Question for Lala: In this widget, controller, repo framework, where are
  // errors handled? How are they passed?
  static Future<ClassSettingsModel?> getClassByCode(
    String classCode,
    String accessToken,
  ) async {
    final Requests req =
        Requests(baseUrl: PApiUrls.baseAPI, accessToken: accessToken);
    final Response res =
        await req.get(url: PApiUrls.getClassByClassCode + classCode);

    if (res.statusCode == 400) {
      return null;
    }
    final json = jsonDecode(res.body);

    final classSettings = ClassSettingsModel.fromJson(json);

    return classSettings;
  }

  static searchClass(String text) async {}

  static sendEmailToJoinClass(
    List<ClassEmailInviteData> data,
    String roomId,
    String teacherName,
  ) async {}

  static inviteAction(BuildContext context, String id, String roomId) async {}

  static reportUser({
    String? classRoomNamedata,
    String? classTeacherNamedata,
    String? reportedUserdata,
    String? classTeacherEmaildata,
    String? offensivedata,
    String? reasondata,
  }) async {}
}
