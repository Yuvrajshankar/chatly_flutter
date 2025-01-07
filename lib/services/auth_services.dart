import 'dart:convert';
import 'dart:typed_data';

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
  Future<void> registerUser({
    required BuildContext context,
    required Uint8List profileImage,
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      // debugPrint("REGISTERING STARTING");
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      // debugPrint(userProvider.toString());
      CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          profileImage,
          identifier: 'profile_image_$userName',
        ),
      );

      String profileImageUrl = cloudinaryResponse.secureUrl;
      // debugPrint("profileImageUrl: $profileImageUrl");
      // debugPrint("userName: $userName");
      // debugPrint("email: $email");
      // debugPrint("password: $password");

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/auth/register'),
        body: jsonEncode({
          'profileImage': profileImageUrl,
          'userName': userName,
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // debugPrint("res: ${res.body}");

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
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

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
  Future<void> updateUser({
    required BuildContext context,
    required Uint8List? profileImage,
    required String userName,
    required String email,
  }) async {
    try {
      // debugPrint("UPDATE USER STARTED");
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String? profileImageUrl;
      // debugPrint("profileImageUrl: $profileImageUrl");

      // Upload new profile image if provided
      if (profileImage != null) {
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            profileImage,
            identifier: 'profile_image_$userName',
          ),
        );
        profileImageUrl = cloudinaryResponse.secureUrl;
        // debugPrint("profileImageUrl12: $profileImageUrl");
      }

      // Prepare the request payload
      Map<String, dynamic> updateData = {
        'userName': userName,
        'email': email,
      };

      if (profileImageUrl != null) {
        updateData['profileImage'] = profileImageUrl;
      }

      // Make the HTTP request
      http.Response res = await http.patch(
        Uri.parse('${Constants.uri}/auth/update'),
        body: jsonEncode(updateData),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token,
        },
      );

      // debugPrint("res: ${res.body}");

      // Handle the response
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final responseData = jsonDecode(res.body);
          responseData['user']['token'] = userProvider.user.token;
          userProvider.setUser(jsonEncode(responseData['user']));
          // userProvider.setUser(res.body);
          // debugPrint("email: ${userProvider.user.email}");
          // debugPrint("userName: ${userProvider.user.userName}");
          // debugPrint("profileImage: ${userProvider.user.profileImage}");
          // debugPrint("token: ${userProvider.user.token}");
          // debugPrint("password: ${userProvider.user.toString()}");
          showSnackBar(context, 'Profile updated successfully!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

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
