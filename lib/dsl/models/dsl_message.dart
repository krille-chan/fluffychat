class DSLMessage {
  final int version;
  final String type;
  final Map<String, dynamic> data;

  DSLMessage({
    required this.version,
    required this.type,
    required this.data,
  });

  factory DSLMessage.fromMap(Map<String, dynamic> map) {
    final v = map['v'];
    final type = map['type'];
    final data = map['data'];

    if (v is! int) {
      throw Exception('DSLMessage: Invalid or missing "v" (version)');
    }

    if (type is! String || type.isEmpty) {
      throw Exception('DSLMessage: Invalid or missing "type"');
    }

    if (data is! Map) {
      throw Exception('DSLMessage: Invalid or missing "data"');
    }

    return DSLMessage(
      version: v,
      type: type,
      data: Map<String, dynamic>.from(data),
    );
  }

  T? get<T>(String key) {
    final value = data[key];
    return value is T ? value : null;
  }

  @override
  String toString() {
    return 'DSLMessage(v: $version, type: $type, data: $data)';
  }
}