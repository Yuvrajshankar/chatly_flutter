import 'package:chatly_flutter/components/chat_messages.dart';
import 'package:chatly_flutter/services/message_services.dart';
// import 'package:chatly_flutter/services/socket_service.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String name;
  final String image;
  final String receiverId;

  const Chat({
    super.key,
    required this.name,
    required this.image,
    required this.receiverId,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = false;
  final MessageServices messageServices = MessageServices();

  void sendMessage() async {
    setState(() {
      isLoading = true;
    });

    await messageServices.sendMessage(
      receiverId: widget.receiverId,
      message: _messageController.text,
    );

    // final message = {
    //   "receiver": widget.receiverId,
    //   "message": _messageController.text.trim(),
    // };

    // SocketService.sendMessage(message);

    setState(() {
      isLoading = false;
      _messageController.clear();
      // _messageController.text = '';
    });
  }

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
              child: ChatMessages(
                receiverId: widget.receiverId,
              ),
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
                isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          // Handle send message action
                          // String message = _messageController.text.trim();
                          if (_messageController.text.isNotEmpty) {
                            debugPrint(
                                "Send message: ${_messageController.text}");
                            sendMessage();
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
