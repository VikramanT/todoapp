import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto/crypto.dart';


class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String encryptData(String data, String secretKey) {
    final key = utf8.encode(secretKey);
    final bytes = utf8.encode(data);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    final encryptedData = base64Url.encode(digest.bytes);
    return encryptedData;
  }

  addTask() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String? uid = user?.uid;
    var time = DateTime.now();

    String encryptedTitle = encryptData(titleController.text, "your-secret-key");
    String encryptedDescription = encryptData(descriptionController.text, "your-secret-key");

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytask')
        .doc(time.toString())
        .set({
      'title': encryptedTitle,
      'description': encryptedDescription,
      'time': time.toString(),
      'timestamp': time
    });

    Fluttertoast.showToast(msg: 'message added');
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff28284d),
      appBar: AppBar(
        title: Text('Todo App'),
        backgroundColor: Color(0xfffa7a40),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter title',
              ),
              maxLines: null,
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter description',
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xfffa7a40),
        onPressed: () {
          addTask();
          titleController.clear();
          descriptionController.clear();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
