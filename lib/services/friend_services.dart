import 'dart:convert';

import 'package:chatly_flutter/models/friends.dart';
import 'package:chatly_flutter/provider/friend_provider.dart';
import 'package:chatly_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:chatly_flutter/utils/utils.dart';

class FriendServices {
  // GET ALL FRIENDS
  Future<void> getFriends(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      // debugPrint("token: $token");

      if (token == null) {
        throw Exception("Token not found. Please log in again.");
      }

      // debugPrint("response is starting STARTING");
      // Make HTTP GET request
      final response = await http.get(
        Uri.parse('${Constants.uri}/auth/friends'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      // debugPrint("friends response : $response");

      // debugPrint("StatusCode Checking");

      // Check for successful response
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Friends> friendsList =
            jsonData.map((item) => Friends.fromMap(item)).toList();

        // debugPrint("jsonData: $jsonData");
        // debugPrint("friendsData: ${friendsList.length}");

        // Update FriendProvider with fetched data
        Provider.of<FriendProvider>(context, listen: false)
            .setFriends(friendsList);
      } else {
        // Handle HTTP errors
        throw Exception('Failed to fetch friends: ${response.body}');
      }
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  // ADD-REMOVE FRIENDS
  Future<void> addRemoveFriend(
    BuildContext context,
    String friendId,
  ) async {
    try {
      debugPrint("add-remove function STARTING");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      debugPrint("token: $token");

      if (token == null) {
        throw Exception("Token not found. Please log in again.");
      }

      debugPrint("friendId: $friendId");

      // Make HTTP PATCH request
      final response = await http.patch(
        Uri.parse('${Constants.uri}/auth/$friendId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      debugPrint("response: ${response.body}");

      // response checking
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint("data: $data");
        final friendDetails = data['friendDetails'];
        debugPrint("friendDetails: $friendDetails");

        // remove from provider
        Provider.of<FriendProvider>(context, listen: false)
            .removeFriend(friendId);

        Navigator.pop(context);

        // showSnackBar(
        //   context,
        //   'Friend successfully added/removed.',
        // );
      } else {
        throw Exception('Failed to add/remove friend: ${response.body}');
      }
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }
}
