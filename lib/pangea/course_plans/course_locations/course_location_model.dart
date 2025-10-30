class CourseLocationModel {
  String uuid;
  String name;
  List<String> mediaIds;

  CourseLocationModel({
    required this.uuid,
    required this.name,
    required this.mediaIds,
  });

  factory CourseLocationModel.fromJson(Map<String, dynamic> json) {
    return CourseLocationModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      mediaIds: (json['media_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'media_ids': mediaIds,
    };
  }
}
