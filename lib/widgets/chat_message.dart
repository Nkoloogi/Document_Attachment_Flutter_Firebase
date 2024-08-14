import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class ChatMessage extends StatelessWidget {
  final DocumentSnapshot message;

  ChatMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: message['isDocument']
          ? Icon(Icons.insert_drive_file) // Change the icon as needed
          : Icon(Icons.message),
      title: Text(
        message['isDocument'] ? message['documentName'] : message['message'],
      ),
      subtitle: Text(
        message['isDocument'] ? 'Document' : 'Text Message',
      ),
      onTap: message['isDocument']
          ? () {
              // Open the document link
              _openDocument(message['message']);
            }
          : null,
    );
  }

  Future<void> _openDocument(String url) async {
    // Implement your download logic here, then open the file
    OpenFile.open(
        url); // Use the URL directly if possible, or download then open
  }
}
