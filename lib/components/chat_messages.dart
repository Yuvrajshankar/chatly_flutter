import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  // Initialize a ScrollController
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> messages = [
    {
      "messageContent": "Hello, Will",
      "messageType": "receiver",
    },
    {
      "messageContent": "How have you been?",
      "messageType": "receiver",
    },
    {
      "messageContent": "Hey Kriss, I am doing fine dude. wbu?",
      "messageType": "sender",
    },
    {
      "messageContent": "ehhhh, doing OK.",
      "messageType": "receiver",
    },
    {
      "messageContent": "Is there any thing wrong?",
      "messageType": "sender",
    },
    {
      "messageContent": "Hello, Will",
      "messageType": "receiver",
    },
    {
      "messageContent": "How have you been?",
      "messageType": "receiver",
    },
    {
      "messageContent": "Hey Kriss, I am doing fine dude. wbu?",
      "messageType": "sender",
    },
    {
      "messageContent": "ehhhh, doing OK.",
      "messageType": "receiver",
    },
    {
      "messageContent": "Is there any thing wrong?",
      "messageType": "sender",
    },
    {
      "messageContent": "Hello, Will",
      "messageType": "receiver",
    },
    {
      "messageContent": "How have you been?",
      "messageType": "receiver",
    },
    {
      "messageContent": "Hey Kriss, I am doing fine dude. wbu?",
      "messageType": "sender",
    },
    {
      "messageContent": "ehhhh, doing OK.",
      "messageType": "receiver",
    },
    {
      "messageContent": "Is there any thing wrong?",
      "messageType": "sender",
    },
  ];

  @override
  void initState() {
    super.initState();

    // Scroll to the bottom after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    // Dispose the ScrollController when the widget is removed from the widget tree
    _scrollController.dispose();
    super.dispose();
  }

  // Function to scroll to the bottom of the ListView
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController, // Assign the controller to the ListView
      itemCount: messages.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      itemBuilder: (context, index) {
        final message = messages[index];

        return Container(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: (message["messageType"] == "receiver"
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (message["messageType"] == "receiver"
                    ? Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.primary),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer, // Border color for sender messages
                  width: 2.0, // Border width
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                message["messageContent"] ?? '', // Provide a default value
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
