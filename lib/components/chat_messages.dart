import 'package:chatly_flutter/provider/user_provider.dart';
import 'package:chatly_flutter/services/message_services.dart';
import 'package:chatly_flutter/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatefulWidget {
  final String receiverId;

  const ChatMessages({
    super.key,
    required this.receiverId,
  });

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  // Initialize a ScrollController
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
    _fetchMessages();

    // Scroll to the bottom after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _initializeSocket() {
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;

    SocketService.initializeSocket(userId);
    SocketService.listenForMessages((newMessage) {
      if (newMessage['sender'] == widget.receiverId ||
          newMessage['receiver'] == widget.receiverId) {
        setState(() {
          messages.add(newMessage);
        });
        _scrollToBottom();
      }
    });
  }

  // Function to scroll to the bottom of the ListView
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  Future<void> _fetchMessages() async {
    setState(() => isLoading = true);
    try {
      debugPrint("FETCH MESSAGES STARTING");
      final fetchedMessages =
          await MessageServices().getMessages(widget.receiverId);
      debugPrint("fetchedMessages: ${fetchedMessages.toString()}");
      setState(() {
        messages = fetchedMessages;
        isLoading = false;
      });

      // Scroll to bottom after loading messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    SocketService.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          )
        : ListView.builder(
            controller:
                _scrollController, // Assign the controller to the ListView
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            itemBuilder: (context, index) {
              final message = messages[index];

              return isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (message["receiver"] == user.id
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (message["receiver"] == user.id
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
                            message["message"] ?? '', // Provide a default value
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
