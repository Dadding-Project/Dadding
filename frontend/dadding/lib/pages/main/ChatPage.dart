import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

List<String> chatList = [
];

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Divider(
            height: 1,
            thickness: 0.5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatList[index]),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}

