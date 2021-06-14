import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sindiary/note_details.dart';

class NoteThumbnail extends StatelessWidget {
  final String isi, judul, id;
  NoteThumbnail(this.judul, this.isi, this.id);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoteDetails(id))),
      child: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width * 0.05,
        ),
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.05,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(29, 41, 54, 0.5),
                Colors.blue.withOpacity(0.5)
              ]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[50],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Text(
              isi,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.red[50],
              ),
            ),
            // Text(DateTime.fromMicrosecondsSinceEpoch(tanggal.seconds * 1000000)
            //     .toString()),
          ],
        ),
      ),
    );
  }
}
