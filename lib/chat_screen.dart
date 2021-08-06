import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat/text_composer.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void _sendMessage({String? text, XFile? imgFile}) async {
    if (imgFile != null) {

      Reference ref = FirebaseStorage.instance.ref().child(imgFile.path);
      String url = (await ref.getDownloadURL().toString());

      // Task task = FirebaseStorage.instance.ref().child(
      //   DateTime.now().millisecondsSinceEpoch.toString(),
      // ).putFile(imgFile);
      //
      // TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
      // String url = await taskSnapshot.ref.getDownloadURL();

      print(url);
    }

    FirebaseFirestore.instance.collection('messages').add({
      'text' : text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ola"),
      ),
      body: TextComposer(_sendMessage),
    );
  }
}
