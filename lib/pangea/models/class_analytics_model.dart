import 'package:intl/intl.dart';

class ClassAnalyticsModel {
  ClassAnalyticsModel();
  late final Null classId;
  late final List<String> userIds;
  late final List<Analytics> analytics;
  get tableView {}
  ClassAnalyticsModel.fromJson(Map<String, dynamic> json) {
    classId = null;
    userIds = List.castFrom<dynamic, String>(json['user_ids']);
    analytics =
        List.from(json['analytics']).map((e) => Analytics.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['class_id'] = classId;
    data['user_ids'] = userIds;
    data['analytics'] = analytics.map((e) => e.toJson()).toList();
    return data;
  }
}

class Analytics {
  Analytics({
    required this.title,
    required this.section,
  });
  late final String title;
  late final List<Section> section;

  Analytics.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    section =
        List.from(json['section']).map((e) => Section.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['section'] = section.map((e) => e.toJson()).toList();
    return data;
  }
}

class Section {
  Section({
    required this.title,
    required this.classTotal,
    required this.data,
  });
  late final String title;
  late final String classTotal;
  late final List<Data> data;

  Section.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    classTotal = json['class_total'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['class_total'] = classTotal;
    (data['data'] as List).map((item) => Data.fromJson(item)).toList();
    return data;
  }
}

class Data {
  Data();
  set value(String val) => _value = val;
  String get value {
    if (value_type == 'date') {
      return DateFormat('yyyy/M/dd hh:mm a')
          .format(DateTime.parse(_value).toLocal())
          .toString();
    }
    return _value;
  }

  late final String userId;
  late final String _value;
  late final String value_type;
  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    _value = json['value'];
    value_type = json['value_type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['value'] = _value;
    data['value_type'] = value_type;
    return data;
  }
}
