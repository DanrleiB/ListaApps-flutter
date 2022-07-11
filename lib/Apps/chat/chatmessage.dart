import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversormoedas/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatMessage extends StatefulWidget {
  ChatMessage(this.data, this.mine, {Key? key}) : super(key: key);

  Map<String, dynamic> data;
  final bool mine;

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User? currentUser;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          widget.mine == false
              ? Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.data["senderPhotoUrl"]),
                  ),
                )
              : Container(),
          Expanded(
            child: GestureDetector(
              onTap: () {
                currentUser != null ? deletar(widget.data) : null;
              },
              child: Column(
                crossAxisAlignment: widget.mine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  widget.data['imgUrl'] != null
                      ? Image.network(
                          widget.data["imgurl"],
                          width: 250,
                        )
                      : Text(
                          widget.data['text'],
                          textAlign:
                              widget.mine ? TextAlign.end : TextAlign.start,
                          style: const TextStyle(fontSize: 16),
                        ),
                  Text(
                    widget.data["senderName"],
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          widget.mine
              ? Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.data["senderPhotoUrl"]),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void deletar(data) async {
    alert(
      context,
      'você deseja apagar está menssagem?',
      callback: () {
        FirebaseFirestore.instance
            .collection('Messages')
            .doc(data['time'].toString())
            .delete();
      },
    );
  }
}
