class ActivitySettingRequestSchema {
  final String langCode;

  ActivitySettingRequestSchema({required this.langCode});

  Map<String, dynamic> toJson() {
    return {
      'lang_code': langCode,
    };
  }

  String get storageKey => 'topic_list-$langCode';
}

class ActivitySettingResponseSchema {
  final String defaultName;
  final String name;

  ActivitySettingResponseSchema({
    required this.defaultName,
    required this.name,
  });

  factory ActivitySettingResponseSchema.fromJson(Map<String, dynamic> json) {
    return ActivitySettingResponseSchema(
      defaultName: json['default_name'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'default_name': defaultName,
      'name': name,
    };
  }
}
