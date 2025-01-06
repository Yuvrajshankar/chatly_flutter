import 'package:chatly_flutter/components/friend_profile.dart';
import 'package:chatly_flutter/widgets/my_pop_up.dart';
import 'package:flutter/material.dart';

class Friends extends StatelessWidget {
  final List<Map<String, String>> friends;
  final Function(Map<String, String>) onFriendSelected;

  const Friends({
    super.key,
    required this.friends,
    required this.onFriendSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];

        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  MyPopUp(
                    context: context,
                    content: FriendProfile(
                      image: friend['image']!,
                      name: friend['name']!,
                      email: friend['email']!,
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(friend['image']!),
                  radius: 25,
                ),
              ),
              title: Text(
                friend['name']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              subtitle: Text(
                "Say 👋🏻 hi to ${friend['name']!}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              onTap: () => onFriendSelected(friend),
            ),
          ),
        );
      },
    );
  }
}
