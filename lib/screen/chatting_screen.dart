import 'package:chatting_app/model/message_model.dart';
import 'package:chatting_app/provider/auth_provider.dart';
import 'package:chatting_app/provider/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class chattingScreen extends StatefulWidget {
  @override
  State<chattingScreen> createState() => _chattingScreenState();
}

class _chattingScreenState extends State<chattingScreen> {
   // ({Key? key}) : super(key: key);
  List<String> colorList = ["blue", "red", "green"];
  final scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final String serverIp = '43.203.34.6';
  final int serverPort = 5555;
  final AuthService _authService = AuthService();
  User? _user;
  String _userId = 'No user ID';


  @override
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false).connect(serverIp, serverPort);
    _getCurrentUser();
  }

  void _getCurrentUser() {
    User? user = _authService.getCurrentUser();
    setState(() {
      _user = user;
      _userId = user?.uid ?? 'No user ID';
    });
  }

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green
  ];

  int _currentIndex = 0;

  void _changeColor() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _colors.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //true 시 가상 키보드 나타날 때 scaffold 위젯이 자동으로 크기 조정 (겹치지 않게)
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chat'),

      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Consumer<ChatProvider>(
                    builder: (context, ChatProvider, child) {

                      return ListView.separated(
                          shrinkWrap: true, //true 시 ListView가 내부 콘텐츠에 맞게 크기조정하여 ALignment 위젯의 영향 받아 상단에 배치
                          reverse: true, //역순으로 배치
                          controller: scrollController,
                          separatorBuilder: (_, __) => const SizedBox(height: 12,),
                          itemCount: ChatProvider.messages.length,
                          itemBuilder: (context, index) {
                            var chatList = ChatProvider.messages.reversed.toList();

                            print('myid : $_userId, messageId : ${chatList[index].userId}.');
                            return   Column(
                              children: [
                                ChatBubble(
                                  clipper: ChatBubbleClipper4(type: chatList[index].userId == _userId ? BubbleType.sendBubble : BubbleType.receiverBubble ),
                                  alignment:  chatList[index].userId == _userId ? Alignment.topRight : Alignment.topLeft,
                                  margin: EdgeInsets.fromLTRB(15, 15, 15, 4),
                                  backGroundColor: Colors.white,
                                  child: Text(
                                    chatList[index].message,
                                    style: TextStyle(color: chatList[index].fontColor),
                                  ),),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(26, 0, 26, 0),
                                  child: Align(
                                      alignment:  chatList[index].userId == _userId ? Alignment.topRight : Alignment.topLeft,
                                      child: Text(chatList[index].sendTime, style: TextStyle(color: Colors.white), )),
                                ),
                              ]
                            );
                          }
                      );
                    },
                  )
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: _changeColor,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: 30,
                    height: 30,
                    color: _colors[_currentIndex],
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Enter message",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final _sendTime = DateFormat('hh:mm a').format(DateTime.now());
                    final _message = Message(_userId, _colors[_currentIndex], _controller.text, _sendTime);
                    Provider.of<ChatProvider>(context, listen: false).sendMessage(_message);
                    _controller.clear();
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



// void addMessage() {}
