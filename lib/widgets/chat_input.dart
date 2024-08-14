import 'dart:typed_data';

import 'package:document_sharing/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatInputField extends StatefulWidget {
  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _messagesRef =
      FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.attach_file),
          onPressed: () => _pickDocument(),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Type a message'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () => _sendMessage(),
        ),
      ],
    );
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      //get bytes and the file name
      Uint8List? fileBytes = result.files.single.bytes;
      String? fileName = result.files.single.name;
      if (fileBytes != null) {
        // Optionally, show a preview or confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: $fileName')),
        );

        //upload the file using the bytes
       StorageService.uploadFileBytes(fileBytes, fileName,
            (downloadURL, fileName) {
          _sendMessage(documentUrl: downloadURL, fileName: fileName);
        }, (progress) {
          // Update UI with the progress percentage
          setState(() {
            // Use any state variable or UI component to show progress
          });
        });
      }
    }
  }

  void _sendMessage({String? documentUrl, String? fileName}) {
    final message = {
      'message': _controller.text,
      'timestamp': Timestamp.now(),
      'isDocument': documentUrl != null,
      'documentName': fileName,
    };
    if (documentUrl != null) {
      message['message'] = documentUrl;
    }

    _messagesRef.add(message);
    _controller.clear();
  }
}
