class Status {
  static const String namespace = 'im.fluffychat.statuses';
  final String senderId;
  final String message;
  final DateTime dateTime;

  Status(this.senderId, this.message, this.dateTime);

  Status.fromJson(Map<String, dynamic> json)
      : senderId = json['sender_id'],
        message = json['message'],
        dateTime = DateTime.fromMillisecondsSinceEpoch(json['date_time']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sender_id': senderId,
        'message': message,
        'date_time': dateTime.millisecondsSinceEpoch,
      };
}
