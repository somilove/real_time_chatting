import 'dart:typed_data';
import 'dart:ui';

class Message {
  String userId;
  Color fontColor;
  String message;
  String sendTime;

  Message(this.userId, this.fontColor, this.message, this.sendTime);

  // Convert the Message object to a byte array
  Uint8List toBytes() {
    // Encode the strings as UTF-8 bytes
    final userNameBytes = Uint8List.fromList(userId.codeUnits);
    final messageBytes = Uint8List.fromList(message.codeUnits);
    final sendTimeBytes = Uint8List.fromList(sendTime.codeUnits);

    // Convert Color to int and then to byte array
    final colorValue = fontColor.value;
    final colorBytes = Uint8List(4);
     final colorBuffer = ByteData.sublistView(colorBytes);
    colorBuffer.setInt32(0, colorValue);

    // Create a buffer with the total size needed
    final bufferLength = 4 + userNameBytes.length +
        4 + colorBytes.length +
        4 + messageBytes.length +
        4 + sendTimeBytes.length;
    final buffer = ByteData(bufferLength);

    int offset = 0;

    // Write the userName length and bytes
    buffer.setInt32(offset, userNameBytes.length);
    offset += 4;
    buffer.buffer.asUint8List().setRange(offset, offset + userNameBytes.length, userNameBytes);
    offset += userNameBytes.length;

    // Write the color bytes
    buffer.buffer.asUint8List().setRange(offset, offset + colorBytes.length, colorBytes);
    offset += colorBytes.length;

    // Write the message length and bytes
    buffer.setInt32(offset, messageBytes.length);
    offset += 4;
    buffer.buffer.asUint8List().setRange(offset, offset + messageBytes.length, messageBytes);
    offset += messageBytes.length;

    // Write the sendTime length and bytes
    buffer.setInt32(offset, sendTimeBytes.length);
    offset += 4;
    buffer.buffer.asUint8List().setRange(offset, offset + sendTimeBytes.length, sendTimeBytes);
    offset += sendTimeBytes.length;

    return buffer.buffer.asUint8List();
  }

  // Create a Message object from a byte array
  static Message fromBytes(Uint8List bytes) {
    final buffer = ByteData.sublistView(bytes);
    int offset = 0;

    // Read the userName length and bytes
    final userNameLength = buffer.getInt32(offset);
    offset += 4;
    final userNameBytes = bytes.sublist(offset, offset + userNameLength);
    final userName = String.fromCharCodes(userNameBytes);
    offset += userNameLength;

    // Read the color bytes
    final colorValue = buffer.getInt32(offset);
    final fontColor = Color(colorValue);
    offset += 4;

    // Read the message length and bytes
    final messageLength = buffer.getInt32(offset);
    offset += 4;
    final messageBytes = bytes.sublist(offset, offset + messageLength);
    final message = String.fromCharCodes(messageBytes);
    offset += messageLength;

    // Read the sendTime length and bytes
    final sendTimeLength = buffer.getInt32(offset);
    offset += 4;
    final sendTimeBytes = bytes.sublist(offset, offset + sendTimeLength);
    final sendTime = String.fromCharCodes(sendTimeBytes);
    offset += sendTimeLength;

    return Message(userName, fontColor, message, sendTime);
  }
}