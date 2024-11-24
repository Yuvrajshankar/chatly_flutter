import 'package:chatly_flutter/services/auth_services.dart';
import 'package:flutter/material.dart';

import 'package:chatly_flutter/widgets/my_button.dart';
import 'package:chatly_flutter/widgets/my_text_field.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final AuthServices authServices = AuthServices();

    void loginUser() {
      authServices.signInUser(
        context: context,
        email: emailController.text,
        password: passwordController.text,
      );
    }

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
          onTap: loginUser,
          text: "Sign in",
        ),
      ],
    );
  }
}
