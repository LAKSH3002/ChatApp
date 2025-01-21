class ChatUser {
  late String createdAt;
  late String image;
  late String lastActive;
  late String about;
  late String name;
  // bool? isOnline;
  late String id;
  late String email;
  String? pushToken;

  ChatUser(
      {required this.createdAt,
      required this.image,
      required this.lastActive,
      required this.about,
      required this.name,
      // this.isOnline,
      required this.id,
      required this.email,
      this.pushToken});

  ChatUser.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] ?? '';
    image = json['image'] ?? '';
    lastActive = json['lastActive'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    // isOnline = json['isOnline'] ?? '';
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
    // data['isOnline'] = this.isOnline;
    data['id'] = this.id;
    data['email'] = this.email;
    data['push_token'] = this.pushToken;
    return data;
  }
}