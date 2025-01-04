import 'package:flutter/material.dart';

import 'package:chatly_flutter/components/auth/login.dart';
import 'package:chatly_flutter/components/auth/register.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool isLogin = true;

  void togglePage() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.chat,
                color: Theme.of(context).colorScheme.primary,
                size: 100,
              ),

              const SizedBox(height: 15),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "welcome back!" : "welcome to chatly"
                  Text(
                    isLogin ? 'Welcome back!' : 'Welcome to chatly',
                  ),

                  const SizedBox(height: 10),

                  // login || signup
                  isLogin ? const Login() : const Register(),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? "Not a member? " : "Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: togglePage,
                      child: Text(
                        isLogin ? "Sign up" : "Sign in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
