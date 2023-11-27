// Package imports:
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
    final _data = <String, dynamic>{};
    _data['class_id'] = classId;
    _data['user_ids'] = userIds;
    _data['analytics'] = analytics.map((e) => e.toJson()).toList();
    return _data;
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
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['section'] = section.map((e) => e.toJson()).toList();
    return _data;
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
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['class_total'] = classTotal;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data();
  set value(String val) => _value = val;
  String get value {
    if (_value == null) {
      return _value.toString();
    }
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
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['value'] = _value;
    _data['value_type'] = value_type;
    return _data;
  }
}
