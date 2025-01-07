import 'dart:convert';

import 'package:chatly_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessageServices {
  // GET MESSAGES
  Future<List<Map<String, dynamic>>> getMessages(String receiverId) async {
    try {
      // debugPrint("Get Messages Starting");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        debugPrint('No token found');
        return [];
      }

      // debugPrint("token: $token");
      // debugPrint("receiverId: $receiverId");

      final response = await http.get(
        Uri.parse('${Constants.uri}/message/$receiverId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      // debugPrint("response: $response");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // debugPrint("data: $data");
        // Convert data to a list of Map<String,dynamic>
        // return data.map((message) => message as Map<String, dynamic>).toList();

        return data.cast<Map<String, dynamic>>();
      } else {
        debugPrint('Failed to search friend: ${response.body}');
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
    return [];
  }

  // send messages
  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    try {
      // debugPrint("SEND MESSAGES STARTING");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        debugPrint('No token found');
      }

      // debugPrint("token: $token");
      // debugPrint("receiverId: $receiverId");
      // debugPrint("message: $message");

      final response = await http.post(
        Uri.parse('${Constants.uri}/message/$receiverId'),
        body: jsonEncode({
          'message': message,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      // return response
      // debugPrint("response: $response");
    } catch (e) {
      print(e);
    }
  }
}
