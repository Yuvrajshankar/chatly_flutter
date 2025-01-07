import 'package:chatly_flutter/components/search_friend.dart';
import 'package:chatly_flutter/models/friends.dart';
import 'package:chatly_flutter/services/friend_services.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final List<Friends> _searchResults = [];
  bool _isLoading = false;

  void _searchFriend(String userName) async {
    if (userName.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    setState(() => _isLoading = true);

    final friendServices = FriendServices();
    final results =
        await friendServices.searchFriends(context, userName.trim());

    setState(() {
      _searchResults.clear();
      _searchResults.addAll(results);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Add friends",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: Column(
        children: [
          SearchFriend(onChanged: _searchFriend),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          "No friends found.",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final friend = _searchResults[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(friend.profileImage),
                                  radius: 25,
                                ),
                                title: Text(
                                  friend.userName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                subtitle: Text(
                                  friend.email,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    FriendServices()
                                        .addRemoveFriend(context, friend.id);
                                  },
                                  icon: Icon(
                                    Icons.person_add,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// class AddFriend extends StatefulWidget {
//   const AddFriend({super.key});

//   @override
//   State<AddFriend> createState() => _AddFriendState();
// }

// class _AddFriendState extends State<AddFriend> {
//   final List<Friends> _searchResults = [];
//   bool _isLoading = false;

//   void _searchFriend(String userName) async {
//     if (userName.isEmpty) {
//       setState(() {
//         _searchResults.clear();
//       });
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//     });

//     final FriendServices friendServices = FriendServices();
//     final results =
//         await friendServices.searchFriends(context, userName.trim());

//     setState(() {
//       _searchResults.clear();
//       _searchResults.addAll(results);
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> friends = [
//       {
//         "name": "John Doe",
//         "subtitle": "Last online 5 min ago",
//         "image":
//             "https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg",
//       },
//       {
//         "name": "Jane Smith",
//         "subtitle": "Last online 2 hours ago",
//         "image":
//             "https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg",
//       },
//       {
//         "name": "Alice Johnson",
//         "subtitle": "Last online yesterday",
//         "image":
//             "https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp",
//       },
//     ];

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         title: Text(
//           "Add friends",
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.secondary,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           SearchFriend(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: friends.length,
//               itemBuilder: (context, index) {
//                 final friend = friends[index];

//                 return Padding(
//                   padding:
//                       const EdgeInsets.only(left: 10.0, right: 10, top: 10),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(friend['image']!),
//                         radius: 25,
//                       ),
//                       title: Text(
//                         friend['name']!,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).colorScheme.secondary,
//                         ),
//                       ),
//                       subtitle: Text(
//                         friend['subtitle']!,
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.primaryContainer,
//                         ),
//                       ),
//                       trailing: IconButton(
//                         onPressed: () {},
//                         icon: Icon(
//                           Icons.person_add,
//                           color: Theme.of(context).colorScheme.secondary,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
