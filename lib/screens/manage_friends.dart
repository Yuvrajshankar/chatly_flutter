import 'package:chatly_flutter/components/remove_friend.dart';
import 'package:chatly_flutter/provider/friend_provider.dart';
import 'package:chatly_flutter/widgets/my_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageFriends extends StatelessWidget {
  const ManageFriends({super.key});

  @override
  Widget build(BuildContext context) {
    var friends = Provider.of<FriendProvider>(context).friendsList;
    debugPrint("friendID: $friends");
    // final friendsData = friends.map((friend) {
    //   return {
    //     'name': friend.userName,
    //     'email': friend.email,
    //     'image': friend.profileImage,
    //   };
    // }).toList();
    // final List<Map<String, String>> friends = [
    //   {
    //     "name": "John Doe",
    //     "subtitle": "Last online 5 min ago",
    //     "image":
    //         "https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg",
    //   },
    //   {
    //     "name": "Jane Smith",
    //     "subtitle": "Last online 2 hours ago",
    //     "image":
    //         "https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg",
    //   },
    //   {
    //     "name": "Alice Johnson",
    //     "subtitle": "Last online yesterday",
    //     "image":
    //         "https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp",
    //   },
    // ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Manage friends",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: ListView.builder(
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
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(friend.profileImage),
                  radius: 25,
                ),
                title: Text(
                  friend.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                subtitle: Text(
                  'Do you want to remove "${friend.userName}"',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    MyPopUp(
                      context: context,
                      content: RemoveFriend(
                        friendName: friend.userName,
                        friendId: friend.id,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
