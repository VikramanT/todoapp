import 'package:dark/screens/newtask.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = '';

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    //Rprint('$uid');
    setState(() {
      uid = user?.uid ?? '';
      print('$uid');
    });
  }

  @override
  void initState() {
    super.initState();
    getuid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff28284d),
      appBar: AppBar(
        title: Text('Todo'),
        backgroundColor: Color(0xfffa7a40),
      ),
      body: Container(
        margin: EdgeInsets.only(top:10,left: 10,right: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: uid.isNotEmpty
              ? FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(uid)
                  .collection('mytask')
                  .snapshots()
              : null,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text('Error occurred: ${snapshot.error}'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
              return Container(
                child: Center(
                  child: Text('No tasks available'),
                ),
              );
            } else {
              final docs = snapshot.data?.docs;
              return ListView.builder(
                itemCount: docs?.length,
                itemBuilder: (context, index) {
                  final task = docs![index].data() as Map<String, dynamic>;
                  return 
                 GestureDetector(
                  onTap:() {
                    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(description: task['description']),
      ),
    );
                  },
                   child: Container(
                   margin: EdgeInsets.only(bottom: 10),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(12),
                     color: Color(0xffefe3d0),
                   ),
                   child: ListTile(
                     title: Text(
                       task['title'],
                       style: GoogleFonts.roboto(fontSize: 18, color: Colors.black),
                     ),
                     subtitle: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                        Text(
  task['description'],
  style: GoogleFonts.roboto(fontSize: 18, color: Colors.black),
  overflow: TextOverflow.ellipsis,
  maxLines: 1,
),

                         SizedBox(height: 8), // Add some spacing between the description and the additional text
                        Text(
                         DateFormat('yyyy-MM-dd HH:mm:ss').format(task['timestamp'].toDate()),
                         style: GoogleFonts.roboto(fontSize: 14, color: Colors.black),
                       ),
                       ],
                     ),
                     trailing: IconButton(
                       icon: Icon(Icons.delete, color: Colors.black),
                       onPressed: () async {
                         await FirebaseFirestore.instance
                             .collection('tasks')
                             .doc(uid)
                             .collection('mytask')
                             .doc(docs[index]['time'])
                             .delete();
                         // Delete functionality here
                       },
                     ),
                   ),
                 ),
                 
                 );

                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoScreen(),
            ),
          );
        },
        backgroundColor: Color(0xfffa7a40),
        child: Icon(Icons.add),
      ),
    );
  }
}



class DetailScreen extends StatelessWidget {
  final String description;

  const DetailScreen({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xff28284d),
      appBar: AppBar(
        title: Text('Description'),
        backgroundColor: Color(0xfffa7a40),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          description,
          style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
