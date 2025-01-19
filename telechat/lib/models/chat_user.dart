class ChatUser {
  String? createdAt;
  late final String image;
  String? lastActive;
  String? about;
  late final String name;
  bool? isOnline;
  String? id;
  late final String email;
  String? pushToken;

  ChatUser(
      {this.createdAt,
      required this.image,
      this.lastActive,
      this.about,
      required this.name,
      this.isOnline,
      this.id,
      required this.email,
      this.pushToken});

  ChatUser.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] ?? '';
    image = json['image'] ?? '';
    lastActive = json['lastActive'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    isOnline = json['isOnline'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['image'] = this.image;
    data['lastActive'] = this.lastActive;
    data['about'] = this.about;
    data['name'] = this.name;
    data['isOnline'] = this.isOnline;
    data['id'] = this.id;
    data['email'] = this.email;
    data['push_token'] = this.pushToken;
    return data;
  }
}