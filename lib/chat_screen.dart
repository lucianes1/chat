import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat/text_composer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User? _currentUser;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
    });
  }

  Future<User?> _getUser() async {

    if (_currentUser != null) return _currentUser;

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      print (user);

      return user;
    } catch(error) {
      return null;
    }
  }

  void _sendMessage({String? text, File? imgFile}) async {

    final User? user = await _getUser();

    if(user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nao foi possivel fazer login.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    Map<String, dynamic> data = {
      "uid": user?.uid,
      "senderName": user?.displayName,
      "senderPhotoUrl": user?.photoURL,
    };

    if (imgFile != null) {
      UploadTask task = FirebaseStorage.instance.ref().child(
        DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgFile);

      TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
      String url = await taskSnapshot.ref.getDownloadURL();

      data['imgUrl'] = url;

      print(url);
    }

    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Ola"),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      List<DocumentSnapshot> documents = snapshot.data!.docs.reversed.toList();
                      return ListView.builder(
                        reverse: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(documents[index]['text']),
                          );
                        },
                      );
                  };
                },
              ),
          ),
          TextComposer(_sendMessage),
        ],
      )
    );
  }
}
