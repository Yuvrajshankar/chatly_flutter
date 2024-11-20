import 'package:chatly_flutter/components/chat_messages.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String name;
  final String image;

  const Chat({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: ChatMessages(),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Typing field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Send button
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    // Handle send message action
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      debugPrint("Send message: $message");
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
