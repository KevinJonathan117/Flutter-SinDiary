import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController judulnote = TextEditingController();
  TextEditingController isinote = TextEditingController();

  CollectionReference diaries =
      FirebaseFirestore.instance.collection('diaries');

  Widget formAdd() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        TextFormField(
          controller: judulnote,
          keyboardType: TextInputType.text,
          autofocus: true,
          decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Judul',
              labelStyle: TextStyle(color: Colors.black)),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: isinote,
          keyboardType: TextInputType.text,
          autofocus: true,
          decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Isi',
              labelStyle: TextStyle(color: Colors.black)),
        ),
        SizedBox(height: 20),
        ElevatedButton(onPressed: saveNote, child: Text("Save"))
      ],
    );
  }

  Future<void> saveNote() {
    var now = new DateTime.now();
    return diaries.add({
      'judul': judulnote.text,
      'isi': isinote.text,
      'tanggal': now,
      'user': FirebaseAuth.instance.currentUser!.email
    }).then((value) {
      print("Note Added");
      judulnote.text = "";
      isinote.text = "";
      Navigator.pop(context);
    }).catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("")),
        body: Container(
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.04,
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Center(
              child: formAdd(),
            )));
  }
}
