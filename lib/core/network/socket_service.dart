import 'package:moments/app/di/di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? _socket;
  Function(Map<String, dynamic>)? _onNotificationReceived;

  void connect() {
    final sharedPreferences = getIt<SharedPreferences>();
    final userID = sharedPreferences.getString('userID') ?? "";

    if (userID.isEmpty) {
      print("UserID is empty, cannot connect to Socket.IO");
      return;
    }

    _socket = io.io(
        'http://192.168.31.132:6278',
        io.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {'Content-Type': 'application/json'}).build());

    _socket!.onConnect((_) {
      print('Connected to Socket.IO Server');
      _socket!.emit('adduser', userID);
    });

    _socket!.on('getusers', (users) {
      print("Connected users: $users");
    });

    _socket!.on('notification', (data) {
      print("New notification received: $data");
      if (_onNotificationReceived != null) {
        _onNotificationReceived!(data);
      }
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

  void sendNotification(Map<String, dynamic> notificationData) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit("notify", notificationData);
      print("Notification sent via socket: $notificationData");
    } else {
      print("Socket is not connected. Notification not sent.");
    }
  }

  void onMessageReceived(Function(Map<String, dynamic>) callback) {
    _socket?.on("get", (data) {
      callback(data);
    });
  }

  void listenForNotifications(Function(Map<String, dynamic>) callback) {
    _onNotificationReceived = callback;
  }
}
