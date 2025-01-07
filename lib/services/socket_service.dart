import 'package:chatly_flutter/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static late IO.Socket socket;

  static void initializeSocket(String userId) {
    socket = IO.io('${Constants.uri}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.onConnect((_) {
      print('Connected to Socket.IO');
      socket.emit('setup', {'_id': userId});
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO');
    });
  }

  static void sendMessage(Map<String, dynamic> message) {
    socket.emit('new message', message);
  }

  static void listenForMessages(Function(Map<String, dynamic>) callback) {
    socket.on('message received', (data) {
      callback(data);
    });
  }

  static void disconnectSocket() {
    socket.disconnect();
  }
}
