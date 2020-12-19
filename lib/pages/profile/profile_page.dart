import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nf_kicks/services/database/database_api.dart';

class ProfilePage extends StatelessWidget {
  final DatabaseApi dataStore;

  const ProfilePage({Key key, this.dataStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Your Account",
          style: GoogleFonts.permanentMarker(),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Text("Profile page"),
    );
  }
}
