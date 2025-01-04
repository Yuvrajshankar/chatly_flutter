import 'package:chatly_flutter/provider/theme_provider.dart';
import 'package:chatly_flutter/provider/user_provider.dart';
import 'package:chatly_flutter/screens/auth.dart';
import 'package:chatly_flutter/screens/home.dart';
import 'package:chatly_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
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
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatly',
      theme: Provider.of<ThemeProvider>(context).themeData,
      // home: isLoading
      //     ? const Center(child: CircularProgressIndicator())
      //     : Provider.of<UserProvider>(context).user.token.isEmpty
      //         ? const Auth()
      //         : const Home(),
      // home: Provider.of<UserProvider>(context).user.token.isEmpty
      //     ? const Auth()
      //     : const Home(),
      home: Home(),
    );
  }
}
