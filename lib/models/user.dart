import 'dart:convert';

class User {
  final String id;
  final String profileImage;
  final String userName;
  final String email;
  final String token;

  User({
    required this.id,
    required this.profileImage,
    required this.userName,
    required this.email,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileImage': profileImage,
      'userName': userName,
      'email': email,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      profileImage: map['profileImage'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
