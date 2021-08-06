import 'package:chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  // FirebaseFirestore.instance.collection("mensagens").doc().set({
  //   "texto" : "Tchau",
  //   "from" : "Maria",
  // });
  
  // DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('mensagens')
  //     .doc('9D4krcOBQaNNiCBR9hQP').get();
  // print(snapshot.data());

  // QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('mensagens').get();
  // snapshot.docs.forEach((element) {
  //   print(element.data());
  //   print(element.id);
  // });

  // QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('mensagens').get();
  // snapshot.docs.forEach((element) {
  //   element.reference.update({'lido' : false});
  // });

  // FirebaseFirestore.instance.collection('mensagens').snapshots().listen((event) {
  //   event.docs.forEach((element) {
  //     print(element.data());
  //   });
  // });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.blue,
        )
      ),
      home: ChatScreen(),
    );
  }
}
