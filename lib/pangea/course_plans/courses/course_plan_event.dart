class CoursePlanEvent {
  final String uuid;

  CoursePlanEvent({required this.uuid});

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
    };
  }

  factory CoursePlanEvent.fromJson(Map<String, dynamic> json) {
    return CoursePlanEvent(
      uuid: json['uuid'] as String,
    );
  }
}
