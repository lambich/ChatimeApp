class ChatUser {
  ChatUser({
    required this.about,
    required this.createdAt,
    required this.lastName,
    required this.id,
    required this.lastActive,
    required this.isOnline,
    required this.avatar,
    required this.firstName,
    required this.email,
    required this.pushToken,
  });
  late String about;
  late String createdAt;
  late String lastName;
  late String id;
  late String lastActive;
  late bool isOnline;
  late String avatar;
  late String firstName;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    lastName = json['last_name'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['is_online'] ?? '';
    avatar = json['avatar'] ?? '';
    firstName = json['first_name'];
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['about'] = about;
    data['created_at'] = createdAt;
    data['last_name'] = lastName;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['avatar'] = avatar;
    data['first_name'] = firstName;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
