class PClassEmailInviteModel {
  List<ClassEmailInviteData>? data;
  String? pangeaClassRoomId;
  String? teacherName;

  PClassEmailInviteModel({this.data, this.pangeaClassRoomId, this.teacherName});

  PClassEmailInviteModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ClassEmailInviteData>[];
      json['data'].forEach((v) {
        data!.add(ClassEmailInviteData.fromJson(v));
      });
    }
    pangeaClassRoomId = json['pangea_class_room_id'];
    teacherName = json['teacher_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pangea_class_room_id'] = pangeaClassRoomId;
    data['teacher_name'] = teacherName;
    return data;
  }
}

class ClassEmailInviteData {
  String? name;
  String? email;

  ClassEmailInviteData({this.name, this.email});

  ClassEmailInviteData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
