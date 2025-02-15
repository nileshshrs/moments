import 'package:moments/app/di/di.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:shared_preferences/shared_preferences.dart';

class SocketService {
  io.Socket? _socket;

  void connect() {
    final sharedPreferences = getIt<SharedPreferences>(); // Get SharedPreferences instance
    final userID = sharedPreferences.getString('userID') ?? "";

    if (userID.isEmpty) {
      print("UserID is empty, cannot connect to Socket.IO");
      return;
    }

    _socket = io.io('http://10.0.2.2:6278',
      io.OptionBuilder()
        .setTransports(['websocket']) // Use WebSocket
        .setExtraHeaders({'Content-Type': 'application/json'}) // Set headers
        .build()
    );

    _socket!.onConnect((_) {
      print('Connected to Socket.IO Server');
      _socket!.emit('adduser', userID);
    });

    _socket!.on('getusers', (users) {
      print("Connected users: $users");
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from server');
    });

    _socket!.onError((data) {
      print('Socket Error: $data');
    });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    print('Disconnected from the server');
  }
  void sendMessage(Map<String, dynamic> messageData) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit("send", messageData);
      print("Message sent via socket: $messageData");
    } else {
      print("Socket is not connected. Message not sent.");
    }
  }
   void onMessageReceived(Function(Map<String, dynamic>) callback) {
    _socket?.on("get", (data) {
      callback(data);
    });
  }
}
