import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(data['sederPhotoUrl']),
          ),
          Expanded(
              child: Column(
                children: [
                  data['imgUrl'] != null ?
                      Image.network(data['imgUrl'])
                  :
                      Text(data['text'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                  Text(data['senderName'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}
