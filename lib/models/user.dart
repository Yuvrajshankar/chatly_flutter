import 'dart:convert';

class User {
  final String id;
  final String profileImage;
  final String userName;
  final String email;
  final String token;
  final List friends;

  User({
    required this.id,
    required this.profileImage,
    required this.userName,
    required this.email,
    required this.token,
    required this.friends,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileImage': profileImage,
      'userName': userName,
      'email': email,
      'token': token,
      'friends': friends,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      profileImage: map['profileImage'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      friends: map['friends'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

}
