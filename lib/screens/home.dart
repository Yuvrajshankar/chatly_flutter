import 'package:chatly_flutter/components/friends.dart';
import 'package:chatly_flutter/provider/friend_provider.dart';
import 'package:chatly_flutter/provider/theme_provider.dart';
import 'package:chatly_flutter/provider/user_provider.dart';
import 'package:chatly_flutter/screens/add_friend.dart';
import 'package:chatly_flutter/screens/chat.dart';
import 'package:chatly_flutter/screens/manage_friends.dart';
import 'package:chatly_flutter/screens/profile.dart';
import 'package:chatly_flutter/services/auth_services.dart';
import 'package:chatly_flutter/services/friend_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // getting friends
    final FriendServices friendServices = FriendServices();
    // bool isLoading = false;

    friendServices.getFriends(context);

    // accessing providers
    final user = Provider.of<UserProvider>(context).user;
    var friends = Provider.of<FriendProvider>(context).friendsList;

    // debugPrint("Home token: ${user.token}");
    // debugPrint("Friends: ${friends.length}");

    // Convert List<Friends> to List<Map<String, String>>
    final friendsData = friends.map((friend) {
      return {
        'id': friend.id,
        'name': friend.userName,
        'email': friend.email,
        'image': friend.profileImage,
      };
    }).toList();

    // debugPrint("friendsData: $friendsData");

    // Log Out
    void signOutUser(BuildContext context) {
      AuthServices().signOut(context);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Chatly",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFriend(),
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.person_add,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      body: friends.isEmpty
          ? Center(
              child: Text("No friends. Make some!"),
            )
          : Column(
              children: [
                Expanded(
                  child: Friends(
                    friends: friendsData,
                    onFriendSelected: (friend) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(
                            name: friend['name']!,
                            image: friend['image']!,
                            receiverId: friend['id']!,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                currentAccountPictureSize: const Size.square(40),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(user.profileImage),
                  radius: 18,
                ),
                accountName: Text(
                  user.userName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                accountEmail: Text(
                  user.email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                'My Profile',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.group,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                ' Manage Friends ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageFriends(),
                  ),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Theme",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Switch(
                    value: Provider.of<ThemeProvider>(context, listen: false)
                        .isLightMode,
                    onChanged: (value) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () => signOutUser(context),
            ),
          ],
        ),
      ),
    );
  }
}
