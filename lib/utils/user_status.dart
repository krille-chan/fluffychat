class UserStatus {
  String statusMsg;
  String userId;
  int receivedAt;

  UserStatus();

  UserStatus.fromJson(Map<String, dynamic> json) {
    statusMsg = json['status_msg'];
    userId = json['user_id'];
    receivedAt = json['received_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status_msg'] = statusMsg;
    data['user_id'] = userId;
    data['received_at'] = receivedAt;
    return data;
  }
}
