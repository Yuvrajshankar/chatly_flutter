import 'dart:typed_data';

import 'package:chatly_flutter/services/auth_services.dart';
import 'package:chatly_flutter/utils/utils.dart';
import 'package:chatly_flutter/widgets/my_button.dart';
import 'package:chatly_flutter/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  Uint8List? _image;
  final AuthServices authServices = AuthServices();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signupUser() async {
    setState(() {
      isLoading = true;
    });

    if (_image != null) {
      await authServices.registerUser(
        context: context,
        profileImage: _image!,
        userName: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    } else {
      showSnackBar(context, 'Please select a profile Image');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: MemoryImage(_image!),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: const NetworkImage(
                        'https://i.stack.imgur.com/l60Hf.png'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
            Positioned(
              bottom: -2,
              left: 60,
              child: IconButton(
                onPressed: selectImage,
                icon: const Icon(Icons.add_a_photo),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        MyTextField(
          controller: usernameController,
          hintText: "Username",
          obscureText: false,
        ),
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
          onTap: signupUser,
          content: isLoading
              ? const CircularProgressIndicator()
              : const Text(
                  "Sign up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
