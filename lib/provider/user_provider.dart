import 'package:flutter/material.dart';

import 'package:chatly_flutter/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    profileImage: '',
    userName: '',
    email: '',
    token: '',
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
