import 'package:flutter/material.dart';

class FriendProfile extends StatelessWidget {
  final String image;
  final String name;
  final String email;

  const FriendProfile({
    super.key,
    required this.image,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(image),
          radius: 50,
        ),
        const SizedBox(width: 20),
        Text(
          name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          email,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
