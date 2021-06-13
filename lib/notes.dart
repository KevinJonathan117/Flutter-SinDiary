import 'package:flutter/material.dart';

class NotesUI extends StatefulWidget {
  const NotesUI({Key? key}) : super(key: key);

  @override
  _NotesUIState createState() => _NotesUIState();
}

class _NotesUIState extends State<NotesUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Notes"),
        ),
      ),
    );
  }
}
