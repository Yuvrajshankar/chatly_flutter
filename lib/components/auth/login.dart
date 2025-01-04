import 'package:chatly_flutter/services/auth_services.dart';
import 'package:chatly_flutter/widgets/my_button.dart';
import 'package:chatly_flutter/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final AuthServices authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextField(
          controller: emailController,
          hintText: "Email",
          obscureText: false,
        ),
        MyTextField(
          controller: passwordController,
          hintText: "Password",
          obscureText: true,
        ),
        MyButton(
          onTap: () {},
          content: isLoading
              ? const CircularProgressIndicator()
              : const Text(
                  "Sign in",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
