// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

final _messageReference = FirebaseFirestore.instance.collection('messages');
final _auth = FirebaseAuth.instance;
final _fireStore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = "/chat";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageText = '';
  TextEditingController _textEditingController = TextEditingController();

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
    print("User : ${loggedInUser.email}");
  }

  // void getMessages() async {
  //   final messages = await _messageReference.get();
  //   for (var message in messages.docs) {
  //     var data = await _messageReference.doc(message.id).get();
  //     print(data.data());
  //   }
  // }

  void messagesStream() async {
    Stream<QuerySnapshot> list = _messageReference.snapshots();
    await for (QuerySnapshot msg in list) {
      for (DocumentChange doc in msg.docChanges) {
        DocumentSnapshot msg = doc.doc;
        print("Data Recieved : ${msg.data()}");
      }
    }
    // await for (var snapshot in _messageReference.snapshots()) {
    //   for (var message in snapshot.docs) {
    //     var item = await _messageReference.doc(message.id).get();
    //     print(message.data());
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                // messagesStream();
                _auth.signOut();
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      _fireStore.collection("messages").add(
                        {
                          "text": messageText,
                          "sender": loggedInUser.email,
                          "timestamp": DateTime.now(),
                        },
                      ).then(
                        (value) => _textEditingController.clear(),
                      );
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

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _messageReference.orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: snapshot.data!.docs
                  .map((DocumentSnapshot<Map<String, dynamic>> document) {
                return MessageBubble(
                  sender: '${document.data()!['sender']}',
                  text: '${document.data()!['text']}',
                  isME: loggedInUser.email == '${document.data()!['sender']}',
                );
              }).toList(),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  String sender, text;
  bool isME;
  MessageBubble(
      {Key? key, required this.text, required this.sender, required this.isME})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(
            height: 5,
          ),
          Material(
            borderRadius: BorderRadius.circular(15).copyWith(
                topRight: isME ? Radius.zero : const Radius.circular(15),
                topLeft: isME ? const Radius.circular(15) : Radius.zero),
            elevation: 5,
            color: isME ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15, color: isME ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
