import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? loggedInUser;
final _firestore = FirebaseFirestore.instance;
class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final textController = TextEditingController();
  
  String? messageText;

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    try{
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch(e){
      messageText = e.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context, ' ');
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const StreamBubble(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textController.clear();

                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                        'date' : DateTime.now(),
                      });
                      setState((){
                        messageText = '';
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamBubble extends StatelessWidget {
  const StreamBubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('date', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
          if (!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data!.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages){
            final messageText1 = message['text'];
            final messageSender = message['sender'];
            final user = loggedInUser!.email;
            MessageBubble messageBubble = MessageBubble(
                text: messageText1,
                sender: messageSender,
                isMe: user == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ListView(
                reverse: true,
                children: messageBubbles,
              ),
            ),
          );
        }
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text,
    required this.sender,
    required this.isMe,
  });

  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.only(topLeft: isMe ? const Radius.circular(15) : const Radius.circular(0),
                bottomLeft: const Radius.circular(15),
                bottomRight: const Radius.circular(15),
              topRight: isMe ? const Radius.circular(0) : const Radius.circular(15)
            ),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 5, left: 20, right: 20),
              child: Text(text,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15.0,
                      color: isMe ? Colors.white : Colors.black54,
                    ),),
            ),
          ),
        ],
      ),
    );
  }
}
