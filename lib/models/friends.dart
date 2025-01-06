import 'dart:convert';

class Friends {
  final String id;
  final String userName;
  final String profileImage;
  final String email;

  Friends({
    required this.id,
    required this.userName,
    required this.profileImage,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'profileImage': profileImage,
      'email': email,
    };
  }

  factory Friends.fromMap(Map<String, dynamic> map) {
    return Friends(
      id: map['_id'] ?? '',
      userName: map['userName'] ?? '',
      profileImage: map['profileImage'] ?? '',
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Friends.fromJson(String source) =>
      Friends.fromMap(json.decode(source));

  static List<Friends> fromJsonList(String source) {
    final List<dynamic> jsonList = json.decode(source);
    return jsonList.map((item) => Friends.fromMap(item)).toList();
  }

  @override
  String toString() {
    return 'Friends(id: $id, userName: $userName, profileImage: $profileImage, email: $email)';
  }
}
