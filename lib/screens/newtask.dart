import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  addtask() async{
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  String? uid =user?.uid;
  var time=DateTime.now();
  await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytask').doc(time.toString()).set({'title':titleController.text,
  'description':descriptionController.text,
  'time':time.toString(),
  'timestamp':time
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
          // Handle saving the todo with the entered title and description
          // You can add your logic here
          // String title = titleController.text;
          // String description = descriptionController.text;
          // print('Title: $title');
          // print('Description: $description');
        addtask();
          // Clear the text fields after saving
          titleController.clear();
          descriptionController.clear();
          
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
