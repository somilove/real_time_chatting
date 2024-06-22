import 'dart:typed_data';
import 'package:chatting_app/model/message_model.dart';
import 'package:chatting_app/repository/tcp_connection.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [];
  final SocketService _socketService = SocketService();

  List<Message> get messages => _messages;

  ChatProvider() {
    _socketService.onMessageReceived = _handleMessageReceived;
  }

  void connect(String address, int port) {
    _socketService.connect(address, port);
  }

  void sendMessage(Message message) {
    _socketService.sendMessage(message);
    // _messages.add(message);
    notifyListeners();
  }

  void _handleMessageReceived(Uint8List bytes) {
    final decodedMessage = Message.fromBytes(bytes);
    print("Decoded Message: userId=${decodedMessage.userId}, fontColor=${decodedMessage.fontColor}, message=${decodedMessage.message}, sendTime=${decodedMessage.sendTime}");
    _messages.add(decodedMessage);
    notifyListeners();
  }
}
