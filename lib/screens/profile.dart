import 'dart:typed_data';

import 'package:chatly_flutter/utils/utils.dart';
import 'package:chatly_flutter/widgets/my_button.dart';
import 'package:chatly_flutter/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStRPupL6Q12lc_6nyw8GhGH2gN4l1qtA5nZA&s"),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
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
              hintText: "kitty",
              obscureText: false,
            ),
            MyTextField(
              controller: emailController,
              hintText: "kitty@gmail.com",
              obscureText: false,
            ),
            MyButton(
              onTap: () {},
              content: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Update Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
