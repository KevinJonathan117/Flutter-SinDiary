import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class NoteDetails extends StatelessWidget {
  final String id;
  NoteDetails(this.id);

  CollectionReference diaries =
      FirebaseFirestore.instance.collection('diaries');

  Future<void> deleteDiary() {
    return diaries
        .doc(id)
        .delete()
        .then((value) => print("Diary Deleted"))
        .catchError((error) => print("Failed to delete diary: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: const Text(
                    'You are going to delete this diary. Diaries that has been deleted cannot be retrieved. Are you sure?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      deleteDiary();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomeUI()));
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.04,
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: diaries.doc(id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              String creationTime = DateTime.fromMicrosecondsSinceEpoch(
                      data['tanggal'].seconds * 1000000)
                  .toString();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      data['judul'],
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                  Text(
                    "Created at : " + creationTime,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Text(
                    data['isi'],
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.075,
        ),
        child: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: null,
        ),
      ),
    );
  }
}
