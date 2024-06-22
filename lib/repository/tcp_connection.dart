import 'dart:io';
import 'dart:typed_data';
import 'package:chatting_app/model/message_model.dart';

class SocketService {
  late Socket _socket;
  late Function(Uint8List) onMessageReceived;

  void connect(String address, int port) async {
    _socket = await Socket.connect(address, port);
    _socket.listen((Uint8List data) {
      String message = String.fromCharCodes(data);
      print('resv data1: $message');
      print('resv data2: $data');
      if (onMessageReceived != null) {
        onMessageReceived(data);
      }
    });
  }
  void sendMessage(Message message) {
    // Convert the Message object to a byte array
    final bytes = message.toBytes();
    print("Byte array: $bytes");
    _socket.add(bytes);
  }

  void disconnect() {
    _socket.close();
  }
}
