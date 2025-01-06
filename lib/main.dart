import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatly_flutter/provider/friend_provider.dart';
import 'package:chatly_flutter/provider/theme_provider.dart';
import 'package:chatly_flutter/provider/user_provider.dart';
import 'package:chatly_flutter/screens/auth.dart';
import 'package:chatly_flutter/screens/home.dart';
import 'package:chatly_flutter/services/auth_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => FriendProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthServices authServices = AuthServices();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await authServices.getUserData(context);
    } catch (e) {
      debugPrint("Error initializing user data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatly',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            )
          : Provider.of<UserProvider>(context).user.token.isEmpty
              ? const Auth()
              : const Home(),
    );
  }
}
