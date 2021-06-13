import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sindiary/notes.dart';

import 'home.dart';

class NoteDetailsEdit extends StatefulWidget {
  final String id;
  NoteDetailsEdit(this.id);

  @override
  _NoteDetailsEditState createState() => _NoteDetailsEditState(this.id);
}

class _NoteDetailsEditState extends State<NoteDetailsEdit> {
  TextEditingController _controllerIsi = TextEditingController();
  final String id;
  _NoteDetailsEditState(this.id);

  String jdl = "";

  CollectionReference diaries =
      FirebaseFirestore.instance.collection('diaries');

  Future<void> deleteDiary() {
    return diaries
        .doc(widget.id)
        .delete()
        .then((value) => print("Diary Deleted"))
        .catchError((error) => print("Failed to delete diary: $error"));
  }

  Future<void> updateNote() {
    print('cek judul:' + jdl);
    var now = new DateTime.now();

    return diaries
        .doc(id)
        .update({'isi': _controllerIsi.text, 'tanggal': now}).then((value) {
      print("Note Updated");
      _controllerIsi.text = "";
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotesUI()));
    }).catchError((error) => print("Failed to update user: $error"));

    // return diaries
    //     .add({'judul': jdl, 'isi': _controllerIsi.text, 'tanggal': now}).then(
    //         (value) {
    //   print("Note Updated");
    //   _controllerIsi.text = "";
    //   Navigator.pop(context);
    // }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Diary"),
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
          future: diaries.doc(widget.id).get(),
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

              jdl = data['judul'];

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
                  TextField(
                    controller: _controllerIsi,
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
          backgroundColor: Colors.green,
          child: Icon(Icons.check),
          onPressed: updateNote,
        ),
      ),
    );
  }
}
