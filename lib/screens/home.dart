import 'package:chatly_flutter/components/friends.dart';
import 'package:chatly_flutter/provider/theme_provider.dart';
import 'package:chatly_flutter/screens/add_friend.dart';
import 'package:chatly_flutter/screens/chat.dart';
import 'package:chatly_flutter/screens/manage_friends.dart';
import 'package:chatly_flutter/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, String>> friends = [
    {
      "name": "John Doe",
      "email": "jondoe@gmail.com",
      "subtitle": "Last online 5 min ago",
      "image": "https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg",
    },
    {
      "name": "Jane Smith",
      "email": "jondoe@gmail.com",
      "subtitle": "Last online 2 hours ago",
      "image": "https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg",
    },
    {
      "name": "Alice Johnson",
      "email": "jondoe@gmail.com",
      "subtitle": "Last online yesterday",
      "image":
          "https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Expanded(
            child: Friends(
              friends: friends,
              onFriendSelected: (friend) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(
                      name: friend['name']!,
                      image: friend['image']!,
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
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStRPupL6Q12lc_6nyw8GhGH2gN4l1qtA5nZA&s"),
                  radius: 18,
                ),
                accountName: Text(
                  "kitty",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                accountEmail: Text(
                  "kitty@gmail.com",
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
