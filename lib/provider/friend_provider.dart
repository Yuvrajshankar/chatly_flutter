import 'package:chatly_flutter/models/friends.dart';
import 'package:flutter/material.dart';

class FriendProvider extends ChangeNotifier {
  List<Friends> _friendsList = [];

  List<Friends> get friendsList => _friendsList;

  void setFriends(List<Friends> friends) {
    _friendsList = friends;
    notifyListeners();
  }

  void updateFriend(String id, Friends updatedFriend) {
    final index = _friendsList.indexWhere((friend) => friend.id == id);
    if (index != -1) {
      _friendsList[index] = updatedFriend;
      notifyListeners();
    }
  }

  void removeFriend(String friendId) {
    _friendsList.removeWhere((friend) => friend.id == friendId);
    notifyListeners();
  }
}
