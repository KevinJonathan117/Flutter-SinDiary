import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sindiary/add_note.dart';
import 'package:sindiary/note_thumbnail.dart';

class NotesUI extends StatefulWidget {
  const NotesUI({Key? key}) : super(key: key);

  @override
  _NotesUIState createState() => _NotesUIState();
}

class _NotesUIState extends State<NotesUI> {
  final Stream<QuerySnapshot> _diariesStream = FirebaseFirestore.instance
      .collection('diaries')
      .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.04,
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: _diariesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String id = document.id;
                    return NoteThumbnail(data['judul'], data['isi'], id);
                  }).toList(),
                );
              },
            ),
          ),
        ),
        floatingActionButton: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.075,
            ),
            child: FloatingActionButton(
              child: Icon(Icons.add_circle),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNote(),
                    ));
              },
            )));
  }
}
