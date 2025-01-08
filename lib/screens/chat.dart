import 'package:chatly_flutter/provider/user_provider.dart';
import 'package:chatly_flutter/services/message_services.dart';
import 'package:chatly_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  bool isMessagesLoading = false;
  bool isLoading = false;
  final MessageServices messageServices = MessageServices();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _initializeSocket();

    // Scroll to the bottom after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _initializeSocket() {
    socket = IO.io(
      '${Constants.uri}',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    // Connect to the server
    socket?.connect();

    // Listen for connection
    socket?.on('connect', (_) {
      debugPrint('Connected to Socket.IO');
      socket?.emit('setup', {
        '_id': Provider.of<UserProvider>(context, listen: false).user.id,
      });
    });

    // Listen for new messages
    socket?.off('message received');
    socket?.on('message received', (data) {
      debugPrint('New message received: $data');
      if (mounted) {
        setState(() {
          messages.add(data);
          // _scrollToBottom();
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });

    // Handle disconnection
    socket?.on(
      'disconnect',
      (_) => debugPrint('Socket.IO disconnected'),
    );
  }

  // Function to scroll to the bottom of the ListView
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  // FETCH MESSAGES
  Future<void> _fetchMessages() async {
    setState(() => isMessagesLoading = true);
    try {
      // debugPrint("FETCH MESSAGES STARTING");
      final fetchedMessages =
          await MessageServices().getMessages(widget.receiverId);
      // debugPrint("fetchedMessages: ${fetchedMessages.toString()}");
      setState(() {
        messages = fetchedMessages;
        isMessagesLoading = false;
      });

      // Scroll to bottom after loading messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      setState(() => isMessagesLoading = false);
    }
  }

  // SEND MESSAGE
  void sendMessage() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    setState(() {
      isLoading = true;
    });

    await messageServices.sendMessage(
      receiverId: widget.receiverId,
      message: _messageController.text,
    );

    final newMessage = {
      'sender': user.id,
      'receiver': widget.receiverId,
      'message': _messageController.text
    };

    // Emit the message to the server
    socket?.emit('new message', newMessage);

    setState(() {
      // messages.add(newMessage);
      isLoading = false;
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

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
              child: isMessagesLoading
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

                        return isMessagesLoading
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
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer, // Border color for sender messages
                                        width: 2.0, // Border width
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      message["message"] ??
                                          '', // Provide a default value
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      },
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
