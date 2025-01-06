import 'dart:convert';

import 'package:chatly_flutter/provider/user_provider.dart';
import 'package:chatly_flutter/screens/auth.dart';
import 'package:chatly_flutter/screens/home.dart';
import 'package:chatly_flutter/utils/constants.dart';
import 'package:chatly_flutter/utils/utils.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final cloudinary = CloudinaryPublic('dkh984g6c', 'yuvraj', cache: false);

  // register

  // login
  Future<void> logInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/auth/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userProvider.setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
            (route) => false,
          );
        },
      );
      // debugPrint("userProvider: ${userProvider.user.email}");
    } catch (e) {
      // debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  // get user details
  Future<void> getUserData(
    BuildContext context,
  ) async {
    try {
      // debugPrint("Get User Data Function Working Start");
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      // debugPrint("token: $token");

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/auth/already'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      // debugPrint("tokenRes: ${tokenRes.body}");

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/auth/user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        // debugPrint("response: $response");
        // debugPrint("userRes: ${userRes.body}");

        userProvider.setUser(userRes.body);
        // debugPrint("userProvider: ${userProvider.user.token}");
      }
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  // update

  // logout
  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const Auth(),
      ),
      (route) => false,
    );
  }
}
